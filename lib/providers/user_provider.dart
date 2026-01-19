import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  bool get isGuest => _username == "Gost";

  bool get isAdmin =>
      _isLoggedIn && (_username?.trim().toLowerCase() == "admin@gmail.com");

  void login(String username) {
    _isLoggedIn = true;
    _username = username.trim();
    notifyListeners();
  }

  void loginAsGuest() {
    _isLoggedIn = true;
    _username = "Gost";
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}
