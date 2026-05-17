import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF101016); // Deep dark, less purple than before
  static const Color surface = Color(0xFF1A1A24); // Card/Container background
  static const Color surfaceHighlight = Color(
    0xFF232330,
  ); // Slightly lighter surface

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(
    0xFF92929D,
  ); // Muted text for subtitles

  // Accents
  static const Color primaryOrange = Color(0xFFFF8B53); // Softer brand color
  static const Color primaryOrangeDark = Color(0xFFE56B3A);
  static const Color accentPurple = Color(
    0xFF4A3A7D,
  ); // Softer, more elegant purple instead of neon

  // Specific elements
  static const Color badgeBackground = Color(
    0xFF252533,
  ); // e.g., USDT badge background
  static const Color borderColor = Color(0xFF282836); // Subtle borders on cards

  // Status & Inputs
  static const Color success = Color(0xFF27AE60); // Less neon green
  static const Color error = Color(0xFFD94A3D);   // Less neon red
  static const Color inputFill = Color(0xFF1E1E2A);

  // Gradients
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFFA070), Color(0xFFFF7A45)], // Softer orange gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
