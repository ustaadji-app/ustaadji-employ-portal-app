import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _user = {}; // ab String -> dynamic

  Map<String, dynamic> get user => _user;

  void setUser(Map<String, dynamic> userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = {};
    notifyListeners();
  }
}
