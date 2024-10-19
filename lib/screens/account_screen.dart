import 'package:flutter/material.dart';
import 'package:msacco/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0, // Flat AppBar
        actions: [
          // Edit Button on the AppBar
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add edit functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/profile_picture.png'), // Profile image
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Peter B Kaphaso", // Placeholder full name
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Account Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text("Full Name"),
              subtitle: const Text("Peter B Kaphaso"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: const Text("Email"),
              subtitle: const Text("blesskapha@outlook.com"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text("Phone Number"),
              subtitle: const Text("+265 123 456 789"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.green),
              title: const Text("Account Balance"),
              subtitle: const Text("MWK 100,000.00"),
            ),
            const SizedBox(height: 30), // Add some space before the button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Confirm before logging out
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Log out"),
                        content:
                            const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Replace the current screen with the LoginScreen
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text("Log out"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Logout button in red
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
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
}
