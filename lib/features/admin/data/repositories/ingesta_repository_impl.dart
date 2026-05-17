import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../reports/data/mappers/cashback_mapper.dart';
import '../../../reports/data/services/reports_api_client.dart';
import '../../domain/models/ingesta_run_result.dart';
import '../../domain/repositories/ingesta_repository.dart';
import '../models/ingesta_result.dart';
import '../models/ingestion_upload_response.dart';
import '../services/export_service.dart';
import '../services/ingesta_api_client.dart';

class IngestaRepositoryImpl implements IngestaRepository {
  static const _maxPollAttempts = 24;
  static const _pollInterval = Duration(seconds: 8);

  final IngestaApiClient _ingestaApi;
  final ReportsApiClient _reportsApi;

  IngestaRepositoryImpl({
    IngestaApiClient? ingestaApi,
    ReportsApiClient? reportsApi,
  })  : _ingestaApi = ingestaApi ?? IngestaApiClient(),
        _reportsApi = reportsApi ?? ReportsApiClient();

  @override
  Future<IngestaRunResult> runIngestion({
    required PlatformFile file,
    required IngestionFileKind kind,
    IngestaProgressCallback? onProgress,
  }) async {
    try {
      onProgress?.call(
        IngestaProgressUpdate(
          stageLabel: 'Subiendo a data-ingestion...',
          progress: 0.1,
          fileName: file.name,
        ),
      );

      final ingestion = await _ingestaApi.uploadFile(file: file, kind: kind);

      onProgress?.call(
        IngestaProgressUpdate(
          stageLabel: 'Esperando motor de cashback...',
          progress: 0.5,
          fileName: file.name,
          ingestion: ingestion,
        ),
      );

      return await fetchCashback(
        ingestion: ingestion,
        onProgress: onProgress,
        autoPoll: true,
        fileName: file.name,
      );
    } on IngestaCashbackPendingException {
      rethrow;
    } catch (e) {
      throw Exception(_mapError(e));
    }
  }

  @override
  Future<IngestaRunResult> fetchCashback({
    required IngestionUploadResponse ingestion,
    IngestaProgressCallback? onProgress,
    bool autoPoll = false,
    String? fileName,
  }) async {
    try {
      final year = ingestion.stats.periodEnd?.year;
      final month = ingestion.stats.periodEnd?.month;

      for (var attempt = 0; attempt <= _maxPollAttempts; attempt++) {
        if (attempt > 0) {
          if (!autoPoll) break;
          await Future.delayed(_pollInterval);
        }

        onProgress?.call(
          IngestaProgressUpdate(
            stageLabel: attempt == 0
                ? 'Consultando reports API...'
                : 'Esperando cashback ($attempt/$_maxPollAttempts)...',
            progress: 0.5 + (attempt / _maxPollAttempts) * 0.45,
            fileName: fileName,
            ingestion: ingestion,
            pollAttempt: attempt,
          ),
        );

        final items = await _reportsApi.listAllCashback(
          year: year,
          month: month,
          maxItems: 500,
        );

        if (items.isNotEmpty) {
          final results = CashbackMapper.toIngestaResults(items)
            ..sort((a, b) => b.reintegroUsdt.compareTo(a.reintegroUsdt));

          final monthDate = ingestion.stats.periodEnd ??
              items.first.period.toDateTime() ??
              DateTime.now();

          return IngestaRunResult(
            results: results,
            month: DateTime(monthDate.year, monthDate.month),
            ingestion: ingestion,
          );
        }

        if (!autoPoll) break;
      }

      throw IngestaCashbackPendingException(ingestion: ingestion);
    } catch (e) {
      if (e is IngestaCashbackPendingException) rethrow;
      throw Exception(_mapError(e));
    }
  }

  @override
  Future<String> exportResults({
    required List<IngestaResult> results,
    required ExportFormat format,
    required double tipoCambio,
  }) =>
      AdminExportService.export(results, format, tipoCambio);

  @override
  Future<String> exportBanexTransfer(List<IngestaResult> results) =>
      AdminExportService.exportBanexTransfer(results);

  String _mapError(Object error) {
    if (error is ApiException) return error.message;
    if (error is DioException) {
      if (kIsWeb && error.type == DioExceptionType.connectionError) {
        return 'No se pudo conectar con el backend (CORS/red). '
            'Recarga la página (F5) e intenta de nuevo.';
      }
      return error.message ?? error.toString();
    }
    return error.toString();
  }
}
