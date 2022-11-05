import 'package:flutter/material.dart';

final theme = ThemeData(
  primaryColor: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.white,
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.white,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.white,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.purpleAccent,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.redAccent,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorStyle: const TextStyle(
      color: Colors.orangeAccent,
    ),
  ),
);
