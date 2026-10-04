import 'package:flutter/material.dart';

const ink = Color(0xFF173B38);
const cream = Color(0xFFF6F3EB);
const coral = Color(0xFFC7543B);
const muted = Color(0xFF53635D);
const sand = Color(0xFFE8E1D2);

ThemeData gatewayTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: cream,
  colorScheme: ColorScheme.fromSeed(seedColor: ink, surface: cream, primary: ink, secondary: coral),
  appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink, elevation: 0),
  textTheme: const TextTheme(
    displaySmall: TextStyle(fontFamily: 'Georgia', fontSize: 42, height: 1.12, color: ink),
    headlineLarge: TextStyle(fontFamily: 'Georgia', fontSize: 32, height: 1.18, color: ink),
    headlineMedium: TextStyle(fontFamily: 'Georgia', fontSize: 27, color: ink),
    titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w600, color: ink),
    bodyLarge: TextStyle(fontSize: 17, height: 1.5, color: ink),
    bodyMedium: TextStyle(fontSize: 15, height: 1.45, color: ink),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  ),
  filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
    minimumSize: const Size(48, 56), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
  outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
    minimumSize: const Size(48, 56), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
);
