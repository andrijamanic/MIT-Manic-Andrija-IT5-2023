import 'package:flutter/material.dart';
import 'ads_detail_screen.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Map<String, String>>> adsByCategory = const {
    'Stanovi': [
      {
        'title': 'Jednosoban stan',
        'description': 'Beograd, Vračar, 35m²',
        'price': '400€',
        'category': 'Stanovi',
      },
      {
        'title': 'Dvosoban stan',
        'description': 'Novi Sad, 55m²',
        'price': '550€',
        'category': 'Stanovi',
      },
    ],
    'Prakse': [
      {
        'title': 'IT praksa',
        'description': 'Frontend developer, Beograd',
        'price': 'Besplatno',
        'category': 'Prakse',
      },
    ],
    'Ostalo': [
      {
        'title': 'Bicikl',
        'description': 'Road bike, korišćen',
        'price': '150€',
        'category': 'Ostalo',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Stanovi'),
            Tab(text: 'Prakse'),
            Tab(text: 'Ostalo'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAdList(context, adsByCategory['Stanovi']!),
              _buildAdList(context, adsByCategory['Prakse']!),
              _buildAdList(context, adsByCategory['Ostalo']!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdList(BuildContext context, List<Map<String, String>> ads) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];

        return Card(
          child: ListTile(
            title: Text(
              ad['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ad['description']!),
                const SizedBox(height: 6),
                Text(
                  ad['price']!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                if (ad['category'] == 'Stanovi')
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rezervacija (frontend placeholder)'),
                          ),
                        );
                      },
                      child: const Text('Rezerviši'),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdDetailScreen(ad: ad),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
