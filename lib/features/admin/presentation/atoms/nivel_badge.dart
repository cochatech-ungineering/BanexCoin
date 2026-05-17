import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'colored_badge.dart';

class NivelBadge extends StatelessWidget {
  static const _colors = {
    1: AppColors.primaryOrange,
    2: AppColors.accentPurple,
    3: AppColors.success,
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
