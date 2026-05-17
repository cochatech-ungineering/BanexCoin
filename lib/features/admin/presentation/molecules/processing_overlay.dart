import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProcessingOverlay extends StatelessWidget {
  final double progress;
  final String stageLabel;
  final String fileName;

  const ProcessingOverlay({
    super.key,
    required this.progress,
    required this.stageLabel,
    required this.fileName,
  });

  String get _remainingText {
    if (progress <= 0) return '';
    final totalMs = 3500;
    final remaining = (totalMs * (1.0 - progress)).round();
    if (remaining <= 0) return 'Finalizando...';
    final secs = (remaining / 1000).ceil();
    return 'Tiempo restante: ~${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(stageLabel, style: AppTextStyles.bodyPrimary),
              ),
              Text(
                '$pct%',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceHighlight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Archivo: $fileName',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _remainingText,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
