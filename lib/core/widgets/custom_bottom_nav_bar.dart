import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // We use a Stack to allow the central FAB to overlap the top edge
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_filled, 'Inicio', true),
                _buildNavItem(Icons.arrow_downward, 'Recibir', false),
                const SizedBox(width: 70), // Spacer for the FAB
                _buildNavItem(Icons.arrow_upward, 'Enviar', false),
                _buildNavItem(Icons.account_balance_wallet, 'Billetera', false),
              ],
            ),
          ),

          // Floating Central Button ("Operar con QR")
          Positioned(
            top: -10, // Overlap the top
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    /* QR Action */
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape
                          .circle, // Note: Use a Hexagon CustomClipper for an exact match
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Operar con QR',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AppColors.textPrimary : AppColors.textSecondary;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
