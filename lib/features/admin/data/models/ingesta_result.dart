class IngestaResult {
  final String accountNumber;
  final double totalConsumoUsdt;
  final double totalConsumoBs;
  final int nivelIndex;
  final double porcentajeReintegro;
  final double reintegroUsdt;
  final double reintegroBs;

  const IngestaResult({
    required this.accountNumber,
    required this.totalConsumoUsdt,
    required this.totalConsumoBs,
    required this.nivelIndex,
    required this.porcentajeReintegro,
    required this.reintegroUsdt,
    required this.reintegroBs,
  });

  factory IngestaResult.fromJson(Map<String, dynamic> m) => IngestaResult(
        accountNumber: m['account_number'].toString(),
        totalConsumoUsdt: (m['total_usdt'] as num).toDouble(),
        totalConsumoBs: (m['total_bs'] as num).toDouble(),
        nivelIndex: (m['nivel'] as num).toInt(),
        porcentajeReintegro: (m['porcentaje_reintegro'] as num).toDouble(),
        reintegroUsdt: (m['reintegro_usdt'] as num).toDouble(),
        reintegroBs: (m['reintegro_bs'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'account_number': accountNumber,
        'total_usdt': totalConsumoUsdt,
        'total_bs': totalConsumoBs,
        'nivel': nivelIndex,
        'porcentaje_reintegro': porcentajeReintegro,
        'reintegro_usdt': reintegroUsdt,
        'reintegro_bs': reintegroBs,
      };

  List<String> toCsvRow() => [
        accountNumber,
        totalConsumoUsdt.toStringAsFixed(2),
        totalConsumoBs.toStringAsFixed(2),
        'Nivel $nivelIndex',
        '${(porcentajeReintegro * 100).toStringAsFixed(1)}%',
        reintegroUsdt.toStringAsFixed(4),
        reintegroBs.toStringAsFixed(2),
      ];
}
