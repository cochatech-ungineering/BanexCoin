import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/cashback_calculation.dart';

class ReportsApiClient {
  final Dio _dio = DioClient.reports();

  Future<CashbackListResponse> listCashback({
    String? userId,
    int? year,
    int? month,
    int limit = 100,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/cashback',
      queryParameters: {
        if (userId != null && userId.isNotEmpty) 'userId': userId,
        if (year != null) 'year': year,
        if (month != null) 'month': month,
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );

    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300 && response.data != null) {
      return CashbackListResponse.fromJson(response.data!);
    }

    throw Exception('No se pudieron cargar los cashback (HTTP $status)');
  }

  Future<CashbackCalculation> getCashbackById(String calculationId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/cashback/calculations/$calculationId',
    );
    final status = response.statusCode ?? 0;
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (status >= 200 && status < 300 && data != null) {
      return CashbackCalculation.fromJson(data);
    }
    throw Exception('Cashback no encontrado');
  }

  Future<Map<String, dynamic>> health() async {
    final response = await _dio.get<Map<String, dynamic>>('/health');
    return response.data ?? {};
  }

  /// Carga todas las páginas hasta un máximo de registros.
  Future<List<CashbackCalculation>> listAllCashback({
    int? year,
    int? month,
    int maxItems = 500,
  }) async {
    final all = <CashbackCalculation>[];
    String? cursor;

    do {
      final page = await listCashback(
        year: year,
        month: month,
        limit: 100,
        cursor: cursor,
      );
      all.addAll(page.items);
      cursor = page.nextCursor;
      if (all.length >= maxItems) break;
    } while (cursor != null && cursor.isNotEmpty);

    return all.take(maxItems).toList();
  }
}
