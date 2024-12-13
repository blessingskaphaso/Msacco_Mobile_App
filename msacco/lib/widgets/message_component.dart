import 'package:flutter/material.dart';

class SweetAlertStyleDialog extends StatelessWidget {
  final String message;
  final MessageType type;
  final VoidCallback?
      onConfirm; // Optional callback for the confirmation button
  final String confirmText;

  const SweetAlertStyleDialog({
    Key? key,
    required this.message,
    required this.type,
    this.onConfirm,
    this.confirmText = "OK",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors and icons based on type
    Color backgroundColor;
    IconData icon;
    switch (type) {
      case MessageType.success:
        backgroundColor = Colors.green.shade600;
        icon = Icons.check_circle_outline;
        break;
      case MessageType.error:
        backgroundColor = Colors.red.shade600;
        icon = Icons.error_outline;
        break;
      case MessageType.warning:
        backgroundColor = Colors.orange.shade600;
        icon = Icons.warning_amber_outlined;
        break;
    }

    // Adjust dialog and text colors based on the app theme
    final theme = Theme.of(context);
    final dialogBackgroundColor =
        theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white;
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon at the top
            CircleAvatar(
              backgroundColor: backgroundColor,
              radius: 35,
              child: Icon(icon, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            // Confirm Button
            ElevatedButton(
              onPressed: () {
                if (onConfirm != null) onConfirm!();
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 30,
                ),
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enum for message types
enum MessageType { success, error, warning }
