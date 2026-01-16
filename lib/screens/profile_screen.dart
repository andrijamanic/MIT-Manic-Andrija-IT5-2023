import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Moj profil',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                child: Icon(Icons.person, size: 30),
              ),
              const SizedBox(width: 15),
              Text(
                username,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildProfileOption(
            icon: Icons.add_circle_outline,
            title: 'Dodaj oglas',
            onTap: () {
              // kasnije: AddAdScreen
            },
          ),
          _buildProfileOption(
            icon: Icons.list_alt,
            title: 'Moji oglasi',
            onTap: () {
              // kasnije: MyAdsScreen
            },
          ),
          _buildProfileOption(
            icon: Icons.bookmark_border,
            title: 'Moje rezervacije',
            onTap: () {
              // kasnije: ReservationsScreen
            },
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                userProvider.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
