import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For debug logging

class AppConfig {
  static const String apiBaseUrl = 'http://192.168.43.240:81/api';

  // Static fields for session data
  static int? userId;
  static String? userName;
  static String? userToken;

  // New fields for account data
  static bool hasAccount = false;
  static String? accountNumber;
  static String? shareBalance;
  static String? depositBalance;

  // Add theme preference
  static bool isDarkMode = false;

  static SharedPreferences? _preferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();

    // Load user data
    userId = _preferences?.getInt('userId');
    userName = _preferences?.getString('userName');
    userToken = _preferences?.getString('token');

    // Load account data
    hasAccount = _preferences?.getBool('hasAccount') ?? false;
    accountNumber = _preferences?.getString('accountNumber');
    shareBalance = _preferences?.getString('shareBalance');
    depositBalance = _preferences?.getString('depositBalance');

    // Load theme preference
    isDarkMode = _preferences?.getBool('isDarkMode') ?? false;

    // Debug logs
    debugPrint('AppConfig initialized.');
    debugPrint('Loaded userId: $userId');
    debugPrint('Loaded userName: $userName');
    debugPrint('Loaded token: $userToken');
    debugPrint('Has Account: $hasAccount');
    debugPrint('Account Number: $accountNumber');
    debugPrint('Share Balance: $shareBalance');
    debugPrint('Deposit Balance: $depositBalance');
    debugPrint('Dark Mode: $isDarkMode');
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

  /// Set Account Details
  static Future<void> setAccountDetails({
    required bool hasAcc,
    String? accNumber,
    String? shareBal,
    String? depositBal,
  }) async {
    hasAccount = hasAcc;
    accountNumber = accNumber;
    shareBalance = shareBal;
    depositBalance = depositBal;

    await _preferences?.setBool('hasAccount', hasAcc);
    if (accNumber != null) {
      await _preferences?.setString('accountNumber', accNumber);
    }
    if (shareBal != null) {
      await _preferences?.setString('shareBalance', shareBal);
    }
    if (depositBal != null) {
      await _preferences?.setString('depositBalance', depositBal);
    }

    debugPrint('Set hasAccount: $hasAccount');
    debugPrint('Set accountNumber: $accountNumber');
    debugPrint('Set shareBalance: $shareBalance');
    debugPrint('Set depositBalance: $depositBalance');
  }

  /// Clear Session Data
  static Future<void> clear() async {
    // Store current theme setting
    final bool? currentTheme = _preferences?.getBool('isDarkMode');

    // Clear session data
    userToken = null;
    userId = null;
    userName = null;
    hasAccount = false;
    accountNumber = null;
    shareBalance = null;
    depositBalance = null;

    // Clear preferences except theme
    await _preferences?.clear();

    // Restore theme setting
    if (currentTheme != null) {
      await _preferences?.setBool('isDarkMode', currentTheme);
      isDarkMode = currentTheme;
    }
  }

  static Future<void> setShareBalance(String balance) async {
    await _preferences?.setString('share_balance', balance);
    shareBalance = balance;
  }

  static Future<void> setDepositBalance(String balance) async {
    await _preferences?.setString('deposit_balance', balance);
    depositBalance = balance;
  }

  // Add theme methods
  static Future<void> saveTheme(bool darkMode) async {
    await _preferences?.setBool('isDarkMode', darkMode);
    isDarkMode = darkMode;
  }
}
