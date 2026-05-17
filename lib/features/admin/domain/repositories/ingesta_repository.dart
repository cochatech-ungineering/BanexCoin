import 'package:file_picker/file_picker.dart';

import '../../data/models/ingesta_result.dart';
import '../../data/models/ingestion_upload_response.dart';
import '../../data/services/export_service.dart';
import '../../data/services/ingesta_api_client.dart';
import '../models/ingesta_run_result.dart';

typedef IngestaProgressCallback = void Function(IngestaProgressUpdate update);

abstract class IngestaRepository {
  Future<IngestaRunResult> runIngestion({
    required PlatformFile file,
    required IngestionFileKind kind,
    IngestaProgressCallback? onProgress,
  });

  Future<IngestaRunResult> fetchCashback({
    required IngestionUploadResponse ingestion,
    IngestaProgressCallback? onProgress,
    bool autoPoll = false,
    String? fileName,
  });

  Future<String> exportResults({
    required List<IngestaResult> results,
    required ExportFormat format,
    required double tipoCambio,
  });

  Future<String> exportBanexTransfer(List<IngestaResult> results);
}
