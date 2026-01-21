import 'package:flutter/material.dart';
import '../models/ads.dart';

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
                    Text(ad.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(ad.description,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(ad.price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
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
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
