import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/cashback_request.dart';

class ApprovalDashboardScreen extends StatefulWidget {
  const ApprovalDashboardScreen({super.key});

  @override
  State<ApprovalDashboardScreen> createState() => _ApprovalDashboardScreenState();
}

class _ApprovalDashboardScreenState extends State<ApprovalDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CashbackRequest> get _pendingReview => mockRequests
      .where((r) =>
          r.status == RequestStatus.preApproved ||
          r.status == RequestStatus.preDenied ||
          r.status == RequestStatus.pending)
      .toList();

  List<CashbackRequest> get _resolved => mockRequests
      .where((r) =>
          r.status == RequestStatus.approved ||
          r.status == RequestStatus.denied)
      .toList();

  @override
  Widget build(BuildContext context) {
    final preApproved = mockRequests.where((r) => r.status == RequestStatus.preApproved).length;
    final preDenied = mockRequests.where((r) => r.status == RequestStatus.preDenied).length;
    final pending = mockRequests.where((r) => r.status == RequestStatus.pending).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/'),
        ),
        title: Text('Aprobación CashBack', style: AppTextStyles.heading2),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildStatsRow(preApproved, preDenied, pending),
              ),
              _buildDlBanner(),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.accentTeal,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'Por revisar (${_pendingReview.length})'),
                  Tab(text: 'Resueltas (${_resolved.length})'),
                  const Tab(text: 'Todas'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRequestList(_pendingReview),
                    _buildRequestList(_resolved),
                    _buildRequestList(mockRequests),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(int preApproved, int preDenied, int pending) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            label: 'Pre-aprobados',
            value: '$preApproved',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatChip(
            label: 'Pre-rechazados',
            value: '$preDenied',
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatChip(
            label: 'Manuales',
            value: '$pending',
            color: const Color(0xFFFF8B53),
          ),
        ),
      ],
    );
  }

  Widget _buildDlBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accentTeal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology_rounded, size: 18, color: AppColors.accentTeal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Clasificación automática por Deep Learning · Modelo v2.4',
              style: AppTextStyles.label.copyWith(color: AppColors.accentTeal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<CashbackRequest> requests) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: requests.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _RequestCard(request: requests[index]),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final CashbackRequest request;

  const _RequestCard({required this.request});

  Color get _statusColor {
    switch (request.status) {
      case RequestStatus.preApproved:
        return AppColors.success;
      case RequestStatus.approved:
        return AppColors.success;
      case RequestStatus.preDenied:
        return AppColors.error;
      case RequestStatus.denied:
        return AppColors.error;
      case RequestStatus.pending:
        return const Color(0xFFFF8B53);
    }
  }

  IconData get _statusIcon {
    switch (request.status) {
      case RequestStatus.preApproved:
        return Icons.check_circle_outline_rounded;
      case RequestStatus.approved:
        return Icons.check_circle_rounded;
      case RequestStatus.preDenied:
        return Icons.cancel_outlined;
      case RequestStatus.denied:
        return Icons.cancel_rounded;
      case RequestStatus.pending:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isResolved =
        request.status == RequestStatus.approved || request.status == RequestStatus.denied;

    return GestureDetector(
      onTap: () => context.go('/approval/request/${request.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: request.hasfraudLink
                ? AppColors.error.withValues(alpha: 0.3)
                : AppColors.borderColor,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_statusIcon, color: _statusColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            request.userName,
                            style: AppTextStyles.bodyPrimary.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isResolved ? AppColors.textSecondary : AppColors.textPrimary,
                            ),
                          ),
                          if (request.hasfraudLink) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.warning_rounded, size: 12, color: AppColors.error),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${request.id} · Nivel ${request.nivel} · ${request.date}',
                        style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${request.montoSolicitado.toStringAsFixed(2)} USDT',
                      style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusLabel(request.status),
                        style: AppTextStyles.label.copyWith(color: _statusColor, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.psychology_rounded, size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Confianza: ${(request.dlConfidence * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
                const SizedBox(width: 12),
                Icon(Icons.speed_rounded, size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Riesgo: ${riskLabel(request.riskLevel)}',
                  style: AppTextStyles.label.copyWith(
                    color: request.riskLevel == RiskLevel.high
                        ? AppColors.error
                        : AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (request.hasfraudLink) ...[
                  const Spacer(),
                  Icon(Icons.link_rounded, size: 13, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    request.fraudAlertId!,
                    style: AppTextStyles.label.copyWith(color: AppColors.error, fontSize: 10),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
