import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PromoBannerCard extends StatelessWidget {
  const PromoBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Muy Pronto!', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Text(
                  'Nuevas formas de pagar dentro y fuera del país, pago de servicios y mucho más!',
                  style: AppTextStyles.bodySecondary.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          // Right side space for the 3D illustration
          Expanded(
            flex: 2,
            child: Container(
              height: 100,
              alignment: Alignment.centerRight,
              // In production, insert Image.asset('assets/illustrations/phone.png') here
            ),
          ),
        ],
      ),
    );
  }
}
