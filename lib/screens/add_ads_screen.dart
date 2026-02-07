import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ads.dart';
import '../providers/user_provider.dart';
import '../services/ads_services.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController();

  String _category = 'Stanovi';
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj Oglas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!userProvider.isLoggedIn || userProvider.isGuest)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Moraš biti ulogovan (ne kao gost) da bi dodao oglas.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Naslov oglasa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              decoration: const InputDecoration(
                labelText: 'Opis oglasa',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _price,
              decoration: const InputDecoration(
                labelText: 'Cena (npr 400€ ili Besplatno)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _location,
              decoration: const InputDecoration(
                labelText: 'Lokacija (npr Beograd)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              items: const [
                DropdownMenuItem(value: 'Stanovi', child: Text('Stanovi')),
                DropdownMenuItem(value: 'Prakse', child: Text('Prakse')),
                DropdownMenuItem(value: 'Ostalo', child: Text('Ostalo')),
              ],
              onChanged: (v) => setState(() => _category = v ?? 'Stanovi'),
              decoration: const InputDecoration(
                labelText: 'Kategorija',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (!userProvider.isLoggedIn || userProvider.isGuest)
                    ? null
                    : () async {
                        if (_title.text.trim().isEmpty ||
                            _desc.text.trim().isEmpty ||
                            _price.text.trim().isEmpty ||
                            _location.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Popuni sva polja.')),
                          );
                          return;
                        }

                        setState(() => _loading = true);

                        try {
                          final ad = Ad(
                            id: '',
                            title: _title.text.trim(),
                            description: _desc.text.trim(),
                            price: _price.text.trim(),
                            category: _category,
                            location: _location.text.trim(),
                            userId: userProvider.uid!,
                            createdAt: DateTime.now(),
                          );

                          await AdsService().addAd(ad);

                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Greška: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Dodaj oglas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
