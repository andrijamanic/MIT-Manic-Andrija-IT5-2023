import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_services.dart';
import 'login_screen.dart';
import 'ads_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';
import '../services/ads_services.dart';
import '../models/ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _adminTabIndex = 0;

  final AdsService _adsService = AdsService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).unselectedWidgetColor;
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.isAdmin ? 'ADMIN PANEL' : 'OGLASI'),
        actions: [
          if (userProvider.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () async {
                // Ako nije gost -> Firebase signOut
                if (!userProvider.isGuest) {
                  await AuthService().logout();
                }
                userProvider.logoutLocal();

                setState(() {
                  _currentIndex = 0;
                  _adminTabIndex = 0;
                });
              },
            ),
        ],
      ),
      body: _buildBody(userProvider, textColor),
      bottomNavigationBar: userProvider.isLoggedIn
          ? (userProvider.isAdmin
              ? BottomNavigationBar(
                  currentIndex: _adminTabIndex,
                  selectedItemColor: selectedColor,
                  unselectedItemColor: unselectedColor,
                  onTap: (index) => setState(() => _adminTabIndex = index),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt, color: iconColor),
                      label: 'Oglasi',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people, color: iconColor),
                      label: 'Korisnici',
                    ),
                  ],
                )
              : BottomNavigationBar(
                  currentIndex: _currentIndex,
                  selectedItemColor: selectedColor,
                  unselectedItemColor: unselectedColor,
                  onTap: (index) => setState(() => _currentIndex = index),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list, color: iconColor),
                      label: 'Oglasi',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person, color: iconColor),
                      label: 'Profil',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat, color: iconColor),
                      label: 'Chat',
                    ),
                  ],
                ))
          : null,
    );
  }

  Widget _buildBody(UserProvider userProvider, Color? textColor) {
    if (!userProvider.isLoggedIn) return const LoginScreen();

    if (userProvider.isAdmin) {
      if (_adminTabIndex == 0) {
        return _buildAdminAdsList();
      } else {
        return _buildAdminUsersList();
      }
    }

    switch (_currentIndex) {
      case 0:
        return const AdsScreen();
      case 1:
        return !userProvider.isGuest
            ? ProfileScreen(username: userProvider.username ?? '')
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Gosti ne mogu pristupiti profilu. Molimo se registrujte da vidite svoj profil.',
                    style: TextStyle(fontSize: 18, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      case 2:
        return !userProvider.isGuest
            ? const ChatScreen()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Gosti ne mogu koristiti chat. Molimo se registrujte da koristite chat.',
                    style: TextStyle(fontSize: 18, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      default:
        return const AdsScreen();
    }
  }

  Widget _buildAdminAdsList() {
    return FutureBuilder<List<Ad>>(
      future: _adsService.getAds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Nema oglasa."));
        }

        final ads = snapshot.data!;

        return ListView.builder(
          itemCount: ads.length,
          itemBuilder: (context, index) {
            final ad = ads[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(ad.title),
                subtitle: Text("${ad.category} • ${ad.location} • ${ad.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _adsService.deleteAd(ad.id);
                    setState(() {}); // refresh FutureBuilder
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdminUsersList() {
    final fakeUsers = [
      "pera@gmail.com",
      "mika@gmail.com",
      "ana@gmail.com",
      "admin@gmail.com",
      "Gost",
    ];

    return ListView.builder(
      itemCount: fakeUsers.length,
      itemBuilder: (context, index) {
        final u = fakeUsers[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(u),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
