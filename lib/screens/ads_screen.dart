import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ads.dart';
import '../widgets/ads_card.dart';
import '../providers/user_provider.dart';
import 'ads_detail_screen.dart';
import '../services/ads_services.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Ad>> _adsFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _adsFuture = AdsService().getAds();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder<List<Ad>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final ads = snapshot.data!;

        // Filtriranje po kategorijama
        final stanoviFiltered = ads
            .where((ad) =>
                ad.category == 'Stanovi' &&
                ad.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        final prakseFiltered = ads
            .where((ad) =>
                ad.category == 'Prakse' &&
                ad.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        final ostaloFiltered = ads
            .where((ad) =>
                ad.category == 'Ostalo' &&
                ad.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pretraži oglase...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),

            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Stanovi'),
                Tab(text: 'Prakse'),
                Tab(text: 'Ostalo'),
              ],
            ),

            // TabBarView sa listama
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAdList(
                      context, stanoviFiltered, userProvider, 'Stanovi'),
                  _buildAdList(context, prakseFiltered, userProvider, 'Prakse'),
                  _buildAdList(context, ostaloFiltered, userProvider, 'Ostalo'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdList(BuildContext context, List<Ad> ads,
      UserProvider userProvider, String category) {
    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];

        // Dodela slike po kategoriji i indeksu
        // (sklonjeni placeholder-i koji ne postoje, da nema crvenog X)
        String slikaPath;
        switch (category) {
          case 'Stanovi':
            slikaPath = (index == 0)
                ? 'assets/images/slika1.jpg'
                : (index == 1)
                    ? 'assets/images/slika2.jpg'
                    : 'assets/images/slika1.jpg';
            break;
          case 'Prakse':
            slikaPath = 'assets/images/slika3.webp';
            break;
          case 'Ostalo':
            slikaPath = 'assets/images/slika4.jpg';
            break;
          default:
            slikaPath = 'assets/images/slika1.jpg';
        }

        return AdCard(
          ad: ad,
          imagePath: slikaPath,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdDetailScreen(ad: ad, imagePath: slikaPath),
              ),
            );
          },
          onReserve: ad.category == 'Stanovi'
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rezervacija')),
                  );
                }
              : null,
        );
      },
    );
  }
}
