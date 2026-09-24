import 'dart:convert';
import 'package:intl/intl.dart';

/// Represents a single in-app foreground usage session
class AppScreenTimeSession {
  final int? id; // SQLite autoincrement ID
  final String sessionId;
  final String date; // YYYY-MM-DD
  final DateTime sessionStartTime;
  final DateTime sessionEndTime;
  final int durationSeconds;
  final Map<String, int> pageBreakdown; // e.g. {"DeviceDiagnostics": 120, "CameraGeotag": 300}
  final int batteryConsumed; // % battery dropped during session
  final bool isSynced;
  final DateTime? syncedAt;
  final DateTime createdAt;

  const AppScreenTimeSession({
    this.id,
    required this.sessionId,
    required this.date,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.durationSeconds,
    this.pageBreakdown = const {},
    this.batteryConsumed = 0,
    this.isSynced = false,
    this.syncedAt,
    required this.createdAt,
  });

  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;

    if (hours > 0) {
      return "${hours}j ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s";
    } else if (minutes > 0) {
      return "${minutes}m ${seconds.toString().padLeft(2, '0')}s";
    } else {
      return "${seconds}s";
    }
  }

  String get formattedTimeRange {
    final fmt = DateFormat('HH:mm:ss');
    return "${fmt.format(sessionStartTime.toLocal())} - ${fmt.format(sessionEndTime.toLocal())}";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'date': date,
      'sessionStartMs': sessionStartTime.millisecondsSinceEpoch,
      'sessionEndMs': sessionEndTime.millisecondsSinceEpoch,
      'durationSeconds': durationSeconds,
      'pageBreakdownJson': jsonEncode(pageBreakdown),
      'batteryConsumed': batteryConsumed,
      'isSynced': isSynced ? 1 : 0,
      'syncedAtMs': syncedAt?.millisecondsSinceEpoch ?? 0,
      'createdAtMs': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AppScreenTimeSession.fromMap(Map<dynamic, dynamic> map) {
    Map<String, int> pages = {};
    if (map['pageBreakdownJson'] != null && map['pageBreakdownJson'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(map['pageBreakdownJson'].toString());
        if (decoded is Map) {
          pages = decoded.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
        }
      } catch (_) {}
    }

    final startMs = (map['sessionStartMs'] as num?)?.toInt() ?? 0;
    final endMs = (map['sessionEndMs'] as num?)?.toInt() ?? 0;
    final syncedAtMs = (map['syncedAtMs'] as num?)?.toInt() ?? 0;
    final createdMs = (map['createdAtMs'] as num?)?.toInt() ?? 0;

    return AppScreenTimeSession(
      id: (map['id'] as num?)?.toInt(),
      sessionId: map['sessionId']?.toString() ?? '',
      date: map['date']?.toString() ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      sessionStartTime: DateTime.fromMillisecondsSinceEpoch(startMs > 0 ? startMs : DateTime.now().millisecondsSinceEpoch),
      sessionEndTime: DateTime.fromMillisecondsSinceEpoch(endMs > 0 ? endMs : DateTime.now().millisecondsSinceEpoch),
      durationSeconds: (map['durationSeconds'] as num?)?.toInt() ?? 0,
      pageBreakdown: pages,
      batteryConsumed: (map['batteryConsumed'] as num?)?.toInt() ?? 0,
      isSynced: map['isSynced'] == 1 || map['isSynced'] == true,
      syncedAt: syncedAtMs > 0 ? DateTime.fromMillisecondsSinceEpoch(syncedAtMs) : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMs > 0 ? createdMs : DateTime.now().millisecondsSinceEpoch),
    );
  }

  AppScreenTimeSession copyWith({
    int? id,
    String? sessionId,
    String? date,
    DateTime? sessionStartTime,
    DateTime? sessionEndTime,
    int? durationSeconds,
    Map<String, int>? pageBreakdown,
    int? batteryConsumed,
    bool? isSynced,
    DateTime? syncedAt,
    DateTime? createdAt,
  }) {
    return AppScreenTimeSession(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      date: date ?? this.date,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionEndTime: sessionEndTime ?? this.sessionEndTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      pageBreakdown: pageBreakdown ?? this.pageBreakdown,
      batteryConsumed: batteryConsumed ?? this.batteryConsumed,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Aggregated daily summary of app screen time
class DailyScreenTimeSummary {
  final String date; // YYYY-MM-DD
  final int totalSeconds;
  final int sessionCount;
  final Map<String, int> aggregatedPages;

  const DailyScreenTimeSummary({
    required this.date,
    required this.totalSeconds,
    required this.sessionCount,
    this.aggregatedPages = const {},
  });

  String get formattedTotalDuration {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return "${hours} Jam ${minutes.toString().padLeft(2, '0')} Menit";
    } else if (minutes > 0) {
      return "${minutes} Menit ${seconds.toString().padLeft(2, '0')} Detik";
    } else {
      return "${seconds} Detik";
    }
  }

  String get formattedShortDuration {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return "${hours}j ${minutes}m";
    }
    return "${minutes}m";
  }

  double get totalHours => totalSeconds / 3600.0;
  double get totalMinutes => totalSeconds / 60.0;
}

/// Standardized JSON Payload structure for Backend API Server sync
class ScreenTimeSyncPayload {
  final String deviceId;
  final String userId;
  final String appVersion;
  final String deviceModel;
  final String osVersion;
  final List<AppScreenTimeSession> sessions;
  final DateTime syncTimestamp;

  const ScreenTimeSyncPayload({
    required this.deviceId,
    required this.userId,
    required this.appVersion,
    required this.deviceModel,
    required this.osVersion,
    required this.sessions,
    required this.syncTimestamp,
  });

  int get totalSessionsCount => sessions.length;
  int get totalTrackedSeconds =>
      sessions.fold(0, (acc, s) => acc + s.durationSeconds);

  Map<String, dynamic> toJson() {
    return {
      'sync_metadata': {
        'sync_id': 'sync_${syncTimestamp.millisecondsSinceEpoch}',
        'sync_timestamp': syncTimestamp.toUtc().toIso8601String(),
        'device_id': deviceId,
        'user_id': userId,
        'app_version': appVersion,
        'device_model': deviceModel,
        'os_version': osVersion,
        'payload_type': 'APP_SCREEN_TIME_DIAGNOSTICS',
      },
      'summary': {
        'total_sessions': totalSessionsCount,
        'total_duration_seconds': totalTrackedSeconds,
        'formatted_total_duration': _formatSeconds(totalTrackedSeconds),
      },
      'sessions': sessions.map((s) {
        return {
          'session_id': s.sessionId,
          'date': s.date,
          'session_start_time': s.sessionStartTime.toUtc().toIso8601String(),
          'session_end_time': s.sessionEndTime.toUtc().toIso8601String(),
          'duration_seconds': s.durationSeconds,
          'formatted_duration': s.formattedDuration,
          'page_breakdown': s.pageBreakdown,
          'battery_consumed_percent': s.batteryConsumed,
        };
      }).toList(),
    };
  }

  String toPrettyJson() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  static String _formatSeconds(int sec) {
    final h = sec ~/ 3600;
    final m = (sec % 3600) ~/ 60;
    final s = sec % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }
}
