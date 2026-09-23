import 'dart:io';
import 'package:intl/intl.dart';

class GeotaggedPhotoModel {
  final int? id;
  final File originalFile;
  final File? watermarkedFile;
  final File? compressedFile;
  final int originalSizeBytes;
  final int compressedSizeBytes;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final String fullAddress;
  final String carrierName;
  final bool isCloudSynced;
  final String cloudUrl;
  final String cloudProvider;
  final DateTime? cloudSyncedAt;
  final DateTime? createdAt;

  const GeotaggedPhotoModel({
    this.id,
    required this.originalFile,
    this.watermarkedFile,
    this.compressedFile,
    this.originalSizeBytes = 0,
    this.compressedSizeBytes = 0,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.altitude = 0.0,
    this.accuracy = 0.0,
    required this.fullAddress,
    this.carrierName = "",
    this.isCloudSynced = false,
    this.cloudUrl = "",
    this.cloudProvider = "",
    this.cloudSyncedAt,
    this.createdAt,
  });

  /// Formatted date and time matching the watermark design: e.g. 'Mon, 21 Sep 2026 13:37'
  String get formattedDateTime {
    return DateFormat('E, d MMM yyyy HH:mm', 'en_US').format(timestamp);
  }

  /// Formatted Indonesian Date & Time alternative
  String get formattedDateTimeId {
    return DateFormat('EEEE, d MMM yyyy HH:mm', 'id_ID').format(timestamp);
  }

  /// Formatted coordinates matching watermark design: 'Latitude: -6.2267871, Longitude: 106.7968818'
  String get formattedCoordinates {
    return "Latitude: ${latitude.toStringAsFixed(7)}, Longitude: ${longitude.toStringAsFixed(7)}";
  }

  /// Alias getters for address and carrier
  String get address => fullAddress;
  String get carrier => carrierName;

  /// Formatted Altitude
  String get formattedAltitude => "${altitude.toStringAsFixed(1)} m dpl";

  /// Compression Byte Savings
  int get savedBytes => (originalSizeBytes > compressedSizeBytes && compressedSizeBytes > 0)
      ? (originalSizeBytes - compressedSizeBytes)
      : 0;

  /// Compression Savings Percentage
  double get savingsPercent => (originalSizeBytes > 0 && savedBytes > 0)
      ? (savedBytes / originalSizeBytes * 100)
      : 0.0;

  String get formattedSavings => "${savingsPercent.toStringAsFixed(0)}%";

  String get formattedOriginalSize => _formatBytes(originalSizeBytes);

  String get formattedCompressedSize =>
      _formatBytes(compressedSizeBytes > 0 ? compressedSizeBytes : originalSizeBytes);

  String get formattedSavedSize => _formatBytes(savedBytes);

  /// Target file used for display / sharing (prefer compressed, then watermarked, then original)
  File get displayFile => compressedFile ?? watermarkedFile ?? originalFile;

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 KB";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPath': originalFile.path,
      'compressedPath': (compressedFile ?? watermarkedFile ?? originalFile).path,
      'originalSize': originalSizeBytes,
      'compressedSize': compressedSizeBytes,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'address': fullAddress,
      'carrier': carrierName,
      'isCloudSynced': isCloudSynced,
      'cloudUrl': cloudUrl,
      'cloudProvider': cloudProvider,
      'cloudSyncedAt': cloudSyncedAt?.millisecondsSinceEpoch,
    };
  }

  factory GeotaggedPhotoModel.fromMap(Map<dynamic, dynamic> map) {
    final origPath = map['original_path']?.toString() ?? '';
    final compPath = map['compressed_path']?.toString() ?? origPath;
    final timeMs = (map['timestamp'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch;
    final createdMs = (map['created_at'] as num?)?.toInt();
    final cloudTimeMs = (map['cloud_synced_at'] as num?)?.toInt();

    int origBytes = (map['original_size_bytes'] as num?)?.toInt() ?? 0;
    int compBytes = (map['compressed_size_bytes'] as num?)?.toInt() ?? 0;

    // Self-healing: if legacy record had inverted sizes (orig < comp), correct so original is the raw size
    if (origBytes > 0 && compBytes > 0 && origBytes < compBytes) {
      final temp = origBytes;
      origBytes = compBytes;
      compBytes = temp;
    }

    final isCloud = map['is_cloud_synced'] == true || map['is_cloud_synced'] == 1;
    final cUrl = map['cloud_url']?.toString() ?? '';
    final cProv = map['cloud_provider']?.toString() ?? '';

    return GeotaggedPhotoModel(
      id: (map['id'] as num?)?.toInt(),
      originalFile: File(origPath),
      watermarkedFile: File(compPath),
      compressedFile: File(compPath),
      originalSizeBytes: origBytes,
      compressedSizeBytes: compBytes,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timeMs),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      altitude: (map['altitude'] as num?)?.toDouble() ?? 0.0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      fullAddress: map['address']?.toString() ?? '',
      carrierName: map['carrier']?.toString() ?? '',
      isCloudSynced: isCloud,
      cloudUrl: cUrl,
      cloudProvider: cProv,
      cloudSyncedAt: cloudTimeMs != null && cloudTimeMs > 0
          ? DateTime.fromMillisecondsSinceEpoch(cloudTimeMs)
          : null,
      createdAt: createdMs != null ? DateTime.fromMillisecondsSinceEpoch(createdMs) : null,
    );
  }

  GeotaggedPhotoModel copyWith({
    int? id,
    File? originalFile,
    File? watermarkedFile,
    File? compressedFile,
    int? originalSizeBytes,
    int? compressedSizeBytes,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    String? fullAddress,
    String? carrierName,
    bool? isCloudSynced,
    String? cloudUrl,
    String? cloudProvider,
    DateTime? cloudSyncedAt,
    DateTime? createdAt,
  }) {
    return GeotaggedPhotoModel(
      id: id ?? this.id,
      originalFile: originalFile ?? this.originalFile,
      watermarkedFile: watermarkedFile ?? this.watermarkedFile,
      compressedFile: compressedFile ?? this.compressedFile,
      originalSizeBytes: originalSizeBytes ?? this.originalSizeBytes,
      compressedSizeBytes: compressedSizeBytes ?? this.compressedSizeBytes,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      fullAddress: fullAddress ?? this.fullAddress,
      carrierName: carrierName ?? this.carrierName,
      isCloudSynced: isCloudSynced ?? this.isCloudSynced,
      cloudUrl: cloudUrl ?? this.cloudUrl,
      cloudProvider: cloudProvider ?? this.cloudProvider,
      cloudSyncedAt: cloudSyncedAt ?? this.cloudSyncedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
