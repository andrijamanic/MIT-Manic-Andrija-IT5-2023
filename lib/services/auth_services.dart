import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = cred.user!.uid;

    // Ako hoćeš admin nalog: napravi user sa email "admin@gmail.com"
    final role =
        email.trim().toLowerCase() == 'admin@gmail.com' ? 'ADMIN' : 'USER';

    await _db.collection('users').doc(uid).set({
      'email': email.trim(),
      'username': username.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() => _auth.signOut();

  Future<String> getRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data();
    return (data?['role'] ?? 'USER') as String;
  }
}
