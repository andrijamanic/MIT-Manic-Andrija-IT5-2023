import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat, size: 50, color: Colors.grey),
          SizedBox(height: 20),
          Text('Chat će biti ovde', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
