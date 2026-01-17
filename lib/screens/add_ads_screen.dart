import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class AddAdScreen extends StatelessWidget {
  const AddAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    String category = 'Stanovi';

    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj oglas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Naslov oglasa'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Opis oglasa'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Cena'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: category,
              items: const [
                DropdownMenuItem(value: 'Stanovi', child: Text('Stanovi')),
                DropdownMenuItem(value: 'Prakse', child: Text('Prakse')),
                DropdownMenuItem(value: 'Ostalo', child: Text('Ostalo')),
              ],
              onChanged: (value) {
                if (value != null) category = value;
              },
              decoration: const InputDecoration(labelText: 'Kategorija'),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Sačuvaj oglas',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Oglas sačuvan (placeholder)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
