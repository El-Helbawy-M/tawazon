import 'package:flutter/material.dart';
const rubik = 'rubik';
abstract class AppTypography {
  // Display
  static const displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: rubik);
  static const displayMedium = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: rubik);
  static const displaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black,fontFamily: rubik);

  // Headline
  static const headlineLarge = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: rubik);
  static const headlineMedium = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black,fontFamily: rubik);
  static const headlineSmall = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: rubik);

  // Title
  static const titleLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black,fontFamily: rubik);
  static const titleMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: rubik);
  static const titleSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black,fontFamily: rubik);

  // Body
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black,fontFamily: rubik);
  static const bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87,fontFamily: rubik);
  static const bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black54,fontFamily: rubik);

  // Label
  static const labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,fontFamily: rubik);
  static const labelMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70,fontFamily: rubik);
  static const labelSmall = TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey,fontFamily: rubik);
}
