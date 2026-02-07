import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  String? _email;
  String? _uid;

  String _role = 'GUEST'; // GUEST / USER / ADMIN

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _email; // tvoj UI koristi username/email
  String? get uid => _uid;

  String get role => _role;
  bool get isGuest => _role == 'GUEST';
  bool get isAdmin => _role == 'ADMIN';

  void setUser({
    required bool isLoggedIn,
    String? email,
    String? uid,
    String role = 'USER',
  }) {
    _isLoggedIn = isLoggedIn;
    _email = email;
    _uid = uid;
    _role = role;
    notifyListeners();
  }

  void loginAsGuest() {
    _isLoggedIn = true;
    _email = "Gost";
    _uid = null;
    _role = 'GUEST';
    notifyListeners();
  }

  void logoutLocal() {
    _isLoggedIn = false;
    _email = null;
    _uid = null;
    _role = 'GUEST';
    notifyListeners();
  }
}
