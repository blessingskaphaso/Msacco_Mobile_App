import 'package:flutter/material.dart';
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:msacco/providers/auth_provider.dart';
import 'package:msacco/screens/dashboard_screen.dart';
import 'package:msacco/screens/signup_screen.dart'; // Import Signup Screen
import 'package:msacco/widgets/loading_widget.dart';
import 'package:msacco/widgets/message_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _clearCache();
  }

  Future<void> _clearCache() async {
    try {
      logger.i('Clearing app cache and user data...');

      // Clear all config variables except theme
      await AppConfig.clear();

      logger.i('Cache cleared successfully');
      logger.d('User Token: ${AppConfig.userToken}');
      logger.d('User ID: ${AppConfig.userId}');
      logger.d('Account Number: ${AppConfig.accountNumber}');
      logger.d('Has Account: ${AppConfig.hasAccount}');
      logger.d('Theme Mode: ${AppConfig.isDarkMode}');
    } catch (e, stackTrace) {
      logger.e('Error clearing cache', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        showMessageDialog(
            context, 'Biometric authentication successful!', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      showMessageDialog(
          context, 'Biometric authentication failed. Please try again.', false);
    }
  }

  Future<void> _fetchAccountDetails() async {
    try {
      logger.i('Fetching account details...');

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/account'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
          'Content-Type': 'application/json',
        },
      );

      logger.d('Account API Response Status: ${response.statusCode}');
      logger.d('Account API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final accountData = json.decode(response.body);
        logger.i('Account found: ${accountData['account_number']}, '
            'Shares: ${accountData['share_balance']}, '
            'Deposits: ${accountData['deposit_balance']}');
        await AppConfig.setAccountDetails(
          hasAcc: true,
          accNumber: accountData['account_number'],
          shareBal: accountData['share_balance'],
          depositBal: accountData['deposit_balance'],
        );
      } else if (response.statusCode == 404) {
        logger.w('No account found for user');
        await AppConfig.setAccountDetails(hasAcc: false);
      } else {
        logger.e(
            'Failed to load account details. Status: ${response.statusCode}');
        throw Exception('Failed to load account details');
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching account details',
          error: e, stackTrace: stackTrace);
      await AppConfig.setAccountDetails(hasAcc: false);
    }
  }

  Future<void> _login() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      logger.i('Attempting login with email: ${email.substring(0, 3)}***');

      if (email.isEmpty || password.isEmpty) {
        logger.w('Login attempted with empty credentials');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Please enter both email and password'),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Show loading widget
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingWidget();
        },
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loginResponse = await authProvider.login(email, password);
      logger.d('Login Response: $loginResponse');

      Navigator.of(context, rootNavigator: true)
          .pop(); // Dismiss loading widget

      if (authProvider.currentUser != null) {
        AppConfig.userId = authProvider.currentUser!.id;
        AppConfig.userName = authProvider.currentUser!.name;
        AppConfig.userToken = loginResponse?['token'];
        logger.d('Auth Token received: ${loginResponse?['token']}');

        // Fetch account details after successful login
        await _fetchAccountDetails();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Login successful!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate after a brief delay to show the success message
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('Login failed. Please check your credentials.'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.e('Login error occurred', error: e, stackTrace: stackTrace);
      Navigator.of(context, rootNavigator: true).pop();
      showMessageDialog(
          context, 'An error occurred during login. Please try again.', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // App Logo
              Center(
                child: Image.asset('assets/images/app_logo.png', height: 120),
              ),
              const SizedBox(height: 40),

              // Email Input Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color),
                ),
              ),
              const SizedBox(height: 20),

              // Password Input Field with show/hide password toggle
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock,
                      color: Theme.of(context).iconTheme.color),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Login',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),

              const SizedBox(height: 20),

              // Fingerprint Icon for Login
              Center(
                child: IconButton(
                  icon: Icon(
                    Icons.fingerprint,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: _authenticateWithBiometrics,
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password and Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to Forgot Password screen (if required)
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Don't have an account? Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Text('Sign up',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
