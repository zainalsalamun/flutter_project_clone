import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_screen_time_model.dart';
import '../services/app_screen_time_service.dart';
import '../theme/diagnostics_colors.dart';

class AppScreenTimeCard extends StatefulWidget {
  const AppScreenTimeCard({super.key});

  @override
  State<AppScreenTimeCard> createState() => _AppScreenTimeCardState();
}

class _AppScreenTimeCardState extends State<AppScreenTimeCard> {
  final AppScreenTimeService _screenTimeService = AppScreenTimeService.instance;

  DailyScreenTimeSummary _todaySummary = const DailyScreenTimeSummary(
    date: '',
    totalSeconds: 0,
    sessionCount: 0,
  );
  List<DailyScreenTimeSummary> _past7Days = [];
  int _pendingSyncCount = 0;
  int _currentSessionSeconds = 0;
  bool _isSyncing = false;
  bool _isLoading = true;

  StreamSubscription<int>? _tickerSub;
  StreamSubscription<DailyScreenTimeSummary>? _summarySub;

  @override
  void initState() {
    super.initState();
    _loadData();

    // Listen to live 1-second ticker
    _tickerSub = _screenTimeService.liveTickerStream.listen((sec) {
      if (mounted) {
        setState(() {
          _currentSessionSeconds = sec;
        });
      }
    });

    // Listen to summary updates
    _summarySub = _screenTimeService.dailySummaryStream.listen((summary) {
      if (mounted) {
        setState(() {
          _todaySummary = summary;
        });
        _refreshPendingCount();
      }
    });
  }

