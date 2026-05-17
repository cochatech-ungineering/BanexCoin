import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../data/models/cashback_level.dart';
import '../../data/services/export_service.dart';
import '../../data/services/ingesta_api_client.dart';

final class IngestaBanexTransferExportRequestedEvent extends IngestaEvent {
  const IngestaBanexTransferExportRequestedEvent();
}

sealed class IngestaEvent extends Equatable {
  const IngestaEvent();

  @override
  List<Object?> get props => [];
}

final class IngestaExportRequestedEvent extends IngestaEvent {
  final ExportFormat format;
  const IngestaExportRequestedEvent(this.format);

  @override
  List<Object?> get props => [format];
}

final class IngestaFileKindChangedEvent extends IngestaEvent {
  final IngestionFileKind kind;
  const IngestaFileKindChangedEvent(this.kind);

  @override
  List<Object?> get props => [kind];
}

final class IngestaFilePickedEvent extends IngestaEvent {
  final PlatformFile file;
  const IngestaFilePickedEvent(this.file);

  @override
  List<Object?> get props => [file.name];
}

final class IngestaLevelChangedEvent extends IngestaEvent {
  final int index;
  final CashbackLevel level;
  const IngestaLevelChangedEvent(this.index, this.level);

  @override
  List<Object?> get props => [index];
}

final class IngestaRefreshCashbackEvent extends IngestaEvent {
  const IngestaRefreshCashbackEvent();
}

final class IngestaResetEvent extends IngestaEvent {
  const IngestaResetEvent();
}

final class IngestaTipoCambioChangedEvent extends IngestaEvent {
  final double value;
  const IngestaTipoCambioChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}
