import 'package:equatable/equatable.dart';

import '../../data/models/cashback_level.dart';
import '../../data/models/ingesta_result.dart';
import '../../data/models/ingestion_upload_response.dart';
import '../../data/services/export_service.dart';
import '../../data/services/ingesta_api_client.dart';

final class IngestaAwaitingCashback extends IngestaState {
  final String fileName;
  final IngestionUploadResponse ingestion;
  final String stageLabel;
  final double progress;
  final int pollAttempt;
  final bool loadingCashback;
  final String? statusMessage;

  const IngestaAwaitingCashback({
    required this.fileName,
    required this.ingestion,
    required this.stageLabel,
    required this.progress,
    required super.levels,
    required super.tipoCambio,
    required super.fileKind,
    this.pollAttempt = 0,
    this.loadingCashback = false,
    this.statusMessage,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    fileName,
    ingestion,
    stageLabel,
    progress,
    pollAttempt,
    loadingCashback,
    statusMessage,
  ];

  IngestaAwaitingCashback copyWith({
    String? stageLabel,
    double? progress,
    int? pollAttempt,
    bool? loadingCashback,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) => IngestaAwaitingCashback(
    fileName: fileName,
    ingestion: ingestion,
    stageLabel: stageLabel ?? this.stageLabel,
    progress: progress ?? this.progress,
    levels: levels,
    tipoCambio: tipoCambio,
    fileKind: fileKind,
    pollAttempt: pollAttempt ?? this.pollAttempt,
    loadingCashback: loadingCashback ?? this.loadingCashback,
    statusMessage:
        clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
  );
}

final class IngestaFailure extends IngestaState {
  final String message;

  const IngestaFailure({
    required this.message,
    required super.levels,
    required super.tipoCambio,
    required super.fileKind,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class IngestaInitial extends IngestaState {
  const IngestaInitial({
    required super.levels,
    required super.tipoCambio,
    super.fileKind = IngestionFileKind.qrPayments,
  });
}

final class IngestaProcessing extends IngestaState {
  final String fileName;
  final String stageLabel;
  final double progress;

  const IngestaProcessing({
    required this.fileName,
    required this.stageLabel,
    required this.progress,
    required super.levels,
    required super.tipoCambio,
    required super.fileKind,
  });

  @override
  List<Object?> get props => [...super.props, fileName, stageLabel, progress];
}

sealed class IngestaState extends Equatable {
  final List<CashbackLevel> levels;
  final double tipoCambio;
  final IngestionFileKind fileKind;

  const IngestaState({
    required this.levels,
    required this.tipoCambio,
    required this.fileKind,
  });

  @override
  List<Object?> get props => [levels, tipoCambio, fileKind];
}

final class IngestaSuccess extends IngestaState {
  final List<IngestaResult> results;
  final DateTime month;
  final IngestionUploadResponse? ingestion;
  final ExportFormat? exportingFormat;
  final bool exportingBanexTransfer;
  final String? lastExportedFilename;

  const IngestaSuccess({
    required this.results,
    required this.month,
    required super.levels,
    required super.tipoCambio,
    required super.fileKind,
    this.ingestion,
    this.exportingFormat,
    this.exportingBanexTransfer = false,
    this.lastExportedFilename,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    results,
    month,
    ingestion,
    exportingFormat,
    exportingBanexTransfer,
    lastExportedFilename,
  ];

  IngestaSuccess copyWith({
    ExportFormat? exportingFormat,
    bool clearExportingFormat = false,
    bool? exportingBanexTransfer,
    String? lastExportedFilename,
  }) => IngestaSuccess(
    results: results,
    month: month,
    levels: levels,
    tipoCambio: tipoCambio,
    fileKind: fileKind,
    ingestion: ingestion,
    exportingFormat: clearExportingFormat
        ? null
        : (exportingFormat ?? this.exportingFormat),
    exportingBanexTransfer:
        exportingBanexTransfer ?? this.exportingBanexTransfer,
    lastExportedFilename: lastExportedFilename ?? this.lastExportedFilename,
  );
}
