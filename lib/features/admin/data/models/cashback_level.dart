class CashbackLevel {
  final int index; // 1, 2, 3
  double minUsdt;
  double maxUsdt; // use double.infinity for the last tier
  double porcentaje; // e.g. 0.01 for 1%

  CashbackLevel({
    required this.index,
    required this.minUsdt,
    required this.maxUsdt,
    required this.porcentaje,
  });

  String get label => 'Nivel $index';

  static List<CashbackLevel> defaults() => [
        CashbackLevel(index: 1, minUsdt: 0, maxUsdt: 500, porcentaje: 0.01),
        CashbackLevel(index: 2, minUsdt: 500, maxUsdt: 2000, porcentaje: 0.015),
        CashbackLevel(index: 3, minUsdt: 2000, maxUsdt: double.infinity, porcentaje: 0.02),
      ];
}
