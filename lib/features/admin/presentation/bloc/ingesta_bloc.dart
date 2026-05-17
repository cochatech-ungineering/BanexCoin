import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cashback_level.dart';
import '../../data/services/ingesta_api_client.dart';
import '../../domain/models/ingesta_run_result.dart';
import '../../domain/repositories/ingesta_repository.dart';
import 'ingesta_event.dart';
import 'ingesta_state.dart';

class IngestaBloc extends Bloc<IngestaEvent, IngestaState> {
  final IngestaRepository _repo;

  IngestaBloc(this._repo)
    : super(
        IngestaInitial(
          levels: CashbackLevel.defaults(),
          tipoCambio: 6.96,
        ),
      ) {
    on<IngestaFilePickedEvent>(_onFilePicked);
    on<IngestaRefreshCashbackEvent>(_onRefreshCashback);
    on<IngestaResetEvent>(_onReset);
    on<IngestaFileKindChangedEvent>(_onFileKindChanged);
    on<IngestaLevelChangedEvent>(_onLevelChanged);
    on<IngestaTipoCambioChangedEvent>(_onTipoCambioChanged);
    on<IngestaExportRequestedEvent>(_onExportRequested);
    on<IngestaBanexTransferExportRequestedEvent>(_onBanexTransferExport);
  }

