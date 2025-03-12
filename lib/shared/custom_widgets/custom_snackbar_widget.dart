import 'package:flutter/material.dart';

class CustomSnackBarWidget {
  static void show({
    required BuildContext context,
    required String message,
    required bool floatHigher,
  }) {
    final scaffoldContext = ScaffoldMessenger.of(context);
    if (scaffoldContext.mounted) scaffoldContext.hideCurrentSnackBar();

    scaffoldContext.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: floatHigher ? 77.0 : 16.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Text(message),
      ),
    );
  }
}
