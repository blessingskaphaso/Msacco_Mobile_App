import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:msacco/config/config.dart';
import 'package:msacco/utils/logger.dart';
import 'package:msacco/widgets/message_component.dart';
import 'package:http/http.dart' as http;

class TransferFundsScreen extends StatefulWidget {
  const TransferFundsScreen({super.key});

  @override
  State<TransferFundsScreen> createState() => _TransferFundsScreenState();
}

class _TransferFundsScreenState extends State<TransferFundsScreen> {
  String? _selectedType;
  String? _selectedSource;
  String? _selectedDestination;
  final TextEditingController _amountController = TextEditingController();

  final List<String> _transferTypes = ["Deposit", "Shares", "Withdraw"];
  final List<String> _paymentMethods = ["Bank", "Airtel Money", "TNM Mpamba"];

  @override
  Widget build(BuildContext context) {
    void _updateDropdownValues() {
      // Reset source and destination if the selected type is not in valid items
      if (_selectedType != null && !_transferTypes.contains(_selectedType)) {
        _selectedType = null;
      }

      if (_selectedSource != null &&
          !(_selectedType == "Withdraw" && _selectedSource == "Deposit" ||
              _paymentMethods.contains(_selectedSource))) {
        _selectedSource = null;
      }

      if (_selectedDestination != null &&
          !(_selectedType == "Deposit" && _selectedDestination == "Deposit" ||
              _selectedType == "Shares" && _selectedDestination == "Shares" ||
              _paymentMethods.contains(_selectedDestination))) {
        _selectedDestination = null;
      }
    }

    _updateDropdownValues();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transfer Funds',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, "Type of Transfer"),
            const SizedBox(height: 10),
            _buildDropdownField(
              context,
              "Select Transfer Type",
              _selectedType,
              _transferTypes,
              Icons.swap_horiz,
              (value) {
                setState(() {
                  _selectedType = value;
                  if (value == "Deposit") {
                    _selectedDestination = "Deposit";
                    _selectedSource = null;
                  } else if (value == "Shares") {
                    _selectedDestination = "Shares";
                    _selectedSource = null;
                  } else if (value == "Withdraw") {
                    _selectedSource = "Deposit";
                    _selectedDestination = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            _buildHeader(context, "Source"),
            const SizedBox(height: 10),
            _buildDropdownField(
              context,
              "Select Source",
              _selectedSource,
              _selectedType == "Withdraw" ? ["Deposit"] : _paymentMethods,
              Icons.account_balance_wallet,
              (value) {
                setState(() {
                  _selectedSource = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildHeader(context, "Destination"),
            const SizedBox(height: 10),
            _buildDropdownField(
              context,
              "Select Destination",
              _selectedDestination,
              _selectedType == "Deposit"
                  ? ["Deposit"]
                  : _selectedType == "Shares"
                      ? ["Shares"]
                      : _paymentMethods,
              Icons.account_balance_wallet,
              (value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildHeader(context, "Amount"),
            const SizedBox(height: 10),
            _buildTextField(
              context,
              "Amount (MWK)",
              _amountController,
              Icons.attach_money,
              TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  logger.i("Submit transfer button clicked.");
                  _performTransfer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Submit Transfer",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String? selectedValue,
    List<String> items,
    IconData icon,
    ValueChanged<String?> onChanged,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            icon: Icon(icon, color: Theme.of(context).primaryColor),
            border: InputBorder.none,
          ),
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
    TextInputType keyboardType,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            icon: Icon(icon, color: Theme.of(context).primaryColor),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Future<void> _performTransfer() async {
    final amount = _amountController.text;
    final type = _selectedType?.toLowerCase();
    final source = _selectedSource;
    final destination = _selectedDestination;
    final accountId = AppConfig.userId;
    final token = AppConfig.userToken;

    logger.i("Performing transfer...");
    logger.i(
        "Transfer details: type=$type, source=$source, amount=$amount, accountId=$accountId");

    // Validation checks
    if (type == null ||
        source == null ||
        destination == null ||
        amount.isEmpty) {
      _showMessageDialog(
          "Please fill out all fields.", false, MessageType.warning);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'account_id': accountId,
          'type': type,
          'amount': int.parse(amount),
          'source': source,
          'destination': destination,
        }),
      );

      logger.i("API response: ${response.statusCode}");
      // logger.i("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final transaction = responseData['transaction'];
        final successMessage = "Transfer completed successfully!\n\n"
            "Amount: MWK ${transaction['amount']}\n"
            "Type: ${transaction['type']}\n"
            "From: ${transaction['source']}\n"
            "To: ${transaction['destination']}";

        _showMessageDialog(successMessage, true, MessageType.success);
      } else {
        final errorData = jsonDecode(response.body);
        _showMessageDialog(
            errorData['message'] ?? "Failed to complete transfer.",
            false,
            MessageType.error);
      }
    } catch (e) {
      logger.e("An error occurred during the transfer", error: e);
      _showMessageDialog(
          "An error occurred during the transfer.", false, MessageType.error);
    }
  }

  void _showMessageDialog(String message, bool success, MessageType type) {
    showDialog(
      context: context,
      builder: (context) {
        return SweetAlertStyleDialog(
          message: message,
          type: type,
        );
      },
    );
    logger.i("Message dialog displayed: $message");
  }
}
