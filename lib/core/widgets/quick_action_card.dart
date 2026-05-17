import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon; // In a real app, you might use SvgPicture
  final VoidCallback onTap;
  final bool isDisabled;
  final String? ribbonText; // e.g., "Pronto"

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
    this.ribbonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: isDisabled
                      ? AppColors.textSecondary.withValues(alpha: 0.5)
                      : AppColors.textPrimary,
                  size: 28,
                ),
                Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    color: isDisabled
                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Ribbon Implementation
          if (ribbonText != null)
            Positioned(
              top: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(8),
                ),
                child: Container(
                  color: AppColors.accentPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  // Note: A true angled ribbon would require a CustomPainter or Transform.rotate
                  child: Text(
                    ribbonText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
