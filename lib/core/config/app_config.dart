/// URLs de los servicios desplegados en AWS (CloudFront).
/// Sobrescribir con --dart-define en build si cambian.
class AppConfig {
  AppConfig._();

  static const String ingestionBaseUrl = String.fromEnvironment(
    'INGESTION_API_URL',
    defaultValue: 'https://d1nx874xbtjx9q.cloudfront.net',
  );

  static const String reportsBaseUrl = String.fromEnvironment(
    'REPORTS_API_URL',
    defaultValue: 'https://d2nozg4tzo8ah6.cloudfront.net',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration uploadReceiveTimeout = Duration(seconds: 300);
}
