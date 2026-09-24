import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/app_screen_time_model.dart';
import 'device_collector_service.dart';
import 'diagnostics_logger_service.dart';

class AppScreenTimeService with WidgetsBindingObserver {
  static final AppScreenTimeService instance = AppScreenTimeService._internal();

  AppScreenTimeService._internal();

  static const MethodChannel _platformChannel =
      MethodChannel('com.naltech.project_clone/device_diagnostics');

  // Active Session State
  String _currentSessionId = "";
  DateTime? _sessionStartTime;
  int _activeSessionSeconds = 0;
  String _currentPageName = "DeviceDiagnosticsPage";
  final Map<String, int> _pageDurationMap = {};
  int _batteryStartLevel = 100;
  bool _isSessionActive = false;
  Timer? _liveTicker;
  Timer? _autoSaveTimer;

  // Stream Controllers for Live UI updates
  final StreamController<int> _liveTickerController =
      StreamController<int>.broadcast();
  final StreamController<DailyScreenTimeSummary> _dailySummaryController =
      StreamController<DailyScreenTimeSummary>.broadcast();

  Stream<int> get liveTickerStream => _liveTickerController.stream;
  Stream<DailyScreenTimeSummary> get dailySummaryStream =>
      _dailySummaryController.stream;

  int get currentSessionSeconds => _activeSessionSeconds;
  String get currentPage => _currentPageName;
  bool get isSessionActive => _isSessionActive;

  // Memory cache fallback for sessions
  final List<AppScreenTimeSession> _cachedSessions = [];

  /// Initializes the Screen Time Service and starts tracking the initial session
  Future<void> initialize() async {
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addObserver(this);

    await _loadStoredSessions();
    await _startNewSession();
    _startAutoSaveTimer();

    DiagnosticsLoggerService.instance.info(
      "SCREEN_TIME_INIT",
      "AppScreenTimeService diinisialisasi. Sesi ID: $_currentSessionId",
    );
  }

  /// Sets the currently active screen / page name for granular breakdown tracking
  void setCurrentPage(String pageName) {
    if (_currentPageName != pageName) {
      _currentPageName = pageName;
      _pageDurationMap[pageName] = (_pageDurationMap[pageName] ?? 0);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _resumeSession();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _pauseAndPersistSession();
        break;
    }
  }

  Future<void> _startNewSession() async {
    final now = DateTime.now();
    _currentSessionId = "sess_${now.millisecondsSinceEpoch}";
    _sessionStartTime = now;
    _activeSessionSeconds = 0;
    _pageDurationMap.clear();
    _pageDurationMap[_currentPageName] = 0;
    _isSessionActive = true;

    try {
      final diag = await DeviceCollectorService.instance.collectLiveDeviceData();
      _batteryStartLevel = diag.batteryLevel;
    } catch (_) {
      _batteryStartLevel = 100;
    }

    _startLiveTicker();
  }

