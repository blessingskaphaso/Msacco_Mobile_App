import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// Perform a GET request
  static Future<Map<String, dynamic>?> get(String url, String token) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('GET request failed: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during GET request: $e');
      return null;
    }
  }

  /// Perform a POST request
  static Future<Map<String, dynamic>?> post(
      String url, String token, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('POST request failed: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return null;
    }
  }

  /// Perform a PATCH request
  static Future<Map<String, dynamic>?> patch(
      String url, String token, Map<String, dynamic> body) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('PATCH request failed: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during PATCH request: $e');
      return null;
    }
  }

  /// Perform a DELETE request
  static Future<bool> delete(String url, String token) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print(
            'DELETE request failed: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return false;
    }
  }
}