  Future<void> _onBanexTransferExport(
    IngestaBanexTransferExportRequestedEvent event,
    Emitter<IngestaState> emit,
  ) async {
    final current = state;
    if (current is! IngestaSuccess) return;

    emit(current.copyWith(exportingBanexTransfer: true));
    try {
      final filename = await _repo.exportBanexTransfer(current.results);
      if (!isClosed) {
        emit(
          (state as IngestaSuccess).copyWith(
            exportingBanexTransfer: false,
            lastExportedFilename: filename,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          (state as IngestaSuccess).copyWith(
            exportingBanexTransfer: false,
            lastExportedFilename: 'ERROR: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> _onExportRequested(
    IngestaExportRequestedEvent event,
    Emitter<IngestaState> emit,
  ) async {
    final current = state;
    if (current is! IngestaSuccess) return;

    emit(current.copyWith(exportingFormat: event.format));
    try {
      final filename = await _repo.exportResults(
        results: current.results,
        format: event.format,
        tipoCambio: current.tipoCambio,
      );
      if (!isClosed) {
        emit(
          (state as IngestaSuccess).copyWith(
            clearExportingFormat: true,
            lastExportedFilename: filename,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          (state as IngestaSuccess).copyWith(
            clearExportingFormat: true,
            lastExportedFilename: 'ERROR: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> _onFileKindChanged(
    IngestaFileKindChangedEvent event,
    Emitter<IngestaState> emit,
  ) {
    emit(_withFileKind(event.kind));
    return Future.value();
  }

  Future<void> _onFilePicked(
    IngestaFilePickedEvent event,
    Emitter<IngestaState> emit,
  ) async {
    final base = state;
    emit(
      IngestaProcessing(
        fileName: event.file.name,
        stageLabel: 'Subiendo a data-ingestion...',
        progress: 0.1,
        levels: base.levels,
        tipoCambio: base.tipoCambio,
        fileKind: base.fileKind,
      ),
    );

    try {
      final result = await _repo.runIngestion(
        file: event.file,
        kind: base.fileKind,
        onProgress: (update) => _emitProgress(emit, base, update),
      );
      if (!isClosed) {
        emit(
          IngestaSuccess(
            results: result.results,
            month: result.month,
            ingestion: result.ingestion,
            levels: base.levels,
            tipoCambio: base.tipoCambio,
            fileKind: base.fileKind,
          ),
        );
      }
    } on IngestaCashbackPendingException catch (e) {
      if (!isClosed) {
        emit(
          IngestaAwaitingCashback(
            fileName: event.file.name,
            ingestion: e.ingestion,
            stageLabel: 'Esperando resultados en S3',
            progress: 0.5,
            levels: base.levels,
            tipoCambio: base.tipoCambio,
            fileKind: base.fileKind,
            statusMessage: e.message,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          IngestaFailure(
            message: e.toString(),
            levels: base.levels,
            tipoCambio: base.tipoCambio,
            fileKind: base.fileKind,
          ),
        );
      }
    }
  }

  Future<void> _onLevelChanged(
    IngestaLevelChangedEvent event,
    Emitter<IngestaState> emit,
  ) {
    final updated = List<CashbackLevel>.from(state.levels);
    updated[event.index] = event.level;
    emit(_withLevels(updated));
    return Future.value();
  }

  Future<void> _onRefreshCashback(
    IngestaRefreshCashbackEvent event,
    Emitter<IngestaState> emit,
  ) async {
    final current = state;
    if (current is! IngestaAwaitingCashback) return;

    emit(current.copyWith(loadingCashback: true, clearStatusMessage: true));

    try {
      final result = await _repo.fetchCashback(
        ingestion: current.ingestion,
        autoPoll: true,
        fileName: current.fileName,
        onProgress: (update) {
          if (isClosed) return;
          emit(
            current.copyWith(
              stageLabel: update.stageLabel,
              progress: update.progress,
              pollAttempt: update.pollAttempt,
              loadingCashback: true,
            ),
          );
        },
      );
      if (!isClosed) {
        emit(
          IngestaSuccess(
            results: result.results,
            month: result.month,
            ingestion: result.ingestion,
            levels: current.levels,
            tipoCambio: current.tipoCambio,
            fileKind: current.fileKind,
          ),
        );
      }
    } on IngestaCashbackPendingException catch (e) {
      if (!isClosed) {
        emit(
          current.copyWith(
            loadingCashback: false,
            statusMessage: e.message,
            stageLabel: 'Sin resultados aún',
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          IngestaFailure(
            message: e.toString(),
            levels: current.levels,
            tipoCambio: current.tipoCambio,
            fileKind: current.fileKind,
          ),
        );
      }
    }
  }

  void _onReset(IngestaResetEvent event, Emitter<IngestaState> emit) {
    emit(
      IngestaInitial(
        levels: state.levels,
        tipoCambio: state.tipoCambio,
        fileKind: state.fileKind,
      ),
    );
  }

  void _onTipoCambioChanged(
    IngestaTipoCambioChangedEvent event,
    Emitter<IngestaState> emit,
  ) {
    emit(_withTipoCambio(event.value));
  }

  void _emitProgress(
    Emitter<IngestaState> emit,
    IngestaState base,
    IngestaProgressUpdate update,
  ) {
    if (isClosed) return;

    if (update.ingestion != null) {
      emit(
        IngestaAwaitingCashback(
          fileName: update.fileName ?? '',
          ingestion: update.ingestion!,
          stageLabel: update.stageLabel,
          progress: update.progress,
          pollAttempt: update.pollAttempt,
          loadingCashback: true,
          levels: base.levels,
          tipoCambio: base.tipoCambio,
          fileKind: base.fileKind,
        ),
      );
    } else {
      emit(
        IngestaProcessing(
          fileName: update.fileName ?? '',
          stageLabel: update.stageLabel,
          progress: update.progress,
          levels: base.levels,
          tipoCambio: base.tipoCambio,
          fileKind: base.fileKind,
        ),
      );
    }
  }

  IngestaState _withFileKind(IngestionFileKind fileKind) {
    final s = state;
    return switch (s) {
      IngestaInitial() => IngestaInitial(
        levels: s.levels,
        tipoCambio: s.tipoCambio,
        fileKind: fileKind,
      ),
      IngestaProcessing() => IngestaProcessing(
        fileName: s.fileName,
        stageLabel: s.stageLabel,
        progress: s.progress,
        levels: s.levels,
        tipoCambio: s.tipoCambio,
        fileKind: fileKind,
      ),
      IngestaAwaitingCashback() => IngestaAwaitingCashback(
        fileName: s.fileName,
        ingestion: s.ingestion,
        stageLabel: s.stageLabel,
        progress: s.progress,
        levels: s.levels,
        tipoCambio: s.tipoCambio,
        fileKind: fileKind,
        pollAttempt: s.pollAttempt,
        loadingCashback: s.loadingCashback,
        statusMessage: s.statusMessage,
      ),
      IngestaSuccess() => IngestaSuccess(
        results: s.results,
        month: s.month,
        levels: s.levels,
        tipoCambio: s.tipoCambio,
        fileKind: fileKind,
        ingestion: s.ingestion,
        exportingFormat: s.exportingFormat,
        exportingBanexTransfer: s.exportingBanexTransfer,
      ),
      IngestaFailure() => IngestaFailure(
        message: s.message,
        levels: s.levels,
        tipoCambio: s.tipoCambio,
        fileKind: fileKind,
      ),
    };
  }

  IngestaState _withLevels(List<CashbackLevel> levels) {
    final s = state;
    return switch (s) {
      IngestaInitial() => IngestaInitial(
        levels: levels,
        tipoCambio: s.tipoCambio,
        fileKind: s.fileKind,
      ),
      IngestaProcessing() => IngestaProcessing(
        fileName: s.fileName,
        stageLabel: s.stageLabel,
        progress: s.progress,
        levels: levels,
        tipoCambio: s.tipoCambio,
        fileKind: s.fileKind,
      ),
      IngestaAwaitingCashback() => IngestaAwaitingCashback(
        fileName: s.fileName,
        ingestion: s.ingestion,
        stageLabel: s.stageLabel,
        progress: s.progress,
        levels: levels,
        tipoCambio: s.tipoCambio,
        fileKind: s.fileKind,
        pollAttempt: s.pollAttempt,
        loadingCashback: s.loadingCashback,
        statusMessage: s.statusMessage,
      ),
      IngestaSuccess() => IngestaSuccess(
        results: s.results,
        month: s.month,
        levels: levels,
        tipoCambio: s.tipoCambio,
        fileKind: s.fileKind,
        ingestion: s.ingestion,
        exportingFormat: s.exportingFormat,
        exportingBanexTransfer: s.exportingBanexTransfer,
      ),
      IngestaFailure() => IngestaFailure(
        message: s.message,
        levels: levels,
        tipoCambio: s.tipoCambio,
        fileKind: s.fileKind,
      ),
    };
  }

  IngestaState _withTipoCambio(double tipoCambio) {
    final s = state;
    return switch (s) {
      IngestaInitial() => IngestaInitial(
        levels: s.levels,
        tipoCambio: tipoCambio,
        fileKind: s.fileKind,
      ),
      IngestaProcessing() => IngestaProcessing(
        fileName: s.fileName,
        stageLabel: s.stageLabel,
        progress: s.progress,
        levels: s.levels,
        tipoCambio: tipoCambio,
        fileKind: s.fileKind,
      ),
      IngestaAwaitingCashback() => IngestaAwaitingCashback(
        fileName: s.fileName,
        ingestion: s.ingestion,
        stageLabel: s.stageLabel,
        progress: s.progress,
        levels: s.levels,
        tipoCambio: tipoCambio,
        fileKind: s.fileKind,
        pollAttempt: s.pollAttempt,
        loadingCashback: s.loadingCashback,
        statusMessage: s.statusMessage,
      ),
      IngestaSuccess() => IngestaSuccess(
        results: s.results,
        month: s.month,
        levels: s.levels,
        tipoCambio: tipoCambio,
        fileKind: s.fileKind,
        ingestion: s.ingestion,
        exportingFormat: s.exportingFormat,
        exportingBanexTransfer: s.exportingBanexTransfer,
      ),
      IngestaFailure() => IngestaFailure(
        message: s.message,
        levels: s.levels,
        tipoCambio: tipoCambio,
        fileKind: s.fileKind,
      ),
    };
  }
}
