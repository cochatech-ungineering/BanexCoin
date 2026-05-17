import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/fraud_alert.dart';

class FraudAlertDetailScreen extends StatefulWidget {
  final String alertId;

  const FraudAlertDetailScreen({super.key, required this.alertId});

  @override
  State<FraudAlertDetailScreen> createState() => _FraudAlertDetailScreenState();
}

class _FraudAlertDetailScreenState extends State<FraudAlertDetailScreen> {
  bool _showRejectConfirm = false;

  FraudAlert get alert => mockAlerts.firstWhere(
        (a) => a.id == widget.alertId,
        orElse: () => mockAlerts.first,
      );

  @override
  Widget build(BuildContext context) {
    final color = severityColor(alert.severity);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/fraud'),
        ),
        title: Text(alert.id, style: AppTextStyles.heading2),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(severityIcon(alert.severity), color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  severityLabel(alert.severity),
                  style: AppTextStyles.label.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPatternHeader(color),
                const SizedBox(height: 16),
                _buildAccountsCard(),
                const SizedBox(height: 20),
                _buildReasonsSection(color),
                const SizedBox(height: 20),
                _buildTransactionsPreview(color),
                const SizedBox(height: 24),
                if (alert.status == AlertStatus.pending ||
                    alert.status == AlertStatus.reviewing)
                  _buildActionsSection(color),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatternHeader(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.pattern_rounded, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alert.patternName, style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    Text(
                      alert.dateRange,
                      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.description,
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Origen', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text(alert.accountOrigin, style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.swap_horiz_rounded, color: AppColors.textSecondary, size: 18),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Destino', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text(alert.accountDestination, style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonsSection(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flag_rounded, size: 18, color: color),
            const SizedBox(width: 8),
            Text('Motivos del flag', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              for (int i = 0; i < alert.reasons.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: AppTextStyles.label.copyWith(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        alert.reasons[i],
                        style: AppTextStyles.bodyPrimary.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < alert.reasons.length - 1)
                  const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsPreview(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text('Vista previa de transacciones', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Mostrando 5 de ${alert.transactionCount} transacciones flaggeadas',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('Fecha', style: _headerStyle())),
                    Expanded(flex: 2, child: Text('Monto', style: _headerStyle())),
                    Expanded(flex: 2, child: Text('Ref.', style: _headerStyle())),
                    Expanded(flex: 1, child: Text('Tipo', style: _headerStyle())),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderColor),
              for (int i = 0; i < alert.transactions.length; i++) ...[
                _buildTransactionRow(alert.transactions[i]),
                if (i < alert.transactions.length - 1)
                  const Divider(height: 1, color: AppColors.borderColor, indent: 14, endIndent: 14),
              ],
              if (alert.transactionCount > 5)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceHighlight,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
                  ),
                  child: Text(
                    '+${alert.transactionCount - 5} transacciones más en el reporte completo',
                    style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(FlaggedTransaction txn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.date, style: AppTextStyles.label),
                Text(txn.hour, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${txn.amount.toStringAsFixed(0)} USDT',
              style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              txn.reference,
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                txn.type,
                style: AppTextStyles.label.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(Color color) {
    if (_showRejectConfirm) {
      return _buildRejectConfirmation(color);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acciones', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _showRejectConfirm = true),
                  icon: const Icon(Icons.block_rounded, size: 18),
                  label: const Text('Rechazar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.12),
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                  label: const Text('Descartar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceHighlight,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.borderColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined, size: 18),
            label: const Text('Exportar reporte completo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.borderColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRejectConfirmation(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Text(
                'Confirmar rechazo',
                style: AppTextStyles.heading3.copyWith(color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Al rechazar, se bloquearán las ${alert.transactionCount} transacciones pendientes entre estas cuentas y se enviará notificación a compliance.',
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Se aplicará:', style: AppTextStyles.label),
                const SizedBox(height: 6),
                _buildRejectItem('Bloqueo temporal de cuentas involucradas'),
                _buildRejectItem('Notificación a oficial de cumplimiento'),
                _buildRejectItem('Reporte automático a la UIF'),
                _buildRejectItem('Congelamiento de fondos en tránsito'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showRejectConfirm = false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _showRejectConfirm = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Alerta ${alert.id} rechazada. Cuentas bloqueadas.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Confirmar rechazo'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRejectItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.error),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return AppTextStyles.label.copyWith(
      color: AppColors.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );
  }
}
