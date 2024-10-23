import 'package:flutter/material.dart';
import 'package:msacco/screens/live_chat_screen.dart'; // Import Live Chat Screen

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Help & Support', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFAQItem(
                context,
                "How can I apply for a loan?",
                "You can apply for a loan by navigating to the 'Apply for Loan' option in the Quick Actions on the dashboard.",
              ),
              const Divider(),
              _buildFAQItem(
                context,
                "How do I withdraw funds?",
                "To withdraw funds, go to the 'Transfer Funds' option and select your preferred withdrawal method.",
              ),
              const Divider(),
              _buildFAQItem(
                context,
                "What is the limit for loan applications?",
                "You can apply for a loan amount that is not more than three times your combined shares and deposits.",
              ),
              const SizedBox(height: 30),

              const Text(
                'Contact Support',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading:
                    Icon(Icons.email, color: Theme.of(context).primaryColor),
                title: const Text('Email Us'),
                subtitle: const Text('support@msacco.com'),
              ),
              ListTile(
                leading:
                    Icon(Icons.phone, color: Theme.of(context).primaryColor),
                title: const Text('Call Us'),
                subtitle: const Text('+265 123 456 789'),
              ),
              const SizedBox(height: 30),

              // Live Chat Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the Live Chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LiveChatScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.chat_bubble,
                    color: Colors.white, // Set icon color to white
                  ),
                  label: const Text(
                    "Live Chat",
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display FAQ items
  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              height: 1.5, // Line height for better readability
            ),
          ),
        ],
      ),
    );
  }
}
