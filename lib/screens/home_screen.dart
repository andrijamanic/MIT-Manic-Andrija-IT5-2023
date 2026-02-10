import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/auth_services.dart';
import '../services/ads_services.dart';
import '../services/user_services.dart';
import '../models/ads.dart';

import 'login_screen.dart';
import 'ads_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _adminTabIndex = 0;

  final AdsService _adsService = AdsService();
  final UsersService _usersService = UsersService();

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
        return _buildAdminUsersList(userProvider);
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

  Widget _buildAdminUsersList(UserProvider userProvider) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _usersService.streamUsers(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text('Greška: ${snap.error}'));
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('Nema korisnika u bazi.'));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final uid = doc.id;
            final email = (data['email'] ?? '').toString();
            final username = (data['username'] ?? '').toString();
            final role = (data['role'] ?? 'USER').toString().toUpperCase();

            final isAdmin = role == 'ADMIN';
            final isMe = (userProvider.uid != null && userProvider.uid == uid);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(username.isNotEmpty ? username : '(bez username)'),
                subtitle: Text(
                  email.isNotEmpty ? '$email  •  $role' : role,
                ),
                trailing: IconButton(
                  tooltip: isAdmin
                      ? 'Admin se ne briše'
                      : isMe
                          ? 'Ne možeš obrisati sam sebe'
                          : 'Obriši korisnika',
                  icon: Icon(
                    Icons.delete,
                    color: (isAdmin || isMe) ? Colors.grey : Colors.red,
                  ),
                  onPressed: (isAdmin || isMe)
                      ? null
                      : () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Brisanje korisnika'),
                              content: Text(
                                'Da li sigurno želiš da obrišeš ovog korisnika iz baze?\n\n$email',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Otkaži'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Obriši'),
                                ),
                              ],
                            ),
                          );

                          if (ok != true) return;

                          try {
                            await _usersService.deleteUserDoc(uid);

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Korisnik obrisan iz Firestore.'),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Greška: $e')),
                            );
                          }
                        },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
