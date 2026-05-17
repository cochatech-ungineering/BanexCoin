import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_profitability.dart';

class UserProfitabilityScreen extends StatelessWidget {
  final String userId;

  const UserProfitabilityScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final user = mockUsers.firstWhere(
      (u) => u.userId == userId,
      orElse: () => mockUsers.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/profitability'),
        ),
        title: Text(user.userName, style: AppTextStyles.heading2),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildUserHeader(user),
                const SizedBox(height: 16),
                _buildRentabilidadCard(user),
                const SizedBox(height: 16),
                _buildDesglose(user),
                const SizedBox(height: 16),
                _buildSimulacion(user),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(UserProfitability user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                user.userName.split(' ').map((w) => w[0]).take(2).join(),
                style: AppTextStyles.heading3,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.userName, style: AppTextStyles.heading3),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildBadge('Nivel ${user.nivel}', AppColors.accentTeal),
                    const SizedBox(width: 8),
                    _buildBadge(user.userId, AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(color: color, fontSize: 11),
      ),
    );
  }

  Widget _buildRentabilidadCard(UserProfitability user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: user.esRentable
            ? AppColors.success.withValues(alpha: 0.05)
            : AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.esRentable
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            user.esRentable ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: user.esRentable ? AppColors.success : AppColors.error,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            '${user.rentabilidadNeta >= 0 ? '+' : ''}${user.rentabilidadNeta.toStringAsFixed(4)} USDT',
            style: AppTextStyles.heading1.copyWith(
              fontSize: 26,
              color: user.esRentable ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.esRentable ? 'Rentabilidad neta positiva' : 'Rentabilidad neta negativa',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Margen: ${user.margenPorcentaje.toStringAsFixed(1)}%',
              style: AppTextStyles.label.copyWith(
                color: user.esRentable ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesglose(UserProfitability user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Desglose', style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          _buildDesgloseRow('Compras USDT', '${user.totalComprasUsdt.toStringAsFixed(0)} USDT', null),
          _buildDivider(),
          _buildDesgloseRow('Retiros USDT', '${user.totalRetirosUsdt.toStringAsFixed(0)} USDT', null),
          _buildDivider(),
          _buildDesgloseRow('Total operado', '${user.totalOperaciones.toStringAsFixed(0)} USDT', AppColors.textPrimary),
          _buildDivider(),
          _buildDesgloseRow(
            'Spread (${user.spreadPorUnidad.toStringAsFixed(2)} Bs/USDT)',
            '${user.comisionBs.toStringAsFixed(2)} Bs',
            null,
          ),
          _buildDivider(),
          _buildDesgloseRow('Comisión equiv.', '${user.comisionUsdt.toStringAsFixed(4)} USDT', AppColors.textPrimary),
          _buildDivider(),
          _buildDesgloseRow('CashBack entregado', '−${user.cashbackEntregado.toStringAsFixed(4)} USDT', const Color(0xFFFF8B53)),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: user.esRentable
                  ? AppColors.success.withValues(alpha: 0.08)
                  : AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resultado neto',
                  style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${user.rentabilidadNeta >= 0 ? '+' : ''}${user.rentabilidadNeta.toStringAsFixed(4)} USDT',
                  style: AppTextStyles.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w700,
                    color: user.esRentable ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesgloseRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyPrimary.copyWith(color: AppColors.textSecondary, fontSize: 13)),
          Text(
            value,
            style: AppTextStyles.bodyPrimary.copyWith(
              color: valueColor ?? AppColors.textSecondary,
              fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.borderColor);
  }

  Widget _buildSimulacion(UserProfitability user) {
    final mesesParaRecuperar = user.esRentable
        ? null
        : (user.cashbackEntregado - user.comisionUsdt) / (user.comisionUsdt / 3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppColors.accentTeal),
              const SizedBox(width: 8),
              Text('Análisis', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 14),
          if (user.esRentable) ...[
            _buildAnalysisItem(
              Icons.check_circle_rounded,
              AppColors.success,
              'Este usuario genera +${user.rentabilidadNeta.toStringAsFixed(2)} USDT de ganancia neta después de cashback.',
            ),
            const SizedBox(height: 10),
            _buildAnalysisItem(
              Icons.speed_rounded,
              AppColors.accentTeal,
              'Con ${user.totalOperaciones.toStringAsFixed(0)} USDT operados, su volumen justifica el nivel ${user.nivel} de cashback.',
            ),
          ] else ...[
            _buildAnalysisItem(
              Icons.warning_rounded,
              AppColors.error,
              'El cashback entregado supera la comisión generada por ${(user.cashbackEntregado - user.comisionUsdt).toStringAsFixed(2)} USDT.',
            ),
            const SizedBox(height: 10),
            if (mesesParaRecuperar != null)
              _buildAnalysisItem(
                Icons.schedule_rounded,
                const Color(0xFFFF8B53),
                'Al ritmo actual, se necesitan ~${mesesParaRecuperar.toStringAsFixed(0)} meses más para alcanzar rentabilidad.',
              ),
          ],
          const SizedBox(height: 10),
          _buildAnalysisItem(
            Icons.calendar_today_rounded,
            AppColors.textSecondary,
            'Última actividad: ${user.lastActivity}',
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
