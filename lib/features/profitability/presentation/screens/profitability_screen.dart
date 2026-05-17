import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_profitability.dart';

class ProfitabilityScreen extends StatelessWidget {
  const ProfitabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = getMockSummary();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/'),
        ),
        title: Text('Rentabilidad CashBack', style: AppTextStyles.heading2),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _buildSpreadCard(summary),
              const SizedBox(height: 16),
              _buildGlobalStats(summary),
              const SizedBox(height: 24),
              _buildRentabilidadBar(summary),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Por usuario', style: AppTextStyles.heading3),
                  Text(
                    '${summary.usuarios.length} usuarios',
                    style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final user in summary.usuarios) ...[
                _UserProfitCard(user: user),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpreadCard(ProfitabilitySummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.currency_exchange_rounded, color: AppColors.accentTeal, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spread actual', style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    Text(
                      'Comisión por operación',
                      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSpreadItem(
                    'Paralelo',
                    '${summary.precioParalelo.toStringAsFixed(2)} Bs',
                    AppColors.textSecondary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: AppColors.borderColor,
                ),
                Expanded(
                  child: _buildSpreadItem(
                    'Cobrado',
                    '${summary.precioCobrado.toStringAsFixed(2)} Bs',
                    AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: AppColors.borderColor,
                ),
                Expanded(
                  child: _buildSpreadItem(
                    'Spread',
                    '${(summary.precioCobrado - summary.precioParalelo).toStringAsFixed(2)} Bs',
                    AppColors.accentTeal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyPrimary.copyWith(color: valueColor, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildGlobalStats(ProfitabilitySummary summary) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Comisiones',
            value: summary.totalComisiones.toStringAsFixed(2),
            unit: 'USDT',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            label: 'CashBack dado',
            value: summary.totalCashbackEntregado.toStringAsFixed(2),
            unit: 'USDT',
            color: const Color(0xFFFF8B53),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            label: 'Ganancia neta',
            value: summary.rentabilidadGlobal.toStringAsFixed(2),
            unit: 'USDT',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildRentabilidadBar(ProfitabilitySummary summary) {
    final comisionFraction = summary.totalComisiones > 0
        ? (summary.totalComisiones - summary.totalCashbackEntregado) / summary.totalComisiones
        : 0.0;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Margen global', style: AppTextStyles.heading3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${summary.margenGlobal.toStringAsFixed(1)}%',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8B53).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: comisionFraction,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendDot(AppColors.success, 'Ganancia retenida'),
              const SizedBox(width: 16),
              _buildLegendDot(const Color(0xFFFF8B53), 'CashBack entregado'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  summary.rentabilidadGlobal > 0
                      ? Icons.check_circle_rounded
                      : Icons.warning_rounded,
                  size: 16,
                  color: summary.rentabilidadGlobal > 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    summary.rentabilidadGlobal > 0
                        ? 'El programa es rentable. Comisiones cubren el cashback con ${summary.margenGlobal.toStringAsFixed(1)}% de margen.'
                        : 'Atención: el cashback supera las comisiones generadas.',
                    style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(color: color, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(unit, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _UserProfitCard extends StatelessWidget {
  final UserProfitability user;

  const _UserProfitCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/profitability/user/${user.userId}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      user.userName.split(' ').map((w) => w[0]).take(2).join(),
                      style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.userName, style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        'Nivel ${user.nivel} · ${user.totalOperaciones.toStringAsFixed(0)} USDT operados',
                        style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user.rentabilidadNeta >= 0 ? '+' : ''}${user.rentabilidadNeta.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyPrimary.copyWith(
                        color: user.esRentable ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'USDT neto',
                      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMiniStat('Comisión', user.comisionUsdt.toStringAsFixed(2), AppColors.textSecondary),
                const SizedBox(width: 16),
                _buildMiniStat('CashBack', '−${user.cashbackEntregado.toStringAsFixed(2)}', const Color(0xFFFF8B53)),
                const SizedBox(width: 16),
                _buildMiniStat('Margen', '${user.margenPorcentaje.toStringAsFixed(1)}%', user.esRentable ? AppColors.success : AppColors.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.label.copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
