import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF13141C); // Main app background
  static const Color surface = Color(0xFF1B1B26); // Card/Container background
  static const Color surfaceHighlight = Color(
    0xFF252533,
  ); // Slightly lighter surface

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(
    0xFF9E9EA7,
  ); // Muted text for subtitles

  // Accents
  static const Color primaryOrange = Color(0xFFFF7E40); // Main brand color
  static const Color primaryOrangeDark = Color(0xFFF26822);
  static const Color accentPurple = Color(
    0xFF6B48FF,
  ); // Used for the "Pronto" ribbon

  // Specific elements
  static const Color badgeBackground = Color(
    0xFF2C2C3E,
  ); // e.g., USDT badge background
  static const Color borderColor = Color(0xFF2A2A38); // Subtle borders on cards

  // Status & Inputs
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color inputFill = Color(0xFF252533);

  // Gradients
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF9255), Color(0xFFFF622A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