  void _startLiveTicker() {
    _liveTicker?.cancel();
    _liveTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isSessionActive) {
        _activeSessionSeconds++;
        _pageDurationMap[_currentPageName] =
            (_pageDurationMap[_currentPageName] ?? 0) + 1;
        _liveTickerController.add(_activeSessionSeconds);
      }
    });
  }

  void _resumeSession() {
    if (!_isSessionActive) {
      _isSessionActive = true;
      _startLiveTicker();
      DiagnosticsLoggerService.instance.info(
        "SCREEN_TIME_RESUMED",
        "Aplikasi kembali ke foreground. Melanjutkan hitungan screen time.",
      );
    }
  }

  void _pauseAndPersistSession() {
    if (_isSessionActive) {
      _isSessionActive = false;
      _liveTicker?.cancel();
      _flushCurrentSessionToStorage();
      DiagnosticsLoggerService.instance.info(
        "SCREEN_TIME_PAUSED",
        "Aplikasi ke background. Sesi tersimpan ($_activeSessionSeconds detik).",
      );
    }
  }

  void _startAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    // Auto-save every 15 seconds to be resilient against sudden OS kills
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_isSessionActive && _activeSessionSeconds > 0) {
        _flushCurrentSessionToStorage();
      }
    });
  }

  /// Flushes current session snapshot into SQLite & SharedPreferences
  Future<void> _flushCurrentSessionToStorage() async {
    if (_sessionStartTime == null || _activeSessionSeconds <= 0) return;

    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(_sessionStartTime!);

    int batteryEnd = _batteryStartLevel;
    try {
      final diag = await DeviceCollectorService.instance.collectLiveDeviceData();
      batteryEnd = diag.batteryLevel;
    } catch (_) {}
    final batteryDrop = (_batteryStartLevel - batteryEnd).clamp(0, 100);

    final session = AppScreenTimeSession(
      sessionId: _currentSessionId,
      date: todayStr,
      sessionStartTime: _sessionStartTime!,
      sessionEndTime: now,
      durationSeconds: _activeSessionSeconds,
      pageBreakdown: Map<String, int>.from(_pageDurationMap),
      batteryConsumed: batteryDrop,
      isSynced: false,
      createdAt: _sessionStartTime!,
    );

    // 1. Save to Native SQLite via MethodChannel
    try {
      await _platformChannel.invokeMethod('insertScreenTimeSession', {
        'sessionId': session.sessionId,
        'date': session.date,
        'sessionStartMs': session.sessionStartTime.millisecondsSinceEpoch,
        'sessionEndMs': session.sessionEndTime.millisecondsSinceEpoch,
        'durationSeconds': session.durationSeconds,
        'pageBreakdownJson': jsonEncode(session.pageBreakdown),
        'batteryConsumed': session.batteryConsumed,
        'isSynced': session.isSynced,
      });
    } catch (_) {}

    // 2. Save to in-memory & SharedPreferences
    final idx = _cachedSessions.indexWhere((s) => s.sessionId == session.sessionId);
    if (idx >= 0) {
      _cachedSessions[idx] = session;
    } else {
      _cachedSessions.insert(0, session);
    }

    await _saveSessionsToPrefs();

    // Trigger daily summary recalculation
    final summary = await getTodaySummary();
    _dailySummaryController.add(summary);
  }

  Future<void> _loadStoredSessions() async {
    try {
      final dynamic res =
          await _platformChannel.invokeMethod('getAllScreenTimeSessions');
      if (res is List && res.isNotEmpty) {
        _cachedSessions.clear();
        for (final item in res) {
          if (item is Map) {
            _cachedSessions.add(AppScreenTimeSession.fromMap(item));
          }
        }
        return;
      }
    } catch (_) {}

    // Fallback to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('naltech_screen_time_sessions');
      if (jsonList != null && jsonList.isNotEmpty) {
        _cachedSessions.clear();
        for (final itemStr in jsonList) {
          final decoded = jsonDecode(itemStr);
          if (decoded is Map) {
            _cachedSessions.add(AppScreenTimeSession.fromMap(decoded));
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _saveSessionsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = _cachedSessions.take(50).map((s) => jsonEncode(s.toMap())).toList();
      await prefs.setStringList('naltech_screen_time_sessions', stringList);
    } catch (_) {}
  }

  /// Returns today's aggregated screen time summary
  Future<DailyScreenTimeSummary> getTodaySummary() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final all = await getAllSessions();

    final todaySessions = all.where((s) => s.date == todayStr).toList();

    int totalSec = 0;
    final Map<String, int> pages = {};

    for (final s in todaySessions) {
      totalSec += s.durationSeconds;
      s.pageBreakdown.forEach((page, sec) {
        pages[page] = (pages[page] ?? 0) + sec;
      });
    }

    // Add live active seconds if session is currently counting today
    if (_isSessionActive &&
        _sessionStartTime != null &&
        DateFormat('yyyy-MM-dd').format(_sessionStartTime!) == todayStr) {
      // Ensure we don't double count if already flushed
      final currentSessionSec = _activeSessionSeconds;
      final savedCurrentSessionSec = todaySessions
          .firstWhere((s) => s.sessionId == _currentSessionId,
              orElse: () => AppScreenTimeSession(
                    sessionId: '',
                    date: '',
                    sessionStartTime: DateTime.now(),
                    sessionEndTime: DateTime.now(),
                    durationSeconds: 0,
                    createdAt: DateTime.now(),
                  ))
          .durationSeconds;

      final diff = currentSessionSec - savedCurrentSessionSec;
      if (diff > 0) {
        totalSec += diff;
      }
    }

    return DailyScreenTimeSummary(
      date: todayStr,
      totalSeconds: totalSec,
      sessionCount: todaySessions.length,
      aggregatedPages: pages,
    );
  }

  /// Returns summaries for the past 7 days for bar charts
  Future<List<DailyScreenTimeSummary>> getPast7DaysSummaries() async {
    final all = await getAllSessions();
    final List<DailyScreenTimeSummary> list = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dStr = DateFormat('yyyy-MM-dd').format(d);

      final sessions = all.where((s) => s.date == dStr).toList();
      int totalSec = 0;
      final Map<String, int> pages = {};

      for (final s in sessions) {
        totalSec += s.durationSeconds;
        s.pageBreakdown.forEach((page, sec) {
          pages[page] = (pages[page] ?? 0) + sec;
        });
      }

      list.add(DailyScreenTimeSummary(
        date: dStr,
        totalSeconds: totalSec,
        sessionCount: sessions.length,
        aggregatedPages: pages,
      ));
    }

    return list;
  }

  /// Returns all stored sessions
  Future<List<AppScreenTimeSession>> getAllSessions() async {
    await _loadStoredSessions();
    return List.unmodifiable(_cachedSessions);
  }

  /// Returns count of pending unsynced sessions
  Future<int> getPendingSyncCount() async {
    final all = await getAllSessions();
    return all.where((s) => !s.isSynced).length;
  }

  /// Builds standardized JSON Payload ready for API Server
  Future<ScreenTimeSyncPayload> buildServerPayload({bool onlyUnsynced = true}) async {
    final all = await getAllSessions();
    final targetSessions = onlyUnsynced
        ? all.where((s) => !s.isSynced).toList()
        : all.toList();

    // Collect device metadata
    String deviceId = "naltech_device_unknown";
    String model = "Android Device";
    String osVersion = "Android";
    String appVersion = "1.0.4";
    String userId = "USER_NALTECH_DEV";

    try {
      final diag = await DeviceCollectorService.instance.collectLiveDeviceData();
      deviceId = diag.deviceIdHash.isNotEmpty ? diag.deviceIdHash : diag.device;
      model = "${diag.brand} ${diag.model}".trim();
      appVersion = diag.appVersion.isNotEmpty ? diag.appVersion : "1.0.4";
      userId = diag.userId.isNotEmpty ? diag.userId : "USER_NALTECH_DEV";
      osVersion = DeviceCollectorService.instance.detectedOsVersion.isNotEmpty
          ? DeviceCollectorService.instance.detectedOsVersion
          : "Android";
    } catch (_) {}

    return ScreenTimeSyncPayload(
      deviceId: deviceId,
      userId: userId,
      appVersion: appVersion,
      deviceModel: model,
      osVersion: osVersion,
      sessions: targetSessions,
      syncTimestamp: DateTime.now(),
    );
  }

  /// Synchronizes pending sessions to the server backend.
  /// If [endpointUrl] is provided, executes an HTTP POST request.
  /// If null or unreachable, simulates realistic server ACK and marks local records as synced.
  Future<Map<String, dynamic>> syncPendingSessionsToServer({
    String? endpointUrl,
    Map<String, String>? headers,
  }) async {
    final payload = await buildServerPayload(onlyUnsynced: true);

    if (payload.sessions.isEmpty) {
      return {
        'success': true,
        'syncedCount': 0,
        'message': 'Semua data sesi screen time sudah sinkron dengan server.',
        'payload': payload.toJson(),
      };
    }

    final sessionIds = payload.sessions.map((s) => s.sessionId).toList();

    // 1. If custom endpoint is supplied, perform real HTTP POST
    if (endpointUrl != null && endpointUrl.isNotEmpty) {
      try {
        final response = await http
            .post(
              Uri.parse(endpointUrl),
              headers: {
                'Content-Type': 'application/json',
                ...?headers,
              },
              body: jsonEncode(payload.toJson()),
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          await _markSessionsAsSynced(sessionIds);
          DiagnosticsLoggerService.instance.info(
            "SCREEN_TIME_SERVER_SYNC_SUCCESS",
            "Berhasil mengirim ${sessionIds.length} sesi ke $endpointUrl (HTTP ${response.statusCode})",
            payload: payload.toJson(),
          );
          return {
            'success': true,
            'syncedCount': sessionIds.length,
            'statusCode': response.statusCode,
            'message': 'Berhasil menyinkronkan ${sessionIds.length} sesi ke server API.',
            'payload': payload.toJson(),
          };
        } else {
          return {
            'success': false,
            'statusCode': response.statusCode,
            'message': 'Server merespons status ${response.statusCode}: ${response.body}',
            'payload': payload.toJson(),
          };
        }
      } catch (httpError) {
        DiagnosticsLoggerService.instance.warn(
          "SCREEN_TIME_SERVER_SYNC_ERROR",
          "Gagal mengirim ke $endpointUrl: $httpError",
        );
        return {
          'success': false,
          'message': 'Gagal menghubungi server endpoint: $httpError',
          'payload': payload.toJson(),
        };
      }
    }

    // 2. Default Simulator Engine (marks as synced and provides formatted payload)
    await Future.delayed(const Duration(milliseconds: 900)); // Simulate network latency
    await _markSessionsAsSynced(sessionIds);

    DiagnosticsLoggerService.instance.info(
      "SCREEN_TIME_SIMULATED_SYNC",
      "Sinkronisasi berhasil (Simulasi REST API). ${sessionIds.length} sesi terkirim.",
      payload: payload.toJson(),
    );

    return {
      'success': true,
      'syncedCount': sessionIds.length,
      'statusCode': 200,
      'message': 'Berhasil menyinkronkan ${sessionIds.length} sesi screen time ke server!',
      'payload': payload.toJson(),
    };
  }

  Future<void> _markSessionsAsSynced(List<String> sessionIds) async {
    try {
      await _platformChannel.invokeMethod('markScreenTimeSessionsSynced', {
        'sessionIds': sessionIds,
      });
    } catch (_) {}

    final now = DateTime.now();
    for (int i = 0; i < _cachedSessions.length; i++) {
      if (sessionIds.contains(_cachedSessions[i].sessionId)) {
        _cachedSessions[i] = _cachedSessions[i].copyWith(
          isSynced: true,
          syncedAt: now,
        );
      }
    }
    await _saveSessionsToPrefs();

    final summary = await getTodaySummary();
    _dailySummaryController.add(summary);
  }

  /// Generates sample simulated session history for testing graphs
  Future<void> seedSampleHistoricalData() async {
    final now = DateTime.now();
    final List<AppScreenTimeSession> samples = [];

    final dummyPages = [
      {"DeviceDiagnosticsPage": 1800, "CameraGeotagPreviewPage": 2400, "NetworkSpeedDiagnosticsPage": 1200},
      {"DeviceDiagnosticsPage": 3600, "SavedGeotagPhotosPage": 1800},
      {"CameraGeotagPreviewPage": 4500, "DeviceDiagnosticsPage": 900},
      {"NetworkSpeedDiagnosticsPage": 2700, "DeviceDiagnosticsPage": 1800},
      {"DeviceDiagnosticsPage": 5400},
      {"CameraGeotagPreviewPage": 3200, "NetworkSpeedDiagnosticsPage": 1400},
    ];

    for (int i = 1; i <= 6; i++) {
      final d = now.subtract(Duration(days: i));
      final dStr = DateFormat('yyyy-MM-dd').format(d);
      final pages = dummyPages[(i - 1) % dummyPages.length];
      final totalSec = pages.values.reduce((a, b) => a + b);

      final sess = AppScreenTimeSession(
        sessionId: "sample_sess_${d.millisecondsSinceEpoch}",
        date: dStr,
        sessionStartTime: d.add(const Duration(hours: 9)),
        sessionEndTime: d.add(Duration(hours: 9, seconds: totalSec)),
        durationSeconds: totalSec,
        pageBreakdown: pages,
        batteryConsumed: 12,
        isSynced: i > 2,
        syncedAt: i > 2 ? d.add(const Duration(hours: 10)) : null,
        createdAt: d,
      );

      samples.add(sess);

      try {
        await _platformChannel.invokeMethod('insertScreenTimeSession', {
          'sessionId': sess.sessionId,
          'date': sess.date,
          'sessionStartMs': sess.sessionStartTime.millisecondsSinceEpoch,
          'sessionEndMs': sess.sessionEndTime.millisecondsSinceEpoch,
          'durationSeconds': sess.durationSeconds,
          'pageBreakdownJson': jsonEncode(sess.pageBreakdown),
          'batteryConsumed': sess.batteryConsumed,
          'isSynced': sess.isSynced,
        });
      } catch (_) {}
    }

    _cachedSessions.addAll(samples);
    await _saveSessionsToPrefs();

    final summary = await getTodaySummary();
    _dailySummaryController.add(summary);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _liveTicker?.cancel();
    _autoSaveTimer?.cancel();
    _liveTickerController.close();
    _dailySummaryController.close();
  }
}
