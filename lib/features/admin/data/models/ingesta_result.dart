class IngestaResult {
  final String accountNumber;
  final String userAlias;
  final double totalConsumoUsdt;
  final int nivelIndex;
  final double porcentajeReintegro;
  final double reintegroUsdt;
  final double reintegroBs;

  factory IngestaResult.fromJson(Map<String, dynamic> m) => IngestaResult(
        accountNumber: m['account_number'].toString(),
        userAlias: m['user_alias']?.toString() ?? '',
        totalConsumoUsdt: (m['total_usdt'] as num).toDouble(),
        nivelIndex: (m['nivel'] as num).toInt(),
        porcentajeReintegro: (m['porcentaje_reintegro'] as num).toDouble(),
        reintegroUsdt: (m['reintegro_usdt'] as num).toDouble(),
        reintegroBs: (m['reintegro_bs'] as num).toDouble(),
      );

  const IngestaResult({
    required this.accountNumber,
    required this.userAlias,
    required this.totalConsumoUsdt,
    required this.nivelIndex,
    required this.porcentajeReintegro,
    required this.reintegroUsdt,
    required this.reintegroBs,
  });

  Map<String, dynamic> toJson() => {
        'account_number': accountNumber,
        'user_alias': userAlias,
        'total_usdt': totalConsumoUsdt,
        'nivel': nivelIndex,
        'porcentaje_reintegro': porcentajeReintegro,
        'reintegro_usdt': reintegroUsdt,
        'reintegro_bs': reintegroBs,
      };

  List<String> toCsvRow() => [
        accountNumber,
        userAlias,
        totalConsumoUsdt.toStringAsFixed(2),
        'Nivel $nivelIndex',
        '${(porcentajeReintegro * 100).toStringAsFixed(1)}%',
        reintegroUsdt.toStringAsFixed(4),
        reintegroBs.toStringAsFixed(2),
      ];
}
