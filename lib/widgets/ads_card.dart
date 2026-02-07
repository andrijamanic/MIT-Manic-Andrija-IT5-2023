import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ads.dart';
import '../providers/user_provider.dart';
import '../services/favorites_services.dart';

class AdCard extends StatelessWidget {
  final Ad ad;
  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback? onReserve;

  const AdCard({
    Key? key,
    required this.ad,
    required this.imagePath,
    required this.onTap,
    this.onReserve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uid = userProvider.uid;
    final canFavorite =
        userProvider.isLoggedIn && !userProvider.isGuest && uid != null;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ad.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        if (canFavorite)
                          StreamBuilder<bool>(
                            stream: FavoritesService().isFavorite(uid!, ad.id),
                            builder: (context, snap) {
                              final fav = snap.data ?? false;
                              return IconButton(
                                tooltip: fav
                                    ? 'Ukloni iz omiljenih'
                                    : 'Dodaj u omiljene',
                                icon: Icon(fav
                                    ? Icons.favorite
                                    : Icons.favorite_border),
                                onPressed: () async {
                                  await FavoritesService()
                                      .toggleFavorite(uid: uid, adId: ad.id);
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(ad.description,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(
                      ad.price,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    if (ad.category == 'Stanovi' && onReserve != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: onReserve,
                          child: const Text('Rezerviši'),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
