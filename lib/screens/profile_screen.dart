import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_option_title.dart';
import '../screens/add_ads_screen.dart';
import '../screens/my_ads_screen.dart';
import '../screens/my_reservations_screen.dart';
import '../screens/favorites_screen.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  final String? username;

  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    if (!userProvider.isLoggedIn || username == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Morate da se ulogujete da vidite profil',
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zdravo, $username!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 25),
            ProfileOptionTile(
              text: 'Dodaj oglas',
              icon: Icons.add,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAdScreen()),
                );
              },
            ),
            ProfileOptionTile(
              text: 'Moji oglasi',
              icon: Icons.list,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyAdsScreen()),
                );
              },
            ),
            ProfileOptionTile(
              text: 'Moji omiljeni oglasi',
              icon: Icons.favorite,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            ProfileOptionTile(
              text: 'Moje rezervacije',
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MyReservationsScreen()),
                );
              },
            ),
            const SizedBox(height: 30),
            Text(
              'Podešavanja',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text('Tamna tema', style: TextStyle(color: textColor)),
                trailing: Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
