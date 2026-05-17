import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/ingesta_bloc.dart';
import '../bloc/ingesta_event.dart';
import '../bloc/ingesta_state.dart';
import '../molecules/backend_info_banner.dart';
import '../molecules/export_row.dart';
import '../molecules/file_kind_selector.dart';
import '../molecules/processing_overlay.dart';
import '../organisms/ingestion_status_card.dart';
import '../organisms/level_config_panel.dart';
import '../organisms/results_table.dart';
import '../organisms/upload_zone.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminView();
  }
}

class _AdminView extends StatelessWidget {
  const _AdminView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IngestaBloc, IngestaState>(
      listenWhen: (prev, curr) {
        if (curr is IngestaFailure) {
          return prev is! IngestaFailure || prev.message != curr.message;
        }
        if (curr is IngestaSuccess && curr.lastExportedFilename != null) {
          return prev is! IngestaSuccess ||
              prev.lastExportedFilename != curr.lastExportedFilename;
        }
        if (curr is IngestaAwaitingCashback && curr.statusMessage != null) {
          return prev is! IngestaAwaitingCashback ||
              prev.statusMessage != curr.statusMessage;
        }
        return false;
      },
      listener: _onStateChange,
      builder: (context, state) {
        final isBusy = state is IngestaProcessing ||
            (state is IngestaAwaitingCashback && state.loadingCashback);
        final isResults = state is IngestaSuccess;
        final isAwaiting = state is IngestaAwaitingCashback;
        final showUpload = !isResults;

        final overlayProgress = switch (state) {
          IngestaProcessing(:final progress) => progress,
          IngestaAwaitingCashback(:final progress) => progress,
          _ => 0.0,
        };
        final overlayLabel = switch (state) {
          IngestaProcessing(:final stageLabel) => stageLabel,
          IngestaAwaitingCashback(:final stageLabel) => stageLabel,
          _ => '',
        };
        final overlayFileName = switch (state) {
          IngestaProcessing(:final fileName) => fileName,
          IngestaAwaitingCashback(:final fileName) => fileName,
          _ => '',
        };

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => context.go('/'),
            ),
            title: Text('Ingesta de Datos', style: AppTextStyles.heading2),
            actions: [
              if (isResults || isAwaiting)
                IconButton(
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Nueva ingesta',
                  onPressed: () => context.read<IngestaBloc>().add(
                    const IngestaResetEvent(),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showUpload) ...[
                        Text(
                          'Sube el reporte a AWS; el cashback se consulta desde Reports API',
                          style: AppTextStyles.bodySecondary,
                        ),
                        const SizedBox(height: 8),
                        const BackendInfoBanner(),
                        const SizedBox(height: 16),
                        FileKindSelector(
                          value: state.fileKind,
                          onChanged: isBusy
                              ? null
                              : (kind) => context.read<IngestaBloc>().add(
                                  IngestaFileKindChangedEvent(kind),
                                ),
                        ),
                        const SizedBox(height: 20),
                        LevelConfigPanel(
                          levels: state.levels,
                          tipoCambio: state.tipoCambio,
                        ),
                        const SizedBox(height: 20),
                        UploadZone(
                          onFilePicked: (file) => context
                              .read<IngestaBloc>()
                              .add(IngestaFilePickedEvent(file)),
                          isDisabled: isBusy,
                        ),
                      ],
                      if (isBusy) ...[
                        const SizedBox(height: 16),
                        ProcessingOverlay(
                          progress: overlayProgress,
                          stageLabel: overlayLabel,
                          fileName: overlayFileName,
                        ),
                      ],
                      if (isAwaiting) ...[
                        const SizedBox(height: 16),
                        IngestionStatusCard(
                          ingestion: state.ingestion,
                          loadingCashback: state.loadingCashback,
                          onRefreshCashback: state.loadingCashback
                              ? null
                              : () => context.read<IngestaBloc>().add(
                                  const IngestaRefreshCashbackEvent(),
                                ),
                        ),
                      ],
                      if (isResults) ...[
                        _SuccessBanner(count: state.results.length),
                        const SizedBox(height: 20),
                        ExportRow(
                          results: state.results,
                          exportingFormat: state.exportingFormat,
                          exportingBanexTransfer: state.exportingBanexTransfer,
                        ),
                        const SizedBox(height: 20),
                        ResultsTable(
                          results: state.results,
                          period: state.month,
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStateChange(BuildContext context, IngestaState state) {
    if (state is IngestaFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    if (state is IngestaAwaitingCashback && state.statusMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.statusMessage!),
          backgroundColor: AppColors.surfaceHighlight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    if (state is IngestaSuccess && state.lastExportedFilename != null) {
      final filename = state.lastExportedFilename!;
      final isError = filename.startsWith('ERROR:');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isError ? filename : 'Guardado: $filename',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: isError ? AppColors.error : AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class _SuccessBanner extends StatelessWidget {
  final int count;

  const _SuccessBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$count registros procesados',
              style: AppTextStyles.bodyPrimary.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
