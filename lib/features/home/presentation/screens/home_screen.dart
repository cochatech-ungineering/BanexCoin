import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/atoms/dotted_background.dart';
import '../../../../core/presentation/molecules/balance_header.dart';
import '../../../../core/presentation/molecules/promo_banner_card.dart';
import '../../../../core/presentation/molecules/quick_action_card.dart';
import '../../../../core/presentation/organisms/custom_bottom_nav_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceHighlight,
              child: Icon(
                Icons.person_outline,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          title: const Text('Inicio'),
          actions: [
            IconButton(
              icon: const Icon(Icons.headset_mic_outlined, size: 22),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long_outlined, size: 22),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 22),
              tooltip: 'Ingesta Admin',
              onPressed: () => context.go('/admin'),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BalanceHeader(balance: '0.0000'),
                  const SizedBox(height: 24),
                  const PromoBannerCard(),
                  const SizedBox(height: 24),
                  Text('Acciones rápidas', style: AppTextStyles.heading3),
                  const SizedBox(height: 14),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.72,
                    children: [
                      QuickActionCard(
                        title: 'Pago de\nServicio',
                        icon: Icons.payments_outlined,
                        onTap: () {},
                        isDisabled: true,
                        ribbonText: 'Pronto',
                      ),
                      QuickActionCard(
                        title: 'Enviar a\nBilletera',
                        icon: Icons.north_east_rounded,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        title: 'Comprar\nUSDT',
                        icon: Icons.currency_exchange_outlined,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        title: 'Pagar con\nQR',
                        icon: Icons.qr_code_scanner_rounded,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        title: 'Enviar\nBanex...',
                        icon: Icons.send_outlined,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        title: 'Recibir de\nBilletera',
                        icon: Icons.south_west_rounded,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        title: 'Comprar con\nTarjeta',
                        icon: Icons.credit_card_outlined,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        title: 'Cobrar con\nQR',
                        icon: Icons.qr_code_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Actividad reciente', style: AppTextStyles.heading3),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ver todo',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
        extendBody: true,
      ),
    );
  }
}
