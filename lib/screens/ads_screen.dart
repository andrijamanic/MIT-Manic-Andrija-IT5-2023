import 'package:flutter/material.dart';
import '../models/ads.dart';
import '../widgets/ads_card.dart';
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
    return FutureBuilder<List<Ad>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final ads = snapshot.data!;

        final stanovi = ads.where((ad) => ad.category == 'Stanovi').toList();
        final prakse = ads.where((ad) => ad.category == 'Prakse').toList();
        final ostalo = ads.where((ad) => ad.category == 'Ostalo').toList();

        final labelColor = Theme.of(context).colorScheme.primary;
        final unselectedLabelColor = Theme.of(context).unselectedWidgetColor;
        final indicatorColor = Theme.of(context).colorScheme.primary;

        return Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: labelColor,
              unselectedLabelColor: unselectedLabelColor,
              indicatorColor: indicatorColor,
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
                  _buildAdList(context, stanovi),
                  _buildAdList(context, prakse),
                  _buildAdList(context, ostalo),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdList(BuildContext context, List<Ad> ads) {
    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return AdCard(
          ad: ad,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdDetailScreen(ad: ad)),
            );
          },
          onReserve: ad.category == 'Stanovi'
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rezervacija (placeholder)')),
                  );
                }
              : null,
        );
      },
    );
  }
}
