import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static SharedPreferences? _preferences;
  static String? apiBaseUrl = 'http://192.168.1.235:81/api';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String? get userId => _preferences?.getString('userId');
  static String? get userName => _preferences?.getString('userName');
  static String? get token => _preferences?.getString('token');

  static Future<void> setUserId(String id) async {
    await _preferences?.setString('userId', id);
  }

  static Future<void> setUserName(String name) async {
    await _preferences?.setString('userName', name);
  }

  static Future<void> setToken(String token) async {
    await _preferences?.setString('token', token);
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
