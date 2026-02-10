import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/chat_services.dart';

class ConversationScreen extends StatefulWidget {
  final String chatId;
  final String title;

  const ConversationScreen({
    super.key,
    required this.chatId,
    required this.title,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _ctrl = TextEditingController();
  final _chatService = ChatService();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _chatService.watchMessages(widget.chatId),
              builder: (context, snap) {
                // ✅ error
                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Poruke greška:\n${snap.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // ✅ loading
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snap.hasData) {
                  return const Center(child: Text('Nema podataka.'));
                }

                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('Nema poruka.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final senderId = (data['senderId'] ?? '') as String;
                    final text = (data['text'] ?? '') as String;

                    final isMine = senderId == uid;

                    return Align(
                      alignment:
                          isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Colors.blue
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: isMine
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInput(uid),
        ],
      ),
    );
  }

  Widget _buildInput(String uid) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: InputDecoration(
                  hintText: 'Unesi poruku...',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _send(uid),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _send(uid),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send(String uid) async {
    final text = _ctrl.text;
    _ctrl.clear();

    await _chatService.sendMessage(
      chatId: widget.chatId,
      senderId: uid,
      text: text,
    );
  }
}
