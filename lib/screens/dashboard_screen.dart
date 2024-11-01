import 'package:flutter/material.dart';
import 'package:msacco/screens/account_screen.dart';
import 'package:msacco/screens/documents_screen.dart';
import 'package:msacco/screens/fund_transfer_screen.dart';
import 'package:msacco/screens/loan_application_screen.dart';
import 'package:msacco/screens/loan_status_screen.dart';
import 'package:msacco/screens/notifications_screen.dart';
import 'package:msacco/screens/settings_screen.dart';
import 'package:msacco/screens/support_screen.dart';
import 'package:msacco/screens/transaction_history_screen.dart';
import 'package:msacco/screens/view_balances_screen.dart'; // Import the Support Screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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

            // Quick Actions Grid (3x3 layout)
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
                _buildQuickActionCard(Icons.monetization_on, "Transfer Funds",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransferFundsScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.account_balance, "Apply for Loan",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoanApplicationScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.history, "Transaction History", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactionHistoryScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.pie_chart, "View Balances", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewBalancesScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.bar_chart, "Loan Status", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoanStatusScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.notifications, "Notifications", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.folder, "My Documents", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyDocumentsScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.settings, "Settings", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                }),
                _buildQuickActionCard(Icons.help_outline, "Help & Support", () {
                  // Navigate to Help & Support screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportScreen()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Card Widget (Medium-sized icons)
  Widget _buildQuickActionCard(IconData icon, String label,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap, // Navigate to appropriate screen
      child: Container(
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
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible, // Ensure text wraps correctly
              ),
            ),
          ],
        ),
      ),
    );
  }
}
