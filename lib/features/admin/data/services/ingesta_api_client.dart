import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/network/dio_client.dart';
import '../models/ingestion_upload_response.dart';

enum IngestionFileKind { qrPayments, transfers }

class IngestaApiClient {
  final Dio _dio = DioClient.ingestion();

  Future<IngestionUploadResponse> uploadFile({
    required PlatformFile file,
    required IngestionFileKind kind,
    bool publish = true,
    bool strictStatus = true,
  }) async {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw const ApiException('No se pudieron leer los bytes del archivo.');
    }

    final path = switch (kind) {
      IngestionFileKind.qrPayments => '/api/v1/ingest/qr-payments',
      IngestionFileKind.transfers => '/api/v1/ingest/transfers',
    };

    final query = <String, dynamic>{
      'publish': publish,
      if (kind == IngestionFileKind.qrPayments) 'strict_status': strictStatus,
    };

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: file.name),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: formData,
      queryParameters: query,
    );

    return _parseResponse(response);
  }

  Future<List<String>> supportedFormats() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/ingest/formats');
    final data = response.data;
    if (data == null) return ['csv', 'xlsx', 'xls', 'json', 'txt'];
    return (data['extensions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }

  IngestionUploadResponse _parseResponse(Response<Map<String, dynamic>> response) {
    final status = response.statusCode ?? 0;
    final data = response.data;

    if (status >= 200 && status < 300 && data != null) {
      return IngestionUploadResponse.fromJson(data);
    }

    if (data != null && data['detail'] != null) {
      final detail = data['detail'];
      if (detail is Map<String, dynamic>) {
        if (detail['message'] != null) {
          throw ApiException(detail['message'].toString(), statusCode: status);
        }
        if (detail['existing_job'] != null) {
          throw ApiException(
            detail['message']?.toString() ?? 'Archivo duplicado',
            statusCode: status,
          );
        }
      }
      if (detail is String) {
        throw ApiException(detail, statusCode: status);
      }
    }

    throw ApiException(
      'Error de ingesta (HTTP $status)',
      statusCode: status,
    );
  }
}
