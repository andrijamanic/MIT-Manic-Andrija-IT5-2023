import 'package:flutter/material.dart';
import '../models/ads.dart';

class AdCard extends StatelessWidget {
  final Ad ad;
  final VoidCallback onTap;
  final VoidCallback? onReserve;

  const AdCard({
    super.key,
    required this.ad,
    required this.onTap,
    this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        title: Text(
          ad.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ad.description),
            const SizedBox(height: 6),
            Text(
              ad.price,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            ),
            if (ad.category == 'Stanovi' && onReserve != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onReserve,
                  child: const Text('Rezerviši'),
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
