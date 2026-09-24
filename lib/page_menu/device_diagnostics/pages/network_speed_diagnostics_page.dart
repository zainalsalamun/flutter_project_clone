import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/network_speed_test_service.dart';
import '../services/app_screen_time_service.dart';

class NetworkSpeedDiagnosticsPage extends StatefulWidget {
  const NetworkSpeedDiagnosticsPage({super.key});

  @override
  State<NetworkSpeedDiagnosticsPage> createState() =>
      _NetworkSpeedDiagnosticsPageState();
}

class _NetworkSpeedDiagnosticsPageState
    extends State<NetworkSpeedDiagnosticsPage>
    with SingleTickerProviderStateMixin {
  final NetworkSpeedTestService _speedService = NetworkSpeedTestService.instance;

  late TabController _tabController;

  // Speedtest State
  bool _isTestingSpeed = false;
  String _speedTestStage = "Siap untuk menguji"; // "Ping", "Download", "Upload", "Done"
  double _currentGaugeMbps = 0.0;
  double _downloadMbps = 0.0;
  double _uploadMbps = 0.0;
  int _pingMs = 0;
  double _jitterMs = 0.0;
  double _packetLoss = 0.0;
  final List<double> _liveSpeedHistory = [];
  SpeedTestSummary? _lastTestSummary;

  // Wi-Fi Telemetry State
  WifiDetailedInfo _wifiInfo = WifiDetailedInfo.empty();
  NetworkTrafficData _trafficData = NetworkTrafficData.empty();
  bool _isLoadingWifi = true;
  Timer? _trafficRefreshTimer;

  // LAN Scanner State
  bool _isScanningLan = false;
  double _lanScanProgress = 0.0;
  int _lanScannedCount = 0;
  final List<LanDevice> _discoveredLanDevices = [];

  // Web Services State
  bool _isLoadingWebServices = false;
  List<WebServiceStatus> _webServices = [];

  @override
  void initState() {
    super.initState();
    AppScreenTimeService.instance.setCurrentPage("NetworkSpeedDiagnosticsPage");
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();

    // Auto-refresh traffic stats every 3 seconds
    _trafficRefreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) _refreshTrafficData();
    });
  }

  @override
  void dispose() {
    AppScreenTimeService.instance.setCurrentPage("DeviceDiagnosticsPage");
    _tabController.dispose();
    _trafficRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingWifi = true);
    final wifi = await _speedService.getWifiDetailedInfo();
    final traffic = await _speedService.getNetworkTrafficStats();
    if (mounted) {
      setState(() {
        _wifiInfo = wifi;
        _trafficData = traffic;
        _isLoadingWifi = false;
      });
    }
    _checkWebServices();
  }

  Future<void> _refreshTrafficData() async {
    final traffic = await _speedService.getNetworkTrafficStats();
    if (mounted) {
      setState(() => _trafficData = traffic);
    }
  }

  Future<void> _checkWebServices() async {
    setState(() => _isLoadingWebServices = true);
    final results = await _speedService.checkWebServices();
    if (mounted) {
      setState(() {
        _webServices = results;
        _isLoadingWebServices = false;
      });
    }
  }

  Future<void> _startFullSpeedTest() async {
    if (_isTestingSpeed) return;

    setState(() {
      _isTestingSpeed = true;
      _speedTestStage = "Mengukur Ping & Jitter...";
      _currentGaugeMbps = 0.0;
      _downloadMbps = 0.0;
      _uploadMbps = 0.0;
      _pingMs = 0;
      _jitterMs = 0.0;
      _packetLoss = 0.0;
      _liveSpeedHistory.clear();
    });

    // 1. Measure Ping & Jitter
    final pingResult = await _speedService.measurePingAndJitter();
    if (!mounted) return;
    setState(() {
      _pingMs = pingResult.avgMs;
      _jitterMs = pingResult.jitterMs;
      _packetLoss = pingResult.packetLossPercent;
      _speedTestStage = "Menguji Kecepatan Download...";
    });

    // 2. Measure Download Speed
    await for (final mbps in _speedService.runDownloadBenchmark(
      onProgress: (m, prog) {
        if (mounted) {
          setState(() {
            _currentGaugeMbps = m;
            _liveSpeedHistory.add(m);
            if (_liveSpeedHistory.length > 40) _liveSpeedHistory.removeAt(0);
          });
        }
      },
    )) {
      _downloadMbps = mbps;
    }

    if (!mounted) return;
    setState(() {
      _currentGaugeMbps = 0.0;
      _speedTestStage = "Menguji Kecepatan Upload...";
    });

    // 3. Measure Upload Speed
    await for (final mbps in _speedService.runUploadBenchmark(
      onProgress: (m, prog) {
        if (mounted) {
          setState(() {
            _currentGaugeMbps = m;
            _liveSpeedHistory.add(m);
            if (_liveSpeedHistory.length > 40) _liveSpeedHistory.removeAt(0);
          });
        }
      },
    )) {
      _uploadMbps = mbps;
    }

    if (!mounted) return;
    final summary = SpeedTestSummary(
      downloadMbps: _downloadMbps,
      uploadMbps: _uploadMbps,
      pingMs: _pingMs,
      jitterMs: _jitterMs,
      packetLossPercent: _packetLoss,
      serverName: "Cloudflare Edge Anycast",
      timestamp: DateTime.now(),
    );

    setState(() {
      _isTestingSpeed = false;
      _currentGaugeMbps = _downloadMbps;
      _speedTestStage = "Uji Kecepatan Selesai";
      _lastTestSummary = summary;
    });

    // Refresh Wi-Fi & traffic data
    _loadInitialData();
  }

  void _startLanScan() {
    if (_isScanningLan) return;

    setState(() {
      _isScanningLan = true;
      _lanScanProgress = 0.0;
      _lanScannedCount = 0;
      _discoveredLanDevices.clear();
    });

    _speedService
        .scanLocalSubnet(
      localIp: _wifiInfo.localIp,
      gatewayIp: _wifiInfo.gateway,
      onProgress: (scanned, total) {
        if (mounted) {
          setState(() {
            _lanScannedCount = scanned;
            _lanScanProgress = scanned / total.toDouble();
          });
        }
      },
    )
        .listen(
      (device) {
        if (mounted) {
          setState(() {
            _discoveredLanDevices.add(device);
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isScanningLan = false;
            _lanScanProgress = 1.0;
          });
        }
      },
      onError: (_) {
        if (mounted) {
          setState(() => _isScanningLan = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Network & Speed Diagnostics",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              _wifiInfo.isConnected
                  ? "${_wifiInfo.ssid} • ${_wifiInfo.band} (${_wifiInfo.rssi} dBm)"
                  : "Cellular / Mobile Network",
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF38BDF8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Refresh Data",
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8)),
            onPressed: () {
              _loadInitialData();
              _checkWebServices();
            },
          ),
          const SizedBox(width: 6),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: const Color(0xFF94A3B8),
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.speed_rounded, size: 18), text: "Speedtest"),
            Tab(icon: Icon(Icons.wifi_rounded, size: 18), text: "Wi-Fi Analyzer"),
            Tab(icon: Icon(Icons.lan_rounded, size: 18), text: "LAN Scanner"),
            Tab(icon: Icon(Icons.public_rounded, size: 18), text: "Web Health"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSpeedTestTab(),
          _buildWifiAnalyzerTab(),
          _buildLanScannerTab(),
          _buildWebHealthTab(),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: SPEEDTEST & LATENCY BENCHMARK
  // ==========================================
  Widget _buildSpeedTestTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Speedometer Gauge Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF38BDF8).withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Stage Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _isTestingSpeed
                      ? const Color(0xFF38BDF8).withOpacity(0.2)
                      : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isTestingSpeed
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF64748B),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isTestingSpeed) ...[
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      _speedTestStage,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _isTestingSpeed ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Animated Gauge CustomPainter
              SizedBox(
                width: 220,
                height: 140,
                child: CustomPaint(
                  painter: _SpeedGaugePainter(mbps: _currentGaugeMbps),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          _currentGaugeMbps.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const Text(
                          "Mbps",
                          style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Realtime Waveform Mini Chart
              if (_liveSpeedHistory.isNotEmpty)
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _liveSpeedHistory.map((val) {
                      final maxVal = _liveSpeedHistory.reduce(math.max);
                      final h = maxVal > 0 ? (val / maxVal * 32.0).clamp(4.0, 32.0) : 4.0;
                      return Container(
                        width: 4,
                        height: h,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 16),

              // Start / Retest Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  icon: _isTestingSpeed
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 20),
                  label: Text(
                    _isTestingSpeed ? "Sedang Menguji Kecepatan..." : "Mulai Uji Kecepatan",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: _isTestingSpeed ? null : _startFullSpeedTest,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Metrics Breakdown (Download, Upload, Ping, Jitter, Loss)
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: Icons.download_rounded,
                color: const Color(0xFF10B981),
                label: "DOWNLOAD",
                value: "${_downloadMbps.toStringAsFixed(1)} Mbps",
                sub: "Transfer Speed",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.upload_rounded,
                color: const Color(0xFF38BDF8),
                label: "UPLOAD",
                value: "${_uploadMbps.toStringAsFixed(1)} Mbps",
                sub: "Throughput",
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: Icons.timer_rounded,
                color: const Color(0xFFA855F7),
                label: "LATENCY (PING)",
                value: "$_pingMs ms",
                sub: "Server Response",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.graphic_eq_rounded,
                color: const Color(0xFFF59E0B),
                label: "JITTER",
                value: "${_jitterMs.toStringAsFixed(1)} ms",
                sub: "Delay Variation",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.layers_clear_rounded,
                color: _packetLoss > 0 ? const Color(0xFFEF4444) : const Color(0xFF06B6D4),
                label: "LOSS",
                value: "${_packetLoss.toStringAsFixed(0)}%",
                sub: "Packet Drop",
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 3. Gaming & Streaming Suitability Grade Card
        if (_lastTestSummary != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 18),
                    SizedBox(width: 6),
                    Text(
                      "PENILAIAN KELAYAKAN KONEKSI",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGradeRow(
                  icon: Icons.sports_esports_rounded,
                  title: "Online Gaming (Low Latency)",
                  rating: _lastTestSummary!.gamingGrade,
                  color: const Color(0xFF10B981),
                ),
                const Divider(color: Color(0xFF1E293B), height: 16),
                _buildGradeRow(
                  icon: Icons.live_tv_rounded,
                  title: "Video Streaming (4K/1080p)",
                  rating: _lastTestSummary!.streamingGrade,
                  color: const Color(0xFF38BDF8),
                ),
                const Divider(color: Color(0xFF1E293B), height: 16),
                _buildGradeRow(
                  icon: Icons.video_camera_front_rounded,
                  title: "Video Conference / Zoom",
                  rating: _lastTestSummary!.videoCallGrade,
                  color: const Color(0xFFA855F7),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
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
                  label,
                  style: TextStyle(fontSize: 9.5, color: color, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeRow({
    required IconData icon,
    required String title,
    required String rating,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5),
              ),
              const SizedBox(height: 1),
              Text(
                rating,
                style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: WI-FI & SIGNAL ANALYZER
  // ==========================================
  Widget _buildWifiAnalyzerTab() {
    if (_isLoadingWifi) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
    }

    final rssi = _wifiInfo.rssi;
    final level = _wifiInfo.signalLevel;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Signal Strength Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.wifi_rounded, color: Color(0xFF38BDF8), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _wifiInfo.ssid,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.4)),
                    ),
                    child: Text(
                      _wifiInfo.band,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Signal Meter Visual
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Kekuatan Sinyal: $rssi dBm ($level%)",
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                            ),
                            Text(
                              _wifiInfo.signalQualityText,
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (level / 100.0).clamp(0.0, 1.0),
                            backgroundColor: const Color(0xFF0F172A),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              rssi >= -65
                                  ? const Color(0xFF10B981)
                                  : (rssi >= -75 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Technical Specs Grid
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SPESIFIKASI & PARAMETER JARINGAN",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38BDF8),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 12),
              _buildNetworkDetailRow("Link Speed (Max Throughput)", "${_wifiInfo.linkSpeedMbps} Mbps"),
              _buildNetworkDetailRow("Frekuensi Radio", "${_wifiInfo.frequencyMhz} MHz (${_wifiInfo.band})"),
              _buildNetworkDetailRow("BSSID (Router MAC)", _wifiInfo.bssid),
              _buildNetworkDetailRow("Alamat IP Lokal (IPv4)", _wifiInfo.localIp),
              _buildNetworkDetailRow("Default Gateway / Router IP", _wifiInfo.gateway),
              _buildNetworkDetailRow("Primary DNS (DNS 1)", _wifiInfo.dns1),
              _buildNetworkDetailRow("Secondary DNS (DNS 2)", _wifiInfo.dns2),
              _buildNetworkDetailRow("Subnet Mask", _wifiInfo.netmask),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Traffic Statistics Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TRAFFIC & DATA COUNTER (REAL-TIME)",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                      letterSpacing: 0.6,
                    ),
                  ),
                  Icon(Icons.data_usage_rounded, color: Color(0xFF10B981), size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      icon: Icons.download_rounded,
                      color: const Color(0xFF10B981),
                      label: "TOTAL RX",
                      value: _trafficData.formattedTotalRx,
                      sub: "${_trafficData.totalRxPackets} Packets",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      icon: Icons.upload_rounded,
                      color: const Color(0xFF38BDF8),
                      label: "TOTAL TX",
                      value: _trafficData.formattedTotalTx,
                      sub: "${_trafficData.totalTxPackets} Packets",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      icon: Icons.signal_cellular_alt_rounded,
                      color: const Color(0xFFA855F7),
                      label: "CELLULAR RX",
                      value: _trafficData.formattedMobileRx,
                      sub: "Mobile Data In",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      icon: Icons.cell_tower_rounded,
                      color: const Color(0xFFF59E0B),
                      label: "CELLULAR TX",
                      value: _trafficData.formattedMobileTx,
                      sub: "Mobile Data Out",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: LAN SUBNET DEVICE SCANNER
  // ==========================================
  Widget _buildLanScannerTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Scanner Trigger Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LAN Subnet Scanner",
                          style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Pindai perangkat aktif & open port di Wi-Fi lokal",
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isScanningLan
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.radar_rounded, size: 15),
                    label: Text(
                      _isScanningLan ? "Scanning..." : "Pindai LAN",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _isScanningLan ? null : _startLanScan,
                  ),
                ],
              ),
              if (_isScanningLan) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scanning IP $_lanScannedCount / 254...",
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10.5),
                    ),
                    Text(
                      "${(_lanScanProgress * 100).toInt()}%",
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _lanScanProgress,
                    backgroundColor: const Color(0xFF0F172A),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                    minHeight: 6,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Discovered Devices Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "PERANGKAT TERDETEKSI (${_discoveredLanDevices.length})",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_discoveredLanDevices.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                "Subnet ${_wifiInfo.localIp.contains('.') ? _wifiInfo.localIp.substring(0, _wifiInfo.localIp.lastIndexOf('.')) : '192.168.1'}.0/24",
                style: const TextStyle(fontSize: 10, color: Color(0xFF38BDF8)),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        if (_discoveredLanDevices.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              children: [
                const Icon(Icons.lan_outlined, size: 36, color: Color(0xFF64748B)),
                const SizedBox(height: 8),
                const Text(
                  "Belum Ada Perangkat Dipindai",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tekan tombol 'Pindai LAN' di atas untuk mencari router, server, smart device, dan printer di jaringan ini.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          )
        else
          ..._discoveredLanDevices.map((dev) => _buildLanDeviceCard(dev)),
      ],
    );
  }

  Widget _buildLanDeviceCard(LanDevice dev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dev.isGateway ? const Color(0xFF38BDF8) : const Color(0xFF334155),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: dev.isGateway
                  ? const Color(0xFF38BDF8).withOpacity(0.2)
                  : const Color(0xFF334155),
              shape: BoxShape.circle,
            ),
            child: Icon(
              dev.isGateway
                  ? Icons.router_rounded
                  : (dev.openPorts.contains(80) ? Icons.dns_rounded : Icons.computer_rounded),
              color: dev.isGateway ? const Color(0xFF38BDF8) : Colors.white70,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dev.ip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (dev.isGateway) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "GATEWAY",
                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${dev.deviceType} • Latency ${dev.responseTimeMs} ms",
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                ),
              ],
            ),
          ),
          if (dev.openPorts.isNotEmpty)
            Wrap(
              spacing: 3,
              children: dev.openPorts
                  .map((p) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ":$p",
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 4: WEB SERVICES & CLOUD HEALTH
  // ==========================================
  Widget _buildWebHealthTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Web Services Header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cloud & Web Services Health",
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Pemeriksaan responsivitas & HTTP latency CDN/Cloud",
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: _isLoadingWebServices
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)),
                      )
                    : const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8)),
                onPressed: _isLoadingWebServices ? null : _checkWebServices,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        if (_webServices.isEmpty && _isLoadingWebServices)
          const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
          ))
        else
          ..._webServices.map((ws) => _buildWebServiceCard(ws)),
      ],
    );
  }

  Widget _buildWebServiceCard(WebServiceStatus ws) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ws.isReachable
              ? const Color(0xFF10B981).withOpacity(0.4)
              : const Color(0xFFEF4444).withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ws.isReachable
                  ? const Color(0xFF10B981).withOpacity(0.15)
                  : const Color(0xFFEF4444).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              ws.isReachable ? Icons.check_circle_rounded : Icons.error_rounded,
              color: ws.isReachable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ws.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  ws.host,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontFamily: 'monospace'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${ws.latencyMs} ms",
                style: TextStyle(
                  color: ws.isReachable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                ws.statusCode > 0 ? "HTTP ${ws.statusCode}" : "Timeout",
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 9.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// CustomPainter for futuristic circular Speedometer Gauge
class _SpeedGaugePainter extends CustomPainter {
  final double mbps;
  const _SpeedGaugePainter({required this.mbps});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.3;

    // Track arc
    final trackPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      trackPaint,
    );

    // Active speed arc with gradient
    final progress = (mbps / 100.0).clamp(0.0, 1.0);
    final sweepAngle = math.pi * progress;

    if (sweepAngle > 0) {
      final activePaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF38BDF8), Color(0xFF10B981)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedGaugePainter oldDelegate) =>
      oldDelegate.mbps != mbps;
}
