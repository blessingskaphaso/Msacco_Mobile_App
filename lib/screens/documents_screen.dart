import 'package:flutter/material.dart';

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({Key? key}) : super(key: key);

  @override
  _MyDocumentsScreenState createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  bool isLoanFormExpanded = false;
  bool isWithdrawalFormExpanded = false;
  bool isPromiseToPayFormExpanded = false; // New bool for Promise to Pay form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('My Documents', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Loan Application Form Card
            _buildDocumentCard(
              "Loan Application Form",
              isLoanFormExpanded,
              () {
                setState(() {
                  isLoanFormExpanded = !isLoanFormExpanded;
                });
              },
              _buildLoanForm(),
            ),
            const SizedBox(height: 20),

            // Savings Withdrawal Transfer Form Card
            _buildDocumentCard(
              "Savings Withdrawal Transfer Form",
              isWithdrawalFormExpanded,
              () {
                setState(() {
                  isWithdrawalFormExpanded = !isWithdrawalFormExpanded;
                });
              },
              _buildWithdrawalForm(),
            ),
            const SizedBox(height: 20),

            // Promise to Pay Form Card
            _buildDocumentCard(
              "Promise to Pay Form", // New form title
              isPromiseToPayFormExpanded,
              () {
                setState(() {
                  isPromiseToPayFormExpanded = !isPromiseToPayFormExpanded;
                });
              },
              _buildPromiseToPayForm(), // Build Promise to Pay form
            ),
          ],
        ),
      ),
    );
  }

  // Builds each document card
  Widget _buildDocumentCard(
      String title, bool isExpanded, VoidCallback onTap, Widget formContent) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: onTap,
          ),
          if (isExpanded) formContent,
        ],
      ),
    );
  }

  // Loan Application Form UI (Simplified)
  Widget _buildLoanForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Personal Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Surname"),
          _buildTextField("First Name"),
          _buildTextField("Rank/Position"),
          _buildTextField("Telephone No"),
          _buildTextField("Unit / Section / Department"),
          const SizedBox(height: 20),
          const Text("Financial Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Shares"),
          _buildTextField("Savings"),
          _buildTextField("Fixed Deposits"),
          _buildTextField("Loans"),
          const SizedBox(height: 20),
          const Text("Loan Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Loan Amount"),
          _buildTextField("Repayment Period (Months)"),
          _buildTextField("Purpose of Loan"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Submit logic for loan application
            },
            child: const Text("Submit Loan Application"),
          ),
        ],
      ),
    );
  }

  // Withdrawal Transfer Form UI (Simplified)
  Widget _buildWithdrawalForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Personal Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Surname"),
          _buildTextField("First Name"),
          _buildTextField("Rank/Position"),
          _buildTextField("Telephone No"),
          const SizedBox(height: 20),
          const Text("Transfer Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Bank Name"),
          _buildTextField("Bank Account No"),
          _buildTextField("Airtel Money No"),
          _buildTextField("TNM Mpamba No"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Submit logic for withdrawal transfer
            },
            child: const Text("Submit Withdrawal Transfer"),
          ),
        ],
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
          _buildTextField("Borrower's Name"),
          _buildTextField("Registration Number"),
          _buildTextField("Signature"),
          _buildTextField("Date"),
          const SizedBox(height: 20),
          const Text("Witness Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildTextField("Witness Name"),
          _buildTextField("Witness Registration Number"),
          _buildTextField("Witness Signature"),
          _buildTextField("Witness Date"),
          const SizedBox(height: 20),
          const Text("Interest Rate & Additional Provisions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Text(
              "The loan shall be charged at an annual rate of ___% per month."),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Submit logic for promise to pay form
            },
            child: const Text("Submit Promise to Pay"),
          ),
        ],
      ),
    );
  }

  // Helper method to build TextField
  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
