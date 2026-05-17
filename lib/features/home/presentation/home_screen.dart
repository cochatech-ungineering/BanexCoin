import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/balance_header.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/promo_banner_card.dart';
import '../../../core/widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceHighlight,
            child: Icon(Icons.person, color: AppColors.textPrimary),
          ),
        ),
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            tooltip: 'Vista Admin',
            onPressed: () => context.go('/admin'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceHeader(balance: '0.0000'),
            const SizedBox(height: 24),
            const PromoBannerCard(),
            const SizedBox(height: 24),
            Text('Acciones rápidas', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
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
                  icon: Icons.upload_outlined,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: 'Comprar\nUSDT',
                  icon: Icons.currency_exchange,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: 'Pagar con\nQR',
                  icon: Icons.qr_code_scanner,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: 'Enviar\nBanex...',
                  icon: Icons.send_to_mobile,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: 'Recibir de\nBilletera',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: 'Comprar con\nTarjeta',
                  icon: Icons.credit_card,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: 'Cobrar con\nQR',
                  icon: Icons.qr_code,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Actividad reciente', style: AppTextStyles.heading2),
                TextButton(
                  onPressed: () {},
                  child:
                      Text('Ver más →', style: AppTextStyles.bodySecondary),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      extendBody: true,
    );
  }
}
