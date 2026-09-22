import 'dart:convert';
import 'user_device_diagnostics_entity.dart';

class DeviceDiagnosticsEvent {
  final String event;
  final String userId;
  final String deviceIdHash;
  final String installationIdHash;
  final String device;
  final String model;
  final String brand;
  final String manufacturer;
  final String appVersion;
  final int storageAvailableBytes;
  final int totalStorageBytes;
  final int ramAvailableBytes;
  final int totalRamBytes;
  final int batteryLevel;
  final String batteryState;
  final DateTime timestamp;

  const DeviceDiagnosticsEvent({
    required this.event,
    required this.userId,
    required this.deviceIdHash,
    required this.installationIdHash,
    required this.device,
    required this.model,
    required this.brand,
    required this.manufacturer,
    required this.appVersion,
    required this.storageAvailableBytes,
    this.totalStorageBytes = 0,
    required this.ramAvailableBytes,
    this.totalRamBytes = 0,
    required this.batteryLevel,
    required this.batteryState,
    required this.timestamp,
  });

  factory DeviceDiagnosticsEvent.fromJson(Map<String, dynamic> json) {
    return DeviceDiagnosticsEvent(
      event: json['event'] as String? ?? 'device_diagnostics',
      userId: json['userId'] as String? ?? '',
      deviceIdHash: json['deviceIdHash'] as String? ?? '',
      installationIdHash: json['installationIdHash'] as String? ?? '',
      device: json['device'] as String? ?? '',
      model: json['model'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      appVersion: json['appVersion'] as String? ?? '',
      storageAvailableBytes: (json['storageAvailableBytes'] as num?)?.toInt() ?? 0,
      totalStorageBytes: (json['totalStorageBytes'] as num?)?.toInt() ?? 0,
      ramAvailableBytes: (json['ramAvailableBytes'] as num?)?.toInt() ?? 0,
      totalRamBytes: (json['totalRamBytes'] as num?)?.toInt() ?? 0,
      batteryLevel: (json['batteryLevel'] as num?)?.toInt() ?? 0,
      batteryState: json['batteryState'] as String? ?? 'unknown',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now().toUtc()
          : DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'userId': userId,
      'deviceIdHash': deviceIdHash,
      'installationIdHash': installationIdHash,
      'device': device,
      'model': model,
      'brand': brand,
      'manufacturer': manufacturer,
      'appVersion': appVersion,
      'storageAvailableBytes': storageAvailableBytes,
      'ramAvailableBytes': ramAvailableBytes,
      'batteryLevel': batteryLevel,
      'batteryState': batteryState,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }

  String toPrettyJson() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toJson());
  }

  /// Converts event payload to the database entity model `user_device_diagnostics`
  UserDeviceDiagnosticsEntity toEntity({
    String? id,
    String? osVersion,
    String? osBuild,
    bool isRooted = false,
    bool isDeveloperMode = false,
  }) {
    return UserDeviceDiagnosticsEntity(
      id: id ?? "diag_${DateTime.now().millisecondsSinceEpoch}",
      userId: userId,
      deviceId: deviceIdHash,
      device: device,
      model: model,
      brand: brand,
      manufacturer: manufacturer,
      appVersion: appVersion,
      storageAvailableBytes: storageAvailableBytes,
      ramAvailableBytes: ramAvailableBytes,
      batteryLevel: batteryLevel,
      batteryState: batteryState,
      osVersion: osVersion ?? brand,
      osBuild: osBuild ?? model,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
      capturedAt: timestamp,
    );
  }

  // --- Helper Getters for UI Presentation ---

  String get formattedRam => formattedAvailableRam;

  String get formattedAvailableRam {
    if (ramAvailableBytes <= 0) return "N/A";
    final gb = ramAvailableBytes / (1024 * 1024 * 1024);
    if (gb >= 1.0) {
      return "${gb.toStringAsFixed(2)} GB";
    }
    final mb = ramAvailableBytes / (1024 * 1024);
    return "${mb.toStringAsFixed(0)} MB";
  }

  String get formattedTotalRam {
    if (totalRamBytes <= 0) return "N/A";
    final gb = totalRamBytes / (1024 * 1024 * 1024);
    if (gb >= 1.0) {
      return "${gb.toStringAsFixed(2)} GB";
    }
    final mb = totalRamBytes / (1024 * 1024);
    return "${mb.toStringAsFixed(0)} MB";
  }

