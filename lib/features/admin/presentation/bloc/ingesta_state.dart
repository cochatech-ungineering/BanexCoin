import 'package:equatable/equatable.dart';

import '../../data/models/cashback_level.dart';
import '../../data/models/ingesta_result.dart';
import '../../data/services/export_service.dart';

final class IngestaFailure extends IngestaState {
  final String message;

  const IngestaFailure({
    required this.message,
    required super.levels,
    required super.tipoCambio,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class IngestaInitial extends IngestaState {
  const IngestaInitial({required super.levels, required super.tipoCambio});
}

final class IngestaProcessing extends IngestaState {
  final String fileName;

  const IngestaProcessing({
    required this.fileName,
    required super.levels,
    required super.tipoCambio,
  });

  @override
  List<Object?> get props => [...super.props, fileName];
}

sealed class IngestaState extends Equatable {
  final List<CashbackLevel> levels;
  final double tipoCambio;

  const IngestaState({required this.levels, required this.tipoCambio});

  @override
  List<Object?> get props => [levels, tipoCambio];
}

final class IngestaSuccess extends IngestaState {
  final List<IngestaResult> results;
  final DateTime month;
  final ExportFormat? exportingFormat;
  final bool exportingBanexTransfer;
  final String? lastExportedFilename;

  const IngestaSuccess({
    required this.results,
    required this.month,
    required super.levels,
    required super.tipoCambio,
    this.exportingFormat,
    this.exportingBanexTransfer = false,
    this.lastExportedFilename,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    results,
    month,
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
    exportingFormat: clearExportingFormat
        ? null
        : (exportingFormat ?? this.exportingFormat),
    exportingBanexTransfer:
        exportingBanexTransfer ?? this.exportingBanexTransfer,
    lastExportedFilename: lastExportedFilename ?? this.lastExportedFilename,
  );
}
