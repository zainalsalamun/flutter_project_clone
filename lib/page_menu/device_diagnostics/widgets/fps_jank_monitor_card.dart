import 'dart:async';
import 'package:flutter/material.dart';

import '../models/fps_jank_metrics_model.dart';
import '../services/fps_jank_monitor_service.dart';
import '../theme/diagnostics_colors.dart';

class FpsJankMonitorCard extends StatefulWidget {
  const FpsJankMonitorCard({super.key});

  @override
  State<FpsJankMonitorCard> createState() => _FpsJankMonitorCardState();
}

class _FpsJankMonitorCardState extends State<FpsJankMonitorCard> {
  final FpsJankMonitorService _fpsService = FpsJankMonitorService.instance;

  FpsPerformanceSnapshot _snapshot = FpsPerformanceSnapshot.initial();
  StreamSubscription<FpsPerformanceSnapshot>? _snapshotSub;

  @override
  void initState() {
    super.initState();
    _fpsService.startMonitoring();
    _snapshot = FpsPerformanceSnapshot.initial(
      targetRate: _fpsService.targetRefreshRate,
    );

    _snapshotSub = _fpsService.snapshotStream.listen((snap) {
      if (mounted) {
        setState(() {
          _snapshot = snap;
        });
      }
    });
  }

  @override
  void dispose() {
    _snapshotSub?.cancel();
    super.dispose();
  }

  Color _getFpsColor(double fps) {
    if (fps >= 57.0) return const Color(0xFF10B981); // Emerald / Green
    if (fps >= 45.0) return const Color(0xFFF59E0B); // Amber / Yellow
    return const Color(0xFFEF4444); // Red
  }

  Color _getFrameTimingBarColor(FrameTimingData frame) {
    if (frame.isSevereJank) return const Color(0xFFEF4444);
    if (frame.isJank) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    final fpsColor = _getFpsColor(_snapshot.currentFps);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DiagnosticsColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DiagnosticsColors.border),
        boxShadow: [
          BoxShadow(
            color: DiagnosticsColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.speed_rounded,
                          color: Color(0xFF0D9488),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "UI RENDERING & FPS PROFILER",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: DiagnosticsColors.textPrimary,
                                letterSpacing: 0.6,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Live FPS & analisis frame drop jank",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: DiagnosticsColors.textSubtle,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Live Pulse Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: fpsColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: fpsColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: fpsColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${_snapshot.formattedCurrentFps} FPS",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: fpsColor,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: DiagnosticsColors.divider),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Performance & Waveform Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _snapshot.formattedCurrentFps,
                                style: TextStyle(
                                  color: fpsColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "FPS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Target ${_snapshot.targetRefreshRate.toInt()} Hz",
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 9.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38BDF8).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _snapshot.smoothnessGrade,
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Real-time Frame Timing Waveform
                      const Text(
                        "WAVEFORM RENDER TIME PER FRAME (RECENT 40 FRAMES)",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildWaveformChart(),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 2. Metrics Grid (Average, Jank, Max Time, Smoothness Score)
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        icon: Icons.auto_graph_rounded,
                        color: const Color(0xFF0284C7),
                        title: "Rata-Rata FPS",
                        value: "${_snapshot.formattedAverageFps} FPS",
                        subtitle: "Stabilitas Render",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        icon: Icons.layers_clear_rounded,
                        color: _snapshot.jankFramesCount > 0
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF10B981),
                        title: "Frame Drops",
                        value: "${_snapshot.jankFramesCount} Frame",
                        subtitle: "Drop (> 16ms)",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        icon: Icons.timer_outlined,
                        color: const Color(0xFF8B5CF6),
                        title: "Max Frame Time",
                        value: _snapshot.formattedMaxFrameTime,
                        subtitle: "Peak Latency",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3. Interactive Scroll Stress Test Area
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "AREA UJI SCROLL CEPAT (STRESS TEST)",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: DiagnosticsColors.textSubtle,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Icon(Icons.swipe_rounded, color: Color(0xFF0284C7), size: 14),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Usap daftar di bawah ini secara cepat untuk menguji respons FPS rendering layar:",
                        style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 52,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 20,
                          itemBuilder: (context, idx) {
                            return Container(
                              width: 110,
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color((0xFF0284C7 + (idx * 0x000508)).clamp(0, 0xFFFFFFFF)),
                                    const Color(0xFF0F172A),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white24,
                                    child: Text(
                                      "${idx + 1}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Item #${idx + 1}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Controls Row (Reset Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 15),
                      label: const Text(
                        "Reset Statistik",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _fpsService.resetStats();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Statistik FPS berhasil di-reset!"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformChart() {
    final frames = _snapshot.recentFrames;
    if (frames.isEmpty) {
      return Container(
        height: 38,
        alignment: Alignment.center,
        child: const Text(
          "Mengumpulkan data render frame...",
          style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
        ),
      );
    }

    const maxScaleMs = 33.3; // 30 FPS threshold scale

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: frames.take(40).map((f) {
          final barColor = _getFrameTimingBarColor(f);
          final h = (f.totalDurationMs / maxScaleMs * 34.0).clamp(4.0, 34.0);

          return Expanded(
            child: Container(
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: DiagnosticsColors.textPrimary,
              fontFamily: 'monospace',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9,
              color: DiagnosticsColors.textSubtle,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
