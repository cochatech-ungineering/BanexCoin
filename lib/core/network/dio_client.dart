import 'package:banexcoin/core/config/app_config.dart';
import 'package:dio/dio.dart';

class DioClient {
  static Dio ingestion() => _create(
        AppConfig.ingestionBaseUrl,
        receiveTimeout: AppConfig.uploadReceiveTimeout,
      );

  static Dio reports() => _create(AppConfig.reportsBaseUrl);

  static Dio _create(
    String baseUrl, {
    Duration receiveTimeout = AppConfig.receiveTimeout,
  }) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: const {'Accept': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}
