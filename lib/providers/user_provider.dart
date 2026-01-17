import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  bool get isGuest => _username == "Gost"; // proveravamo da li je gost

  void login(String username) {
    _isLoggedIn = true;
    _username = username;
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
