import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/models/cashback_level.dart';
import '../data/models/ingesta_result.dart';
import '../data/services/ingesta_processor.dart';
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

  _Phase _phase = _Phase.idle;
  List<IngestaResult> _results = [];
  DateTime? _processedMonth;
  double _progress = 0.0;
  String _stageLabel = '';
  String _fileName = '';
  String? _errorMessage;
  double _tipoCambio = 6.96;

  final List<CashbackLevel> _levels = CashbackLevel.defaults();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Vista Admin', style: AppTextStyles.heading2),
        actions: [
          if (_phase == _Phase.results)
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: 'Nueva ingesta',
              onPressed: _resetToIdle,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                levels: _levels,
                tipoCambio: _tipoCambio,
                onTipoCambioChanged: (v) => setState(() => _tipoCambio = v),
                onLevelChanged: (i, updated) =>
                    setState(() => _levels[i] = updated),
              ),
              const SizedBox(height: 24),

              if (_phase != _Phase.results)
                UploadZone(
                  onFilePicked: _handleFilePicked,
                  isDisabled: _phase == _Phase.processing,
                ),

              if (_phase == _Phase.processing) ...[
                const SizedBox(height: 16),
                ProcessingOverlay(
                  progress: _progress,
                  stageLabel: _stageLabel,
                  fileName: _fileName,
                ),
              ],

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                _ErrorBanner(
                  message: _errorMessage!,
                  onDismiss: () => setState(() => _errorMessage = null),
                ),
              ],

              if (_phase == _Phase.results) ...[
                ResultsTable(results: _results, period: _processedMonth),
                const SizedBox(height: 20),
                ExportRow(results: _results, tipoCambio: _tipoCambio),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFilePicked(PlatformFile file) async {
    setState(() {
      _phase = _Phase.processing;
      _fileName = file.name;
      _progress = 0.0;
      _stageLabel = 'Leyendo archivo...';
      _errorMessage = null;
      _results = [];
      _processedMonth = null;
    });

    try {
      final animFuture = _runProcessingAnimation();
      final processFuture = Future(
        () => IngestaProcessor.process(
          file: file,
          levels: _levels,
          tipoCambio: _tipoCambio,
        ),
      );

      final processed = await Future.wait([animFuture, processFuture]);
      final ingestaResult = processed[1] as IngestaProcessorResult;

      if (mounted) {
        setState(() {
          _results = ingestaResult.results;
          _processedMonth = ingestaResult.month;
          _phase = _Phase.results;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _phase = _Phase.idle;
        });
      }
    }
  }

  void _resetToIdle() {
    setState(() {
      _phase = _Phase.idle;
      _results = [];
      _processedMonth = null;
      _progress = 0.0;
      _stageLabel = '';
      _fileName = '';
      _errorMessage = null;
    });
  }

  Future<void> _runProcessingAnimation() {
    final completer = Completer<void>();
    const totalTicks = 70;
    var tick = 0;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      tick++;
      final progress = tick / totalTicks;
      String label = _stages.last.$2;
      for (final stage in _stages.reversed) {
        if (progress >= stage.$1) {
          label = stage.$2;
          break;
        }
      }
      if (mounted) {
        setState(() {
          _progress = progress.clamp(0.0, 1.0);
          _stageLabel = label;
        });
      }
      if (tick >= totalTicks) {
        timer.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade700.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySecondary.copyWith(
                color: Colors.red.shade300,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: Colors.red.shade400),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

enum _Phase { idle, processing, results }
