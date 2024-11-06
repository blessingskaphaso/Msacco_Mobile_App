import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/cache_manager.dart';
import 'package:msacco/utils/logger.dart';

class ApiService {
  final CacheManager _cacheManager = CacheManager();
  static const String baseUrl = AppConfig.apiBaseUrl;

  // Method for GET requests with optional auth header
  Future<http.Response> getRequest(String endpoint, [String? token]) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Method for POST requests with optional auth header
  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data,
      [String? token]) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      logger.i('Making POST request to: $url');
      logger.i('Request headers: ${{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      }}');

      // Log the request body without sensitive data
      final sanitizedData = Map<String, dynamic>.from(data);
      if (sanitizedData.containsKey('password')) {
        sanitizedData['password'] = '****';
      }
      logger.i('Request body: $sanitizedData');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      logger.i('Response status code: ${response.statusCode}');
      logger.i('Response headers: ${response.headers}');

      // Log response body if it's not successful
      if (response.statusCode != 200) {
        logger.w('Error response body: ${response.body}');
      }

      return response;
    } catch (e, stackTrace) {
      logger.e('API request failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Method to get token from cache if required for authenticated requests
  Future<String?> getAuthToken() async {
    return await _cacheManager.getToken();
  }
}
