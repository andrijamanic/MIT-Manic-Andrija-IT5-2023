import 'package:flutter/material.dart';
import '../consts/validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registracija')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // EMAIL
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // KORISNIČKO IME
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Korisničko ime',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ŠIFRA sa sakrij/prikaži
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Šifra',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),

            // REGISTRACIJA DUGME
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validatori
                  final emailError =
                      MyValidators.emailValidator(emailController.text);
                  final usernameError = MyValidators.displayNameValidator(
                      usernameController.text);
                  final passwordError =
                      MyValidators.passwordValidator(passwordController.text);

                  if (emailError != null ||
                      usernameError != null ||
                      passwordError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(emailError ?? usernameError ?? passwordError!),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                },
                child: const Text('Registruj se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
