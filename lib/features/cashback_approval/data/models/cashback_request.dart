enum RequestStatus { preApproved, preDenied, approved, denied, pending }

enum RiskLevel { low, medium, high }

class CashbackRequest {
  final String id;
  final String userId;
  final String userName;
  final int nivel;
  final double montoSolicitado;
  final double volumenMes;
  final RequestStatus status;
  final double dlConfidence;
  final RiskLevel riskLevel;
  final String? fraudAlertId;
  final List<String> dlReasons;
  final String date;

  const CashbackRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.nivel,
    required this.montoSolicitado,
    required this.volumenMes,
    required this.status,
    required this.dlConfidence,
    required this.riskLevel,
    this.fraudAlertId,
    required this.dlReasons,
    required this.date,
  });

  bool get hasfraudLink => fraudAlertId != null;
  bool get isPreClassified =>
      status == RequestStatus.preApproved || status == RequestStatus.preDenied;
}

String statusLabel(RequestStatus status) {
  switch (status) {
    case RequestStatus.preApproved:
      return 'Pre-aprobado';
    case RequestStatus.preDenied:
      return 'Pre-rechazado';
    case RequestStatus.approved:
      return 'Aprobado';
    case RequestStatus.denied:
      return 'Rechazado';
    case RequestStatus.pending:
      return 'Pendiente';
  }
}

String riskLabel(RiskLevel level) {
  switch (level) {
    case RiskLevel.low:
      return 'Bajo';
    case RiskLevel.medium:
      return 'Medio';
    case RiskLevel.high:
      return 'Alto';
  }
}

final List<CashbackRequest> mockRequests = [
  CashbackRequest(
    id: 'CBK-0451',
    userId: 'USR-001',
    userName: 'Carlos Mendoza',
    nivel: 3,
    montoSolicitado: 12.45,
    volumenMes: 4200,
    status: RequestStatus.preApproved,
    dlConfidence: 0.97,
    riskLevel: RiskLevel.low,
    dlReasons: [
      'Historial consistente de 8 meses sin anomalías',
      'Volumen mensual dentro del rango esperado para nivel 3',
      'Sin alertas de fraude asociadas',
      'Patrón de transacciones regular y predecible',
    ],
    date: '16 may 2025',
  ),
  CashbackRequest(
    id: 'CBK-0450',
    userId: 'USR-002',
    userName: 'María Quispe',
    nivel: 2,
    montoSolicitado: 8.23,
    volumenMes: 2750,
    status: RequestStatus.preApproved,
    dlConfidence: 0.92,
    riskLevel: RiskLevel.low,
    dlReasons: [
      'Actividad constante por 5 meses consecutivos',
      'Monto solicitado proporcional al volumen operado',
      'Score crediticio dentro de parámetros normales',
    ],
    date: '16 may 2025',
  ),
  CashbackRequest(
    id: 'CBK-0449',
    userId: 'USR-008',
    userName: 'Diego Salazar',
    nivel: 3,
    montoSolicitado: 45.80,
    volumenMes: 15300,
    status: RequestStatus.preDenied,
    dlConfidence: 0.89,
    riskLevel: RiskLevel.high,
    fraudAlertId: 'FRD-2025-0847',
    dlReasons: [
      'Cuenta vinculada a alerta de fraude FRD-2025-0847',
      'Incremento súbito del 340% en volumen mensual',
      'Patrón de transacciones coincide con circuito cerrado detectado',
      'Score de riesgo elevado por modelo anti-lavado',
    ],
    date: '15 may 2025',
  ),
  CashbackRequest(
    id: 'CBK-0448',
    userId: 'USR-009',
    userName: 'Patricia Rojas',
    nivel: 1,
    montoSolicitado: 2.10,
    volumenMes: 700,
    status: RequestStatus.pending,
    dlConfidence: 0.65,
    riskLevel: RiskLevel.medium,
    dlReasons: [
      'Cuenta nueva (menos de 30 días)',
      'Insuficiente historial para clasificación automática',
      'Modelo requiere revisión manual por falta de data',
    ],
    date: '15 may 2025',
  ),
  CashbackRequest(
    id: 'CBK-0447',
    userId: 'USR-003',
    userName: 'Jorge Mamani',
    nivel: 3,
    montoSolicitado: 33.50,
    volumenMes: 11200,
    status: RequestStatus.approved,
    dlConfidence: 0.99,
    riskLevel: RiskLevel.low,
    dlReasons: [
      'Usuario top con 14 meses de actividad continua',
      'Volumen y frecuencia consistentes con perfil nivel 3',
      'Cero alertas históricas',
      'Aprobación automática por superar umbral de confianza (>0.95)',
    ],
    date: '14 may 2025',
  ),
  CashbackRequest(
    id: 'CBK-0446',
    userId: 'USR-010',
    userName: 'Ramiro Condori',
    nivel: 2,
    montoSolicitado: 18.90,
    volumenMes: 6300,
    status: RequestStatus.denied,
    dlConfidence: 0.94,
    riskLevel: RiskLevel.high,
    fraudAlertId: 'FRD-2025-0831',
    dlReasons: [
      'Cuenta destino en esquema de smurfing (FRD-2025-0831)',
      'KYC con inconsistencias detectadas',
      'Rechazado automáticamente por vinculación directa a fraude confirmado',
    ],
    date: '13 may 2025',
  ),
  CashbackRequest(
    id: 'CBK-0445',
    userId: 'USR-006',
    userName: 'Lucía Vargas',
    nivel: 2,
    montoSolicitado: 5.60,
    volumenMes: 1870,
    status: RequestStatus.preApproved,
    dlConfidence: 0.88,
    riskLevel: RiskLevel.low,
    dlReasons: [
      'Perfil de bajo riesgo sostenido por 6 meses',
      'Monto dentro del percentil 40 para su nivel',
      'Sin flags de velocidad ni patrones sospechosos',
    ],
    date: '16 may 2025',
  ),
];
