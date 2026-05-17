class UserProfitability {
  final String userId;
  final String userName;
  final int nivel;
  final double totalComprasUsdt;
  final double totalRetirosUsdt;
  final double precioParalelo;
  final double precioCobrado;
  final double cashbackEntregado;
  final String lastActivity;

  const UserProfitability({
    required this.userId,
    required this.userName,
    required this.nivel,
    required this.totalComprasUsdt,
    required this.totalRetirosUsdt,
    required this.precioParalelo,
    required this.precioCobrado,
    required this.cashbackEntregado,
    required this.lastActivity,
  });

  double get totalOperaciones => totalComprasUsdt + totalRetirosUsdt;
  double get spreadPorUnidad => precioCobrado - precioParalelo;
  double get comisionTotal => totalOperaciones * spreadPorUnidad;
  double get comisionBs => comisionTotal;
  double get comisionUsdt => comisionBs / precioCobrado;
  double get rentabilidadNeta => comisionUsdt - cashbackEntregado;
  double get margenPorcentaje =>
      comisionUsdt > 0 ? (rentabilidadNeta / comisionUsdt) * 100 : 0;
  bool get esRentable => rentabilidadNeta > 0;
}

class ProfitabilitySummary {
  final double totalComisiones;
  final double totalCashbackEntregado;
  final double rentabilidadGlobal;
  final int usuariosRentables;
  final int usuariosNoRentables;
  final double precioParalelo;
  final double precioCobrado;
  final List<UserProfitability> usuarios;

  const ProfitabilitySummary({
    required this.totalComisiones,
    required this.totalCashbackEntregado,
    required this.rentabilidadGlobal,
    required this.usuariosRentables,
    required this.usuariosNoRentables,
    required this.precioParalelo,
    required this.precioCobrado,
    required this.usuarios,
  });

  double get margenGlobal =>
      totalComisiones > 0 ? ((totalComisiones - totalCashbackEntregado) / totalComisiones) * 100 : 0;
}

final mockUsers = [
  UserProfitability(
    userId: 'USR-001',
    userName: 'Carlos Mendoza',
    nivel: 3,
    totalComprasUsdt: 12500,
    totalRetirosUsdt: 3200,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 78.50,
    lastActivity: '15 may 2025',
  ),
  UserProfitability(
    userId: 'USR-002',
    userName: 'María Quispe',
    nivel: 2,
    totalComprasUsdt: 8400,
    totalRetirosUsdt: 1800,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 30.60,
    lastActivity: '14 may 2025',
  ),
  UserProfitability(
    userId: 'USR-003',
    userName: 'Jorge Mamani',
    nivel: 3,
    totalComprasUsdt: 45000,
    totalRetirosUsdt: 22000,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 335.00,
    lastActivity: '16 may 2025',
  ),
  UserProfitability(
    userId: 'USR-004',
    userName: 'Ana Flores',
    nivel: 1,
    totalComprasUsdt: 1200,
    totalRetirosUsdt: 400,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 4.80,
    lastActivity: '10 may 2025',
  ),
  UserProfitability(
    userId: 'USR-005',
    userName: 'Roberto Paz',
    nivel: 3,
    totalComprasUsdt: 95000,
    totalRetirosUsdt: 48000,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 715.00,
    lastActivity: '16 may 2025',
  ),
  UserProfitability(
    userId: 'USR-006',
    userName: 'Lucía Vargas',
    nivel: 2,
    totalComprasUsdt: 5600,
    totalRetirosUsdt: 2100,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 23.10,
    lastActivity: '12 may 2025',
  ),
  UserProfitability(
    userId: 'USR-007',
    userName: 'Fernando Choque',
    nivel: 1,
    totalComprasUsdt: 800,
    totalRetirosUsdt: 150,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    cashbackEntregado: 2.85,
    lastActivity: '08 may 2025',
  ),
];

ProfitabilitySummary getMockSummary() {
  final totalComisiones = mockUsers.fold<double>(0, (sum, u) => sum + u.comisionUsdt);
  final totalCashback = mockUsers.fold<double>(0, (sum, u) => sum + u.cashbackEntregado);
  final rentables = mockUsers.where((u) => u.esRentable).length;

  return ProfitabilitySummary(
    totalComisiones: totalComisiones,
    totalCashbackEntregado: totalCashback,
    rentabilidadGlobal: totalComisiones - totalCashback,
    usuariosRentables: rentables,
    usuariosNoRentables: mockUsers.length - rentables,
    precioParalelo: 9.90,
    precioCobrado: 10.00,
    usuarios: mockUsers,
  );
}
