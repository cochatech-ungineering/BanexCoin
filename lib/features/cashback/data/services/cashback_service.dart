import '../models/cashback_entry.dart';

class CashbackData {
  final double totalGanado;
  final int nivelActual;
  final double porcentajeActual;
  final double gananciasMes;
  final double montoParaSiguienteNivel;
  final List<CashbackEntry> historial;
  final int totalHistorial;

  const CashbackData({
    required this.totalGanado,
    required this.nivelActual,
    required this.porcentajeActual,
    required this.gananciasMes,
    required this.montoParaSiguienteNivel,
    required this.historial,
    required this.totalHistorial,
  });
}

class CashbackService {
  // ignore: unused_field
  static const _baseUrl = 'https://api.banexcoin.com/v1/cashback';

  Future<CashbackData> getSummary() async {
    // TODO: GET $_baseUrl/summary
    // For now, return mock data
    return const CashbackData(
      totalGanado: 31.19,
      nivelActual: 2,
      porcentajeActual: 3.0,
      gananciasMes: 8.23,
      montoParaSiguienteNivel: 412.50,
      historial: [],
      totalHistorial: 12,
    );
  }

  Future<List<CashbackEntry>> getHistorial({int page = 0, int limit = 5}) async {
    // TODO: GET $_baseUrl/historial?page=$page&limit=$limit
    return [
      const CashbackEntry(date: '15 ago 2025', montoUsdt: 12.4500, porcentaje: 0.05, nivel: 3),
      const CashbackEntry(date: '15 jul 2025', montoUsdt: 8.2300, porcentaje: 0.05, nivel: 3),
      const CashbackEntry(date: '15 jun 2025', montoUsdt: 5.1200, porcentaje: 0.03, nivel: 2),
      const CashbackEntry(date: '15 may 2025', montoUsdt: 3.8400, porcentaje: 0.03, nivel: 2),
      const CashbackEntry(date: '15 abr 2025', montoUsdt: 1.5600, porcentaje: 0.01, nivel: 1),
    ];
  }
}
