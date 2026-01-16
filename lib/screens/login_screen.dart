import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Već ste ulogovani kao ${userProvider.username}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProvider.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Korisničko ime'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Šifra'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String username = _usernameController.text.trim();
              String password = _passwordController.text.trim();

              if (username.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Unesite korisničko ime i šifru')),
                );
                return;
              }

              userProvider.login(username); // frontend-only
            },
            child: Text(_isRegister ? 'Registruj se' : 'Login'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isRegister = !_isRegister;
              });
            },
            child: Text(_isRegister
                ? 'Već imate nalog? Login'
                : 'Nemate nalog? Registruj se'),
          ),
        ],
      ),
    );
  }
}
