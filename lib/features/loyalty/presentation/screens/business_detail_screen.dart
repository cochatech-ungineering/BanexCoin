import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/business.dart';

class BusinessDetailScreen extends StatelessWidget {
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final business = mockBusinesses.firstWhere(
      (b) => b.id == businessId,
      orElse: () => mockBusinesses.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/loyalty/cards'),
        ),
        title: Text(business.name, style: AppTextStyles.heading2),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(business),
                const SizedBox(height: 20),
                _buildStampCard(business),
                const SizedBox(height: 24),
                _buildAboutSection(business),
                const SizedBox(height: 24),
                _buildRewardsSection(business),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Business business) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: business.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: business.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: business.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: business.accentColor.withValues(alpha: 0.4)),
            ),
            child: Icon(
              business.icon,
              color: business.accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(business.name, style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text(
                  business.category,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  'NIT: ${business.nit}',
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStampCard(Business business) {
    final isComplete = business.currentStamps >= business.totalStamps;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isComplete
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.borderColor,
        ),
        boxShadow: isComplete
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tu tarjeta', style: AppTextStyles.heading3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppColors.success.withValues(alpha: 0.12)
                      : business.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isComplete
                      ? '¡Completa!'
                      : '${business.currentStamps}/${business.totalStamps}',
                  style: AppTextStyles.label.copyWith(
                    color: isComplete ? AppColors.success : business.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStampGrid(business),
          const SizedBox(height: 16),
          if (isComplete)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.celebration_rounded, color: AppColors.success, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '¡Reclama tu ${business.reward}!',
                    style: AppTextStyles.bodyPrimary.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'Te faltan ${business.totalStamps - business.currentStamps} estampas para tu premio',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildStampGrid(Business business) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(business.totalStamps, (index) {
        final isStamped = index < business.currentStamps;
        final isNext = index == business.currentStamps;

        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isStamped
                ? business.accentColor.withValues(alpha: 0.12)
                : AppColors.surfaceHighlight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isStamped
                  ? business.accentColor.withValues(alpha: 0.5)
                  : isNext
                      ? business.accentColor.withValues(alpha: 0.3)
                      : AppColors.borderColor.withValues(alpha: 0.5),
              width: isNext ? 1.5 : 1,
            ),
          ),
          child: isStamped
              ? Icon(
                  business.icon,
                  color: business.accentColor,
                  size: 24,
                )
              : isNext
                  ? Icon(
                      Icons.add_rounded,
                      color: business.accentColor.withValues(alpha: 0.5),
                      size: 20,
                    )
                  : Icon(
                      business.icon,
                      color: AppColors.borderColor.withValues(alpha: 0.4),
                      size: 20,
                    ),
        );
      }),
    );
  }

  Widget _buildAboutSection(Business business) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acerca de', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Text(
            business.description,
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsSection(Business business) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recompensas', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              _buildRewardTier(
                business,
                stamps: business.totalStamps,
                reward: business.reward,
                isCurrent: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardTier(
    Business business, {
    required int stamps,
    required String reward,
    required bool isCurrent,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: business.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: business.accentColor.withValues(alpha: 0.3)),
          ),
          child: Icon(
            Icons.card_giftcard_rounded,
            color: business.accentColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reward,
                style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                'Completa $stamps estampas',
                style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ],
    );
  }
}
