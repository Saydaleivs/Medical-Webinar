import 'package:flutter/material.dart';

// Reusable error dialog
class ErrorDialog extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;
  final VoidCallback onOkPressed;

  const ErrorDialog({
    Key? key,
    required this.errorTitle,
    required this.errorMessage,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(errorTitle),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: onOkPressed,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
