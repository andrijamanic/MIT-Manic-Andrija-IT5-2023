import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapPickResult {
  final LatLng latLng;
  final String city;

  const MapPickResult({required this.latLng, required this.city});
}

class MapPickerScreen extends StatefulWidget {
  final LatLng initial;
  const MapPickerScreen({super.key, required this.initial});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();

  LatLng? _selected;
  bool _saving = false;

  LatLng get _point => _selected ?? widget.initial;

  // ✅ 1) BigDataCloud (najčešće radi u WEB-u bez CORS problema)
  Future<String?> _reverseBigDataCloud(LatLng p) async {
    final uri = Uri.parse(
      'https://api.bigdatacloud.net/data/reverse-geocode-client',
    ).replace(queryParameters: {
      'latitude': p.latitude.toString(),
      'longitude': p.longitude.toString(),
      'localityLanguage': 'sr',
    });

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body) as Map<String, dynamic>;

    // BigDataCloud polja (neka mogu biti prazna)
    final city = (data['city'] ?? '').toString().trim();
    final locality = (data['locality'] ?? '').toString().trim();
    final principalSubdivision = (data['principalSubdivision'] ?? '')
        .toString()
        .trim(); // npr. okrug/pokrajina

    // Preferiramo city, pa locality, pa principalSubdivision
    if (city.isNotEmpty) return city;
    if (locality.isNotEmpty) return locality;
    if (principalSubdivision.isNotEmpty) return principalSubdivision;

    return null;
  }

  // ✅ 2) Nominatim fallback (nekad radi, nekad blokira/rate limit)
  Future<String?> _reverseNominatim(LatLng p) async {
    final uri = Uri.parse('https://nominatim.openstreetmap.org/reverse')
        .replace(queryParameters: {
      'format': 'jsonv2',
      'lat': p.latitude.toString(),
      'lon': p.longitude.toString(),
      'zoom': '10',
      'addressdetails': '1',
    });

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
      // Nominatim voli da vidi User-Agent (na web-u header nekad browser ograniči, ali nije problem da stoji)
      'User-Agent': 'projekatoglasimit/1.0 (flutter web)',
    });

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final address = (data['address'] ?? {}) as Map<String, dynamic>;

    final city = (address['city'] ??
            address['town'] ??
            address['village'] ??
            address['municipality'] ??
            address['county'] ??
            '')
        .toString()
        .trim();

    if (city.isNotEmpty) return city;

    final name = (data['name'] ?? '').toString().trim();
    if (name.isNotEmpty) return name;

    return null;
  }

  Future<String> _reverseToCity(LatLng p) async {
    try {
      final a = await _reverseBigDataCloud(p);
      if (a != null && a.isNotEmpty) return a;
    } catch (_) {}

    try {
      final b = await _reverseNominatim(p);
      if (b != null && b.isNotEmpty) return b;
    } catch (_) {}

    // ✅ nema koordinata u UI — ako baš ništa ne uspe
    return 'Nepoznata lokacija';
  }

  Future<void> _save() async {
    final picked = _selected ?? widget.initial;

    setState(() => _saving = true);
    try {
      final city = await _reverseToCity(picked);
      if (!mounted) return;

      Navigator.pop(context, MapPickResult(latLng: picked, city: city));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izaberi lokaciju na mapi'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sačuvaj'),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _point,
          zoom: 14,
          onTap: (_, latlng) {
            setState(() => _selected = latlng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _point,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
