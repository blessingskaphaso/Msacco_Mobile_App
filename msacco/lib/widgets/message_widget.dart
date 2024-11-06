import 'package:flutter/material.dart';

void showMessageDialog(BuildContext context, String message, bool isSuccess,
    {VoidCallback? onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isSuccess ? 'Success' : 'Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: Text(isSuccess ? 'OK' : 'Try Again'),
          ),
        ],
      );
    },
  );
}
