import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../reports/data/models/cashback_calculation.dart';
import '../../../reports/data/services/reports_api_client.dart';

class RecentCashbackSection extends StatefulWidget {
  const RecentCashbackSection({super.key});

  @override
  State<RecentCashbackSection> createState() => _RecentCashbackSectionState();
}

class _RecentCashbackSectionState extends State<RecentCashbackSection> {
  late final Future<List<CashbackCalculation>> _future;

  @override
  void initState() {
    super.initState();
    _future = ReportsApiClient().listCashback(limit: 5).then((r) => r.items);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CashbackCalculation>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'No se pudo cargar actividad: ${snapshot.error}',
            style: AppTextStyles.bodySecondary,
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Text(
            'Sin cashback calculado aún. Sube un reporte en Vista Admin.',
            style: AppTextStyles.bodySecondary,
          );
        }

        return Column(
          children: items.map(_tile).toList(),
        );
      },
    );
  }

  Widget _tile(CashbackCalculation c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: AppColors.primaryOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.userId,
                  style: AppTextStyles.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${c.cashbackLevel} · ${c.cashbackAmountUsdt.toStringAsFixed(4)} USDT',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          Text(
            '${c.cashbackPercentage.toStringAsFixed(1)}%',
            style: AppTextStyles.label.copyWith(color: AppColors.primaryOrange),
          ),
        ],
      ),
    );
  }
}
