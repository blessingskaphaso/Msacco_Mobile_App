import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:msacco/config/config.dart';
import 'package:msacco/screens/login_screen.dart';
import 'package:msacco/utils/logger.dart'; // Assuming you have a logger utility
import 'package:msacco/widgets/message_component.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final token = AppConfig.userToken;
    final baseUrl = AppConfig.apiBaseUrl;

    if (token == null) {
      logger.w('No token found. Redirecting to login.');
      return;
    }

    try {
      logger.i('Fetching user details from $baseUrl/user');
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      logger.i('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userDetails = data['user'];
        });
        logger.i('User details fetched: ${data['user']}');
      } else {
        logger.w(
            'Failed to fetch user details. Status code: ${response.statusCode}');
        // Handle error - maybe show a message to user
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching user details', error: e, stackTrace: stackTrace);
      // Handle error - maybe show a message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              _showEditProfileDialog(context);
            },
          ),
        ],
      ),
      body: userDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          const AssetImage('assets/images/profile_picture.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      userDetails!['name'], // Dynamic full name
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Account Details",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildAccountDetailTile(
                      context, Icons.person, "Full Name", userDetails!['name']),
                  const Divider(),
                  _buildAccountDetailTile(
                      context, Icons.email, "Email", userDetails!['email']),
                  const Divider(),
                  _buildAccountDetailTile(context, Icons.phone, "Phone Number",
                      userDetails!['phone_number'] ?? "Not Provided"),
                  const Divider(),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAccountDetailTile(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[300]
              : Colors.grey[700],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController =
        TextEditingController(text: userDetails?['name'] ?? "");
    final emailController =
        TextEditingController(text: userDetails?['email'] ?? "");
    final phoneController =
        TextEditingController(text: userDetails?['phone_number'] ?? "");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final userId = AppConfig.userId;
                final token = AppConfig.userToken;
                final baseUrl = AppConfig.apiBaseUrl;

                try {
                  final response = await http.put(
                    Uri.parse('$baseUrl/user/update'),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Accept': 'application/json',
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'user_id': userId,
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone_number': phoneController.text,
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop();
                    _fetchUserDetails(); // Refresh user details
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => const SweetAlertStyleDialog(
                          message: 'Profile updated successfully!',
                          type: MessageType.success,
                        ),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const SweetAlertStyleDialog(
                        message: 'Failed to update profile. Please try again.',
                        type: MessageType.error,
                      ),
                    );
                  }
                } catch (e) {
                  logger.e('Error updating profile', error: e);
                  showDialog(
                    context: context,
                    builder: (context) => const SweetAlertStyleDialog(
                      message: 'An error occurred while updating profile.',
                      type: MessageType.error,
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                AppConfig.clear(); // Clear preferences
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text("Log out"),
            ),
          ],
        );
      },
    );
  }
}
