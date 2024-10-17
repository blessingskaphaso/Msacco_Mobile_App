import 'package:flutter/material.dart';
import 'package:msacco/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
        // Added SingleChildScrollView to enable scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/profile_picture.png'), // Profile image
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Peter Kaphaso", // Placeholder full name
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Account Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(Icons.person, color: Colors.green),
              title: Text("Full Name"),
              subtitle: Text("Peter Kaphaso"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.green),
              title: Text("Email"),
              subtitle: Text("blesskapha@outlook.com"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text("Phone Number"),
              subtitle: Text("+265 88 280 1476"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.credit_card, color: Colors.green),
              title: Text("Account Balance"),
              subtitle: Text("MWK 100,000.00"),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
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
