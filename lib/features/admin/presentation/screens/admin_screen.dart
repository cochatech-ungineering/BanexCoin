import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/ingesta_bloc.dart';
import '../bloc/ingesta_event.dart';
import '../bloc/ingesta_state.dart';
import '../molecules/export_row.dart';
import '../molecules/processing_overlay.dart';
import '../organisms/level_config_panel.dart';
import '../organisms/results_table.dart';
import '../organisms/upload_zone.dart';

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

  double _progress = 0.0;
  String _stageLabel = '';
  Timer? _animTimer;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IngestaBloc, IngestaState>(
      listener: _onStateChange,
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
            title: Text('Ingesta de Datos', style: AppTextStyles.heading2),
            actions: [
              if (isResults)
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isResults) ...[
                        Text(
                          'Procesa reportes mensuales y calcula reintegros por nivel.',
                          style: AppTextStyles.bodySecondary,
                        ),
                        const SizedBox(height: 20),
                        LevelConfigPanel(
                          levels: state.levels,
                          tipoCambio: state.tipoCambio,
                        ),
                        const SizedBox(height: 20),
                        UploadZone(
                          onFilePicked: (file) => context.read<IngestaBloc>().add(
                            IngestaFilePickedEvent(file),
                          ),
                          isDisabled: isProcessing,
                        ),
                      ],

                      if (isProcessing) ...[
                        const SizedBox(height: 16),
                        ProcessingOverlay(
                          progress: _progress,
                          stageLabel: _stageLabel,
                          fileName: state.fileName,
                        ),
                      ],

                      if (isResults) ...[
                        _buildSuccessBanner(state),
                        const SizedBox(height: 20),
                        ExportRow(
                          results: state.results,
                          exportingFormat: state.exportingFormat,
                        ),
                        const SizedBox(height: 20),
                        ResultsTable(results: state.results, period: state.month),
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

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  void _onStateChange(BuildContext context, IngestaState state) {
    if (state is IngestaProcessing) {
      _startAnimation();
    } else {
      _stopAnimation();
    }

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

  Widget _buildSuccessBanner(IngestaSuccess state) {
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
              '${state.results.length} registros procesados',
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
}
