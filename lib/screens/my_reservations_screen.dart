import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            showCancel: true,
          ),
          _ReservationsList(
            stream: ReservationsService().watchReservationsForMyAds(uid),
            showCancel: false,
          ),
        ],
      ),
    );
  }
}

class _ReservationsList extends StatelessWidget {
  final Stream<List<Reservation>> stream;
  final bool showCancel;

  const _ReservationsList({
    required this.stream,
    required this.showCancel,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd.MM.yyyy HH:mm');

    return StreamBuilder<List<Reservation>>(
      stream: stream,
      builder: (context, snap) {
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

            final when = r.dateTime != null ? fmt.format(r.dateTime!) : '—';
            final status = r.status;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: (r.adTitle != null && r.adTitle!.trim().isNotEmpty)
                    ? Text(r.adTitle!)
                    : FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('ads')
                            .doc(r.adId)
                            .get(),
                        builder: (context, adSnap) {
                          if (!adSnap.hasData) return Text(r.adId);
                          if (!adSnap.data!.exists) return Text(r.adId);

                          final data =
                              adSnap.data!.data() as Map<String, dynamic>;
                          final title = (data['title'] ?? r.adId).toString();
                          return Text(title);
                        },
                      ),
                subtitle: Text('Termin: $when\nStatus: $status'),
                trailing: showCancel && status != 'canceled'
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        tooltip: 'Otkaži',
                        onPressed: () async {
                          await ReservationsService().cancelReservation(r.id);
                        },
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
