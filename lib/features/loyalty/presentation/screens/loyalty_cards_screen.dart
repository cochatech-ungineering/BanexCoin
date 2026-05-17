import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/business.dart';

class LoyaltyCardsScreen extends StatelessWidget {
  const LoyaltyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/loyalty'),
        ),
        title: Text('Mis Tarjetas', style: AppTextStyles.heading2),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Text(
                'Negocios afiliados',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 16),
              for (final business in mockBusinesses) ...[
                _BusinessCard(business: business),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  final Business business;

  const _BusinessCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final progress = business.currentStamps / business.totalStamps;
    final isComplete = business.currentStamps >= business.totalStamps;

    return GestureDetector(
      onTap: () => context.go('/loyalty/business/${business.id}'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: business.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete
                ? business.accentColor.withValues(alpha: 0.5)
                : AppColors.borderColor,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: business.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: business.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    business.icon,
                    color: business.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        business.category,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '¡Canjear!',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Text(
                    '${business.currentStamps}/${business.totalStamps}',
                    style: AppTextStyles.bodyPrimary.copyWith(
                      color: business.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: AppColors.surfaceHighlight,
                valueColor: AlwaysStoppedAnimation(business.accentColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.card_giftcard_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Premio: ${business.reward}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
