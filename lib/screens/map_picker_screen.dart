import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initial;
  const MapPickerScreen({super.key, required this.initial});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? selected;

  @override
  Widget build(BuildContext context) {
    final point = selected ?? widget.initial;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Izaberi lokaciju'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, selected),
            child: const Text('Sačuvaj'),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: point,
          zoom: 14,
          onTap: (tapPos, latlng) => setState(() => selected = latlng),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
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
