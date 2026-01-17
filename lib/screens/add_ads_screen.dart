import 'package:flutter/material.dart';

class AddAdScreen extends StatelessWidget {
  const AddAdScreen({super.key}); // OBAVEZNO const konstruktor sa key

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
              'Forma za dodavanje oglasa (placeholder)',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Primer input polja
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
              onPressed: () {
                // TODO: implement save functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Oglas dodat (placeholder)')),
                );
              },
              child: const Text('Dodaj oglas'),
            ),
          ],
        ),
      ),
    );
  }
}
