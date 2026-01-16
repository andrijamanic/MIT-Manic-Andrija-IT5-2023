import 'package:flutter/material.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  // Placeholder oglasi po kategorijama
  final Map<String, List<Map<String, String>>> adsByCategory = const {
    'Stanovi': [
      {
        'title': 'Jednosoban stan',
        'description': 'Beograd, Vračar, 35m²',
        'price': '400€',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'title': 'Dvosoban stan',
        'description': 'Novi Sad, 55m²',
        'price': '550€',
        'image': 'https://via.placeholder.com/150'
      },
    ],
    'Prakse': [
      {
        'title': 'IT praksa',
        'description': 'Frontend developer, Beograd',
        'price': 'Besplatno',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'title': 'Marketing praksa',
        'description': 'Digital marketing, Novi Sad',
        'price': 'Besplatno',
        'image': 'https://via.placeholder.com/150'
      },
    ],
    'Ostalo': [
      {
        'title': 'Bicikl',
        'description': 'Road bike, korišćen',
        'price': '150€',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'title': 'Fudbalska lopta',
        'description': 'Adidas, original',
        'price': '50€',
        'image': 'https://via.placeholder.com/150'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'Stanovi'),
                Tab(text: 'Prakse'),
                Tab(text: 'Ostalo'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAdList(adsByCategory['Stanovi']!),
                _buildAdList(adsByCategory['Prakse']!),
                _buildAdList(adsByCategory['Ostalo']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Funkcija za pravljenje liste oglasa
  Widget _buildAdList(List<Map<String, String>> ads) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
            title: Text(
              ad['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ad['description']!),
                const SizedBox(height: 5),
                Text(
                  ad['price']!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
