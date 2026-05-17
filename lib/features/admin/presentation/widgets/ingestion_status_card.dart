import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/ingestion_upload_response.dart';

class IngestionStatusCard extends StatelessWidget {
  final IngestionUploadResponse ingestion;
  final bool loadingCashback;
  final VoidCallback? onRefreshCashback;

  const IngestionStatusCard({
    super.key,
    required this.ingestion,
    this.loadingCashback = false,
    this.onRefreshCashback,
  });

  @override
  Widget build(BuildContext context) {
    final stats = ingestion.stats;
    return Container(
      width: double.infinity,
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
              const Icon(Icons.check_circle_outline,
                  color: Color(0xFF2ECC71), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ingesta enviada al backend',
                  style: AppTextStyles.heading3,
                ),
              ),
              if (loadingCashback)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _row('Reporte', ingestion.reportId),
          _row('Archivo', ingestion.sourceFile),
          _row('Estado', ingestion.jobStatus ?? 'completed'),
          _row('Registros', '${stats.totalRecords}'),
          _row('Usuarios', '${stats.uniqueUsers}'),
          _row('Eventos publicados', '${ingestion.eventsPublished}'),
          if (stats.periodEnd != null)
            _row('Período', _formatPeriod(stats.periodEnd!)),
          const SizedBox(height: 12),
          Text(
            'El motor de cashback procesa en segundo plano. '
            'Los resultados aparecen cuando estén en S3.',
            style: AppTextStyles.bodySecondary,
          ),
          if (onRefreshCashback != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: loadingCashback ? null : onRefreshCashback,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Cargar resultados de cashback'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: AppTextStyles.label),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyPrimary,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  static const _months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  static String _formatPeriod(DateTime d) =>
      '${_months[d.month - 1]} ${d.year}';
}
