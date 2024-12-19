import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';
import 'package:msacco/widgets/loading_widget.dart';
import 'package:msacco/widgets/message_component.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({Key? key}) : super(key: key);

  @override
  _LoanApplicationScreenState createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> loanTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchLoanTypes();
  }

  Future<void> _fetchLoanTypes() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/loan-types'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          loanTypes = data
              .map((type) => {
                    'id': type['id'],
                    'name': type['name'],
                    'interest_rate': type['interest_rate'],
                    'duration': type['duration'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        logger.e('Failed to fetch loan types: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      logger.e('Error fetching loan types', error: e);
      setState(() => isLoading = false);
    }
  }

  void _showLoanApplicationModal(Map<String, dynamic> loanType) {
    final _formKey = GlobalKey<FormState>();
    final _amountController = TextEditingController();
    bool isSubmitting = false;

    Future<void> _submitLoanApplication() async {
      try {
        setState(() => isSubmitting = true);

        final response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/loans'),
          headers: {
            'Authorization': 'Bearer ${AppConfig.userToken}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'loan_type_id': loanType['id'],
            'amount': int.parse(_amountController.text),
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          Navigator.pop(context); // Close the modal

          // Show success message using SweetAlertStyleDialog
          showDialog(
            context: context,
            builder: (context) => SweetAlertStyleDialog(
              message:
                  'Loan application submitted successfully!\nStatus: ${responseData['status']}',
              type: MessageType.success,
            ),
          );

          logger.i('Loan application submitted: ${responseData['id']}');
        } else {
          throw Exception('Failed to submit loan application');
        }
      } catch (e) {
        logger.e('Error submitting loan application', error: e);
        showDialog(
          context: context,
          builder: (context) => SweetAlertStyleDialog(
            message: 'Failed to submit loan application. Please try again.',
            type: MessageType.error,
          ),
        );
      } finally {
        setState(() => isSubmitting = false);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apply for ${loanType['name']} Loan',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow(
                          'Interest Rate', '${loanType['interest_rate']}%'),
                      _buildInfoRow('Duration', '${loanType['duration']} days'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Loan Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixText: 'MWK ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan amount';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _submitLoanApplication();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Apply Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Loans',
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
          else
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: loanTypes.length,
              itemBuilder: (context, index) {
                final loanType = loanTypes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () => _showLoanApplicationModal(loanType),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                loanType['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.color,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${loanType['interest_rate']}%',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Duration',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${loanType['duration']} days',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
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
