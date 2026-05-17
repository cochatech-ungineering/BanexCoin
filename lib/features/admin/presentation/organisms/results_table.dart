import 'package:flutter/material.dart';

import '../../data/models/ingesta_result.dart';
import '../molecules/ingesta_results_data_table.dart';
import '../molecules/results_table_header.dart';
import '../utils/ingesta_result_sort.dart';

class ResultsTable extends StatefulWidget {
  final List<IngestaResult> results;
  final DateTime? period;
  final int maxPreviewRows;

  const ResultsTable({
    super.key,
    required this.results,
    this.period,
    this.maxPreviewRows = 5,
  });

  @override
  State<ResultsTable> createState() => _ResultsTableState();
}

class _ResultsTableState extends State<ResultsTable> {
  int _sortColumnIndex = IngestaResultsDataTable.colTotalUsdt;
  bool _sortAscending = false;

  late List<IngestaResult> _sorted;

  @override
  Widget build(BuildContext context) {
    final previewRows = _sorted.length > widget.maxPreviewRows
        ? _sorted.sublist(0, widget.maxPreviewRows)
        : _sorted;
    final hasMore = _sorted.length > widget.maxPreviewRows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResultsTableHeader(
          userCount: widget.results.length,
          period: widget.period,
        ),
        const SizedBox(height: 14),
        IngestaResultsDataTable(
          rows: previewRows,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onSort: _onSort,
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Vista previa: ${widget.maxPreviewRows} de ${_sorted.length} registros. '
              'Descarga el archivo completo abajo.',
              style: const TextStyle(
                color: Color(0xFF8E8E9A),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void didUpdateWidget(ResultsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.results != widget.results) {
      _sorted = _sort(widget.results);
    }
  }

  @override
  void initState() {
    super.initState();
    _sorted = _sort(widget.results);
  }

  void _onSort(int colIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = colIndex;
      _sortAscending = ascending;
      _sorted = _sort(widget.results);
    });
  }

  List<IngestaResult> _sort(List<IngestaResult> source) => sortIngestaResults(
        source,
        columnIndex: _sortColumnIndex,
        ascending: _sortAscending,
      );
}
