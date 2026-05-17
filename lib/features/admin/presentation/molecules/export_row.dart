import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/ingesta_result.dart';
import '../../data/services/export_service.dart';
import '../bloc/ingesta_bloc.dart';
import '../bloc/ingesta_event.dart';

class ExportRow extends StatelessWidget {
  final List<IngestaResult> results;
  final ExportFormat? exportingFormat;
  final bool exportingBanexTransfer;

  const ExportRow({
    super.key,
    required this.results,
    required this.exportingFormat,
    required this.exportingBanexTransfer,
  });

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.file_download_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Descargar resultados', style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    Text(
                      'Los archivos se guardan en tu carpeta de Descargas',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ExportButton(
                  format: ExportFormat.csv,
                  label: 'CSV',
                  icon: Icons.table_chart_outlined,
                  isLoading: exportingFormat == ExportFormat.csv,
                  onTap: () => context.read<IngestaBloc>().add(
                    IngestaExportRequestedEvent(ExportFormat.csv),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ExportButton(
                  format: ExportFormat.xlsx,
                  label: 'XLSX',
                  icon: Icons.grid_on_outlined,
                  isLoading: exportingFormat == ExportFormat.xlsx,
                  onTap: () => context.read<IngestaBloc>().add(
                    IngestaExportRequestedEvent(ExportFormat.xlsx),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ExportButton(
                  format: ExportFormat.json,
                  label: 'JSON',
                  icon: Icons.data_object_outlined,
                  isLoading: exportingFormat == ExportFormat.json,
                  onTap: () => context.read<IngestaBloc>().add(
                    IngestaExportRequestedEvent(ExportFormat.json),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ExportButton(
                  format: ExportFormat.txt,
                  label: 'TXT',
                  icon: Icons.text_snippet_outlined,
                  isLoading: exportingFormat == ExportFormat.txt,
                  onTap: () => context.read<IngestaBloc>().add(
                    IngestaExportRequestedEvent(ExportFormat.txt),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: exportingBanexTransfer
                  ? null
                  : () => context.read<IngestaBloc>().add(
                      const IngestaBanexTransferExportRequestedEvent(),
                    ),
              icon: exportingBanexTransfer
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_outlined, size: 18),
              label: const Text('Exportar para BanexTransfer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: AppTextStyles.bodyPrimary.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Genera CSV con cuenta + monto para pagos masivos',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final ExportFormat format;
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;

  const _ExportButton({
    required this.format,
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceHighlight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
