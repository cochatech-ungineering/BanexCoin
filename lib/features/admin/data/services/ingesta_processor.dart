import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import '../models/cashback_level.dart';
import '../models/ingesta_result.dart';
import '../models/transaction_record.dart';

class IngestaProcessorResult {
  final List<IngestaResult> results;
  final DateTime month;

  const IngestaProcessorResult({required this.results, required this.month});
}

class IngestaProcessor {
  static IngestaProcessorResult process({
    required PlatformFile file,
    required List<CashbackLevel> levels,
    required double tipoCambio,
  }) {
    final bytes = file.bytes;
    if (bytes == null) throw Exception('No se pudieron leer los bytes del archivo.');

    final name = file.name.toLowerCase();
    final List<TransactionRecord> transactions;

    if (name.endsWith('.json')) {
      transactions = _parseJson(utf8.decode(bytes));
    } else if (name.endsWith('.csv')) {
      transactions = _parseCsv(utf8.decode(bytes));
    } else {
      throw Exception(
        'Formato no soportado: ${file.extension}. Use JSON o CSV.',
      );
    }

    if (transactions.isEmpty) throw Exception('El archivo no contiene transacciones.');

    // Pick the most recent month present in the data
    final latestDate = transactions.map((t) => t.createdAt).reduce(
          (a, b) => a.isAfter(b) ? a : b,
        );
    final targetMonth = DateTime(latestDate.year, latestDate.month);

    // Filter to target month only
    final monthly = transactions
        .where((t) =>
            t.createdAt.year == targetMonth.year &&
            t.createdAt.month == targetMonth.month)
        .toList();

    // Aggregate by account
    final Map<String, _Acc> agg = {};
    for (final t in monthly) {
      final acc = agg.putIfAbsent(t.accountNumber, () => _Acc());
      acc.usdt += t.amountUsdt;
      acc.bob += t.amountBob;
    }

    // Classify + calculate
    final sortedLevels = List<CashbackLevel>.from(levels)
      ..sort((a, b) => a.minUsdt.compareTo(b.minUsdt));

    final results = agg.entries.map((entry) {
      final totalUsdt = entry.value.usdt;
      final totalBob = entry.value.bob;

      final level = _classify(totalUsdt, sortedLevels);
      final reintegroUsdt = totalUsdt * level.porcentaje;
      final reintegroBs = reintegroUsdt * tipoCambio;

      return IngestaResult(
        accountNumber: entry.key,
        totalConsumoUsdt: totalUsdt,
        totalConsumoBs: totalBob,
        nivelIndex: level.index,
        porcentajeReintegro: level.porcentaje,
        reintegroUsdt: reintegroUsdt,
        reintegroBs: reintegroBs,
      );
    }).toList();

    results.sort((a, b) => b.totalConsumoUsdt.compareTo(a.totalConsumoUsdt));

    return IngestaProcessorResult(results: results, month: targetMonth);
  }

  static CashbackLevel _classify(double usdt, List<CashbackLevel> levels) {
    for (final level in levels.reversed) {
      if (usdt >= level.minUsdt) return level;
    }
    return levels.first;
  }

  static List<TransactionRecord> _parseJson(String source) {
    final decoded = jsonDecode(source);
    final List<dynamic> txList;

    if (decoded is Map && decoded.containsKey('transactions')) {
      txList = decoded['transactions'] as List<dynamic>;
    } else if (decoded is List) {
      txList = decoded;
    } else {
      throw Exception('JSON no reconocido: se esperaba una lista de transacciones o un objeto con clave "transactions".');
    }

    return txList
        .cast<Map<String, dynamic>>()
        .map(TransactionRecord.fromJson)
        .toList();
  }

  static List<TransactionRecord> _parseCsv(String source) {
    final rows = const CsvToListConverter(eol: '\n').convert(source);
    if (rows.length < 2) return [];
    // Skip header row
    return rows.skip(1).map(TransactionRecord.fromCsvRow).toList();
  }
}

class _Acc {
  double usdt = 0;
  double bob = 0;
}
