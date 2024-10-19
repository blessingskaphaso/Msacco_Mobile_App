import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.green),
              title: const Text("Change Password"),
              onTap: () {
                // Navigate to Change Password screen
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text("Edit Profile"),
              onTap: () {
                // Navigate to Edit Profile screen
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
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (bool value) {
                  // Toggle Dark/Light mode
                },
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text("Change Language"),
              onTap: () {
                // Navigate to Change Language screen
              },
            ),
            const Divider(),

            // App Info
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.green),
              title: const Text("About App"),
              onTap: () {
                // Navigate to About App screen
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
