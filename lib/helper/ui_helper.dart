import 'package:flutter/material.dart';

class UiHelper {
  static showCustomDialog(
      {required BuildContext context, required String title}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static customSnackbar(
      {required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.onError,
        content: Text(message),
      ),
    );
  }

  static errorCustomSnackbar(
      {required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(message),
      ),
    );
  }
}
