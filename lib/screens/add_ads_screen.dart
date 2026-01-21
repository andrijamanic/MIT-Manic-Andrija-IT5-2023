import 'package:flutter/material.dart';

class AddAdScreen extends StatelessWidget {
  const AddAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Oglas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Forma za dodavanje oglasa',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Naslov oglasa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Opis oglasa',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Dodaj oglas'),
            ),
          ],
        ),
      ),
    );
  }
}
