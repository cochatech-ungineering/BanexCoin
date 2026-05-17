import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../reports/data/mappers/cashback_mapper.dart';
import '../../reports/data/services/reports_api_client.dart';
import '../data/models/cashback_level.dart';
import '../data/models/ingesta_result.dart';
import '../data/models/ingestion_upload_response.dart';
import '../data/services/ingesta_api_client.dart';
import 'widgets/export_row.dart';
import 'widgets/ingestion_status_card.dart';
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
  final _ingestaApi = IngestaApiClient();
  final _reportsApi = ReportsApiClient();

  _Phase _phase = _Phase.idle;
  IngestionFileKind _fileKind = IngestionFileKind.qrPayments;
  List<IngestaResult> _results = [];
  DateTime? _processedMonth;
  IngestionUploadResponse? _ingestion;
  double _progress = 0.0;
  String _stageLabel = '';
  String _fileName = '';
  String? _errorMessage;
  double _tipoCambio = 6.96;
  bool _loadingCashback = false;
  Timer? _pollTimer;
  int _pollAttempts = 0;

  final List<CashbackLevel> _levels = CashbackLevel.defaults();

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

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
          if (_phase == _Phase.results || _ingestion != null)
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
                'Sube el reporte a AWS; el cashback se consulta desde Reports API',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 8),
              _BackendInfoBanner(),
              const SizedBox(height: 16),
              _FileKindSelector(
                value: _fileKind,
                onChanged: _phase == _Phase.processing
                    ? null
                    : (v) => setState(() => _fileKind = v),
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
              if (_ingestion != null) ...[
                const SizedBox(height: 16),
                IngestionStatusCard(
                  ingestion: _ingestion!,
                  loadingCashback: _loadingCashback,
                  onRefreshCashback: _loadCashbackResults,
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
    _pollTimer?.cancel();
    setState(() {
      _phase = _Phase.processing;
      _fileName = file.name;
      _progress = 0.1;
      _stageLabel = 'Subiendo a data-ingestion...';
      _errorMessage = null;
      _results = [];
      _processedMonth = null;
      _ingestion = null;
      _pollAttempts = 0;
    });

    try {
      final ingestion = await _ingestaApi.uploadFile(
        file: file,
        kind: _fileKind,
      );

      if (!mounted) return;
      setState(() {
        _ingestion = ingestion;
        _progress = 0.5;
        _stageLabel = 'Esperando motor de cashback...';
        _processedMonth = ingestion.stats.periodEnd;
      });

      await _loadCashbackResults(autoPoll: true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _phase = _Phase.idle;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _dioMessage(e);
          _phase = _Phase.idle;
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

  String _dioMessage(DioException e) {
    if (kIsWeb && e.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar con data-ingestion (CORS/red). '
          'Recarga la página (F5) e intenta de nuevo.';
    }
    return e.message ?? e.toString();
  }

  Future<void> _loadCashbackResults({bool autoPoll = false}) async {
    setState(() {
      _loadingCashback = true;
      _stageLabel = 'Consultando reports API...';
    });

    try {
      final year = _ingestion?.stats.periodEnd?.year;
      final month = _ingestion?.stats.periodEnd?.month;

      final items = await _reportsApi.listAllCashback(
        year: year,
        month: month,
        maxItems: 500,
      );

      if (!mounted) return;

      if (items.isEmpty && autoPoll && _pollAttempts < 24) {
        _pollAttempts++;
        setState(() {
          _loadingCashback = true;
          _progress = 0.5 + (_pollAttempts / 24) * 0.4;
          _stageLabel =
              'Esperando cashback ($_pollAttempts/24)...';
        });
        _pollTimer?.cancel();
        _pollTimer = Timer(const Duration(seconds: 8), () {
          _loadCashbackResults(autoPoll: true);
        });
        return;
      }

      final results = CashbackMapper.toIngestaResults(items);
      results.sort((a, b) => b.reintegroUsdt.compareTo(a.reintegroUsdt));

      setState(() {
        _loadingCashback = false;
        _results = results;
        if (results.isNotEmpty) {
          _phase = _Phase.results;
          _progress = 1;
          _stageLabel = 'Completado';
          if (_processedMonth == null && items.isNotEmpty) {
            _processedMonth = items.first.period.toDateTime();
          }
        } else {
          _phase = _Phase.idle;
          _errorMessage =
              'Ingesta OK, pero aún no hay cashback en S3. '
              'Reintenta "Cargar resultados" en unos minutos.';
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingCashback = false;
          _errorMessage = 'Error al cargar cashback: $e';
        });
      }
    }
  }

  void _resetToIdle() {
    _pollTimer?.cancel();
    setState(() {
      _phase = _Phase.idle;
      _results = [];
      _processedMonth = null;
      _ingestion = null;
      _progress = 0;
      _stageLabel = '';
      _fileName = '';
      _errorMessage = null;
      _loadingCashback = false;
      _pollAttempts = 0;
    });
  }
}

class _BackendInfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Backend conectado', style: AppTextStyles.label),
          const SizedBox(height: 4),
          Text(
            'Ingesta: ${AppConfig.ingestionBaseUrl}',
            style: AppTextStyles.bodySecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Reports: ${AppConfig.reportsBaseUrl}',
            style: AppTextStyles.bodySecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FileKindSelector extends StatelessWidget {
  final IngestionFileKind value;
  final ValueChanged<IngestionFileKind>? onChanged;

  const _FileKindSelector({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<IngestionFileKind>(
      segments: const [
        ButtonSegment(
          value: IngestionFileKind.qrPayments,
          label: Text('Pagos QR'),
          icon: Icon(Icons.qr_code_2, size: 18),
        ),
        ButtonSegment(
          value: IngestionFileKind.transfers,
          label: Text('Transferencias'),
          icon: Icon(Icons.swap_horiz, size: 18),
        ),
      ],
      selected: {value},
      onSelectionChanged: onChanged == null
          ? null
          : (set) => onChanged!(set.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryOrange.withValues(alpha: 0.2);
          }
          return AppColors.surface;
        }),
      ),
    );
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
