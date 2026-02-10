import 'package:cloud_firestore/cloud_firestore.dart';

class UsersService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Svi korisnici iz Firestore (real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsers() {
    // createdAt ti postoji u users dokumentu (po tvom AuthService.register)
    return _db
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Briše samo dokument iz 'users' kolekcije (ne briše Firebase Auth nalog)
  Future<void> deleteUserDoc(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }
}
