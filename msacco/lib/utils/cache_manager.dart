import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheManager {
  final _storage = const FlutterSecureStorage();

  // Save the auth token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  // Retrieve the auth token
  Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  // Clear stored data (useful on logout)
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
