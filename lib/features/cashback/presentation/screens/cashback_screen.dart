import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/cashback_entry.dart';
import '../../data/services/cashback_service.dart';

class CashbackScreen extends StatefulWidget {
  const CashbackScreen({super.key});

  @override
  State<CashbackScreen> createState() => _CashbackScreenState();
}

class _CashbackScreenState extends State<CashbackScreen> {
  final _service = CashbackService();

  late Future<CashbackData> _summaryFuture;
  List<CashbackEntry> _historial = [];
  bool _loadingMore = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _service.getSummary();
    _loadHistorial();
  }

  Future<void> _loadHistorial() async {
    final entries = await _service.getHistorial(page: _page);
    setState(() => _historial = entries);
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    _page++;
    final more = await _service.getHistorial(page: _page);
    setState(() {
      _historial = [..._historial, ...more];
      _loadingMore = false;
    });
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
          onPressed: () => context.go('/'),
        ),
        title: Text('CashBack', style: AppTextStyles.heading2),
      ),
      body: FutureBuilder<CashbackData>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.textPrimary),
            );
          }

          final data = snapshot.data!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTotalCard(data.totalGanado),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildMesSection(data.gananciasMes)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildNivelCard(data),
                    const SizedBox(height: 24),
                    _buildHistorialSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalCard(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentTeal.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentTeal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: AppColors.accentTeal,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${total.toStringAsFixed(4)} USDT',
            style: AppTextStyles.heading1.copyWith(fontSize: 32, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          Text('Total ganado', style: AppTextStyles.bodySecondary),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ganas dinero cada vez que usas Banexcoin',
              style: AppTextStyles.label.copyWith(
                color: AppColors.accentTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNivelCard(CashbackData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.4)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.star_rounded,
                    color: AppColors.accentTeal,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nivel ${data.nivelActual}', style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    Text(
                      '${data.porcentajeActual.toStringAsFixed(0)}% de reintegro este mes',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${data.porcentajeActual.toStringAsFixed(0)}%',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.accentTeal,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          if (data.montoParaSiguienteNivel > 0) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Te faltan ${data.montoParaSiguienteNivel.toStringAsFixed(2)} USDT para subir al siguiente nivel',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMesSection(double gananciasMes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: AppColors.success,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Este mes', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  '+${gananciasMes.toStringAsFixed(4)} USDT',
                  style: AppTextStyles.heading3.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial reciente', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _historial.length; i++) ...[
                _buildHistorialItem(_historial[i]),
                if (i < _historial.length - 1)
                  const Divider(
                    height: 1,
                    color: AppColors.borderColor,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
              if (_historial.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Sin reintegros aún',
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _loadingMore ? null : _loadMore,
            child: _loadingMore
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textSecondary,
                    ),
                  )
                : Text(
                    'Ver más',
                    style: AppTextStyles.bodyPrimary.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorialItem(CashbackEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_downward_rounded,
              color: AppColors.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+${entry.montoUsdt.toStringAsFixed(4)} USDT',
                  style: AppTextStyles.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.date,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Nivel ${entry.nivel}',
                style: AppTextStyles.label,
              ),
              const SizedBox(height: 2),
              Text(
                '${(entry.porcentaje * 100).toStringAsFixed(0)}% reintegro',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.accentTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
