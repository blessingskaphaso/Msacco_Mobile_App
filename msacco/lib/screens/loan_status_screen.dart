import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';
import 'package:msacco/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

class LoanStatusScreen extends StatefulWidget {
  const LoanStatusScreen({Key? key}) : super(key: key);

  @override
  _LoanStatusScreenState createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> loans = [];

  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  Future<void> _fetchLoans() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/loans'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          loans = data
              .map((loan) => {
                    'id': loan['id'],
                    'amount': loan['loan_amount'],
                    'status': loan['status'],
                    'interest_rate': loan['interest_rate'],
                    'repayment_period': loan['repayment_period'],
                    'created_at': loan['created_at'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        logger.e('Failed to fetch loans: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      logger.e('Error fetching loans', error: e);
      setState(() => isLoading = false);
    }
  }

  void _showLoanDetailsModal(Map<String, dynamic> loan) {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Details',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard(loan),
            const SizedBox(height: 20),
            _buildRepaymentSchedule(loan),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> loan) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow('Loan Amount', 'MWK ${loan['amount']}'),
            _buildDetailRow('Interest Rate', '${loan['interest_rate']}%'),
            _buildDetailRow('Duration', '${loan['repayment_period']} days'),
            _buildDetailRow(
                'Application Date',
                DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(loan['created_at']))),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(value).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRepaymentSchedule(Map<String, dynamic> loan) {
    // Calculate due date by adding repayment period to created_at
    final applicationDate = DateTime.parse(loan['created_at']);
    final dueDate = applicationDate
        .add(Duration(days: int.parse(loan['repayment_period'].toString())));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Repayment Schedule',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Repayment'),
                        const SizedBox(height: 5),
                        Text(
                          'MWK ${_calculateTotalRepayment(loan)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.calendar_today,
                        color: Theme.of(context).primaryColor),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('dd MMM yyyy').format(dueDate),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                _isOverdue(dueDate) ? Colors.red : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _isOverdue(dueDate)
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getRemainingDays(dueDate),
                        style: TextStyle(
                          color:
                              _isOverdue(dueDate) ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _calculateTotalRepayment(Map<String, dynamic> loan) {
    double amount = double.parse(loan['amount']);
    double interestRate = double.parse(loan['interest_rate']);
    double interest = (amount * interestRate) / 100;
    return (amount + interest).toStringAsFixed(2);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool _isOverdue(DateTime dueDate) {
    return DateTime.now().isAfter(dueDate);
  }

  String _getRemainingDays(DateTime dueDate) {
    final difference = dueDate.difference(DateTime.now()).inDays;
    if (difference < 0) {
      return '${difference.abs()} days overdue';
    } else if (difference == 0) {
      return 'Due today';
    } else {
      return '$difference days remaining';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Loans',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 100,
            color: Theme.of(context).primaryColor,
          ),
          if (isLoading)
            const LoadingWidget()
          else if (loans.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No loans found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () => _showLoanDetailsModal(loan),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MWK ${loan['amount']}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(loan['status'])
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  loan['status'],
                                  style: TextStyle(
                                    color: _getStatusColor(loan['status']),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Applied on: ${DateFormat('dd MMM yyyy').format(DateTime.parse(loan['created_at']))}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${loan['repayment_period']} days',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
