import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'colored_badge.dart';

class NivelBadge extends StatelessWidget {
  static const _colors = {
    1: Color(0xFF00D2D3), // Teal
    2: Color(0xFF6C5CE7), // Purple
    3: Color(0xFF27AE60), // Green
  };

  final int index;
  final bool compact;

  const NivelBadge({super.key, required this.index, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ColoredBadge(
      label: compact ? 'N$index' : 'Nivel $index',
      accentColor: colorFor(index),
      compact: compact,
    );
  }

  static Color colorFor(int index) {
    return _colors[index] ?? AppColors.textSecondary;
  }
}
