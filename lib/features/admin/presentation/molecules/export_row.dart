import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/ingesta_result.dart';
import '../../data/services/export_service.dart';
import '../bloc/ingesta_bloc.dart';
import '../bloc/ingesta_event.dart';

class ExportRow extends StatefulWidget {
  final List<IngestaResult> results;
  final ExportFormat? exportingFormat;
  final bool exportingBanexTransfer;

  const ExportRow({
    super.key,
    required this.results,
    required this.exportingFormat,
    this.exportingBanexTransfer = false,
  });

  @override
  State<ExportRow> createState() => _ExportRowState();
}

class _ExportRowState extends State<ExportRow> {
  ExportFormat _selectedFormat = ExportFormat.csv;

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                size: 20,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 10),
              Text('Descargar resultados', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Se guarda en tu carpeta de Descargas',
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              _FormatChip(
                label: 'CSV',
                isSelected: _selectedFormat == ExportFormat.csv,
                onTap: () => setState(() => _selectedFormat = ExportFormat.csv),
              ),
              const SizedBox(width: 8),
              _FormatChip(
                label: 'XLSX',
                isSelected: _selectedFormat == ExportFormat.xlsx,
                onTap: () => setState(() => _selectedFormat = ExportFormat.xlsx),
              ),
              const SizedBox(width: 8),
              _FormatChip(
                label: 'JSON',
                isSelected: _selectedFormat == ExportFormat.json,
                onTap: () => setState(() => _selectedFormat = ExportFormat.json),
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.exportingFormat != null
                  ? null
                  : () => context.read<IngestaBloc>().add(
                      IngestaExportRequestedEvent(_selectedFormat),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                foregroundColor: AppColors.background,
                disabledBackgroundColor: AppColors.textSecondary,
                disabledForegroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: widget.exportingFormat != null
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : Text(
                      'Descargar ${_selectedFormat.name.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.surfaceHighlight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
