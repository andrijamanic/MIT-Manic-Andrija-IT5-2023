import 'package:flutter/material.dart';

enum UserRole { guest, user, admin }

class AuthProvider with ChangeNotifier {
  UserRole _role = UserRole.guest;
  bool _isLoggedIn = false;

  UserRole get role => _role;
  bool get isLoggedIn => _isLoggedIn;

  void login(UserRole role) {
    _role = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _role = UserRole.guest;
    _isLoggedIn = false;
    notifyListeners();
  }
}
