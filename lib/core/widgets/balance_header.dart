import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BalanceHeader extends StatelessWidget {
  final String balance;

  const BalanceHeader({Key? key, required this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Balance estimado:', style: AppTextStyles.bodySecondary),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.badgeBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('USDT', style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 16),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              balance,
              style: AppTextStyles.heading1.copyWith(fontSize: 40),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Añadir Fondos'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Bs. ≈ 0.00', style: AppTextStyles.bodySecondary),
            const SizedBox(width: 8),
            const Icon(Icons.visibility_off, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ],
    );
  }
}
