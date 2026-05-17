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
              const Icon(
                Icons.download_outlined,
                size: 18,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text('Exportar resultados', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ExportButton(
                format: ExportFormat.csv,
                label: 'CSV',
                icon: Icons.table_chart_outlined,
                isLoading: exportingFormat == ExportFormat.csv,
                onTap: () => context.read<IngestaBloc>().add(
                  IngestaExportRequestedEvent(ExportFormat.csv),
                ),
              ),
              _ExportButton(
                format: ExportFormat.xlsx,
                label: 'XLSX',
                icon: Icons.grid_on_outlined,
                isLoading: exportingFormat == ExportFormat.xlsx,
                onTap: () => context.read<IngestaBloc>().add(
                  IngestaExportRequestedEvent(ExportFormat.xlsx),
                ),
              ),
              _ExportButton(
                format: ExportFormat.json,
                label: 'JSON',
                icon: Icons.code_outlined,
                isLoading: exportingFormat == ExportFormat.json,
                onTap: () => context.read<IngestaBloc>().add(
                  IngestaExportRequestedEvent(ExportFormat.json),
                ),
              ),
              _ExportButton(
                format: ExportFormat.txt,
                label: 'TXT',
                icon: Icons.text_snippet_outlined,
                isLoading: exportingFormat == ExportFormat.txt,
                onTap: () => context.read<IngestaBloc>().add(
                  IngestaExportRequestedEvent(ExportFormat.txt),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.send_outlined,
                size: 16,
                color: AppColors.accentPurple,
              ),
              const SizedBox(width: 8),
              Text(
                'Exportar para BanexTransfer',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.accentPurple,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(pagos masivos USDT)',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: exportingBanexTransfer
                ? null
                : () => context.read<IngestaBloc>().add(
                    const IngestaBanexTransferExportRequestedEvent(),
                  ),
            icon: exportingBanexTransfer
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentPurple,
                    ),
                  )
                : const Icon(
                    Icons.send_outlined,
                    size: 16,
                    color: AppColors.accentPurple,
                  ),
            label: const Text('Generar archivo BanexTransfer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentPurple,
              side: BorderSide(
                color: AppColors.accentPurple.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: AppTextStyles.bodyPrimary,
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
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onTap,
      icon: isLoading
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryOrange,
              ),
            )
          : Icon(icon, size: 16, color: AppColors.primaryOrange),
      label: Text('Exportar $label'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: AppTextStyles.bodyPrimary,
      ),
    );
  }
}
