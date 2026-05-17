import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cashback_level.dart';
import '../../data/services/ingesta_processor.dart' show IngestaProcessorResult;
import '../../domain/repositories/ingesta_repository.dart';
import 'ingesta_event.dart';
import 'ingesta_state.dart';

class IngestaBloc extends Bloc<IngestaEvent, IngestaState> {
  final IngestaRepository _repo;

  IngestaBloc(this._repo)
    : super(
        IngestaInitial(levels: CashbackLevel.defaults(), tipoCambio: 6.96),
      ) {
    on<IngestaFilePickedEvent>(_onFilePicked);
    on<IngestaResetEvent>(_onReset);
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

  Future<void> _onFilePicked(
    IngestaFilePickedEvent event,
    Emitter<IngestaState> emit,
  ) async {
    emit(
      IngestaProcessing(
        fileName: event.file.name,
        levels: state.levels,
        tipoCambio: state.tipoCambio,
      ),
    );

    // Run processing and a minimum display duration in parallel so the
    // progress animation always completes before results are shown.
    const animDuration = Duration(milliseconds: 3500); // matches 70 ticks × 50ms
    try {
      final results = await Future.wait([
        _repo.processFile(
          file: event.file,
          levels: state.levels,
          tipoCambio: state.tipoCambio,
        ),
        Future<void>.delayed(animDuration),
      ]);
      final result = results[0] as IngestaProcessorResult;
      emit(
        IngestaSuccess(
          results: result.results,
          month: result.month,
          levels: state.levels,
          tipoCambio: state.tipoCambio,
        ),
      );
    } catch (e) {
      emit(
        IngestaFailure(
          message: e.toString(),
          levels: state.levels,
          tipoCambio: state.tipoCambio,
        ),
      );
    }
  }

  void _onLevelChanged(
    IngestaLevelChangedEvent event,
    Emitter<IngestaState> emit,
  ) {
    final updated = List<CashbackLevel>.from(state.levels);
    updated[event.index] = event.level;
    emit(_withLevels(updated));
  }

  void _onReset(IngestaResetEvent event, Emitter<IngestaState> emit) {
    emit(IngestaInitial(levels: state.levels, tipoCambio: state.tipoCambio));
  }

  void _onTipoCambioChanged(
    IngestaTipoCambioChangedEvent event,
    Emitter<IngestaState> emit,
  ) {
    emit(_withTipoCambio(event.value));
  }

  IngestaState _withLevels(List<CashbackLevel> levels) {
    final s = state;
    return switch (s) {
      IngestaInitial() => IngestaInitial(
        levels: levels,
        tipoCambio: s.tipoCambio,
      ),
      IngestaProcessing() => IngestaProcessing(
        fileName: s.fileName,
        levels: levels,
        tipoCambio: s.tipoCambio,
      ),
      IngestaSuccess() => IngestaSuccess(
        results: s.results,
        month: s.month,
        levels: levels,
        tipoCambio: s.tipoCambio,
        exportingFormat: s.exportingFormat,
        exportingBanexTransfer: s.exportingBanexTransfer,
      ),
      IngestaFailure() => IngestaFailure(
        message: s.message,
        levels: levels,
        tipoCambio: s.tipoCambio,
      ),
    };
  }

  IngestaState _withTipoCambio(double tipoCambio) {
    final s = state;
    return switch (s) {
      IngestaInitial() => IngestaInitial(
        levels: s.levels,
        tipoCambio: tipoCambio,
      ),
      IngestaProcessing() => IngestaProcessing(
        fileName: s.fileName,
        levels: s.levels,
        tipoCambio: tipoCambio,
      ),
      IngestaSuccess() => IngestaSuccess(
        results: s.results,
        month: s.month,
        levels: s.levels,
        tipoCambio: tipoCambio,
        exportingFormat: s.exportingFormat,
        exportingBanexTransfer: s.exportingBanexTransfer,
      ),
      IngestaFailure() => IngestaFailure(
        message: s.message,
        levels: s.levels,
        tipoCambio: tipoCambio,
      ),
    };
  }
}
