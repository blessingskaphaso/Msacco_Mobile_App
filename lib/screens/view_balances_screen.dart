import 'package:flutter/material.dart';

class ViewBalancesScreen extends StatelessWidget {
  final double shares = 120000.0; // Placeholder for shares balance
  final double deposits = 50000.0; // Placeholder for deposits balance
  final double loan = 20000.0;

  const ViewBalancesScreen({super.key}); // Placeholder for loan balance

  @override
  Widget build(BuildContext context) {
    double totalHoldings = shares + deposits;
    double availableForLoan = (shares + deposits) * 3 - loan;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Balances',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Padding(
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

            // Loan Balance Card
            _buildBalanceCard(
              context,
              'Outstanding Loan',
              'MWK ${loan.toStringAsFixed(2)}',
              Icons.credit_card,
              Colors.red,
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

  // Helper method to build each balance card
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
