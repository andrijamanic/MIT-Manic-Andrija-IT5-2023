import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Sadržaj za svaki tab
    final List<Widget> _pages = [
      const LoginScreen(), // sada samo widget, bez Scaffold
      const AdsScreen(),
      userProvider.isLoggedIn
          ? ProfileScreen(username: userProvider.username!)
          : const Center(
              child: Text('Morate da se ulogujete da vidite profil',
                  style: TextStyle(fontSize: 18))),
      userProvider.isLoggedIn
          ? const ChatScreen()
          : const Center(
              child: Text('Morate da se ulogujete da pristupite chatu',
                  style: TextStyle(fontSize: 18))),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('OGLASI')),
      body: _pages[_currentIndex], // prikazuje stranicu
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black, // boja aktivnog taba
        unselectedItemColor: Colors.black54, // boja neaktivnih tabova
        backgroundColor: Colors.white, // pozadina navbar-a
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Oglasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
