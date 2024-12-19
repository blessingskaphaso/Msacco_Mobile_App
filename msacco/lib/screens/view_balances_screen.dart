import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';

class ViewBalancesScreen extends StatefulWidget {
  @override
  State<ViewBalancesScreen> createState() => _ViewBalancesScreenState();
}

class _ViewBalancesScreenState extends State<ViewBalancesScreen> {
  double shares = 0.0;
  double deposits = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountData();
  }

  Future<void> _fetchAccountData() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/account'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          shares = double.parse(data['share_balance']);
          deposits = double.parse(data['deposit_balance']);
          isLoading = false;
        });
      } else {
        logger.e('Failed to fetch account data');
      }
    } catch (e) {
      logger.e('Error fetching account data', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalHoldings = shares + deposits;
    double availableForLoan = (shares + deposits) * 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Balances',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Your Balances',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Shares Balance Card
                  _buildBalanceCard(
                    context,
                    'Shares Balance',
                    'MWK ${shares.toStringAsFixed(2)}',
                    Icons.savings_outlined,
                    Colors.greenAccent,
                    'Your investment in the SACCO',
                  ),

                  // Deposits Balance Card
                  _buildBalanceCard(
                    context,
                    'Deposits Balance',
                    'MWK ${deposits.toStringAsFixed(2)}',
                    Icons.account_balance_wallet_outlined,
                    Colors.orangeAccent,
                    'Your savings in the SACCO',
                  ),

                  const SizedBox(height: 20),

                  // Summary Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.analytics_outlined,
                                color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Summary',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSummaryItem(
                          'Total Holdings',
                          'MWK ${totalHoldings.toStringAsFixed(2)}',
                          Icons.account_balance_outlined,
                        ),
                        const Divider(color: Colors.white24, height: 30),
                        _buildSummaryItem(
                          'Available for Loan',
                          'MWK ${availableForLoan.toStringAsFixed(2)}',
                          Icons.monetization_on_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, String title, String balance,
      IconData icon, Color iconColor, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[600]
                            : Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      balance,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[600]
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
