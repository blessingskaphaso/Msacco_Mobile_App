import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Loan Approved",
      "description": "Your loan application of MWK 50,000 has been approved.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "title": "Loan Rejected",
      "description": "Your loan application of MWK 75,000 has been rejected.",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "title": "Deposit Received",
      "description": "You received a deposit of MWK 20,000 to your account.",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "title": "Account Update",
      "description": "Your account details have been successfully updated.",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _notifications.isEmpty
            ? const Center(
                child: Text("No notifications available.",
                    style: TextStyle(fontSize: 18)),
              )
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationItem(
                    notification["title"],
                    notification["description"],
                    notification["timestamp"],
                  );
                },
              ),
      ),
    );
  }

  // Helper method to build each notification item
  Widget _buildNotificationItem(
      String title, String description, DateTime timestamp) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850] // Darker background for dark mode
          : Colors.white, // White background for light mode
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: Theme.of(context).primaryColor,
          size: 35,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format timestamp to display date and time
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('dd-MM-yyyy hh:mm a').format(timestamp);
  }
}
