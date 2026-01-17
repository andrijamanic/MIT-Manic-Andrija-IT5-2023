import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // KORISNIČKO IME
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Korisničko ime',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ŠIFRA
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Šifra',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            // LOGIN DUGME
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);

                  // Placeholder login: postavi bilo šta kao username
                  userProvider.login(usernameController.text);

                  // Zamenjujemo trenutni ekran HomeScreen-om da se sve osveži
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text('Uloguj se'),
              ),
            ),

            const SizedBox(height: 15),

            // REGISTRACIJA
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Nemaš nalog? Registruj se'),
            ),
          ],
        ),
      ),
    );
  }
}
