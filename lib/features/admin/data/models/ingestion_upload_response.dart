class IngestionStatsDto {
  final int totalRecords;
  final int uniqueUsers;
  final double? totalAmountBob;
  final double? totalAmountUsdt;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const IngestionStatsDto({
    required this.totalRecords,
    required this.uniqueUsers,
    this.totalAmountBob,
    this.totalAmountUsdt,
    this.periodStart,
    this.periodEnd,
  });

  factory IngestionStatsDto.fromJson(Map<String, dynamic> json) {
    return IngestionStatsDto(
      totalRecords: (json['total_records'] as num?)?.toInt() ?? 0,
      uniqueUsers: (json['unique_users'] as num?)?.toInt() ?? 0,
      totalAmountBob: (json['total_amount_bob'] as num?)?.toDouble(),
      totalAmountUsdt: (json['total_amount_usdt'] as num?)?.toDouble(),
      periodStart: _parseDate(json['period_start']),
      periodEnd: _parseDate(json['period_end']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class IngestionUploadResponse {
  final String reportId;
  final String? jobStatus;
  final String fileType;
  final String sourceFile;
  final IngestionStatsDto stats;
  final int eventsPublished;

  const IngestionUploadResponse({
    required this.reportId,
    this.jobStatus,
    required this.fileType,
    required this.sourceFile,
    required this.stats,
    required this.eventsPublished,
  });

  factory IngestionUploadResponse.fromJson(Map<String, dynamic> json) {
    return IngestionUploadResponse(
      reportId: json['report_id']?.toString() ?? '',
      jobStatus: json['job_status']?.toString(),
      fileType: json['file_type']?.toString() ?? 'qr_payments',
      sourceFile: json['source_file']?.toString() ?? '',
      stats: IngestionStatsDto.fromJson(
        (json['stats'] as Map<String, dynamic>?) ?? {},
      ),
      eventsPublished: (json['events_published'] as num?)?.toInt() ?? 0,
    );
  }
}

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
