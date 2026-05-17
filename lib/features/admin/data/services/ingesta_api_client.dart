import 'dart:convert';

import 'package:banexcoin/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../models/cashback_level.dart';
import '../models/ingesta_result.dart';

class IngestaApiClient {
  // Set to false when the real backend is live.
  static const bool useMock = true;

  final Dio _dio = DioClient.create();

  Future<List<IngestaResult>> processFile({
    required PlatformFile file,
    required List<CashbackLevel> levels,
    required double tipoCambio,
  }) async {
    if (useMock) return _mockResults(tipoCambio);

    final levelsJson = jsonEncode(
      levels
          .map(
            (l) => {
              'index': l.index,
              'min_usdt': l.minUsdt,
              'max_usdt': l.maxUsdt == double.infinity ? null : l.maxUsdt,
              'porcentaje': l.porcentaje,
            },
          )
          .toList(),
    );

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(file.bytes!, filename: file.name),
      'tipo_cambio': tipoCambio.toString(),
      'levels': levelsJson,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/ingesta/process',
      data: formData,
    );

    final data = response.data!;
    return (data['results'] as List)
        .map((e) => IngestaResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<IngestaResult> _mockResults(double tipoCambio) {
    final rows = [
      _row('20149', 'ElenaMoreno57Max', 3450.00, 3, 0.02, tipoCambio),
      _row('20312', 'CarlosVilla88', 1850.75, 2, 0.015, tipoCambio),
      _row('20501', 'MariaPazLopez', 1200.00, 2, 0.015, tipoCambio),
      _row('20078', 'JuanRodriguez', 620.50, 2, 0.015, tipoCambio),
      _row('20934', 'SofiaAguirreQR', 480.00, 1, 0.01, tipoCambio),
      _row('20267', 'AndresTorrez', 310.25, 1, 0.01, tipoCambio),
      _row('20445', 'LuciaFernandez', 195.80, 1, 0.01, tipoCambio),
      _row('20188', 'MiguelCastillo', 98.40, 1, 0.01, tipoCambio),
      _row('20731', 'ValeriaMendoza', 55.00, 1, 0.01, tipoCambio),
      _row('20602', 'PedroSalinas', 12.30, 1, 0.01, tipoCambio),
    ];
    // Return sorted by total descending (mirrors server behaviour)
    rows.sort((a, b) => b.totalConsumoUsdt.compareTo(a.totalConsumoUsdt));
    return rows;
  }

  IngestaResult _row(
    String account,
    String alias,
    double total,
    int nivel,
    double pct,
    double tipoCambio,
  ) {
    final reintegroUsdt = total * pct;
    return IngestaResult(
      accountNumber: account,
      userAlias: alias,
      totalConsumoUsdt: total,
      nivelIndex: nivel,
      porcentajeReintegro: pct,
      reintegroUsdt: reintegroUsdt,
      reintegroBs: reintegroUsdt * tipoCambio,
    );
  }
}
