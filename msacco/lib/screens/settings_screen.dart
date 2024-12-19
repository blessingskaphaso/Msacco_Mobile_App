import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msacco/providers/theme_provider.dart';
import 'package:msacco/screens/account_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msacco/config/config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Customize your app preferences',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Account",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSettingTile(
            context,
            'Change Password',
            'Update your account password',
            Icons.lock_outline,
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildSettingTile(
            context,
            'Edit Profile',
            'Update your profile information',
            Icons.person_outline,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "App Settings",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSettingTile(
            context,
            'Dark Mode',
            'Switch between light and dark theme',
            Icons.dark_mode,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(value),
              activeColor: Theme.of(context).primaryColor,
            ),
          ),
          _buildSettingTile(
            context,
            'Change Language',
            'Select your preferred language',
            Icons.language,
            onTap: () => _showChangeLanguageDialog(),
          ),
          const Divider(),
          _buildSettingTile(
            context,
            'About App',
            'Information about the developer',
            Icons.info_outline,
            onTap: () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, color: Colors.grey[400])
              : null),
    );
  }

  // Your existing dialog methods
  void _showChangePasswordDialog() {
    bool _currentPasswordVisible = false;
    bool _newPasswordVisible = false;
    bool _confirmPasswordVisible = false;

    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    Future<void> changePassword() async {
      try {
        final response = await http.put(
          Uri.parse('${AppConfig.apiBaseUrl}/user/change-password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppConfig.userToken}',
          },
          body: jsonEncode({
            'user_id': AppConfig.userId,
            'current_password': currentPasswordController.text,
            'new_password': newPasswordController.text,
            'new_password_confirmation': confirmPasswordController.text,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Failed to change password: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                const Text("Change Password"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _currentPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPasswordVisible = !_currentPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: !_currentPasswordVisible,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: !_newPasswordVisible,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: !_confirmPasswordVisible,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:
                    Text("Cancel", style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New passwords do not match'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  changePassword();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Change Password",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showChangeLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text("Chichewa"),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("About the Developer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/profile_picture.png',
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                "Peter Blessings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 5),
              const Text(
                "This app was developed as part of a mini project at DMI St John the Baptist University.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
