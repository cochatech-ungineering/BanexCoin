import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/cashback_request.dart';

class ApprovalDetailScreen extends StatefulWidget {
  final String requestId;

  const ApprovalDetailScreen({super.key, required this.requestId});

  @override
  State<ApprovalDetailScreen> createState() => _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends State<ApprovalDetailScreen> {
  bool _actionTaken = false;
  String _actionResult = '';

  CashbackRequest get request => mockRequests.firstWhere(
        (r) => r.id == widget.requestId,
        orElse: () => mockRequests.first,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/approval'),
        ),
        title: Text(request.id, style: AppTextStyles.heading2),
        actions: [
          if (request.hasfraudLink)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => context.go('/fraud/alert/${request.fraudAlertId}'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_rounded, size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      Text(
                        'Ver fraude',
                        style: AppTextStyles.label.copyWith(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
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
                _buildUserSection(),
                const SizedBox(height: 16),
                _buildRequestInfo(),
                const SizedBox(height: 16),
                _buildDlAnalysis(),
                if (request.hasfraudLink) ...[
                  const SizedBox(height: 16),
                  _buildFraudLink(),
                ],
                const SizedBox(height: 24),
                if (!_actionTaken && request.isPreClassified || request.status == RequestStatus.pending)
                  _buildActions()
                else if (_actionTaken)
                  _buildActionResult(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                request.userName.split(' ').map((w) => w[0]).take(2).join(),
                style: AppTextStyles.heading3,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.userName, style: AppTextStyles.heading3),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _badge('Nivel ${request.nivel}', AppColors.accentTeal),
                    const SizedBox(width: 6),
                    _badge(request.userId, AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInfo() {
    final statusColor = _getStatusColor(request.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Solicitud de reintegro', style: AppTextStyles.heading3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel(request.status),
                  style: AppTextStyles.label.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Monto solicitado', '${request.montoSolicitado.toStringAsFixed(2)} USDT'),
          _buildInfoRow('Volumen del mes', '${request.volumenMes.toStringAsFixed(0)} USDT'),
          _buildInfoRow('Fecha', request.date),
          _buildInfoRow('Riesgo', riskLabel(request.riskLevel)),
        ],
      ),
    );
  }

  Widget _buildDlAnalysis() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.2)),
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
                  color: AppColors.accentTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.psychology_rounded, color: AppColors.accentTeal, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Análisis Deep Learning', style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      'Modelo v2.4 · Confianza: ${(request.dlConfidence * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _buildConfidenceIndicator(request.dlConfidence),
            ],
          ),
          const SizedBox(height: 16),
          _buildConfidenceBar(request.dlConfidence),
          const SizedBox(height: 16),
          for (int i = 0; i < request.dlReasons.length; i++) ...[
            _buildReasonItem(i + 1, request.dlReasons[i]),
            if (i < request.dlReasons.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(double confidence) {
    final color = confidence >= 0.9
        ? AppColors.success
        : confidence >= 0.7
            ? const Color(0xFFFF8B53)
            : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence,
            minHeight: 6,
            backgroundColor: AppColors.surfaceHighlight,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            Text(
              confidence >= 0.9
                  ? 'Alta confianza'
                  : confidence >= 0.7
                      ? 'Confianza moderada'
                      : 'Baja confianza',
              style: AppTextStyles.label.copyWith(color: color, fontSize: 10),
            ),
            Text('100%', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildConfidenceIndicator(double confidence) {
    final color = confidence >= 0.9
        ? AppColors.success
        : confidence >= 0.7
            ? const Color(0xFFFF8B53)
            : AppColors.error;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          (confidence * 100).toStringAsFixed(0),
          style: AppTextStyles.label.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildReasonItem(int index, String reason) {
    final isNegative = reason.toLowerCase().contains('fraude') ||
        reason.toLowerCase().contains('riesgo') ||
        reason.toLowerCase().contains('incremento') ||
        reason.toLowerCase().contains('inconsistencia');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: isNegative
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.accentTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Icon(
              isNegative ? Icons.close_rounded : Icons.check_rounded,
              size: 12,
              color: isNegative ? AppColors.error : AppColors.accentTeal,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            reason,
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

  Widget _buildFraudLink() {
    return GestureDetector(
      onTap: () => context.go('/fraud/alert/${request.fraudAlertId}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.link_rounded, color: AppColors.error, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vinculado a alerta de fraude',
                    style: AppTextStyles.bodyPrimary.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${request.fraudAlertId} · Toca para ver detalles',
                    style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    final isPreDenied = request.status == RequestStatus.preDenied;
    final isPreApproved = request.status == RequestStatus.preApproved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acción del administrador', style: AppTextStyles.heading3),
        const SizedBox(height: 6),
        Text(
          isPreApproved
              ? 'El modelo recomienda aprobar esta solicitud.'
              : isPreDenied
                  ? 'El modelo recomienda rechazar esta solicitud.'
                  : 'Se requiere revisión manual para esta solicitud.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _takeAction('Aprobado'),
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Aprobar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPreApproved
                        ? AppColors.success
                        : AppColors.success.withValues(alpha: 0.12),
                    foregroundColor: isPreApproved
                        ? AppColors.textPrimary
                        : AppColors.success,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isPreApproved
                          ? BorderSide.none
                          : BorderSide(color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _takeAction('Rechazado'),
                  icon: const Icon(Icons.cancel_rounded, size: 18),
                  label: const Text('Rechazar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPreDenied
                        ? AppColors.error
                        : AppColors.error.withValues(alpha: 0.12),
                    foregroundColor: isPreDenied
                        ? AppColors.textPrimary
                        : AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isPreDenied
                          ? BorderSide.none
                          : BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isPreApproved || isPreDenied) ...[
          const SizedBox(height: 10),
          Center(
            child: Text(
              isPreApproved
                  ? 'Recomendación DL: Aprobar (${(request.dlConfidence * 100).toStringAsFixed(0)}% confianza)'
                  : 'Recomendación DL: Rechazar (${(request.dlConfidence * 100).toStringAsFixed(0)}% confianza)',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionResult() {
    final isApproved = _actionResult == 'Aprobado';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isApproved
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApproved
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isApproved ? AppColors.success : AppColors.error,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solicitud $_actionResult',
                  style: AppTextStyles.heading3.copyWith(
                    color: isApproved ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isApproved
                      ? 'El reintegro de ${request.montoSolicitado.toStringAsFixed(2)} USDT será procesado.'
                      : 'La solicitud ha sido rechazada. Se notificará al usuario.',
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _takeAction(String action) {
    setState(() {
      _actionTaken = true;
      _actionResult = action;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.id} — $action correctamente'),
        backgroundColor: action == 'Aprobado' ? AppColors.success : AppColors.error,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyPrimary.copyWith(color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: AppTextStyles.label.copyWith(color: color, fontSize: 11)),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.preApproved:
      case RequestStatus.approved:
        return AppColors.success;
      case RequestStatus.preDenied:
      case RequestStatus.denied:
        return AppColors.error;
      case RequestStatus.pending:
        return const Color(0xFFFF8B53);
    }
  }
}
