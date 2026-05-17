import '../../data/models/ingesta_result.dart';
import '../../data/models/ingestion_upload_response.dart';

class IngestaRunResult {
  final List<IngestaResult> results;
  final DateTime month;
  final IngestionUploadResponse ingestion;

  const IngestaRunResult({
    required this.results,
    required this.month,
    required this.ingestion,
  });
}

class IngestaProgressUpdate {
  final String stageLabel;
  final double progress;
  final String? fileName;
  final IngestionUploadResponse? ingestion;
  final int pollAttempt;

  const IngestaProgressUpdate({
    required this.stageLabel,
    required this.progress,
    this.fileName,
    this.ingestion,
    this.pollAttempt = 0,
  });
}

class IngestaCashbackPendingException implements Exception {
  final IngestionUploadResponse ingestion;
  final String message;

  const IngestaCashbackPendingException({
    required this.ingestion,
    this.message =
        'Ingesta OK, pero aún no hay cashback en S3. '
        'Reintenta "Cargar resultados" en unos minutos.',
  });
}
