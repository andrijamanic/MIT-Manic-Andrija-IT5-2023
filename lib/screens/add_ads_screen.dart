import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/ads.dart';
import '../providers/user_provider.dart';
import '../services/ads_services.dart';
import 'map_picker_screen.dart';

class AddAdScreen extends StatefulWidget {
  final Ad? existing;

  const AddAdScreen({super.key, this.existing});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _imageUrl = TextEditingController();

  // ✅ Lokacija (grad) se popunjava iz mape
  final _location = TextEditingController();

  String _category = 'Stanovi';
  bool _loading = false;

  LatLng? _pickedLatLng;

  bool get isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();

    final e = widget.existing;
    if (e != null) {
      _title.text = e.title;
      _desc.text = e.description;
      _price.text = e.price;
      _imageUrl.text = e.imageUrl;
      _category = e.category;

      _location.text = e.location;

      if (e.lat != null && e.lng != null) {
        _pickedLatLng = LatLng(e.lat!, e.lng!);
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    _imageUrl.dispose();
    _location.dispose();
    super.dispose();
  }

  LatLng _fallbackInitial() => const LatLng(44.8176, 20.4569); // BG

  Future<void> _pickOnMap() async {
    final initial = _pickedLatLng ?? _fallbackInitial();

    final result = await Navigator.push<MapPickResult?>(
      context,
      MaterialPageRoute(builder: (_) => MapPickerScreen(initial: initial)),
    );

    if (result != null) {
      setState(() {
        _pickedLatLng = result.latLng;
        _location.text = result.city; // ✅ samo grad/adresa
      });
    }
  }

  bool _isValidUrl(String url) {
    final u = url.trim();
    return u.startsWith('http://') || u.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Izmeni oglas' : 'Dodaj oglas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!userProvider.isLoggedIn || userProvider.isGuest)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Moraš biti ulogovan (ne kao gost) da bi dodao/izmenio oglas.',
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

            // ✅ samo grad/adresa, bez koordinata
            TextField(
              controller: _location,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Lokacija (grad)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.map),
                label: Text(_pickedLatLng == null
                    ? 'Izaberi lokaciju na mapi'
                    : 'Promeni lokaciju na mapi'),
                onPressed: (!userProvider.isLoggedIn || userProvider.isGuest)
                    ? null
                    : _pickOnMap,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _imageUrl,
              decoration: const InputDecoration(
                labelText: 'Link slike (Image URL)',
                hintText: 'https://...',
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
                            _imageUrl.text.trim().isEmpty ||
                            _location.text.trim().isEmpty ||
                            _pickedLatLng == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Popuni sva polja + izaberi lokaciju na mapi (da se upiše grad).',
                              ),
                            ),
                          );
                          return;
                        }

                        if (!_isValidUrl(_imageUrl.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Link slike mora da bude http/https.'),
                            ),
                          );
                          return;
                        }

                        setState(() => _loading = true);

                        try {
                          final e = widget.existing;

                          final ad = Ad(
                            id: isEdit ? e!.id : '',
                            title: _title.text.trim(),
                            description: _desc.text.trim(),
                            price: _price.text.trim(),
                            category: _category,
                            location: _location.text.trim(),
                            userId: userProvider.uid!,
                            createdAt: isEdit ? e!.createdAt : DateTime.now(),
                            imageUrl: _imageUrl.text.trim(),
                            lat: _pickedLatLng!.latitude,
                            lng: _pickedLatLng!.longitude,
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
                    : Text(isEdit ? 'Sačuvaj izmene' : 'Dodaj oglas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
