import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1565C0),
    primary: const Color(0xFF1565C0),
    secondary: const Color.fromARGB(255, 0, 187, 255),
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1565C0),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16),
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
  ),
  useMaterial3: true,
);
