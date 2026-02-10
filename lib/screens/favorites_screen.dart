import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ads.dart';
import '../providers/user_provider.dart';
import '../services/ads_services.dart';
import '../services/favorites_services.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final uid = user.uid;

    if (!user.isLoggedIn || uid == null || user.isGuest) {
      return const Scaffold(
        body: Center(
          child: Text('Moraš biti ulogovan da vidiš omiljene oglase.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Moji omiljeni oglasi')),
      body: StreamBuilder<Set<String>>(
        stream: FavoritesService().watchFavoriteIds(uid),
        builder: (context, favSnap) {
          if (favSnap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Omiljeni greška:\n${favSnap.error}'),
              ),
            );
          }

          if (favSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!favSnap.hasData) {
            return const Center(child: Text('Nema podataka.'));
          }

          final favIds = favSnap.data!;
          if (favIds.isEmpty) {
            return const Center(child: Text('Nemaš omiljene oglase.'));
          }

          return StreamBuilder<List<Ad>>(
            stream: AdsService().watchAds(),
            builder: (context, adsSnap) {
              if (adsSnap.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Oglasi greška:\n${adsSnap.error}'),
                  ),
                );
              }

              if (adsSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!adsSnap.hasData) {
                return const Center(child: Text('Nema podataka.'));
              }

              final favAds =
                  adsSnap.data!.where((a) => favIds.contains(a.id)).toList();

              if (favAds.isEmpty) {
                return const Center(
                  child: Text('Omiljeni oglasi nisu pronađeni.'),
                );
              }

              return ListView.builder(
                itemCount: favAds.length,
                itemBuilder: (context, i) {
                  final ad = favAds[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(ad.title),
                      subtitle:
                          Text('${ad.category} • ${ad.location} • ${ad.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () async {
                          await FavoritesService()
                              .toggleFavorite(uid: uid, adId: ad.id);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
