import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanStatusScreen extends StatefulWidget {
  const LoanStatusScreen({Key? key}) : super(key: key);

  @override
  _LoanStatusScreenState createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
  String? _selectedStatusFilter; // Filter by loan status

  double _currentLoanAmount = 50000.0; // Placeholder for current loan amount

  final List<Map<String, dynamic>> _loans = [
    {
      "amount": 50000.0,
      "status": "Approved",
      "date": DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      "amount": 75000.0,
      "status": "Pending",
      "date": DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      "amount": 120000.0,
      "status": "Rejected",
      "date": DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      "amount": 200000.0,
      "status": "Approved",
      "date": DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  List<String> _statuses = ["All", "Pending", "Approved", "Rejected"];

  // Filter loans by the selected status
  List<Map<String, dynamic>> _getFilteredLoans() {
    if (_selectedStatusFilter == null || _selectedStatusFilter == "All") {
      return _loans;
    }
    return _loans
        .where((loan) => loan['status'] == _selectedStatusFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Status', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Current Loan Amount
            Card(
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Loan Amount',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'MWK ${_currentLoanAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _selectedStatusFilter ?? "All",
              items: _statuses.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatusFilter = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Loan Status List
            Expanded(
              child: ListView.builder(
                itemCount: _getFilteredLoans().length,
                itemBuilder: (context, index) {
                  final loan = _getFilteredLoans()[index];
                  return _buildLoanStatusItem(
                    context,
                    loan["amount"],
                    loan["status"],
                    loan["date"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each loan status item
  Widget _buildLoanStatusItem(
      BuildContext context, double amount, String status, DateTime date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          _getIconForLoanStatus(status),
          color: _getColorForLoanStatus(status),
          size: 35,
        ),
        title: Text(
          "Loan Amount: MWK ${amount.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "Status: $status\nDate: ${_formatDate(date)}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  // Get icon based on the loan status
  IconData _getIconForLoanStatus(String status) {
    switch (status) {
      case "Pending":
        return Icons.hourglass_empty;
      case "Approved":
        return Icons.check_circle;
      case "Rejected":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  // Get color based on the loan status
  Color _getColorForLoanStatus(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Format the date as a readable string
  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
