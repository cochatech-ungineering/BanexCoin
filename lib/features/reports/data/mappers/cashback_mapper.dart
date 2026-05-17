import '../../../admin/data/models/ingesta_result.dart';
import '../models/cashback_calculation.dart';

/// Convierte resultados del motor (reports API) al modelo de tabla del admin.
class CashbackMapper {
  static List<IngestaResult> toIngestaResults(List<CashbackCalculation> items) {
    return items.map(toIngestaResult).toList();
  }

  static IngestaResult toIngestaResult(CashbackCalculation c) {
    final nivelIndex = _levelIndex(c.cashbackLevel);
    final porcentaje = c.cashbackPercentage > 1
        ? c.cashbackPercentage / 100
        : c.cashbackPercentage;

    return IngestaResult(
      accountNumber: c.userId,
      totalConsumoUsdt: c.totalVolumeUsdt,
      totalConsumoBs: c.totalVolumeBs,
      nivelIndex: nivelIndex,
      porcentajeReintegro: porcentaje,
      reintegroUsdt: c.cashbackAmountUsdt,
      reintegroBs: c.cashbackAmountBs,
    );
  }

  static int _levelIndex(String level) {
    final match = RegExp(r'(\d+)').firstMatch(level);
    if (match != null) return int.tryParse(match.group(1)!) ?? 1;
    return 1;
  }
}
