import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ads.dart';
import '../providers/user_provider.dart';
import '../services/ads_services.dart';
import 'add_ads_screen.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final uid = user.uid;

    if (!user.isLoggedIn || uid == null || user.isGuest) {
      return const Scaffold(
        body: Center(child: Text('Moraš biti ulogovan da vidiš svoje oglase.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Moji oglasi')),
      body: StreamBuilder<List<Ad>>(
        stream: AdsService().watchAds(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Greška:\n${snap.error}'),
              ),
            );
          }

          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mine = snap.data!.where((a) => a.userId == uid).toList();

          if (mine.isEmpty) {
            return const Center(child: Text('Nemaš nijedan oglas.'));
          }

          return ListView.builder(
            itemCount: mine.length,
            itemBuilder: (context, i) {
              final ad = mine[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(ad.title),
                  subtitle:
                      Text('${ad.category} • ${ad.location} • ${ad.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddAdScreen(existing: ad),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await AdsService().deleteAd(ad.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
