import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For debug logging

class AppConfig {
  static const String apiBaseUrl = 'http://192.168.43.240/api';

  // Static fields for session data
  static int? userId;
  static String? userName;
  static String? userToken;

  static SharedPreferences? _preferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    userId = _preferences?.getInt('userId');
    userName = _preferences?.getString('userName');
    userToken = _preferences?.getString('token');

    // Debug logs
    debugPrint('AppConfig initialized.');
    debugPrint('Loaded userId: $userId');
    debugPrint('Loaded userName: $userName');
    debugPrint('Loaded token: $userToken');
  }

  /// Set User ID
  static Future<void> setUserId(int id) async {
    userId = id;
    await _preferences?.setInt('userId', id);
    debugPrint('Set userId: $userId');
  }

  /// Set User Name
  static Future<void> setUserName(String name) async {
    userName = name;
    await _preferences?.setString('userName', name);
    debugPrint('Set userName: $userName');
  }

  /// Set Token
  static Future<void> setToken(String newToken) async {
    userToken = newToken;
    await _preferences?.setString('token', newToken);
    debugPrint('Set token: $userToken');
  }

  /// Clear Session Data
  static Future<void> clear() async {
    userId = null;
    userName = null;
    userToken = null;
    await _preferences?.clear();

    // Debug logs
    debugPrint('Cleared all session data.');
  }
}
