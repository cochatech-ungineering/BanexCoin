class TransactionRecord {
  final String accountNumber;
  final double amountUsdt;
  final double amountBob;
  final double exchangeRate;
  final DateTime createdAt;

  const TransactionRecord({
    required this.accountNumber,
    required this.amountUsdt,
    required this.amountBob,
    required this.exchangeRate,
    required this.createdAt,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> m) =>
      TransactionRecord(
        accountNumber: m['account_number'].toString(),
        amountUsdt: (m['amount_usdt'] as num).toDouble(),
        amountBob: (m['amount_bob'] as num).toDouble(),
        exchangeRate: (m['exchange_rate'] as num).toDouble(),
        createdAt: DateTime.parse(m['created_at'] as String),
      );

  // CSV column order: account_number, amount_usdt, amount_bob, exchange_rate, created_at
  factory TransactionRecord.fromCsvRow(List<dynamic> row) => TransactionRecord(
        accountNumber: row[0].toString(),
        amountUsdt: double.parse(row[1].toString()),
        amountBob: double.parse(row[2].toString()),
        exchangeRate: double.parse(row[3].toString()),
        createdAt: DateTime.parse(row[4].toString()),
      );
}
