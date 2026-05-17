import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds – from Banexcoin real app screenshots
  static const Color background = Color(0xFF0A0A12);
  static const Color surface = Color(0xFF161622);
  static const Color surfaceHighlight = Color(0xFF1E1E2C);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF7B7B8E);

  // Primary CTA – violet used for main buttons (like "Siguiente")
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5A4BD6);
  static const Color primaryLight = Color(0xFF8B7DF0);

  // Legacy aliases so existing code compiles without changes
  static const Color primaryOrange = primary;
  static const Color primaryOrangeDark = primaryDark;
  static const Color accentPurple = primary;

  // Accent – teal for secondary highlights
  static const Color accentTeal = Color(0xFF00D2D3);

  // Specific elements
  static const Color badgeBackground = Color(0xFF1E1E2C);
  static const Color borderColor = Color(0xFF252535);

  // Status
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFE74C3C);
  static const Color inputFill = Color(0xFF1A1A28);

  // QR FAB – orange only for the hexagonal QR button (matches real app)
  static const Color qrOrange = Color(0xFFFF8B53);
  static const Color qrOrangeDark = Color(0xFFE56B3A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C6CF0), Color(0xFF5A4BD6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient qrGradient = LinearGradient(
    colors: [Color(0xFFFFA070), Color(0xFFFF7A45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy alias
  static const LinearGradient orangeGradient = qrGradient;
}
