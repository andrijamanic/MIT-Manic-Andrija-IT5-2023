import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/user_provider.dart';
import '../services/reservations_services.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final uid = user.uid;

    if (!user.isLoggedIn || uid == null || user.isGuest) {
      return const Scaffold(
        body: Center(child: Text('Moraš biti ulogovan da vidiš rezervacije.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervacije'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Moje'),
            Tab(text: 'Za moje oglase'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _ReservationsList(
            stream: ReservationsService().watchMyReservations(uid),
            mode: _ReservationMode.my,
          ),
          _ReservationsList(
            stream: ReservationsService().watchReservationsForMyAds(uid),
            mode: _ReservationMode.forMyAds,
          ),
        ],
      ),
    );
  }
}

enum _ReservationMode { my, forMyAds }

class _ReservationsList extends StatelessWidget {
  final Stream<List<Reservation>> stream;
  final _ReservationMode mode;

  const _ReservationsList({required this.stream, required this.mode});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reservation>>(
      stream: stream,
      builder: (context, snap) {
        // ✅ najbitnije: prikaži Firestore error (index/rules/field)
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Rezervacije greška:\n${snap.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData) {
          return const Center(child: Text('Nema podataka.'));
        }

        final items = snap.data!;
        if (items.isEmpty) {
          return const Center(child: Text('Nema rezervacija.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
            final r = items[i];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text('Oglas: ${r.adId}'),
                subtitle: Text('Status: ${r.status}'),
                trailing: mode == _ReservationMode.forMyAds
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            tooltip: 'Prihvati',
                            onPressed: () => ReservationsService().updateStatus(
                              reservationId: r.id,
                              status: 'accepted',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Odbij',
                            onPressed: () => ReservationsService().updateStatus(
                              reservationId: r.id,
                              status: 'rejected',
                            ),
                          ),
                        ],
                      )
                    : IconButton(
                        icon: const Icon(Icons.cancel),
                        tooltip: 'Otkaži',
                        onPressed: () => ReservationsService().updateStatus(
                          reservationId: r.id,
                          status: 'canceled',
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
