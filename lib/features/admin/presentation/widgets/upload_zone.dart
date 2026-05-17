import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class UploadZone extends StatefulWidget {
  final void Function(PlatformFile file) onFilePicked;
  final bool isDisabled;

  const UploadZone({
    super.key,
    required this.onFilePicked,
    this.isDisabled = false,
  });

  @override
  State<UploadZone> createState() => _UploadZoneState();
}

class _FormatChip extends StatelessWidget {
  final String label;
  const _FormatChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Text(label, style: AppTextStyles.label),
    );
  }
}

class _UploadZoneState extends State<UploadZone> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered && !widget.isDisabled
                ? AppColors.primaryOrange
                : AppColors.borderColor,
            width: _isHovered && !widget.isDisabled ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: widget.isDisabled
                  ? AppColors.textSecondary.withValues(alpha: 0.4)
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text('Arrastra tu archivo aquí', style: AppTextStyles.bodyPrimary),
            const SizedBox(height: 4),
            Text('o', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: widget.isDisabled ? null : _pickFile,
              icon: const Icon(Icons.folder_open_outlined, size: 18),
              label: const Text('Seleccionar archivo'),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                _FormatChip('CSV'),
                _FormatChip('XLS'),
                _FormatChip('XLSX'),
                _FormatChip('JSON'),
                _FormatChip('TXT'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    if (widget.isDisabled) return;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx', 'json', 'txt'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      widget.onFilePicked(result.files.first);
    }
  }
}
