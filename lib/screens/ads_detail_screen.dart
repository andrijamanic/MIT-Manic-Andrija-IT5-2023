import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/ads.dart';
import '../providers/user_provider.dart';
import '../widgets/primary_button.dart';
import '../services/favorites_services.dart';
import '../services/reservations_services.dart';

class AdDetailScreen extends StatelessWidget {
  final Ad ad;
  final String imagePath;

  const AdDetailScreen({
    super.key,
    required this.ad,
    required this.imagePath,
  });

  LatLng getCoordinates(String location) {
    switch (location.toLowerCase()) {
      case 'beograd':
        return const LatLng(44.8176, 20.4569);
      case 'novi sad':
        return const LatLng(45.2671, 19.8335);
      case 'niš':
        return const LatLng(43.3209, 21.8958);
      default:
        return const LatLng(44.8176, 20.4569);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final uid = userProvider.uid;
    final isGuest = userProvider.isGuest;
    final isOwner = (uid != null && uid == ad.userId);

    final LatLng adPosition = getCoordinates(ad.location);

    return Scaffold(
      appBar: AppBar(
        title: Text(ad.title),
        actions: [
          if (userProvider.isLoggedIn && !isGuest && uid != null)
            StreamBuilder<bool>(
              stream: FavoritesService().isFavorite(uid, ad.id),
              builder: (context, snap) {
                final fav = snap.data ?? false;
                return IconButton(
                  tooltip: fav ? 'Ukloni iz omiljenih' : 'Dodaj u omiljene',
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                  onPressed: () async {
                    await FavoritesService()
                        .toggleFavorite(uid: uid, adId: ad.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          fav ? 'Uklonjeno iz omiljenih' : 'Dodato u omiljene',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              Text(ad.description, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              Text(
                ad.price,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              Text('Lokacija: ${ad.location}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),

              SizedBox(
                height: 250,
                child: FlutterMap(
                  options: MapOptions(
                    center: adPosition,
                    zoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: adPosition,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // REZERVACIJA (samo za stanove)
              if (ad.category == 'Stanovi')
                PrimaryButton(
                  text: isOwner
                      ? 'Ovo je tvoj oglas'
                      : isGuest
                          ? 'Uloguj se da rezervišeš'
                          : 'Rezerviši stan',
                  onPressed: (!userProvider.isLoggedIn ||
                          isGuest ||
                          uid == null ||
                          isOwner)
                      ? () {}
                      : () async {
                          try {
                            await ReservationsService().createReservation(
                              adId: ad.id,
                              ownerId: ad.userId,
                              reservedBy: uid,
                            );

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Rezervacija poslata (pending).')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Greška: $e')),
                            );
                          }
                        },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
