import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  _MyDocumentsScreenState createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  bool isLoanFormExpanded = false;
  bool isWithdrawalFormExpanded = false;
  bool isPromiseToPayFormExpanded = false; // New bool for Promise to Pay form

  File? _signatureImage; // To store the selected signature image
  final ImagePicker _picker = ImagePicker(); // Initialize the image picker

  Future<void> _pickSignatureImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _signatureImage = File(pickedFile.path);
      });
    }
  }

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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[200]
                  : Colors.grey[700],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.insert_drive_file,
                  color: Theme.of(context).primaryColor),
              title: Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  )),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              onTap: onTap,
            ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Submit Loan Application",
              style: TextStyle(color: Colors.white),
            ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Submit Withdrawal Transfer",
              style: TextStyle(color: Colors.white),
            ),
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
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickSignatureImage,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[200]
                    : Colors.grey[700],
              ),
              child: Center(
                child: _signatureImage == null
                    ? const Text("Upload Signature",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                    : Image.file(
                        _signatureImage!,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Submit Promise to Pay",
              style: TextStyle(color: Colors.white),
            ),
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
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[700],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
