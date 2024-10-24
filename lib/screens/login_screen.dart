import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import the signup screen
import 'dashboard_screen.dart'; // Import the dashboard screen
import 'package:local_auth/local_auth.dart'; // Import Local Authentication package

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; // For hiding and showing the password
  final LocalAuthentication auth =
      LocalAuthentication(); // Local Authentication instance

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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Adaptive background
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

              // Login Button with white text and navigation to Dashboard
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Dashboard screen upon login
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // Army Green
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
                  onPressed: () {
                    // Trigger fingerprint authentication
                    _authenticateWithBiometrics();
                  },
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
