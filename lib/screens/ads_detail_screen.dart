import 'package:flutter/material.dart';

class AdDetailScreen extends StatelessWidget {
  final Map<String, String> ad;

  const AdDetailScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ad['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ad['description']!,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              ad['price']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            if (ad['category'] == 'Stanovi')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Rezerviši stan'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
