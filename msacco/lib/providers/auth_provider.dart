import 'package:flutter/material.dart';
import 'package:msacco/data_layer/auth_repository.dart';
import 'package:msacco/models/user_model.dart';
import 'package:msacco/utils/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msacco/config/config.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  Account? _currentAccount;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  Account? get currentAccount => _currentAccount;

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

  Future<void> fetchAccountDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/account'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final accountData = json.decode(response.body);
        _currentAccount = Account.fromJson(accountData);
        await AppConfig.setAccountDetails(
          hasAcc: true,
          accNumber: accountData['account_number'],
          shareBal: accountData['share_balance'],
          depositBal: accountData['deposit_balance'],
        );
      } else {
        _currentAccount = null;
        await AppConfig.setAccountDetails(hasAcc: false);
      }
      notifyListeners();
    } catch (e) {
      _currentAccount = null;
      await AppConfig.setAccountDetails(hasAcc: false);
      rethrow;
    }
  }
}

class Account {
  final String accountNumber;
  final String shareBalance;
  final String depositBalance;

  Account({
    required this.accountNumber,
    required this.shareBalance,
    required this.depositBalance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountNumber: json['account_number'],
      shareBalance: json['share_balance'],
      depositBalance: json['deposit_balance'],
    );
  }
}
