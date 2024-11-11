import 'package:flutter/material.dart';

class TransferFundsScreen extends StatefulWidget {
  const TransferFundsScreen({super.key});

  @override
  _TransferFundsScreenState createState() => _TransferFundsScreenState();
}

class _TransferFundsScreenState extends State<TransferFundsScreen> {
  String? _selectedSource; // Source of funds
  String? _selectedDestination; // Destination of funds
  final TextEditingController _amountController = TextEditingController();

  final List<String> _sources = [
    "Deposits",
    "Bank",
    "Airtel Money",
    "TNM Mpamba"
  ];

  final List<String> _destinations = [
    "Shares",
    "Deposits",
    "Airtel Money",
    "TNM Mpamba"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transfer Funds',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Wrap the content with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Source of Funds",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Dropdown for selecting source of funds
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Source",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _selectedSource,
              items: _sources.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSource = value;
                  // Reset destination if source changes
                  _selectedDestination = null;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              "Destination of Funds",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Dropdown for selecting destination of funds
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Destination",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _selectedDestination,
              items: _filteredDestinations().map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Amount to transfer input field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount (MWK)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Submit button for the transfer
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Perform transfer logic
                  _performTransfer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
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

  // Filters the destination based on the selected source
  List<String> _filteredDestinations() {
    if (_selectedSource == "Bank" ||
        _selectedSource == "Airtel Money" ||
        _selectedSource == "TNM Mpamba") {
      // If the source is from Bank or Mobile Money, allow only "Shares" or "Deposits" as destination
      return _destinations.where((dest) => dest != "Bank").toList();
    } else {
      // Otherwise, show all available destinations
      return _destinations;
    }
  }

  // Logic to handle the transfer (placeholder)
  void _performTransfer() {
    final amount = _amountController.text;
    final source = _selectedSource;
    final destination = _selectedDestination;

    if (source != null && destination != null && amount.isNotEmpty) {
      if (_isValidTransfer(source, destination)) {
        // Success transfer logic
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Transfer Successful"),
              content: Text(
                  "You have successfully transferred MWK $amount from $source to $destination."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog("Invalid Transfer",
            "You cannot transfer between the same types or between Bank, Airtel Money, and TNM Mpamba.");
      }
    } else {
      _showErrorDialog("Incomplete Form", "Please fill out all fields.");
    }
  }

  // Validates the transfer to ensure no invalid transfers between the same types
  bool _isValidTransfer(String source, String destination) {
    // Prevent transfers between the same types
    if (source == destination) {
      return false; // Same type transfers should not be allowed
    }

    // Prevent transfers between Bank, Airtel Money, and TNM Mpamba
    if ((source == "Bank" ||
            source == "Airtel Money" ||
            source == "TNM Mpamba") &&
        (destination == "Bank" ||
            destination == "Airtel Money" ||
            destination == "TNM Mpamba")) {
      return false;
    }

    return true;
  }

  // Displays error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
