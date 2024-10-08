import 'package:flutter/material.dart';
import 'package:msacco/screens/account_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Adaptive background
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white, // Make the text white
            fontWeight:
                FontWeight.bold, // Optional to make it bold for more prominence
          ),
        ),
        automaticallyImplyLeading: false, // No back button for Dashboard
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0, // Flat AppBar
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.white, // Make the icon white
            ),
            onPressed: () {
              // Navigate to the Account Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Padding(
              padding:
                  const EdgeInsets.all(8.0), // Apply 8px padding on all sides
              child: Text(
                "Welcome back, John Doe", // Placeholder user name
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 10),

            // Account Balance Card
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // Army Green
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Balance",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "MWK 100,000.00", // Placeholder balance
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Grid (3x2 layout)
            Text(
              "Quick Actions",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3, // 3 columns for the quick actions
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickActionCard(Icons.monetization_on, "Transfer Funds"),
                _buildQuickActionCard(Icons.account_balance, "Apply for Loan"),
                _buildQuickActionCard(Icons.history, "Transaction History"),
                _buildQuickActionCard(Icons.notifications, "Notifications"),
                _buildQuickActionCard(Icons.settings, "Settings"),
                _buildQuickActionCard(Icons.help_outline, "Help & Support"),
              ],
            ),
            const SizedBox(height: 30),

            // Recent Transactions
            Text(
              "Recent Transactions",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTransactionList(),

            const SizedBox(height: 20),

            // Notification Banner
            _buildNotificationBanner(),
          ],
        ),
      ),
    );
  }

  // Quick Action Card Widget (Medium-sized icons)
  Widget _buildQuickActionCard(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 35, color: Theme.of(context).primaryColor), // Medium size
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Recent Transactions List
  Widget _buildTransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Example recent transactions count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.monetization_on,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              "Transaction #$index",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: const Text(
              "MWK 10,000.00",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Text("2023-10-05"),
          ),
        );
      },
    );
  }

  // Notification Banner Widget
  Widget _buildNotificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[300], // Banner color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Your loan application has been approved!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.check_circle, color: Colors.black),
        ],
      ),
    );
  }
}
