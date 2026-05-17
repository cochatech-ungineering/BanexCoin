import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

import 'save_file_stub.dart'
    if (dart.library.html) 'save_file_web.dart'
    if (dart.library.io) 'save_file_desktop.dart';

enum ExportFormat { csv, xlsx, json }

class ExportService {
  static Future<String> export({
    required String filename,
    required ExportFormat format,
    required List<String> headers,
    required List<List<dynamic>> rows,
    List<Map<String, dynamic>>? jsonRows,
  }) async {
    late Uint8List bytes;
    final String fullFilename = '$filename.${format.name}';

    switch (format) {
      case ExportFormat.csv:
        bytes = _buildCsvBytes(headers, rows);
      case ExportFormat.xlsx:
        bytes = _buildXlsxBytes(headers, rows);
      case ExportFormat.json:
        bytes = _buildJsonBytes(jsonRows ?? _rowsToMaps(headers, rows));
    }

    await saveFile(fullFilename, bytes);
    return fullFilename;
  }

  static Uint8List _buildCsvBytes(
    List<String> headers,
    List<List<dynamic>> rows,
  ) {
    final csv = const ListToCsvConverter().convert([headers, ...rows]);
    return Uint8List.fromList(utf8.encode(csv));
  }

  static Uint8List _buildJsonBytes(List<Map<String, dynamic>> data) {
    return Uint8List.fromList(utf8.encode(jsonEncode(data)));
  }

  static Uint8List _buildXlsxBytes(
    List<String> headers,
    List<List<dynamic>> rows,
  ) {
    final excel = Excel.createExcel();
    final sheetName = 'Sheet1';
    final sheet = excel[sheetName];
    excel.setDefaultSheet(sheetName);

    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (final row in rows) {
      sheet.appendRow(
        row.map((v) {
          if (v is num) return DoubleCellValue(v.toDouble());
          return TextCellValue(v.toString());
        }).toList(),
      );
    }

    final encoded = excel.encode();
    if (encoded == null) throw Exception('Failed to encode XLSX.');
    return Uint8List.fromList(encoded);
  }

  static List<Map<String, dynamic>> _rowsToMaps(
    List<String> headers,
    List<List<dynamic>> rows,
  ) => rows
      .map((r) => {for (var i = 0; i < headers.length; i++) headers[i]: r[i]})
      .toList();
}
