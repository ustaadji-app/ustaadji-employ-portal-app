import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageHelper {
  static final _secureStorage = FlutterSecureStorage();

  // ---------------- Token ----------------
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  static const String _userKey = "user";

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user);
    await prefs.setString(_userKey, userJson);
  }

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null || userString.isEmpty) return {};
    return jsonDecode(userString) as Map<String, dynamic>;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // ---------------- Clear All ----------------
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secureStorage.deleteAll();
  }
}
