class CashbackPeriod {
  final int year;
  final int month;

  const CashbackPeriod({required this.year, required this.month});

  factory CashbackPeriod.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CashbackPeriod(year: 0, month: 0);
    return CashbackPeriod(
      year: (json['year'] as num?)?.toInt() ?? 0,
      month: (json['month'] as num?)?.toInt() ?? 0,
    );
  }

  DateTime? toDateTime() {
    if (year <= 0 || month <= 0) return null;
    return DateTime(year, month);
  }
}

class CashbackCalculation {
  final String s3Key;
  final String calculationId;
  final String userId;
  final CashbackPeriod period;
  final double totalVolumeBs;
  final double totalVolumeUsdt;
  final double qrVolumeBs;
  final int transactionCount;
  final String cashbackLevel;
  final double cashbackPercentage;
  final double cashbackAmountBs;
  final double cashbackAmountUsdt;
  final String status;
  final DateTime? calculatedAt;

  const CashbackCalculation({
    required this.s3Key,
    required this.calculationId,
    required this.userId,
    required this.period,
    required this.totalVolumeBs,
    required this.totalVolumeUsdt,
    required this.qrVolumeBs,
    required this.transactionCount,
    required this.cashbackLevel,
    required this.cashbackPercentage,
    required this.cashbackAmountBs,
    required this.cashbackAmountUsdt,
    required this.status,
    this.calculatedAt,
  });

  factory CashbackCalculation.fromJson(Map<String, dynamic> json) {
    return CashbackCalculation(
      s3Key: json['s3Key']?.toString() ?? '',
      calculationId: json['calculationId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      period: CashbackPeriod.fromJson(
        json['period'] as Map<String, dynamic>?,
      ),
      totalVolumeBs: (json['totalVolumeBs'] as num?)?.toDouble() ?? 0,
      totalVolumeUsdt: (json['totalVolumeUsdt'] as num?)?.toDouble() ?? 0,
      qrVolumeBs: (json['qrVolumeBs'] as num?)?.toDouble() ?? 0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      cashbackLevel: json['cashbackLevel']?.toString() ?? '',
      cashbackPercentage: (json['cashbackPercentage'] as num?)?.toDouble() ?? 0,
      cashbackAmountBs: (json['cashbackAmountBs'] as num?)?.toDouble() ?? 0,
      cashbackAmountUsdt: (json['cashbackAmountUsdt'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
      calculatedAt: DateTime.tryParse(json['calculatedAt']?.toString() ?? ''),
    );
  }
}

class CashbackListResponse {
  final List<CashbackCalculation> items;
  final String? nextCursor;
  final bool isTruncated;

  const CashbackListResponse({
    required this.items,
    this.nextCursor,
    this.isTruncated = false,
  });

  factory CashbackListResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return CashbackListResponse(
      items: rawItems
          .map((e) => CashbackCalculation.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor']?.toString(),
      isTruncated: json['isTruncated'] == true,
    );
  }
}
