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
        title: const Text(
          'View Balances',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Balances',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Shares Balance Card
                  _buildBalanceCard(
                    context,
                    'Shares Balance',
                    'MWK ${shares.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),

                  // Deposits Balance Card
                  _buildBalanceCard(
                    context,
                    'Deposits Balance',
                    'MWK ${deposits.toStringAsFixed(2)}',
                    Icons.savings,
                    Colors.blue,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Summary of Holdings
                  const Text(
                    'Summary',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Holdings (Shares + Deposits): MWK ${totalHoldings.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Available for Loan: MWK ${availableForLoan.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, String title, String balance,
      IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          balance,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
