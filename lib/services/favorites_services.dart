import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<Set<String>> watchFavoriteIds(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => d.id).toSet(),
        );
  }

  Stream<bool> isFavorite(String uid, String adId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(adId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> toggleFavorite({
    required String uid,
    required String adId,
  }) async {
    final ref =
        _db.collection('users').doc(uid).collection('favorites').doc(adId);
    final doc = await ref.get();

    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({
        'adId': adId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
