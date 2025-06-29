import 'package:flutter/material.dart';

abstract class AppTypography {
  // Display
  static const displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black);
  static const displayMedium = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);
  static const displaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black);

  // Headline
  static const headlineLarge = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);
  static const headlineMedium = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black);
  static const headlineSmall = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black);

  // Title
  static const titleLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
  static const titleMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
  static const titleSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);

  // Body
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black);
  static const bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87);
  static const bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black54);

  // Label
  static const labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);
  static const labelMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70);
  static const labelSmall = TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey);
}
