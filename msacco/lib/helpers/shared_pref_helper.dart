// lib/helpers/shared_pref_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _keyUserId = 'userId';
  static const String _keyToken = 'token';

  static Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyToken);
  }
}
