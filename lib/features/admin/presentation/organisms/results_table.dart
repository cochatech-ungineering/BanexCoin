import 'package:flutter/material.dart';

import '../../data/models/ingesta_result.dart';
import '../molecules/ingesta_results_data_table.dart';
import '../molecules/results_table_header.dart';
import '../utils/ingesta_result_sort.dart';

class ResultsTable extends StatefulWidget {
  final List<IngestaResult> results;
  final DateTime? period;

  const ResultsTable({super.key, required this.results, this.period});

  @override
  State<ResultsTable> createState() => _ResultsTableState();
}

class _ResultsTableState extends State<ResultsTable> {
  int _sortColumnIndex = IngestaResultsDataTable.colTotalUsdt;
  bool _sortAscending = false;

  late List<IngestaResult> _sorted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResultsTableHeader(
          userCount: widget.results.length,
          period: widget.period,
        ),
        const SizedBox(height: 14),
        IngestaResultsDataTable(
          rows: _sorted,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onSort: _onSort,
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
