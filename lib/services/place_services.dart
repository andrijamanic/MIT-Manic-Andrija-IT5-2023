import 'dart:convert';
import 'package:http/http.dart' as http;

/// Suggestion model
class PlaceSuggestion {
  final String label;
  final double lat;
  final double lng;

  PlaceSuggestion({
    required this.label,
    required this.lat,
    required this.lng,
  });
}

class PlaceServices {
  // ✅ HTTPS (bitno za web)
  static const String _baseUrl = 'https://photon.komoot.io/api/';

  Future<List<PlaceSuggestion>> searchPlaces(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': q,
      'limit': '7',
      // opcionalno: 'lang': 'sr',
    });

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (res.statusCode != 200) {
      throw Exception('Photon error ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    final features = (data['features'] as List?) ?? [];

    return features.map((f) {
      final props = (f['properties'] ?? {}) as Map<String, dynamic>;
      final coords = (f['geometry']?['coordinates'] as List?) ?? [0, 0];

      final lng = (coords[0] as num).toDouble();
      final lat = (coords[1] as num).toDouble();

      final name = (props['name'] ?? '').toString();
      final city = (props['city'] ?? '').toString();
      final state = (props['state'] ?? '').toString();
      final country = (props['country'] ?? '').toString();

      // sklopi label
      final parts = <String>[];
      if (name.isNotEmpty) parts.add(name);
      if (city.isNotEmpty && city != name) parts.add(city);
      if (state.isNotEmpty) parts.add(state);
      if (country.isNotEmpty) parts.add(country);

      return PlaceSuggestion(
        label: parts.isEmpty ? q : parts.join(', '),
        lat: lat,
        lng: lng,
      );
    }).toList();
  }
}
