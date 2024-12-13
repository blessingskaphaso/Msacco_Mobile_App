import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static SharedPreferences? _preferences;
  static const String _apiBaseUrlKey = 'apiBaseUrl';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';
  static const String _tokenKey = 'token';

  static String apiBaseUrl = 'http://192.168.1.198:81/api'; // Default base URL

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Get User ID
  static String? get userId => _preferences?.getString(_userIdKey);

  /// Get User Name
  static String? get userName => _preferences?.getString(_userNameKey);

  /// Get Token
  static String? get token => _preferences?.getString(_tokenKey);

  /// Set User ID
  static Future<void> setUserId(String id) async {
    if (_preferences != null) {
      await _preferences!.setString(_userIdKey, id);
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }

  /// Set User Name
  static Future<void> setUserName(String name) async {
    if (_preferences != null) {
      await _preferences!.setString(_userNameKey, name);
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }

  /// Set Token
  static Future<void> setToken(String token) async {
    if (_preferences != null) {
      await _preferences!.setString(_tokenKey, token);
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }

  /// Clear All Stored Data
  static Future<void> clear() async {
    if (_preferences != null) {
      await _preferences!.clear();
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }
}
