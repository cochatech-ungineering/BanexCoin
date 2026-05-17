import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/cashback_level.dart';
import '../atoms/nivel_badge.dart';
import '../bloc/ingesta_bloc.dart';
import '../bloc/ingesta_event.dart';

class LevelConfigPanel extends StatefulWidget {
  final List<CashbackLevel> levels;
  final double tipoCambio;

  const LevelConfigPanel({
    super.key,
    required this.levels,
    required this.tipoCambio,
  });

  @override
  State<LevelConfigPanel> createState() => _LevelConfigPanelState();
}

class _ConfigField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final String? suffix;
  final bool isLastRow;

  const _ConfigField({
    required this.controller,
    required this.onChanged,
    this.suffix,
    this.isLastRow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLastRow) {
      return Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceHighlight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        alignment: Alignment.centerLeft,
        child: Text('∞', style: AppTextStyles.bodyPrimary),
      );
    }
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyles.bodyPrimary,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceHighlight,
        suffixText: suffix,
        suffixStyle: AppTextStyles.label.copyWith(
          color: AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryOrange),
        ),
      ),
    );
  }
}

class _LevelConfigPanelState extends State<LevelConfigPanel> {
  bool _expanded = false;
  late final TextEditingController _tcController;
  late final List<TextEditingController> _minCtrl;
  late final List<TextEditingController> _maxCtrl;
  late final List<TextEditingController> _pctCtrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.tune_outlined,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Configuración de niveles',
                    style: AppTextStyles.heading3,
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(
              height: 1,
              color: AppColors.borderColor,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header row
                  Row(
                    children: [
                      _headerCell('Nivel', flex: 2),
                      _headerCell('Mín USDT', flex: 3),
                      _headerCell('Máx USDT', flex: 3),
                      _headerCell('% Reintegro', flex: 3),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(widget.levels.length, (i) {
                    final level = widget.levels[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: NivelBadge(index: level.index, compact: true),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: _ConfigField(
                              controller: _minCtrl[i],
                              onChanged: (v) {
                                final val = double.tryParse(v);
                                if (val != null) {
                                  level.minUsdt = val;
                                  context.read<IngestaBloc>().add(
                                    IngestaLevelChangedEvent(i, level),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: _ConfigField(
                              controller: _maxCtrl[i],
                              isLastRow: level.maxUsdt == double.infinity,
                              onChanged: (v) {
                                final val = double.tryParse(v);
                                if (val != null) {
                                  level.maxUsdt = val;
                                  context.read<IngestaBloc>().add(
                                    IngestaLevelChangedEvent(i, level),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: _ConfigField(
                              controller: _pctCtrl[i],
                              suffix: '%',
                              onChanged: (v) {
                                final val = double.tryParse(v);
                                if (val != null) {
                                  level.porcentaje = val / 100;
                                  context.read<IngestaBloc>().add(
                                    IngestaLevelChangedEvent(i, level),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tipo de cambio (Bs/USDT):',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: _ConfigField(
                          controller: _tcController,
                          onChanged: (v) {
                            final val = double.tryParse(v);
                            if (val != null) {
                              context.read<IngestaBloc>().add(
                                IngestaTipoCambioChangedEvent(val),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tcController.dispose();
    for (final c in [..._minCtrl, ..._maxCtrl, ..._pctCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tcController = TextEditingController(
      text: widget.tipoCambio.toStringAsFixed(2),
    );
    _minCtrl = widget.levels
        .map((l) => TextEditingController(text: l.minUsdt.toStringAsFixed(0)))
        .toList();
    _maxCtrl = widget.levels.map((l) {
      final v = l.maxUsdt == double.infinity
          ? '∞'
          : l.maxUsdt.toStringAsFixed(0);
      return TextEditingController(text: v);
    }).toList();
    _pctCtrl = widget.levels
        .map(
          (l) => TextEditingController(
            text: (l.porcentaje * 100).toStringAsFixed(1),
          ),
        )
        .toList();
  }

  Widget _headerCell(String text, {int flex = 1}) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
    ),
  );
}

