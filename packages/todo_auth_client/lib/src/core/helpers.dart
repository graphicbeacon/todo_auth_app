import 'package:flutter/material.dart';

ScaffoldFeatureController showAlert(BuildContext context, String message,
        [bool isError = true]) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('AlertMessagePopup'),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
