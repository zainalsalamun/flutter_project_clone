/// Represents the latency, response size, and status of an API endpoint benchmark
class ApiEndpointBenchmark {
  final String id;
  final String name;
  final String url;
  final String method;
  final int latencyMs;
  final int statusCode;
  final bool isSuccess;
  final bool isGzipCompressed;
  final int responseSizeBytes;
  final DateTime testedAt;

  const ApiEndpointBenchmark({
    required this.id,
    required this.name,
    required this.url,
    this.method = 'GET',
    required this.latencyMs,
    required this.statusCode,
    required this.isSuccess,
    this.isGzipCompressed = false,
    this.responseSizeBytes = 0,
    required this.testedAt,
  });

  String get formattedLatency => "$latencyMs ms";

  String get formattedSize {
    if (responseSizeBytes <= 0) return "-";
    if (responseSizeBytes < 1024) return "$responseSizeBytes B";
    return "${(responseSizeBytes / 1024.0).toStringAsFixed(1)} KB";
  }

  String get latencyGrade {
    if (!isSuccess) return "Gagal Terhubung";
    if (latencyMs < 200) return "Sangat Cepat (< 200ms)";
    if (latencyMs < 600) return "Normal (Cukup Cepat)";
    if (latencyMs < 1200) return "Lambat (Perlu Optimasi)";
    return "Sangat Lambat (> 1.2s)";
  }
}

/// Represents the session network bandwidth and data transfer summary
class SessionBandwidthSummary {
  final int totalRxBytes;
  final int totalTxBytes;
  final int totalRequestsCount;
  final List<ApiEndpointBenchmark> benchmarks;
  final DateTime updatedAt;

  const SessionBandwidthSummary({
    required this.totalRxBytes,
    required this.totalTxBytes,
    required this.totalRequestsCount,
    required this.benchmarks,
    required this.updatedAt,
  });

  factory SessionBandwidthSummary.initial() {
    return SessionBandwidthSummary(
      totalRxBytes: 0,
      totalTxBytes: 0,
      totalRequestsCount: 0,
      benchmarks: const [],
      updatedAt: DateTime.now(),
    );
  }

  String get formattedTotalRx => _formatBytes(totalRxBytes);
  String get formattedTotalTx => _formatBytes(totalTxBytes);
  String get formattedTotalBandwidth => _formatBytes(totalRxBytes + totalTxBytes);

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024.0).toStringAsFixed(1)} KB";
    }
    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024.0 * 1024.0)).toStringAsFixed(1)} MB";
    }
    return "${(bytes / (1024.0 * 1024.0 * 1024.0)).toStringAsFixed(2)} GB";
  }
}
