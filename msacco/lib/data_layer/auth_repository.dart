import 'dart:convert';
import 'package:msacco/models/user_model.dart';
import 'package:msacco/services/api_service.dart';
import 'package:msacco/utils/cache_manager.dart';
import 'package:msacco/utils/logger.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final CacheManager _cacheManager = CacheManager();

  // Method for registering a new user
  Future<String?> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _apiService.postRequest('register', {
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'password_confirmation': password,
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        logger.i('Registration successful: ${data['message']}');
        return null; // No error
      } else {
        final errors = data['errors'] ?? data['message'];
        logger.w('Registration failed: $errors');
        return errors is Map ? errors.values.join(', ') : errors;
      }
        } catch (e) {
      logger.e('Error during registration: $e');
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Method for logging in the user
  Future<UserModel?> login(String email, String password) async {
    final response = await _apiService.postRequest(
      'login',
      {'email': email, 'password': password},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      logger.i('Login successful: ${data['message']}');
      await _cacheManager.saveToken(data['token']);
      return UserModel.fromJson(data['user']);
    } else {
      logger.w('Login failed: ${data['message']}');
      return null;
    }
    }

  // Method to fetch user details
  Future<UserModel?> fetchUserDetails() async {
    final token = await _cacheManager.getToken();
    if (token == null) {
      logger.w('No token found in cache for fetching user details');
      return null;
    }

    final response = await _apiService.getRequest('user/profile', token);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      logger.i('User details fetched successfully');
      return UserModel.fromJson(data);
    } else {
      logger.w('Failed to fetch user details: ${data['message']}');
      return null;
    }
    }

  // Method to clear token
  Future<void> clearToken() async {
    await _cacheManager.clear();
    logger.i('Token cleared from cache.');
  }
}
