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

  Future<void> _login() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      logger.i('Attempting login with email: ${email.substring(0, 3)}***');

      if (email.isEmpty || password.isEmpty) {
        logger.w('Login attempted with empty credentials');
        showMessageDialog(
            context, 'Please enter both email and password.', false);
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
      await authProvider.login(email, password);

      Navigator.of(context, rootNavigator: true).pop();

      if (authProvider.currentUser != null) {
        AppConfig.userId = authProvider.currentUser!.id;
        AppConfig.userName = authProvider.currentUser!.name;

        showMessageDialog(
          context,
          'Login successful!',
          true,
          onConfirm: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
        );
      } else {
        showMessageDialog(
            context, 'Login failed. Please check your credentials.', false);
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
