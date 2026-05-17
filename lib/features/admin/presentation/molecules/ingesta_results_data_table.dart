import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/ingesta_result.dart';
import '../atoms/nivel_badge.dart';

class IngestaResultsDataTable extends StatelessWidget {
  static const colAccount = 0;
  static const colTotalUsdt = 1;
  static const colTotalBs = 2;
  static const colNivel = 3;
  static const colPctReintegro = 4;
  static const colReintegroUsdt = 5;
  static const colReintegroBs = 6;

  final List<IngestaResult> rows;
  final int sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending) onSort;

  const IngestaResultsDataTable({
    super.key,
    required this.rows,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: sortColumnIndex,
            sortAscending: sortAscending,
            headingRowColor: WidgetStateProperty.all(
              AppColors.surfaceHighlight,
            ),
            dataRowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary.withValues(alpha: 0.08);
              }
              return AppColors.surface;
            }),
            border: TableBorder(
              horizontalInside: BorderSide(
                color: AppColors.borderColor,
                width: 0.5,
              ),
            ),
            headingTextStyle: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
            ),
            dataTextStyle: AppTextStyles.bodyPrimary,
            columnSpacing: 24,
            horizontalMargin: 20,
            columns: [
              DataColumn(
                label: const Text('Cuenta Destino'),
                onSort: onSort,
              ),
              DataColumn(
                label: const Text('Total USDT'),
                numeric: true,
                onSort: onSort,
              ),
              DataColumn(
                label: const Text('Total Bs'),
                numeric: true,
                onSort: onSort,
              ),
              DataColumn(label: const Text('Nivel'), onSort: onSort),
              DataColumn(
                label: const Text('% Reintegro'),
                numeric: true,
                onSort: onSort,
              ),
              DataColumn(
                label: const Text('Reintegro USDT'),
                numeric: true,
                onSort: onSort,
              ),
              DataColumn(
                label: const Text('Reintegro Bs'),
                numeric: true,
                onSort: onSort,
              ),
            ],
            rows: rows.map(_buildRow).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(IngestaResult r) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            r.accountNumber,
            style: AppTextStyles.bodyPrimary.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            r.totalConsumoUsdt.toStringAsFixed(2),
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            r.totalConsumoBs.toStringAsFixed(2),
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        DataCell(NivelBadge(index: r.nivelIndex)),
        DataCell(
          Text(
            '${(r.porcentajeReintegro * 100).toStringAsFixed(1)}%',
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.accentTeal,
            ),
          ),
        ),
        DataCell(
          Text(
            r.reintegroUsdt.toStringAsFixed(4),
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.success,
            ),
          ),
        ),
        DataCell(
          Text(
            r.reintegroBs.toStringAsFixed(2),
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }
}
