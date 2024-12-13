import 'package:flutter/material.dart';
import 'package:msacco/data_layer/auth_repository.dart';
import 'package:msacco/models/user_model.dart';
import 'package:msacco/utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;

  /// Method to register a new user
  Future<String?> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final error = await _authRepository.register(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    return error; // null if success, or an error message if failed
  }

  /// Method to log in the user
  Future<Map<String, dynamic>?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);
      if (response != null) {
        _currentUser = UserModel.fromJson(response['user']);
        _token = response['token'];
        logger.d('Token received in provider: $_token');
      }
      _isLoading = false;
      notifyListeners();

      return response;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Method to fetch current user details
  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authRepository.fetchUserDetails();
    _isLoading = false;
    notifyListeners();
  }

  /// Method to log out the user
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    await _authRepository.clearToken();
    notifyListeners();
  }
}