  String get formattedUsedRam {
    if (totalRamBytes <= 0 || ramAvailableBytes <= 0) return "N/A";
    final used = (totalRamBytes - ramAvailableBytes).clamp(0, totalRamBytes);
    final gb = used / (1024 * 1024 * 1024);
    if (gb >= 1.0) {
      return "${gb.toStringAsFixed(2)} GB";
    }
    final mb = used / (1024 * 1024);
    return "${mb.toStringAsFixed(0)} MB";
  }

  double get ramUsageRatio {
    if (totalRamBytes <= 0 || ramAvailableBytes <= 0) return 0.5;
    final used = (totalRamBytes - ramAvailableBytes).clamp(0, totalRamBytes);
    return (used / totalRamBytes).clamp(0.0, 1.0);
  }

  double get ramFreeRatio {
    if (totalRamBytes <= 0 || ramAvailableBytes <= 0) return 0.5;
    return (ramAvailableBytes / totalRamBytes).clamp(0.0, 1.0);
  }

  String get formattedStorage => formattedAvailableStorage;

  String get formattedAvailableStorage {
    if (storageAvailableBytes <= 0) return "N/A";
    if (storageAvailableBytes >= 1000 * 1000 * 1000) {
      final gb = storageAvailableBytes / (1000 * 1000 * 1000);
      return "${gb.toStringAsFixed(2)} GB";
    } else {
      final mb = storageAvailableBytes / (1000 * 1000);
      return "${mb.toStringAsFixed(0)} MB";
    }
  }

  String get formattedTotalStorage {
    if (totalStorageBytes <= 0) return "N/A";
    if (totalStorageBytes >= 1000 * 1000 * 1000) {
      final gb = totalStorageBytes / (1000 * 1000 * 1000);
      return "${gb.toStringAsFixed(0)} GB";
    } else {
      final mb = totalStorageBytes / (1000 * 1000);
      return "${mb.toStringAsFixed(0)} MB";
    }
  }

  String get formattedUsedStorage {
    if (totalStorageBytes <= 0 || storageAvailableBytes <= 0) return "N/A";
    final used = (totalStorageBytes - storageAvailableBytes).clamp(0, totalStorageBytes);
    if (used >= 1000 * 1000 * 1000) {
      final gb = used / (1000 * 1000 * 1000);
      return "${gb.toStringAsFixed(2)} GB";
    } else {
      final mb = used / (1000 * 1000);
      return "${mb.toStringAsFixed(0)} MB";
    }
  }

  double get storageUsageRatio {
    if (totalStorageBytes <= 0 || storageAvailableBytes <= 0) return 0.5;
    final used = (totalStorageBytes - storageAvailableBytes).clamp(0, totalStorageBytes);
    return (used / totalStorageBytes).clamp(0.0, 1.0);
  }

  double get storageFreeRatio {
    if (totalStorageBytes <= 0 || storageAvailableBytes <= 0) return 0.5;
    return (storageAvailableBytes / totalStorageBytes).clamp(0.0, 1.0);
  }

  String get maskedDeviceId {
    if (deviceIdHash.length <= 12) return deviceIdHash;
    final prefix = deviceIdHash.substring(0, 6);
    final suffix = deviceIdHash.substring(deviceIdHash.length - 6);
    return "$prefix••••••••••••••••$suffix";
  }

  String get maskedInstallationId {
    if (installationIdHash.length <= 10) return installationIdHash;
    final prefix = installationIdHash.substring(0, 6);
    final suffix = installationIdHash.substring(installationIdHash.length - 4);
    return "$prefix••••••••$suffix";
  }

  DeviceDiagnosticsEvent copyWith({
    String? event,
    String? userId,
    String? deviceIdHash,
    String? installationIdHash,
    String? device,
    String? model,
    String? brand,
    String? manufacturer,
    String? appVersion,
    int? storageAvailableBytes,
    int? totalStorageBytes,
    int? ramAvailableBytes,
    int? totalRamBytes,
    int? batteryLevel,
    String? batteryState,
    DateTime? timestamp,
  }) {
    return DeviceDiagnosticsEvent(
      event: event ?? this.event,
      userId: userId ?? this.userId,
      deviceIdHash: deviceIdHash ?? this.deviceIdHash,
      installationIdHash: installationIdHash ?? this.installationIdHash,
      device: device ?? this.device,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      appVersion: appVersion ?? this.appVersion,
      storageAvailableBytes: storageAvailableBytes ?? this.storageAvailableBytes,
      totalStorageBytes: totalStorageBytes ?? this.totalStorageBytes,
      ramAvailableBytes: ramAvailableBytes ?? this.ramAvailableBytes,
      totalRamBytes: totalRamBytes ?? this.totalRamBytes,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
