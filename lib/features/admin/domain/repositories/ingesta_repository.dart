import 'package:file_picker/file_picker.dart';

import '../../data/models/cashback_level.dart';
import '../../data/models/ingesta_result.dart';
import '../../data/services/export_service.dart';
import '../../data/services/ingesta_processor.dart';

abstract class IngestaRepository {
  Future<IngestaProcessorResult> processFile({
    required PlatformFile file,
    required List<CashbackLevel> levels,
    required double tipoCambio,
  });

  Future<String> exportResults({
    required List<IngestaResult> results,
    required ExportFormat format,
    required double tipoCambio,
  });

  Future<String> exportBanexTransfer(List<IngestaResult> results);
}
