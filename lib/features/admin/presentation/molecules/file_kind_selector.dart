import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/services/ingesta_api_client.dart';

class FileKindSelector extends StatelessWidget {
  final IngestionFileKind value;
  final ValueChanged<IngestionFileKind>? onChanged;

  const FileKindSelector({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<IngestionFileKind>(
      segments: const [
        ButtonSegment(
          value: IngestionFileKind.qrPayments,
          label: Text('Pagos QR'),
          icon: Icon(Icons.qr_code_2, size: 18),
        ),
        ButtonSegment(
          value: IngestionFileKind.transfers,
          label: Text('Transferencias'),
          icon: Icon(Icons.swap_horiz, size: 18),
        ),
      ],
      selected: {value},
      onSelectionChanged: onChanged == null
          ? null
          : (set) => onChanged!(set.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryOrange.withValues(alpha: 0.2);
          }
          return AppColors.surface;
        }),
      ),
    );
  }
}
