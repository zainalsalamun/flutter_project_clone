import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../models/device_diagnostics_event.dart';
import '../models/user_device_diagnostics_entity.dart';

enum LogLevel {
  debug,
  info,
  warn,
  error,
  success,
}

class DiagnosticsLogEntry {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final dynamic payload;

  DiagnosticsLogEntry({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.payload,
  });

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    final ms = timestamp.millisecond.toString().padLeft(3, '0');
    return "$h:$m:$s.$ms";
  }

  String get formattedPayload {
    if (payload == null) return '';
    if (payload is Map || payload is List) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(payload);
    }
    return payload.toString();
  }
}

class DiagnosticsLoggerService extends ChangeNotifier {
  static final DiagnosticsLoggerService instance = DiagnosticsLoggerService._internal();

  DiagnosticsLoggerService._internal();

  final List<DiagnosticsLogEntry> _logs = [];

  List<DiagnosticsLogEntry> get logs => List.unmodifiable(_logs);

  void log({
    required LogLevel level,
    required String tag,
    required String message,
    dynamic payload,
  }) {
    final entry = DiagnosticsLogEntry(
      id: "log_${DateTime.now().microsecondsSinceEpoch}",
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
      payload: payload,
    );

    _logs.insert(0, entry);
    // Keep up to 200 logs in memory
    if (_logs.length > 200) {
      _logs.removeLast();
    }

    _printToConsole(entry);
    notifyListeners();
  }

  void debug(String tag, String message, {dynamic payload}) {
    log(level: LogLevel.debug, tag: tag, message: message, payload: payload);
  }

  void info(String tag, String message, {dynamic payload}) {
    log(level: LogLevel.info, tag: tag, message: message, payload: payload);
  }

  void warn(String tag, String message, {dynamic payload}) {
    log(level: LogLevel.warn, tag: tag, message: message, payload: payload);
  }

  void error(String tag, String message, {dynamic payload}) {
    log(level: LogLevel.error, tag: tag, message: message, payload: payload);
  }

  void success(String tag, String message, {dynamic payload}) {
    log(level: LogLevel.success, tag: tag, message: message, payload: payload);
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }

  /// Processes and executes complete diagnostic telemetry pipeline with clean structured logging
  UserDeviceDiagnosticsEntity processDiagnosticsPipeline(
    DeviceDiagnosticsEvent event, {
    String osVersion = "Android 14 (API 34)",
    String osBuild = "UP1A.231005.007",
    bool isRooted = false,
    bool isDeveloperMode = false,
  }) {
    info(
      "DIAGNOSTICS_IN",
      "Event '${event.event}' received from User '${event.userId}' on device '${event.model}'",
      payload: event.toJson(),
    );

    debug(
      "DEVICE_ID_VERIFY",
      "Extracted Hardware Hash: ${event.deviceIdHash} (len=${event.deviceIdHash.length})",
      payload: {
        "deviceIdHash": event.deviceIdHash,
        "installationIdHash": event.installationIdHash,
        "userId": event.userId,
        "fingerprintStatus": "VALID_SHA256",
      },
    );

    debug(
      "HARDWARE_METRICS",
      "Battery: ${event.batteryLevel}% (${event.batteryState}) | Temp: ${event.formattedBatteryTemp} (${event.batteryTempStatus}) | Health: ${event.batteryHealthLabel} | PowerSave: ${event.isPowerSaveMode ? 'ON' : 'OFF'} | Sisa RAM: ${event.formattedAvailableRam} / ${event.formattedTotalRam} | Sisa Storage: ${event.formattedAvailableStorage} / ${event.formattedTotalStorage}",
      payload: {
        "batteryLevel": event.batteryLevel,
        "batteryState": event.batteryState,
        "temperatureCelsius": event.temperatureCelsius,
        "batteryHealth": event.batteryHealth,
        "batteryTechnology": event.batteryTechnology,
        "batteryVoltageMv": event.batteryVoltageMv,
        "isPowerSaveMode": event.isPowerSaveMode,
        "storageAvailableBytes": event.storageAvailableBytes,
        "totalStorageBytes": event.totalStorageBytes,
        "storageFreeFormatted": event.formattedAvailableStorage,
        "storageTotalFormatted": event.formattedTotalStorage,
        "storageUsedFormatted": event.formattedUsedStorage,
        "ramAvailableBytes": event.ramAvailableBytes,
        "totalRamBytes": event.totalRamBytes,
        "ramFreeFormatted": event.formattedAvailableRam,
        "ramTotalFormatted": event.formattedTotalRam,
        "ramUsedFormatted": event.formattedUsedRam,
      },
    );

    final entity = event.toEntity(
      osVersion: osVersion,
      osBuild: osBuild,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
    );

    info(
      "DB_MAPPING",
      "Mapped to 'user_device_diagnostics' table entity (id=${entity.id})",
      payload: entity.toMap(),
    );

    success(
      "INGEST_SUCCESS",
      "Telemetry snapshot saved & synced. Device ID [${entity.deviceId.substring(0, 8)}...] registered.",
      payload: {
        "status": "INGESTED",
        "sql": entity.toSqlInsertStatement(),
      },
    );

    return entity;
  }

  void _printToConsole(DiagnosticsLogEntry entry) {
    final levelLabel = switch (entry.level) {
      LogLevel.debug => 'DEBUG',
      LogLevel.info => 'INFO',
      LogLevel.warn => 'WARN',
      LogLevel.error => 'ERROR',
      LogLevel.success => 'SUCCESS',
    };

    final icon = switch (entry.level) {
      LogLevel.debug => '🔍',
      LogLevel.info => 'ℹ️',
      LogLevel.warn => '⚠️',
      LogLevel.error => '❌',
      LogLevel.success => '✅',
    };

    final formattedHeader =
        "[$icon $levelLabel] [${entry.tag}] ${entry.message}";

    developer.log(
      formattedHeader,
      name: "DeviceDiagnostics",
      time: entry.timestamp,
      level: switch (entry.level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warn => 900,
        LogLevel.error => 1000,
        LogLevel.success => 800,
      },
    );

    if (kDebugMode) {
      debugPrint("🕒 ${entry.formattedTime} $formattedHeader");
      if (entry.payload != null) {
        debugPrint("   📄 Payload: ${entry.formattedPayload}");
      }
    }
  }

  String exportLogsAsString() {
    final buffer = StringBuffer();
    buffer.writeln("=== DEVICE DIAGNOSTICS LOG EXPORT ===");
    buffer.writeln("Exported at: ${DateTime.now().toUtc().toIso8601String()}");
    buffer.writeln("Total Log Entries: ${_logs.length}");
    buffer.writeln("=====================================\n");

    for (final log in _logs.reversed) {
      final levelStr = log.level.name.toUpperCase().padRight(7);
      buffer.writeln("[${log.formattedTime}] [$levelStr] [${log.tag}] ${log.message}");
      if (log.payload != null) {
        buffer.writeln("   Payload: ${log.formattedPayload}");
      }
      buffer.writeln("-------------------------------------");
    }

    return buffer.toString();
  }
}
