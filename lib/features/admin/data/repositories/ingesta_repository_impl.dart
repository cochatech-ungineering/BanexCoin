import 'package:file_picker/file_picker.dart';

import '../models/cashback_level.dart';
import '../models/ingesta_result.dart';
import '../services/export_service.dart';
import '../services/ingesta_processor.dart';
import '../../domain/repositories/ingesta_repository.dart';

class IngestaRepositoryImpl implements IngestaRepository {
  const IngestaRepositoryImpl();

  @override
  Future<IngestaProcessorResult> processFile({
    required PlatformFile file,
    required List<CashbackLevel> levels,
    required double tipoCambio,
  }) =>
      Future(() => IngestaProcessor.process(
            file: file,
            levels: levels,
            tipoCambio: tipoCambio,
          ));

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
}
