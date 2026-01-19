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
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // za skrivanje/otkrivanje lozinke

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // KORISNIČKO IME (ovde možeš uneti i email, npr admin@gmail.com)
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Korisničko ime / email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite korisničko ime';
                  }
                  if (value.length < 3) {
                    return 'Korisničko ime mora imati najmanje 3 karaktera';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // ŠIFRA sa opcijom prikaza/skrivanja
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Šifra',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite šifru';
                  }
                  if (value.length < 4) {
                    return 'Šifra mora imati najmanje 4 karaktera';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // LOGIN DUGME
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);

                      userProvider.login(usernameController.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                  child: const Text('Uloguj se'),
                ),
              ),

              const SizedBox(height: 10),

              // PRIJAVA KAO GOST
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);

                    userProvider.loginAsGuest();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text('Prijavi se kao gost'),
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
      ),
    );
  }
}
