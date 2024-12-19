import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:msacco/config/config.dart';
import 'package:msacco/screens/login_screen.dart';
import 'package:msacco/utils/logger.dart'; // Assuming you have a logger utility
import 'package:msacco/widgets/message_component.dart';
import 'package:provider/provider.dart';
import 'package:msacco/providers/auth_provider.dart';

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
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userDetails!['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userDetails!['email'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Account Details Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailItem(
                          context,
                          Icons.person_outline,
                          "Full Name",
                          userDetails!['name'],
                        ),
                        _buildDetailItem(
                          context,
                          Icons.email_outlined,
                          "Email",
                          userDetails!['email'],
                        ),
                        _buildDetailItem(
                          context,
                          Icons.phone_outlined,
                          "Phone",
                          userDetails!['phone_number'] ?? "Not Provided",
                        ),
                        _buildDetailItem(
                          context,
                          Icons.account_balance_outlined,
                          "Account Status",
                          AppConfig.hasAccount
                              ? "Active Account (${AppConfig.accountNumber ?? 'N/A'})"
                              : "No Account",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Close confirmation dialog first
                Navigator.of(context).pop();

                try {
                  // Hit the logout endpoint without waiting for response
                  http.post(
                    Uri.parse('${AppConfig.apiBaseUrl}/logout'),
                    headers: {
                      'Authorization': 'Bearer ${AppConfig.userToken}',
                      'Accept': 'application/json',
                    },
                  );

                  // Clear local storage
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logout();

                  // Navigate to login screen immediately
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  print('Error during logout: $e');
                  // Still proceed with navigation on error
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child:
                  const Text("Log out", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
