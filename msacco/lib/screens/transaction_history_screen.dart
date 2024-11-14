import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample transaction data including Loan Disbursal
  final List<Map<String, dynamic>> _transactions = [
    {
      "type": "Deposit",
      "amount": "MWK 50,000.00",
      "date": DateTime.now().subtract(const Duration(days: 2))
    },
    {
      "type": "Withdrawal",
      "amount": "MWK 20,000.00",
      "date": DateTime.now().subtract(const Duration(days: 5))
    },
    {
      "type": "Loan Repayment",
      "amount": "MWK 10,000.00",
      "date": DateTime.now().subtract(const Duration(days: 10))
    },
    {
      "type": "Loan Disbursal",
      "amount": "MWK 150,000.00",
      "date": DateTime.now().subtract(const Duration(days: 12))
    }, // New loan disbursal transaction
    {
      "type": "Deposit",
      "amount": "MWK 70,000.00",
      "date": DateTime.now().subtract(const Duration(days: 15))
    },
  ];

  // Filter transactions based on the selected date range
  List<Map<String, dynamic>> _getFilteredTransactions() {
    if (_fromDate == null && _toDate == null) {
      return _transactions;
    }
    return _transactions.where((transaction) {
      final transactionDate = transaction['date'] as DateTime;
      if (_fromDate != null && transactionDate.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && transactionDate.isAfter(_toDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  // Function to pick the date for the filter
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (_fromDate ?? _toDate)) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("From Date"),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text(
                          _fromDate == null
                              ? 'Select Date'
                              : DateFormat('dd-MM-yyyy').format(_fromDate!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("To Date"),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text(
                          _toDate == null
                              ? 'Select Date'
                              : DateFormat('dd-MM-yyyy').format(_toDate!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Filtered Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: _getFilteredTransactions().length,
                itemBuilder: (context, index) {
                  final transaction = _getFilteredTransactions()[index];
                  return _buildTransactionItem(
                    context,
                    transaction["type"],
                    transaction["amount"],
                    transaction["date"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each transaction item
  Widget _buildTransactionItem(
      BuildContext context, String type, String amount, DateTime date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          _getIconForTransactionType(type),
          color: Theme.of(context).primaryColor,
          size: 35,
        ),
        title: Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "Amount: $amount\nDate: ${_formatDate(date)}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  // Get icon based on the type of transaction
  IconData _getIconForTransactionType(String type) {
    switch (type) {
      case "Deposit":
        return Icons.arrow_downward;
      case "Withdrawal":
        return Icons.arrow_upward;
      case "Loan Repayment":
        return Icons.monetization_on;
      case "Loan Disbursal":
        return Icons.attach_money; // Icon for loan disbursal
      default:
        return Icons.money;
    }
  }

  // Format the date as a readable string
  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}
