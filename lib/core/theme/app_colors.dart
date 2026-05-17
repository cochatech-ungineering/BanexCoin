import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A12);
  static const Color surface = Color(0xFF161622);
  static const Color surfaceHighlight = Color(0xFF1E1E2C);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF7B7B8E);

  // Primary – clean white/light gray for CTAs (high contrast on dark)
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryDark = Color(0xFFE0E0E0);
  static const Color primaryLight = Color(0xFFFFFFFF);

  // Legacy aliases
  static const Color primaryOrange = primary;
  static const Color primaryOrangeDark = primaryDark;
  static const Color accentPurple = primary;
  static const Color accentTeal = Color(0xFF00D2D3);

  // Specific elements
  static const Color badgeBackground = Color(0xFF1E1E2C);
  static const Color borderColor = Color(0xFF2A2A3A);

  // Status
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFE74C3C);
  static const Color inputFill = Color(0xFF1A1A28);

  // QR FAB
  static const Color qrOrange = Color(0xFFFF8B53);
  static const Color qrOrangeDark = Color(0xFFE56B3A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient qrGradient = LinearGradient(
    colors: [Color(0xFFFFA070), Color(0xFFFF7A45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = qrGradient;
}
