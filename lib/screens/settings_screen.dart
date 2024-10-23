import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msacco/providers/theme_provider.dart';
import 'package:msacco/screens/account_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Account Settings
            SettingTile(
              icon: Icons.lock,
              title: "Change Password",
              iconColor: Colors.green,
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            const Divider(),

            SettingTile(
              icon: Icons.person,
              title: "Edit Profile",
              iconColor: Colors.green,
              onTap: () {
                // Navigate to Account Settings screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              },
            ),
            const Divider(),

            const SizedBox(height: 30), // Space between sections

            const Text(
              "App Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Theme settings
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.green),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            const Divider(),

            SettingTile(
              icon: Icons.language,
              title: "Change Language",
              iconColor: Colors.green,
              onTap: () {
                _showChangeLanguageDialog();
              },
            ),
            const Divider(),

            // App Info
            SettingTile(
              icon: Icons.info_outline,
              title: "About App",
              iconColor: Colors.green,
              onTap: () {
                _showAboutDialog();
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Dialog to change password
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(labelText: "Current Password"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration:
                    const InputDecoration(labelText: "Confirm New Password"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform change password action
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Dialog to change language
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
                onTap: () {
                  // Set language to English
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Chichewa"),
                onTap: () {
                  // Set language to Chichewa
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog to show about the developer
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

// Reusable setting tile widget
class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const SettingTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
