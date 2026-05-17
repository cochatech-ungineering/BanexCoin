import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/ingesta_result.dart';

class ResultsTable extends StatefulWidget {
  final List<IngestaResult> results;
  final DateTime? period;

  const ResultsTable({super.key, required this.results, this.period});

  @override
  State<ResultsTable> createState() => _ResultsTableState();
}

class _NivelBadge extends StatelessWidget {
  static const _colors = {
    1: AppColors.primaryOrange,
    2: AppColors.accentPurple,
    3: Color(0xFF2ECC71),
  };
  final int index;

  const _NivelBadge(this.index);

  @override
  Widget build(BuildContext context) {
    final color = _colors[index] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        'Nivel $index',
        style: AppTextStyles.label.copyWith(color: color),
      ),
    );
  }
}

class _ResultsTableState extends State<ResultsTable> {
  // col indices: 0=Cuenta, 1=TotalUSDT, 2=TotalBs, 3=Nivel, 4=%Reintegro, 5=ReintegroUSDT, 6=ReintegroBs
  int _sortColumnIndex = 1;
  bool _sortAscending = false;
  late List<IngestaResult> _sorted;

  @override
  void initState() {
    super.initState();
    _sorted = List.from(widget.results);
    _applySort();
  }

  @override
  void didUpdateWidget(ResultsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.results != widget.results) {
      _sorted = List.from(widget.results);
      _applySort();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                '${widget.results.length} usuarios',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (widget.period != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.accentPurple.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Período: ${_formatPeriod(widget.period!)}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              'Resultados del período',
              style: AppTextStyles.bodySecondary,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
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
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                headingRowColor: WidgetStateProperty.all(
                  AppColors.surfaceHighlight,
                ),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primaryOrange.withValues(alpha: 0.08);
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
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('Total USDT'),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('Total Bs'),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  DataColumn(label: const Text('Nivel'), onSort: _onSort),
                  DataColumn(
                    label: const Text('% Reintegro'),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('Reintegro USDT'),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  DataColumn(
                    label: const Text('Reintegro Bs'),
                    numeric: true,
                    onSort: _onSort,
                  ),
                ],
                rows: _sorted.map((r) {
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
                      DataCell(_NivelBadge(r.nivelIndex)),
                      DataCell(
                        Text(
                          '${(r.porcentajeReintegro * 100).toStringAsFixed(1)}%',
                          style: AppTextStyles.bodyPrimary.copyWith(
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          r.reintegroUsdt.toStringAsFixed(4),
                          style: AppTextStyles.bodyPrimary.copyWith(
                            color: const Color(0xFF2ECC71),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          r.reintegroBs.toStringAsFixed(2),
                          style: AppTextStyles.bodyPrimary.copyWith(
                            color: const Color(0xFF2ECC71),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _applySort() {
    _sorted.sort((a, b) {
      final cmp = _compareByColumn(_sortColumnIndex, a, b);
      return _sortAscending ? cmp : -cmp;
    });
  }

  int _compareByColumn(int col, IngestaResult a, IngestaResult b) {
    switch (col) {
      case 0:
        return a.accountNumber.compareTo(b.accountNumber);
      case 1:
        return a.totalConsumoUsdt.compareTo(b.totalConsumoUsdt);
      case 2:
        return a.totalConsumoBs.compareTo(b.totalConsumoBs);
      case 3:
        return a.nivelIndex.compareTo(b.nivelIndex);
      case 4:
        return a.porcentajeReintegro.compareTo(b.porcentajeReintegro);
      case 5:
        return a.reintegroUsdt.compareTo(b.reintegroUsdt);
      case 6:
        return a.reintegroBs.compareTo(b.reintegroBs);
      default:
        return 0;
    }
  }

  void _onSort(int colIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = colIndex;
      _sortAscending = ascending;
      _applySort();
    });
  }

  static const _months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static String _formatPeriod(DateTime d) =>
      '${_months[d.month - 1]} ${d.year}';
}
