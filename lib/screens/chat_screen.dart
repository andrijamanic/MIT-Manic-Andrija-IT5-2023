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

          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData) {
            return const Center(child: Text('Nema podataka.'));
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nema chatova.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data();

              final last = (data['lastMessage'] ?? '') as String;
              final participants =
                  (data['participants'] ?? []) as List<dynamic>;

              // nađi drugog korisnika
              String otherUid = '';
              for (final p in participants) {
                final s = p.toString();
                if (s != uid) {
                  otherUid = s;
                  break;
                }
              }

              return FutureBuilder<String>(
                future: _chatService.getUsername(otherUid),
                builder: (context, nameSnap) {
                  final otherName = (nameSnap.data ?? 'Korisnik');

                  final combined = ('$otherName $last').toLowerCase();
                  if (searchQuery.isNotEmpty &&
                      !combined.contains(searchQuery.toLowerCase())) {
                    return const SizedBox.shrink();
                  }

                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(otherName),
                    subtitle: Text(last.isEmpty ? 'Nema poruka' : last),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConversationScreen(
                            chatId: doc.id,
                            title: otherName, // ✅ username
                          ),
                        ),
                      );
                    },
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
