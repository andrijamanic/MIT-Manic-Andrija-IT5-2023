import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> chats = const [
    'Marko',
    'Ana',
    'Vlasnik stana',
    'Jovana',
  ];

  List<String> filteredChats = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredChats = chats;
  }

  void _filterChats(String query) {
    setState(() {
      searchQuery = query;
      filteredChats = chats
          .where((chat) => chat.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatovi'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pretraži kontakte...',
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
              onChanged: (value) => _filterChats(value),
            ),
          ),
        ),
      ),
      body: filteredChats.isEmpty
          ? Center(
              child: Text(
                'Nema kontakata koji odgovaraju pretrazi',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            )
          : ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    filteredChats[index],
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationScreen(
                            contactName: filteredChats[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class ConversationScreen extends StatelessWidget {
  final String contactName;
  const ConversationScreen({super.key, required this.contactName});

  @override
  Widget build(BuildContext context) {
    // Fejk poruke
    final List<Map<String, dynamic>> messages = [
      {'text': 'Pozdrav, video sam oglas, jel jos aktivan?', 'isMine': false},
      {'text': 'Da, jeste zainteresovani?', 'isMine': true},
      {'text': 'Super! Jesam, mozemo da se dogovorimo?', 'isMine': false},
      {'text': 'Naravno, kada ste slobodni', 'isMine': true},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(contactName)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Align(
              alignment:
                  msg['isMine'] ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: msg['isMine']
                      ? Colors.blue
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  msg['text'],
                  style: TextStyle(
                    color: msg['isMine']
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
