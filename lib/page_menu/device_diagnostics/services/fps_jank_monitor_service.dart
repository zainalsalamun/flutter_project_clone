import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../models/fps_jank_metrics_model.dart';
import 'diagnostics_logger_service.dart';

class FpsJankMonitorService {
  static final FpsJankMonitorService instance =
      FpsJankMonitorService._internal();

  FpsJankMonitorService._internal();

  bool _isMonitoring = false;
  double _targetRefreshRate = 60.0;

  final List<FrameTimingData> _recentFrames = [];
  final List<DateTime> _frameTimestamps = [];

  int _totalRecordedFrames = 0;
  int _jankFramesCount = 0;
  int _severeJankFramesCount = 0;
  double _maxFrameDurationMs = 0.0;
  double _currentFps = 60.0;
  double _averageFps = 60.0;

  Timer? _emitTimer;

  final StreamController<FpsPerformanceSnapshot> _snapshotController =
      StreamController<FpsPerformanceSnapshot>.broadcast();

  Stream<FpsPerformanceSnapshot> get snapshotStream =>
      _snapshotController.stream;

  bool get isMonitoring => _isMonitoring;
  double get currentFps => _currentFps;
  double get targetRefreshRate => _targetRefreshRate;

  /// Starts monitoring UI frame timings from Flutter's SchedulerBinding
  void startMonitoring({double? customRefreshRate}) {
    if (_isMonitoring) return;

    _targetRefreshRate = customRefreshRate ?? _detectDisplayRefreshRate();
    _isMonitoring = true;

    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);

    // Periodic emitter for UI updates (every 400ms)
    _emitTimer?.cancel();
    _emitTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      _computeAndEmitSnapshot();
    });

    DiagnosticsLoggerService.instance.info(
      "FPS_MONITOR_START",
      "Real-time FPS & Frame Drop Monitor aktif (Target: ${_targetRefreshRate.toInt()} Hz)",
    );
  }

  /// Stops monitoring frame timings
  void stopMonitoring() {
    if (!_isMonitoring) return;
    _isMonitoring = false;

    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
    _emitTimer?.cancel();

    DiagnosticsLoggerService.instance.info(
      "FPS_MONITOR_STOP",
      "FPS Monitor dinonaktifkan.",
    );
  }

  /// Resets statistical accumulators (total frames, jank counters, max latency)
  void resetStats() {
    _totalRecordedFrames = 0;
    _jankFramesCount = 0;
    _severeJankFramesCount = 0;
    _maxFrameDurationMs = 0.0;
    _recentFrames.clear();
    _frameTimestamps.clear();
    _currentFps = _targetRefreshRate;
    _averageFps = _targetRefreshRate;
    _computeAndEmitSnapshot();
  }

  void _onFrameTimings(List<FrameTiming> timings) {
    if (!_isMonitoring) return;

    final now = DateTime.now();
    final jankThresholdMs = 1000.0 / _targetRefreshRate + 1.0;
    final severeJankThresholdMs = (1000.0 / _targetRefreshRate) * 2.0;

    for (final timing in timings) {
      final buildMs = timing.buildDuration.inMicroseconds / 1000.0;
      final rasterMs = timing.rasterDuration.inMicroseconds / 1000.0;
      final totalMs = timing.totalSpan.inMicroseconds / 1000.0;

      final isJank = totalMs > jankThresholdMs;
      final isSevere = totalMs > severeJankThresholdMs;

      _totalRecordedFrames++;
      if (isJank) _jankFramesCount++;
      if (isSevere) _severeJankFramesCount++;
      if (totalMs > _maxFrameDurationMs) _maxFrameDurationMs = totalMs;

      final frameData = FrameTimingData(
        buildDurationMs: buildMs,
        rasterDurationMs: rasterMs,
        totalDurationMs: totalMs,
        isJank: isJank,
        isSevereJank: isSevere,
        timestamp: now,
      );

      _recentFrames.add(frameData);
      if (_recentFrames.length > 50) {
        _recentFrames.removeAt(0);
      }

      _frameTimestamps.add(now);
    }

    // Keep only timestamps within the last 1.5 seconds for instant FPS computation
    final cutoff = now.subtract(const Duration(milliseconds: 1500));
    _frameTimestamps.removeWhere((t) => t.isBefore(cutoff));
  }

  void _computeAndEmitSnapshot() {
    final now = DateTime.now();

    // 1. Calculate Instantaneous FPS based on frames in the last 1 second
    final oneSecAgo = now.subtract(const Duration(seconds: 1));
    final framesInLastSec = _frameTimestamps.where((t) => t.isAfter(oneSecAgo)).length;

    if (framesInLastSec > 0) {
      _currentFps = framesInLastSec.toDouble().clamp(0.0, _targetRefreshRate + 5.0);
    } else {
      // If no new frames were scheduled (idle screen), FPS is nominally at target rate
      _currentFps = _targetRefreshRate;
    }

    // 2. Compute Average FPS
    if (_totalRecordedFrames > 0 && _recentFrames.isNotEmpty) {
      final recentJankRatio = _recentFrames.where((f) => f.isJank).length /
          _recentFrames.length.toDouble();
      _averageFps = (_targetRefreshRate * (1.0 - recentJankRatio * 0.5))
          .clamp(15.0, _targetRefreshRate);
    } else {
      _averageFps = _targetRefreshRate;
    }

    final snapshot = FpsPerformanceSnapshot(
      currentFps: _currentFps,
      averageFps: _averageFps,
      totalFramesRecorded: _totalRecordedFrames,
      jankFramesCount: _jankFramesCount,
      severeJankFramesCount: _severeJankFramesCount,
      maxFrameDurationMs: _maxFrameDurationMs,
      targetRefreshRate: _targetRefreshRate,
      recentFrames: List.unmodifiable(_recentFrames),
      snapshotTime: now,
    );

    _snapshotController.add(snapshot);
  }

  double _detectDisplayRefreshRate() {
    try {
      final views = WidgetsBinding.instance.platformDispatcher.views;
      if (views.isNotEmpty) {
        final rate = views.first.display.refreshRate;
        if (rate > 0) return rate;
      }
    } catch (_) {}
    return 60.0;
  }

  void dispose() {
    stopMonitoring();
    _snapshotController.close();
  }
}
