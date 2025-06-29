import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    background: AppColors.backgroundColor,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: AppColors.textPrimary,
    onBackground: AppColors.textPrimary,
    error: AppColors.errorColor,
    onError: Colors.white,
  ),

  textTheme: const TextTheme(
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,
    headlineLarge: AppTypography.headlineLarge,
    headlineMedium: AppTypography.headlineMedium,
    headlineSmall: AppTypography.headlineSmall,
    titleLarge: AppTypography.titleLarge,
    titleMedium: AppTypography.titleMedium,
    titleSmall: AppTypography.titleSmall,
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    bodySmall: AppTypography.bodySmall,
    labelLarge: AppTypography.labelLarge,
    labelMedium: AppTypography.labelMedium,
    labelSmall: AppTypography.labelSmall,
  ),

  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  iconTheme: const IconThemeData(
    color: AppColors.primaryColor,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accentColor,
    foregroundColor: Colors.white,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Sets the overall brightness to dark
  primaryColor: Colors.deepPurple,
  // Fallback primary color for dark mode
  scaffoldBackgroundColor: Colors.black,
  // Main background color for dark mode

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple, // AppBar background color
    foregroundColor: Colors.white, // AppBar icon/text color
    elevation: 0,
  ),

  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple,
    // Brand color
    secondary: Colors.tealAccent,
    // Accent/highlight color
    background: Colors.black,
    // General background
    surface: Colors.grey,
    // Background for surfaces like Cards
    onPrimary: Colors.white,
    // Content color on primary
    onSecondary: Colors.black,
    // Content color on secondary
    onSurface: Colors.white,
    // Text/icon color on surfaces
    onBackground: Colors.white,
    // Color for text/icon on background
    error: Colors.redAccent,
    // Error background color
    onError: Colors.black, // Content color on error background
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // Headers
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white), // Main body text
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70), // Subtext
  ),

  cardTheme: CardTheme(
    color: Colors.grey[850], // Card background in dark mode
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, // Button fill color
      foregroundColor: Colors.white, // Text/icon color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800], // Input background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurpleAccent), // Border on focus
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  iconTheme: const IconThemeData(
    color: Colors.tealAccent, // Default icon color in dark mode
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
);
