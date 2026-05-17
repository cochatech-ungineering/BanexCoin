import 'package:banexcoin/core/export/export_service.dart';

import '../models/ingesta_result.dart';

export 'package:banexcoin/core/export/export_service.dart' show ExportFormat;

class AdminExportService {
  static const List<String> _headers = [
    'account_number',
    'total_usdt',
    'total_bs',
    'nivel',
    'porcentaje_reintegro',
    'reintegro_usdt',
    'reintegro_bs',
  ];

  static Future<String> export(
    List<IngestaResult> results,
    ExportFormat format,
    double tipoCambio,
  ) =>
      ExportService.export(
        filename: 'reintegros_banexcoin',
        format: format,
        headers: _headers,
        rows: results.map((r) => r.toCsvRow()).toList(),
        jsonRows: results.map((r) => r.toJson()).toList(),
      );

  /// Two-column CSV ready for BanexTransfer bulk payout.
  static Future<String> exportBanexTransfer(List<IngestaResult> results) =>
      ExportService.export(
        filename: 'banextransfer_reintegros',
        format: ExportFormat.csv,
        headers: ['account_number', 'reintegro_usdt'],
        rows: results
            .map((r) => [r.accountNumber, r.reintegroUsdt.toStringAsFixed(4)])
            .toList(),
      );
}
