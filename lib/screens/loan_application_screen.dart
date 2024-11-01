import 'package:flutter/material.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  _LoanApplicationScreenState createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  final TextEditingController _borrowerSignatureController =
      TextEditingController();
  final TextEditingController _witnessNameController = TextEditingController();
  final TextEditingController _witnessSignatureController =
      TextEditingController();
  final TextEditingController _witnessRegController = TextEditingController();

  double _maxLoanAmount =
      0.0; // To be calculated based on shares, deposits, and loan
  final double _shares = 100000.0; // Placeholder value for shares
  final double _deposits = 200000.0; // Placeholder value for deposits
  final double _loan = 50000.0; // Placeholder value for outstanding loan

  @override
  void initState() {
    super.initState();
    _calculateMaxLoanAmount();
  }

  void _calculateMaxLoanAmount() {
    // Max loan amount = (shares + deposits) * 3 minus outstanding loan
    setState(() {
      _maxLoanAmount = ((_shares + _deposits) * 3) - _loan;
    });
  }

  void _submitLoanApplication() {
    if (_formKey.currentState!.validate()) {
      // Proceed with loan application submission
      String loanAmount = _loanAmountController.text;
      String purpose = _purposeController.text;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Loan Application Submitted'),
            content: Text(
                'Your loan application for MWK $loanAmount has been submitted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Apply for Loan', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display user's shares, deposits, and loan
            Card(
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Your Holdings',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shares:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          'MWK ${_shares.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deposits:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          'MWK ${_deposits.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Outstanding Loan:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          'MWK ${_loan.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loan Application Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Loan Eligibility',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Maximum Loan Amount: MWK ${_maxLoanAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _loanAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Loan Amount (MWK)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter loan amount';
                      }
                      double? amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Please enter a valid number';
                      }
                      if (amount > _maxLoanAmount) {
                        return 'Loan amount exceeds maximum eligibility';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _purposeController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Purpose of Loan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter purpose of loan';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Promise to Pay Section
                  _buildPromiseToPayForm(),

                  Center(
                    child: ElevatedButton(
                      onPressed: _submitLoanApplication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Submit Application',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Promise to Pay Form UI (New)
  Widget _buildPromiseToPayForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Borrower's Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Borrower's Name", _borrowerSignatureController),
          _buildTextField("Registration Number", _borrowerSignatureController),
          _buildTextField("Signature", _borrowerSignatureController),
          _buildTextField("Date", _borrowerSignatureController),
          const SizedBox(height: 20),
          const Text("Witness Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Witness Name", _witnessNameController),
          _buildTextField("Witness Registration Number", _witnessRegController),
          _buildTextField("Witness Signature", _witnessSignatureController),
          _buildTextField("Witness Date", _witnessSignatureController),
          const SizedBox(height: 20),
          const Text("Interest Rate & Additional Provisions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Text(
              "The loan shall be charged at an annual rate of ___% per month."),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to build TextField
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
