import 'package:dio/dio.dart';

class DioClient {
  static const String _defaultBaseUrl = 'https://api-gateway.banexcoin.com';

  static Dio create({
    String baseUrl = _defaultBaseUrl,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 60),
  }) => Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: const {'Accept': 'application/json'},
    ),
  );
}