  @override
  void dispose() {
    _tickerSub?.cancel();
    _summarySub?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final today = await _screenTimeService.getTodaySummary();
    final past7 = await _screenTimeService.getPast7DaysSummaries();
    final pending = await _screenTimeService.getPendingSyncCount();

    if (mounted) {
      setState(() {
        _todaySummary = today;
        _past7Days = past7;
        _pendingSyncCount = pending;
        _currentSessionSeconds = _screenTimeService.currentSessionSeconds;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPendingCount() async {
    final pending = await _screenTimeService.getPendingSyncCount();
    final past7 = await _screenTimeService.getPast7DaysSummaries();
    if (mounted) {
      setState(() {
        _pendingSyncCount = pending;
        _past7Days = past7;
      });
    }
  }

  Future<void> _handleSyncToServer() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);

    final result = await _screenTimeService.syncPendingSessionsToServer();

    if (mounted) {
      setState(() => _isSyncing = false);
      await _loadData();

      final success = result['success'] == true;
      final count = result['syncedCount'] ?? 0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              success ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(
                success ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  success
                      ? "Berhasil sinkronisasi $count sesi ke server API!"
                      : "Gagal sinkronisasi: ${result['message']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showPayloadModal() async {
    final payload = await _screenTimeService.buildServerPayload(
      onlyUnsynced: false,
    );
    final jsonText = payload.toPrettyJson();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                // Modal Handle Bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "JSON Payload API Server",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Format data REST API siap kirim ke server backend",
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E293B)),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF050B14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: SelectableText(
                        jsonText,
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontFamily: 'monospace',
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF38BDF8),
                            side: const BorderSide(color: Color(0xFF38BDF8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text(
                            "Salin JSON",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: jsonText));
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "JSON Payload berhasil disalin ke clipboard!",
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.cloud_upload_rounded,
                            size: 16,
                          ),
                          label: const Text(
                            "Sync Sekarang",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _handleSyncToServer();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatSessionTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
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
                          color: const Color(0xFF0284C7).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.timelapse_rounded,
                          color: Color(0xFF0284C7),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "APP SCREEN TIME & SESI",
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
                              "Durasi aktif aplikasi & analytics server",
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
                // Live Session Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Sesi: ${_formatSessionTimer(_currentSessionSeconds)}",
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
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

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF0284C7)),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Metrics Row
                  Row(
                    children: [
                      // Total Today Card
                      Expanded(
                        flex: 11,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
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
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "SCREEN TIME HARI INI",
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.today_rounded,
                                    color: Color(0xFF38BDF8),
                                    size: 14,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _todaySummary.formattedTotalDuration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "${_todaySummary.sessionCount} Sesi hari ini",
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 9.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Sync Queue Status Card
                      Expanded(
                        flex: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _pendingSyncCount > 0
                                    ? const Color(0xFFFFFBEB)
                                    : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  _pendingSyncCount > 0
                                      ? const Color(0xFFFDE68A)
                                      : const Color(0xFFBBF7D0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "SERVER",
                                      style: TextStyle(
                                        color:
                                            _pendingSyncCount > 0
                                                ? const Color(0xFFB45309)
                                                : const Color(0xFF15803D),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    _pendingSyncCount > 0
                                        ? Icons.cloud_queue_rounded
                                        : Icons.cloud_done_rounded,
                                    color:
                                        _pendingSyncCount > 0
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF16A34A),
                                    size: 14,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _pendingSyncCount > 0
                                    ? "$_pendingSyncCount Sesi"
                                    : "Sinkron",
                                style: TextStyle(
                                  color:
                                      _pendingSyncCount > 0
                                          ? const Color(0xFF92400E)
                                          : const Color(0xFF166534),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _pendingSyncCount > 0
                                    ? "Antrean sync"
                                    : "Tersimpan",
                                style: TextStyle(
                                  color:
                                      _pendingSyncCount > 0
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFF15803D),
                                  fontSize: 9.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 7-Day Usage Trend Bar Chart
                  const Text(
                    "TREN SCREEN TIME 7 HARI TERAKHIR",
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: DiagnosticsColors.textSubtle,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _build7DaysBarChart(),

                  const SizedBox(height: 16),

                  // Page / Module Breakdown
                  if (_todaySummary.aggregatedPages.isNotEmpty) ...[
                    const Text(
                      "RINCIAN PEMAKAIAN PER MODUL (HARI INI)",
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: DiagnosticsColors.textSubtle,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildPageBreakdownWidgets(),
                    const SizedBox(height: 14),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0284C7),
                            side: const BorderSide(color: Color(0xFF0284C7)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.code_rounded, size: 16),
                          label: const Text(
                            "Payload JSON",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _showPayloadModal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon:
                              _isSyncing
                                  ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.cloud_upload_rounded,
                                    size: 16,
                                  ),
                          label: Text(
                            _isSyncing ? "Mengirim..." : "Kirim ke Server",
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _isSyncing ? null : _handleSyncToServer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _build7DaysBarChart() {
    if (_past7Days.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find maximum seconds for proportional scaling
    int maxSec = _past7Days
        .map((d) => d.totalSeconds)
        .fold(0, (a, b) => a > b ? a : b);
    if (maxSec <= 0) maxSec = 3600; // default 1 hour scale

    const weekdayLabels = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            _past7Days.map((item) {
              final isToday = item.date == _todaySummary.date;
              final dt = DateTime.tryParse(item.date) ?? DateTime.now();
              final dayLabel = weekdayLabels[(dt.weekday - 1) % 7];

              final heightFraction = (item.totalSeconds / maxSec.toDouble())
                  .clamp(0.08, 1.0);
              final barHeight = heightFraction * 48.0;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.formattedShortDuration,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color:
                          isToday
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 18,
                    height: barHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isToday
                                ? [
                                  const Color(0xFF38BDF8),
                                  const Color(0xFF0284C7),
                                ]
                                : [
                                  const Color(0xFFCBD5E1),
                                  const Color(0xFF94A3B8),
                                ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayLabel,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                      color:
                          isToday
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF64748B),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  List<Widget> _buildPageBreakdownWidgets() {
    final totalSec =
        _todaySummary.totalSeconds > 0 ? _todaySummary.totalSeconds : 1;
    final pages = _todaySummary.aggregatedPages;

    final sortedEntries =
        pages.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((e) {
      final percentage = (e.value / totalSec.toDouble()).clamp(0.0, 1.0);
      final humanName = _getReadablePageName(e.key);
      final icon = _getPageIcon(e.key);

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(icon, size: 14, color: const Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          humanName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: DiagnosticsColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDurationSeconds(e.value),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF38BDF8),
                ),
                minHeight: 5,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getReadablePageName(String key) {
    switch (key) {
      case "DeviceDiagnosticsPage":
        return "Device Diagnostics & Telemetry";
      case "CameraGeotagPreviewPage":
        return "Kamera Geotagging & Cloud";
      case "NetworkSpeedDiagnosticsPage":
        return "Network & Speed Benchmark";
      case "SavedGeotagPhotosPage":
        return "Galeri Geotag Vault";
      case "InteractiveGeotagMapPage":
        return "Peta Interaktif GPS";
      default:
        return key.replaceAll("Page", "").replaceAll("View", "");
    }
  }

  IconData _getPageIcon(String key) {
    switch (key) {
      case "DeviceDiagnosticsPage":
        return Icons.devices_other_rounded;
      case "CameraGeotagPreviewPage":
        return Icons.camera_alt_rounded;
      case "NetworkSpeedDiagnosticsPage":
        return Icons.speed_rounded;
      case "SavedGeotagPhotosPage":
        return Icons.photo_library_rounded;
      case "InteractiveGeotagMapPage":
        return Icons.map_rounded;
      default:
        return Icons.dashboard_rounded;
    }
  }

  String _formatDurationSeconds(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    if (m > 0) return "${m}m ${s}s";
    return "${s}s";
  }
}
