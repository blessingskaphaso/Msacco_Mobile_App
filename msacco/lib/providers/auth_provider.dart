import 'package:flutter/material.dart';
import 'package:msacco/data_layer/auth_repository.dart';
import 'package:msacco/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Method to register a new user
  // Method to register a new user
  Future<String?> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Retrieve the error message or null if successful
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

  // Method to log in the user
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authRepository.login(email, password);
    _isLoading = false;
    notifyListeners();
  }

  // Method to fetch current user details
  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authRepository.fetchUserDetails();
    _isLoading = false;
    notifyListeners();
  }

  // Method to log out the user
  Future<void> logout() async {
    _currentUser = null;
    await _authRepository.clearToken();
    notifyListeners();
  }
}
