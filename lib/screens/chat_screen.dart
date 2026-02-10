import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/chat_services.dart';
import 'coversation_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatService = ChatService();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final uid = user.uid;

    if (!user.isLoggedIn || user.isGuest || uid == null) {
      return const Scaffold(
        body: Center(child: Text('Moraš biti ulogovan da koristiš chat.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatovi'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pretraži chatove...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => searchQuery = v.trim()),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _chatService.watchMyChats(uid),
        builder: (context, snap) {
          // ✅ 1) Error grana (najbitnije da ne vrti zauvek)
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Chat greška:\n${snap.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // ✅ 2) Connection state
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ 3) Nema podataka
          if (!snap.hasData) {
            return const Center(child: Text('Nema podataka.'));
          }

          final docs = snap.data!.docs;

          final filtered = docs.where((d) {
            final data = d.data();
            final title = (data['adTitle'] ?? '') as String;
            final last = (data['lastMessage'] ?? '') as String;
            final combined = ('$title $last').toLowerCase();
            return combined.contains(searchQuery.toLowerCase());
          }).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Nema chatova.'));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final doc = filtered[i];
              final data = doc.data();
              final adTitle = (data['adTitle'] ?? 'Oglas') as String;
              final last = (data['lastMessage'] ?? '') as String;

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.chat)),
                title: Text(adTitle),
                subtitle: Text(last.isEmpty ? 'Nema poruka' : last),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(
                        chatId: doc.id,
                        title: adTitle,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
