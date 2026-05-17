import 'package:flutter/material.dart';

enum AlertSeverity { high, medium, low }

enum AlertStatus { pending, reviewing, rejected, cleared }

class FraudAlert {
  final String id;
  final String patternName;
  final String description;
  final AlertSeverity severity;
  final AlertStatus status;
  final String accountOrigin;
  final String accountDestination;
  final int transactionCount;
  final double totalAmount;
  final String dateRange;
  final List<FlaggedTransaction> transactions;
  final List<String> reasons;

  const FraudAlert({
    required this.id,
    required this.patternName,
    required this.description,
    required this.severity,
    required this.status,
    required this.accountOrigin,
    required this.accountDestination,
    required this.transactionCount,
    required this.totalAmount,
    required this.dateRange,
    required this.transactions,
    required this.reasons,
  });
}

class FlaggedTransaction {
  final String date;
  final String hour;
  final double amount;
  final String reference;
  final String type;

  const FlaggedTransaction({
    required this.date,
    required this.hour,
    required this.amount,
    required this.reference,
    required this.type,
  });
}

Color severityColor(AlertSeverity severity) {
  switch (severity) {
    case AlertSeverity.high:
      return const Color(0xFFE74C3C);
    case AlertSeverity.medium:
      return const Color(0xFFFF8B53);
    case AlertSeverity.low:
      return const Color(0xFFFFD93D);
  }
}

IconData severityIcon(AlertSeverity severity) {
  switch (severity) {
    case AlertSeverity.high:
      return Icons.error_rounded;
    case AlertSeverity.medium:
      return Icons.warning_rounded;
    case AlertSeverity.low:
      return Icons.info_rounded;
  }
}

String severityLabel(AlertSeverity severity) {
  switch (severity) {
    case AlertSeverity.high:
      return 'Alta';
    case AlertSeverity.medium:
      return 'Media';
    case AlertSeverity.low:
      return 'Baja';
  }
}

String statusLabel(AlertStatus status) {
  switch (status) {
    case AlertStatus.pending:
      return 'Pendiente';
    case AlertStatus.reviewing:
      return 'En revisión';
    case AlertStatus.rejected:
      return 'Rechazado';
    case AlertStatus.cleared:
      return 'Descartado';
  }
}

