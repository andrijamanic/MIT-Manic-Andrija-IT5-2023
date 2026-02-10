import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String buildChatId({
    required String adId,
    required String uid1,
    required String uid2,
  }) {
    final a = uid1.compareTo(uid2) <= 0 ? uid1 : uid2;
    final b = uid1.compareTo(uid2) <= 0 ? uid2 : uid1;
    return '${adId}__${a}__${b}';
  }

  /// Kreira chat ako ne postoji i vraća chatId
  Future<String> createOrGetChat({
    required String adId,
    required String adTitle,
    required String ownerId,
    required String otherUserId,
  }) async {
    final chatId = buildChatId(adId: adId, uid1: ownerId, uid2: otherUserId);
    final ref = _db.collection('chats').doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'adId': adId,
        'adTitle': adTitle,
        'ownerId': ownerId,
        'participants': [ownerId, otherUserId],
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMyChats(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final chatRef = _db.collection('chats').doc(chatId);
    final msgRef = chatRef.collection('messages').doc();

    await _db.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': senderId,
        'text': trimmed,
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.update(chatRef, {
        'lastMessage': trimmed,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
