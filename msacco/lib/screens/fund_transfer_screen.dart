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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Transfer Form Card
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Transfer Type"),
                      const SizedBox(height: 10),
                      _buildTransferTypeSelector(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Source"),
                      const SizedBox(height: 10),
                      _buildSourceSelector(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Destination"),
                      const SizedBox(height: 10),
                      _buildDestinationSelector(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Amount"),
                      const SizedBox(height: 10),
                      _buildAmountField(),
                      const SizedBox(height: 30),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTransferTypeSelector() {
    return _buildDropdownField(
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
    );
  }

  Widget _buildSourceSelector() {
    return _buildDropdownField(
      "Select Source",
      _selectedSource,
      _selectedType == "Withdraw" ? ["Deposit"] : _paymentMethods,
      Icons.account_balance_wallet,
      (value) => setState(() => _selectedSource = value),
    );
  }

  Widget _buildDestinationSelector() {
    return _buildDropdownField(
      "Select Destination",
      _selectedDestination,
      _selectedType == "Deposit"
          ? ["Deposit"]
          : _selectedType == "Shares"
              ? ["Shares"]
              : _paymentMethods,
      Icons.account_balance_wallet,
      (value) => setState(() => _selectedDestination = value),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Amount (MWK)",
        prefixIcon:
            Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _performTransfer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "Submit Transfer",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
