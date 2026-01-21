import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/ads.dart';
import '../widgets/primary_button.dart';

class AdDetailScreen extends StatelessWidget {
  final Ad ad;
  final String imagePath;

  const AdDetailScreen({
    super.key,
    required this.ad,
    required this.imagePath,
  });

  // Hardcodovane koordinate za primer
  LatLng getCoordinates(String location) {
    switch (location.toLowerCase()) {
      case 'beograd':
        return const LatLng(44.8176, 20.4569);
      case 'novi sad':
        return const LatLng(45.2671, 19.8335);
      case 'niš':
        return const LatLng(43.3209, 21.8958);
      default:
        return const LatLng(44.8176, 20.4569); // default Beograd
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng adPosition = getCoordinates(ad.location);

    return Scaffold(
      appBar: AppBar(title: Text(ad.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slika oglasa
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // Tekst
              Text(ad.description, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              Text(ad.price,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              const SizedBox(height: 20),

              // Lokacija
              Text('Lokacija: ${ad.location}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),

              // Mapa
              SizedBox(
                height: 250,
                child: FlutterMap(
                  options: MapOptions(
                    center: adPosition,
                    zoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: adPosition,
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
              ),

              const SizedBox(height: 30),

              if (ad.category == 'Stanovi')
                PrimaryButton(
                  text: 'Rezerviši stan',
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
