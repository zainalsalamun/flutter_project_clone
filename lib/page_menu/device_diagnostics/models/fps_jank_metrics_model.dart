/// Represents the render duration and status of a single frame
class FrameTimingData {
  final double buildDurationMs;
  final double rasterDurationMs;
  final double totalDurationMs;
  final bool isJank; // Frame took > 16.6ms (dropped frame)
  final bool isSevereJank; // Frame took > 33.3ms (multiple frames dropped)
  final DateTime timestamp;

  const FrameTimingData({
    required this.buildDurationMs,
    required this.rasterDurationMs,
    required this.totalDurationMs,
    required this.isJank,
    required this.isSevereJank,
    required this.timestamp,
  });
}

/// Represents an aggregated performance snapshot of FPS and UI smoothness
class FpsPerformanceSnapshot {
  final double currentFps;
  final double averageFps;
  final int totalFramesRecorded;
  final int jankFramesCount;
  final int severeJankFramesCount;
  final double maxFrameDurationMs;
  final double targetRefreshRate; // e.g. 60.0, 90.0, 120.0
  final List<FrameTimingData> recentFrames;
  final DateTime snapshotTime;

  const FpsPerformanceSnapshot({
    required this.currentFps,
    required this.averageFps,
    required this.totalFramesRecorded,
    required this.jankFramesCount,
    required this.severeJankFramesCount,
    required this.maxFrameDurationMs,
    this.targetRefreshRate = 60.0,
    required this.recentFrames,
    required this.snapshotTime,
  });

  factory FpsPerformanceSnapshot.initial({double targetRate = 60.0}) {
    return FpsPerformanceSnapshot(
      currentFps: targetRate,
      averageFps: targetRate,
      totalFramesRecorded: 0,
      jankFramesCount: 0,
      severeJankFramesCount: 0,
      maxFrameDurationMs: 0.0,
      targetRefreshRate: targetRate,
      recentFrames: const [],
      snapshotTime: DateTime.now(),
    );
  }

  /// Percentage of frames that were dropped/janky (0.0 to 100.0%)
  double get jankPercentage {
    if (totalFramesRecorded <= 0) return 0.0;
    return (jankFramesCount / totalFramesRecorded.toDouble() * 100.0).clamp(0.0, 100.0);
  }

  /// UI Smoothness score from 0.0% to 100.0%
  double get smoothnessScore {
    if (totalFramesRecorded <= 0) return 100.0;
    final score = 100.0 - jankPercentage;
    return score.clamp(0.0, 100.0);
  }

  /// Categorized grade label for UI smoothness
  String get smoothnessGrade {
    if (smoothnessScore >= 95.0) {
      return "Ultra Smooth";
    } else if (smoothnessScore >= 85.0) {
      return "Cukup Mulus";
    } else if (smoothnessScore >= 70.0) {
      return "Mild Jank";
    } else {
      return "Severe Lag";
    }
  }

  String get fullSmoothnessGrade {
    if (smoothnessScore >= 95.0) {
      return "Sangat Mulus (Ultra Smooth)";
    } else if (smoothnessScore >= 85.0) {
      return "Normal (Cukup Mulus)";
    } else if (smoothnessScore >= 70.0) {
      return "Patah-Patah Ringan (Mild Jank)";
    } else {
      return "Lag / Patah Parah (Severe Lag)";
    }
  }

  String get formattedCurrentFps => currentFps.toStringAsFixed(1);
  String get formattedAverageFps => averageFps.toStringAsFixed(1);
  String get formattedMaxFrameTime => "${maxFrameDurationMs.toStringAsFixed(1)} ms";
}
