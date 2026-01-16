import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;

  const ProfileScreen({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dobrodošao, $username!',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }
}
