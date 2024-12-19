import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';
import 'package:msacco/widgets/loading_widget.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool isLoading = true;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/transactions'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          transactions = data
              .map((transaction) => {
                    'id': transaction['id'],
                    'type': transaction['type'],
                    'amount': transaction['amount'],
                    'date': transaction['transaction_date'],
                    'source': transaction['source'],
                    'destination': transaction['destination'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        logger.e('Failed to fetch transactions: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      logger.e('Error fetching transactions', error: e);
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> _getFilteredTransactions() {
    if (_fromDate == null && _toDate == null) {
      return transactions;
    }
    return transactions.where((transaction) {
      final transactionDate = DateTime.parse(transaction['date']);
      if (_fromDate != null && transactionDate.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && transactionDate.isAfter(_toDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _showTransactionDetail(
      BuildContext context, Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Transaction Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Transaction Type and Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getTransactionColor(transaction['type'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconForTransactionType(transaction['type']),
                            color: _getTransactionColor(transaction['type']),
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            transaction['type'].toString().toUpperCase(),
                            style: TextStyle(
                              color: _getTransactionColor(transaction['type']),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Amount
                    _buildDetailRow(
                      'Amount',
                      'MWK ${transaction['amount']}',
                      Icons.monetization_on_outlined,
                    ),
                    const Divider(height: 32),

                    // Date and Time
                    _buildDetailRow(
                      'Date & Time',
                      _formatDate(transaction['date']),
                      Icons.access_time,
                    ),
                    const Divider(height: 32),

                    // Source
                    _buildDetailRow(
                      'From',
                      transaction['source'],
                      Icons.account_balance_outlined,
                    ),
                    const Divider(height: 32),

                    // Destination
                    _buildDetailRow(
                      'To',
                      transaction['destination'],
                      Icons.account_balance_outlined,
                    ),
                    const Divider(height: 32),

                    // Transaction ID
                    _buildDetailRow(
                      'Transaction ID',
                      '#${transaction['id']}',
                      Icons.tag,
                    ),
                  ],
                ),
              ),
            ),

            // Action Button (if needed)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to download or share receipt
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Download Receipt'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getTransactionColor(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return Colors.green;
      case 'shares':
        return Colors.blue;
      case 'withdrawal':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                // Date Filters
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("From",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      _fromDate == null
                                          ? 'Select Date'
                                          : _formatDate(_fromDate!.toString()),
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("To",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () => _selectDate(context, false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      _toDate == null
                                          ? 'Select Date'
                                          : _formatDate(_toDate!.toString()),
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Transactions List
                Expanded(
                  child: _getFilteredTransactions().isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _getFilteredTransactions().length,
                          itemBuilder: (context, index) {
                            final transaction =
                                _getFilteredTransactions()[index];
                            return _buildTransactionItem(
                              context,
                              transaction['type'],
                              transaction['amount'],
                              transaction['date'],
                              transaction['source'],
                              transaction['destination'],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, String type, String amount,
      String date, String source, String destination) {
    final displayType = type[0].toUpperCase() + type.substring(1);
    final icon = _getIconForTransactionType(type);
    final isDeposit = type.toLowerCase() == "deposit";
    final isShares = type.toLowerCase() == "shares";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => _showTransactionDetail(context, {
          'type': type,
          'amount': amount,
          'date': date,
          'source': source,
          'destination': destination,
          'id': '12345', // Add actual transaction ID
        }),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDeposit
                ? Colors.green.withOpacity(0.1)
                : isShares
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDeposit
                ? Colors.green
                : isShares
                    ? Colors.blue
                    : Colors.orange,
            size: 28,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "MWK $amount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDeposit ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.arrow_right_alt, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "From: $source → To: $destination",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTransactionType(String type) {
    switch (type.toLowerCase()) {
      case "deposit":
        return Icons.account_balance_wallet;
      case "withdrawal":
        return Icons.money_off;
      case "shares":
        return Icons.savings;
      case "transfer":
        return Icons.swap_horiz;
      default:
        return Icons.receipt_long;
    }
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }
}
