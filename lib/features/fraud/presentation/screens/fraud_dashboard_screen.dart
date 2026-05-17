import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/fraud_alert.dart';

class FraudDashboardScreen extends StatelessWidget {
  const FraudDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = mockAlerts.where((a) => a.status == AlertStatus.pending).length;
    final reviewing = mockAlerts.where((a) => a.status == AlertStatus.reviewing).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/'),
        ),
        title: Text('Detección de Fraude', style: AppTextStyles.heading2),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _buildStatsRow(pending, reviewing),
              const SizedBox(height: 24),
              _buildSectionHeader('Alertas activas'),
              const SizedBox(height: 12),
              for (final alert in mockAlerts.where((a) =>
                  a.status == AlertStatus.pending || a.status == AlertStatus.reviewing)) ...[
                _AlertCard(alert: alert),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 24),
              _buildSectionHeader('Resueltas'),
              const SizedBox(height: 12),
              for (final alert in mockAlerts.where((a) =>
                  a.status == AlertStatus.rejected || a.status == AlertStatus.cleared)) ...[
                _AlertCard(alert: alert),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(int pending, int reviewing) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Pendientes',
            value: '$pending',
            color: const Color(0xFFE74C3C),
            icon: Icons.error_outline_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'En revisión',
            value: '$reviewing',
            color: const Color(0xFFFF8B53),
            icon: Icons.visibility_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Este mes',
            value: '${mockAlerts.length}',
            color: AppColors.accentTeal,
            icon: Icons.shield_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: AppTextStyles.heading3);
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(color: color),
          ),
          const SizedBox(height: 2),
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

class _AlertCard extends StatelessWidget {
  final FraudAlert alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = severityColor(alert.severity);
    final isResolved = alert.status == AlertStatus.rejected || alert.status == AlertStatus.cleared;

    return GestureDetector(
      onTap: () => context.go('/fraud/alert/${alert.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isResolved ? AppColors.borderColor : color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    severityIcon(alert.severity),
                    color: isResolved ? AppColors.textSecondary : color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.patternName,
                        style: AppTextStyles.bodyPrimary.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isResolved ? AppColors.textSecondary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.id,
                        style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isResolved
                        ? AppColors.surfaceHighlight
                        : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    severityLabel(alert.severity),
                    style: AppTextStyles.label.copyWith(
                      color: isResolved ? AppColors.textSecondary : color,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(Icons.swap_horiz_rounded, '${alert.transactionCount} txns'),
                const SizedBox(width: 10),
                _buildInfoChip(Icons.attach_money_rounded, '${alert.totalAmount.toStringAsFixed(0)} USDT'),
                const Spacer(),
                Text(
                  statusLabel(alert.status),
                  style: AppTextStyles.label.copyWith(
                    color: alert.status == AlertStatus.cleared
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
