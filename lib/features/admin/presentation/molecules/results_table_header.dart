import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../atoms/colored_badge.dart';
import '../utils/period_formatter.dart';

class ResultsTableHeader extends StatelessWidget {
  final int userCount;
  final DateTime? period;

  const ResultsTableHeader({
    super.key,
    required this.userCount,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Vista previa', style: AppTextStyles.heading3),
        const Spacer(),
        if (period != null)
          ColoredBadge(
            label: formatAdminPeriod(period!),
            accentColor: AppColors.textSecondary,
            compact: true,
          ),
      ],
    );
  }
}
