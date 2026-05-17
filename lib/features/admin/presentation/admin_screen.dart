import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'bloc/ingesta_bloc.dart';
import 'bloc/ingesta_event.dart';
import 'bloc/ingesta_state.dart';
import 'widgets/export_row.dart';
import 'widgets/level_config_panel.dart';
import 'widgets/processing_overlay.dart';
import 'widgets/results_table.dart';
import 'widgets/upload_zone.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const _stages = [
    (0.0, 'Leyendo archivo...'),
    (0.20, 'Procesando transacciones...'),
    (0.50, 'Calculando reintegros...'),
    (0.80, 'Generando reporte...'),
  ];

  // Local UI-only state: animation progress
  double _progress = 0.0;
  String _stageLabel = '';
  Timer? _animTimer;

  void _startAnimation() {
    _animTimer?.cancel();
    _progress = 0.0;
    _stageLabel = 'Leyendo archivo...';
    const totalTicks = 70;
    var tick = 0;

    _animTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      tick++;
      final progress = tick / totalTicks;
      String label = _stages.last.$2;
      for (final stage in _stages.reversed) {
        if (progress >= stage.$1) {
          label = stage.$2;
          break;
        }
      }
      setState(() {
        _progress = progress.clamp(0.0, 1.0);
        _stageLabel = label;
      });
      if (tick >= totalTicks) timer.cancel();
    });
  }

  void _stopAnimation() {
    _animTimer?.cancel();
    _animTimer = null;
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IngestaBloc, IngestaState>(
      listener: (context, state) {
        if (state is IngestaProcessing) {
          _startAnimation();
        } else {
          _stopAnimation();
        }

        if (state is IngestaFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade800,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Show export result snackbar when lastExportedFilename changes
        if (state is IngestaSuccess && state.lastExportedFilename != null) {
          final filename = state.lastExportedFilename!;
          final isError = filename.startsWith('ERROR:');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  isError ? filename : 'Exportado: $filename'),
              backgroundColor: isError
                  ? Colors.red.shade800
                  : AppColors.surfaceHighlight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isProcessing = state is IngestaProcessing;
        final isResults = state is IngestaSuccess;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => context.go('/'),
            ),
            title: Text('Vista Admin', style: AppTextStyles.heading2),
            actions: [
              if (isResults)
                IconButton(
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Nueva ingesta',
                  onPressed: () => context
                      .read<IngestaBloc>()
                      .add(const IngestaResetEvent()),
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingesta de Datos', style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text(
                    'Procesa reportes mensuales de transacciones QR y calcula reintegros',
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: 24),

                  LevelConfigPanel(
                    levels: state.levels,
                    tipoCambio: state.tipoCambio,
                  ),
                  const SizedBox(height: 24),

                  if (!isResults)
                    UploadZone(
                      onFilePicked: (file) => context
                          .read<IngestaBloc>()
                          .add(IngestaFilePickedEvent(file)),
                      isDisabled: isProcessing,
                    ),

                  if (isProcessing) ...[
                    const SizedBox(height: 16),
                    ProcessingOverlay(
                      progress: _progress,
                      stageLabel: _stageLabel,
                      fileName: state.fileName,
                    ),
                  ],

                  if (isResults) ...[
                    ResultsTable(
                      results: state.results,
                      period: state.month,
                    ),
                    const SizedBox(height: 20),
                    ExportRow(
                      results: state.results,
                      exportingFormat: state.exportingFormat,
                      exportingBanexTransfer: state.exportingBanexTransfer,
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
