import 'package:flutter/material.dart';
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';
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
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _fetchUserDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.fetchUserDetails();
      if (authProvider.currentUser != null) {
        await AppConfig.setUserName(authProvider.currentUser!.name);
      }
    } catch (e) {
      logger.e('Error fetching user details', error: e);
    }
  }

  Future<void> _fetchAccountDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/account'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await AppConfig.setShareBalance(data['share_balance']);
        await AppConfig.setDepositBalance(data['deposit_balance']);
      }
    } catch (e) {
      logger.e('Error fetching account details', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        Provider.of<AuthProvider>(context).currentUser?.name ?? 'User';
    final totalBalance = AppConfig.hasAccount
        ? (double.parse(AppConfig.shareBalance ?? '0') +
            double.parse(AppConfig.depositBalance ?? '0'))
        : 0.00;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchUserDetails();
          await _fetchAccountDetails();
        },
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Balance
            SliverAppBar(
              expandedHeight: 260.0,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.account_circle,
                                  color: Colors.white, size: 28),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AccountScreen()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Balance',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'MWK ${totalBalance.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _fetchUserDetails();
                                  await _fetchAccountDetails();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Details refreshed successfully'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Balance Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBalanceCard(
                        'Shares',
                        AppConfig.shareBalance ?? '0.00',
                        Icons.savings,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBalanceCard(
                        'Deposits',
                        AppConfig.depositBalance ?? '0.00',
                        Icons.account_balance_wallet,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Quick Actions Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildListDelegate([
                  _buildActionCard(
                    'Transfer Funds',
                    Icons.send_rounded,
                    Colors.purple,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransferFundsScreen())),
                  ),
                  _buildActionCard(
                    'Apply for Loan',
                    Icons.account_balance,
                    Colors.orange,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoanApplicationScreen())),
                  ),
                  _buildActionCard(
                    'Transaction History',
                    Icons.history,
                    Colors.blue,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TransactionHistoryScreen())),
                  ),
                  _buildActionCard(
                    'View Balances',
                    Icons.pie_chart,
                    Colors.green,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBalancesScreen())),
                  ),
                ]),
              ),
            ),

            // Other Services section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Services',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildServiceTile(
                      'Loan Status',
                      Icons.bar_chart,
                      Colors.teal,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoanStatusScreen())),
                    ),
                    _buildServiceTile(
                      'My Documents',
                      Icons.folder,
                      Colors.amber,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyDocumentsScreen())),
                    ),
                    _buildServiceTile(
                      'Help & Support',
                      Icons.help_outline,
                      Colors.indigo,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SupportScreen())),
                    ),
                    _buildServiceTile(
                      'Settings',
                      Icons.settings,
                      Colors.grey,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'MWK $amount',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? color.withOpacity(0.2) // More opacity in dark mode
                : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode
                  ? color.withOpacity(0.3) // More visible border in dark mode
                  : color.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isDarkMode
                      ? color.withAlpha(255)
                      : color, // Full opacity icon in dark mode
                  size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode
                      ? Colors.white
                      : color, // White text in dark mode
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTile(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
    );
  }
}
