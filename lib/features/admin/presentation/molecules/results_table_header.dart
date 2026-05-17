import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../atoms/colored_badge.dart';
import '../utils/period_formatter.dart';

class ResultsTableHeader extends StatelessWidget {
  final int userCount;
  final DateTime? period;
  final String subtitle;

  const ResultsTableHeader({
    super.key,
    required this.userCount,
    this.period,
    this.subtitle = 'Resultados del período',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColoredBadge(
          label: '$userCount usuarios',
          accentColor: AppColors.primary,
        ),
        const SizedBox(width: 10),
        if (period != null) ...[
          ColoredBadge(
            label: 'Período: ${formatAdminPeriod(period!)}',
            accentColor: AppColors.accentPurple,
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            subtitle,
            style: AppTextStyles.bodySecondary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
