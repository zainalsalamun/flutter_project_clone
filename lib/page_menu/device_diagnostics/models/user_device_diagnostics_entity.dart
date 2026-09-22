import 'dart:convert';

/// Entity representing the `user_device_diagnostics` database table
class UserDeviceDiagnosticsEntity {
  final String id;
  final String userId;
  final String deviceId;
  final String device;
  final String model;
  final String brand;
  final String manufacturer;
  final String appVersion;
  final int storageAvailableBytes;
  final int ramAvailableBytes;
  final int batteryLevel;
  final String batteryState;
  final String osVersion;
  final String osBuild;
  final bool isRooted;
  final bool isDeveloperMode;
  final DateTime capturedAt;

  const UserDeviceDiagnosticsEntity({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.device,
    required this.model,
    required this.brand,
    required this.manufacturer,
    required this.appVersion,
    required this.storageAvailableBytes,
    required this.ramAvailableBytes,
    required this.batteryLevel,
    required this.batteryState,
    required this.osVersion,
    required this.osBuild,
    required this.isRooted,
    required this.isDeveloperMode,
    required this.capturedAt,
  });

  factory UserDeviceDiagnosticsEntity.fromMap(Map<String, dynamic> map) {
    return UserDeviceDiagnosticsEntity(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      deviceId: map['device_id']?.toString() ?? '',
      device: map['device']?.toString() ?? '',
      model: map['model']?.toString() ?? '',
      brand: map['brand']?.toString() ?? '',
      manufacturer: map['manufacturer']?.toString() ?? '',
      appVersion: map['app_version']?.toString() ?? '',
      storageAvailableBytes: (map['storage_available_bytes'] as num?)?.toInt() ?? 0,
      ramAvailableBytes: (map['ram_available_bytes'] as num?)?.toInt() ?? 0,
      batteryLevel: (map['battery_level'] as num?)?.toInt() ?? 0,
      batteryState: map['battery_state']?.toString() ?? 'unknown',
      osVersion: map['os_version']?.toString() ?? 'unknown',
      osBuild: map['os_build']?.toString() ?? 'unknown',
      isRooted: map['is_rooted'] == true || map['is_rooted'] == 1,
      isDeveloperMode:
          map['is_developer_mode'] == true || map['is_developer_mode'] == 1,
      capturedAt: map['captured_at'] != null
          ? DateTime.tryParse(map['captured_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'device': device,
      'model': model,
      'brand': brand,
      'manufacturer': manufacturer,
      'app_version': appVersion,
      'storage_available_bytes': storageAvailableBytes,
      'ram_available_bytes': ramAvailableBytes,
      'battery_level': batteryLevel,
      'battery_state': batteryState,
      'os_version': osVersion,
      'os_build': osBuild,
      'is_rooted': isRooted,
      'is_developer_mode': isDeveloperMode,
      'captured_at': capturedAt.toUtc().toIso8601String(),
    };
  }

  String toPrettyJson() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toMap());
  }

  /// Generates executable SQL INSERT statement for debugging and database seeding
  String toSqlInsertStatement() {
    return '''
INSERT INTO user_device_diagnostics (
  id, user_id, device_id, device, model, brand, manufacturer,
  app_version, storage_available_bytes, ram_available_bytes,
  battery_level, battery_state, os_version, os_build,
  is_rooted, is_developer_mode, captured_at
) VALUES (
  '$id',
  '$userId',
  '$deviceId',
  '$device',
  '$model',
  '$brand',
  '$manufacturer',
  '$appVersion',
  $storageAvailableBytes,
  $ramAvailableBytes,
  $batteryLevel,
  '$batteryState',
  '$osVersion',
  '$osBuild',
  $isRooted,
  $isDeveloperMode,
  '${capturedAt.toUtc().toIso8601String()}'
);''';
  }

  static String get tableSchemaSql => '''
CREATE TABLE user_device_diagnostics (
  id VARCHAR(64) PRIMARY KEY,
  user_id VARCHAR(64) NOT NULL,
  device_id VARCHAR(128) NOT NULL,
  device VARCHAR(64),
  model VARCHAR(64),
  brand VARCHAR(64),
  manufacturer VARCHAR(64),
  app_version VARCHAR(32),
  storage_available_bytes BIGINT,
  ram_available_bytes BIGINT,
  battery_level INT,
  battery_state VARCHAR(32),
  os_version VARCHAR(64),
  os_build VARCHAR(64),
  is_rooted BOOLEAN DEFAULT FALSE,
  is_developer_mode BOOLEAN DEFAULT FALSE,
  captured_at TIMESTAMP WITH TIME ZONE NOT NULL
);
CREATE INDEX idx_user_device_diagnostics_device_id ON user_device_diagnostics(device_id);
CREATE INDEX idx_user_device_diagnostics_user_id ON user_device_diagnostics(user_id);
''';
}
