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

    // Boje koje prate temu
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).unselectedWidgetColor;
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OGLASI'),
      ),
      body: _buildBody(userProvider, textColor),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login, color: iconColor),
            label: 'Login',
          ),
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
      ),
    );
  }

  Widget _buildBody(UserProvider userProvider, Color? textColor) {
    switch (_currentIndex) {
      case 0:
        return const LoginScreen();
      case 1:
        return const AdsScreen();
      case 2:
        return userProvider.isLoggedIn && userProvider.username != null
            ? ProfileScreen(username: userProvider.username!)
            : Center(
                child: Text(
                  'Morate da se ulogujete da vidite profil',
                  style: TextStyle(fontSize: 18, color: textColor),
                  textAlign: TextAlign.center,
                ),
              );
      case 3:
        return userProvider.isLoggedIn
            ? const ChatScreen()
            : Center(
                child: Text(
                  'Morate da se ulogujete da pristupite chatu',
                  style: TextStyle(fontSize: 18, color: textColor),
                  textAlign: TextAlign.center,
                ),
              );
      default:
        return const LoginScreen();
    }
  }
}
