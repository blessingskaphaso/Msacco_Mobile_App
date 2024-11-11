import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msacco/providers/auth_provider.dart';
import 'package:msacco/widgets/loading_widget.dart';
import 'package:msacco/widgets/message_widget.dart';
import 'package:msacco/screens/account_screen.dart';
import 'package:msacco/screens/documents_screen.dart';
import 'package:msacco/screens/fund_transfer_screen.dart';
import 'package:msacco/screens/loan_application_screen.dart';
import 'package:msacco/screens/loan_status_screen.dart';
import 'package:msacco/screens/notifications_screen.dart';
import 'package:msacco/screens/settings_screen.dart';
import 'package:msacco/screens/support_screen.dart';
import 'package:msacco/screens/transaction_history_screen.dart';
import 'package:msacco/screens/view_balances_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    // Show loading widget
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingWidget();
      },
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchUserDetails();

    // Hide loading widget
    Navigator.of(context, rootNavigator: true).pop();

    if (authProvider.currentUser == null) {
      showMessageDialog(context, 'Failed to fetch user details.', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        Provider.of<AuthProvider>(context).currentUser?.name ?? 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome back, $userName",
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
                color: Theme.of(context).primaryColor,
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
                        "MWK 100,000.00",
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

            // Quick Actions Grid
            Text(
              "Quick Actions",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
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
                        builder: (context) => ViewBalancesScreen()),
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

  Widget _buildQuickActionCard(IconData icon, String label,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