final List<FraudAlert> mockAlerts = [
  FraudAlert(
    id: 'FRD-2025-0847',
    patternName: 'Circuito cerrado recurrente',
    description: 'Transferencias cíclicas entre 2 cuentas con montos fraccionados bajo el umbral de reporte.',
    severity: AlertSeverity.high,
    status: AlertStatus.pending,
    accountOrigin: 'BNX-****4521',
    accountDestination: 'BNX-****8903',
    transactionCount: 23,
    totalAmount: 48750.00,
    dateRange: '01 abr - 15 may 2025',
    reasons: [
      'Frecuencia anómala: 23 transferencias en 45 días entre mismas cuentas',
      'Montos fraccionados: todos bajo 2,500 USDT (umbral de reporte automático)',
      'Patrón horario: 87% ejecutadas entre 23:00 - 04:00',
      'Sin actividad comercial asociada a las cuentas involucradas',
    ],
    transactions: [
      FlaggedTransaction(date: '15 may', hour: '01:23', amount: 2480.00, reference: 'TXN-98412', type: 'QR'),
      FlaggedTransaction(date: '13 may', hour: '23:45', amount: 2100.00, reference: 'TXN-98301', type: 'QR'),
      FlaggedTransaction(date: '11 may', hour: '02:10', amount: 2490.00, reference: 'TXN-98187', type: 'Transfer'),
      FlaggedTransaction(date: '09 may', hour: '00:32', amount: 1950.00, reference: 'TXN-98054', type: 'QR'),
      FlaggedTransaction(date: '07 may', hour: '03:15', amount: 2400.00, reference: 'TXN-97923', type: 'Transfer'),
    ],
  ),
  FraudAlert(
    id: 'FRD-2025-0831',
    patternName: 'Smurfing detectado',
    description: 'Múltiples micro-depósitos desde cuentas nuevas hacia una cuenta consolidadora.',
    severity: AlertSeverity.high,
    status: AlertStatus.reviewing,
    accountOrigin: 'BNX-****1127 (+4 cuentas)',
    accountDestination: 'BNX-****6640',
    transactionCount: 47,
    totalAmount: 92300.00,
    dateRange: '20 mar - 10 may 2025',
    reasons: [
      'Cuenta destino recibe de 5 cuentas creadas en la misma semana',
      'Cuentas origen sin historial previo de actividad',
      'Consolidación inmediata: fondos retirados dentro de 2 hrs de recepción',
      'KYC de cuentas origen con documentación similar',
    ],
    transactions: [
      FlaggedTransaction(date: '10 may', hour: '14:20', amount: 1990.00, reference: 'TXN-97801', type: 'Transfer'),
      FlaggedTransaction(date: '10 may', hour: '14:18', amount: 1850.00, reference: 'TXN-97800', type: 'Transfer'),
      FlaggedTransaction(date: '10 may', hour: '14:15', amount: 2000.00, reference: 'TXN-97799', type: 'Transfer'),
      FlaggedTransaction(date: '09 may', hour: '15:01', amount: 1970.00, reference: 'TXN-97712', type: 'Transfer'),
      FlaggedTransaction(date: '09 may', hour: '14:58', amount: 2100.00, reference: 'TXN-97711', type: 'Transfer'),
    ],
  ),
  FraudAlert(
    id: 'FRD-2025-0819',
    patternName: 'Ping-pong entre pares',
    description: 'Dos cuentas se envían fondos mutuamente con incrementos progresivos.',
    severity: AlertSeverity.medium,
    status: AlertStatus.pending,
    accountOrigin: 'BNX-****3345',
    accountDestination: 'BNX-****7782',
    transactionCount: 12,
    totalAmount: 18400.00,
    dateRange: '25 abr - 14 may 2025',
    reasons: [
      'Patrón bidireccional: ambas cuentas envían y reciben en ciclos de 48hrs',
      'Incremento progresivo del 15% en cada ciclo',
      'Posible esquema de layering para ofuscar origen de fondos',
    ],
    transactions: [
      FlaggedTransaction(date: '14 may', hour: '10:05', amount: 2300.00, reference: 'TXN-97650', type: 'QR'),
      FlaggedTransaction(date: '12 may', hour: '09:50', amount: 2000.00, reference: 'TXN-97534', type: 'QR'),
      FlaggedTransaction(date: '10 may', hour: '11:20', amount: 1740.00, reference: 'TXN-97401', type: 'Transfer'),
      FlaggedTransaction(date: '08 may', hour: '10:15', amount: 1510.00, reference: 'TXN-97289', type: 'Transfer'),
      FlaggedTransaction(date: '06 may', hour: '09:30', amount: 1310.00, reference: 'TXN-97150', type: 'QR'),
    ],
  ),
  FraudAlert(
    id: 'FRD-2025-0802',
    patternName: 'Velocidad inusual',
    description: 'Ráfaga de 8 transacciones en menos de 3 minutos desde una misma cuenta.',
    severity: AlertSeverity.low,
    status: AlertStatus.cleared,
    accountOrigin: 'BNX-****9901',
    accountDestination: 'BNX-****2254',
    transactionCount: 8,
    totalAmount: 4200.00,
    dateRange: '12 may 2025',
    reasons: [
      'Velocidad: 8 transacciones en ventana de 3 minutos',
      'Posible uso de script automatizado o bot',
      'Descartado: usuario confirmó pago a proveedor con múltiples facturas',
    ],
    transactions: [
      FlaggedTransaction(date: '12 may', hour: '16:42', amount: 525.00, reference: 'TXN-97100', type: 'QR'),
      FlaggedTransaction(date: '12 may', hour: '16:41', amount: 525.00, reference: 'TXN-97099', type: 'QR'),
      FlaggedTransaction(date: '12 may', hour: '16:41', amount: 525.00, reference: 'TXN-97098', type: 'QR'),
      FlaggedTransaction(date: '12 may', hour: '16:40', amount: 525.00, reference: 'TXN-97097', type: 'QR'),
      FlaggedTransaction(date: '12 may', hour: '16:40', amount: 525.00, reference: 'TXN-97096', type: 'QR'),
    ],
  ),
];
