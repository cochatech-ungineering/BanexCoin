import 'dart:convert';

import 'package:banexcoin/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../models/cashback_level.dart';
import '../models/ingesta_result.dart';

/// Legacy API client kept for future backend integration.
/// The app currently processes files client-side via [IngestaProcessor].
class IngestaApiClient {
  static const bool useMock = false;

  final Dio _dio = DioClient.create();

  Future<List<IngestaResult>> processFile({
    required PlatformFile file,
    required List<CashbackLevel> levels,
    required double tipoCambio,
  }) async {
    final levelsJson = jsonEncode(
      levels
          .map((l) => {
                'index': l.index,
                'min_usdt': l.minUsdt,
                'max_usdt': l.maxUsdt == double.infinity ? null : l.maxUsdt,
                'porcentaje': l.porcentaje,
              })
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
}
