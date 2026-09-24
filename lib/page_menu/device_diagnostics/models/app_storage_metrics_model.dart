/// Represents the storage and memory consumption metrics of the application
class AppStorageMetrics {
  final int tempCacheBytes;
  final int documentsBytes;
  final int sqliteDatabaseBytes;
  final int ramImageCacheBytes;
  final int ramImageCount;
  final int temporaryFilesCount;
  final DateTime scannedAt;

  const AppStorageMetrics({
    required this.tempCacheBytes,
    required this.documentsBytes,
    required this.sqliteDatabaseBytes,
    required this.ramImageCacheBytes,
    required this.ramImageCount,
    required this.temporaryFilesCount,
    required this.scannedAt,
  });

  factory AppStorageMetrics.empty() {
    return AppStorageMetrics(
      tempCacheBytes: 0,
      documentsBytes: 0,
      sqliteDatabaseBytes: 0,
      ramImageCacheBytes: 0,
      ramImageCount: 0,
      temporaryFilesCount: 0,
      scannedAt: DateTime.now(),
    );
  }

  int get totalAppStorageBytes =>
      tempCacheBytes + documentsBytes + sqliteDatabaseBytes;

  int get cleanableBytes =>
      tempCacheBytes + ramImageCacheBytes;

  String get formattedTempCache => _formatBytes(tempCacheBytes);
  String get formattedDocuments => _formatBytes(documentsBytes);
  String get formattedSqlite => _formatBytes(sqliteDatabaseBytes);
  String get formattedRamImageCache => _formatBytes(ramImageCacheBytes);
  String get formattedTotalAppStorage => _formatBytes(totalAppStorageBytes);
  String get formattedCleanable => _formatBytes(cleanableBytes);

  /// Status of the app storage health
  String get storageStatusText {
    if (cleanableBytes > 50 * 1024 * 1024) {
      return "Perlu Dibersihkan (> 50 MB)";
    } else if (cleanableBytes > 15 * 1024 * 1024) {
      return "Cukup Bersih (Normal)";
    } else {
      return "Sangat Bersih (Optimal)";
    }
  }

  bool get needsCleaning => cleanableBytes > 10 * 1024 * 1024; // > 10 MB

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

/// Represents individual file detail in cache
class JunkFileDetail {
  final String path;
  final String fileName;
  final int sizeBytes;
  final String category; // e.g. "Image Cache", "PDF Temp", "HTTP Buffer"
  final DateTime lastModified;

  const JunkFileDetail({
    required this.path,
    required this.fileName,
    required this.sizeBytes,
    required this.category,
    required this.lastModified,
  });

  String get formattedSize => AppStorageMetrics._formatBytes(sizeBytes);
}
