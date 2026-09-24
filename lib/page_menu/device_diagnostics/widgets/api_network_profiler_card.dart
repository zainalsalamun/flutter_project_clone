import 'dart:async';
import 'package:flutter/material.dart';

import '../models/api_network_profiler_model.dart';
import '../services/api_network_profiler_service.dart';
import '../theme/diagnostics_colors.dart';

class ApiNetworkProfilerCard extends StatefulWidget {
  const ApiNetworkProfilerCard({super.key});

  @override
  State<ApiNetworkProfilerCard> createState() => _ApiNetworkProfilerCardState();
}

class _ApiNetworkProfilerCardState extends State<ApiNetworkProfilerCard> {
  final ApiNetworkProfilerService _profilerService =
      ApiNetworkProfilerService.instance;
  final TextEditingController _customUrlController = TextEditingController();

  SessionBandwidthSummary _summary = SessionBandwidthSummary.initial();
  bool _isBenchmarking = false;
  bool _isCustomTesting = false;
  StreamSubscription<SessionBandwidthSummary>? _sub;

  @override
  void initState() {
    super.initState();
    _summary = _profilerService.getSessionSummary();

    _sub = _profilerService.summaryStream.listen((data) {
      if (mounted) {
        setState(() => _summary = data);
      }
    });

    if (_summary.benchmarks.isEmpty) {
      _runAllBenchmarks();
    }
  }

  @override
  void dispose() {
    _customUrlController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _runAllBenchmarks() async {
    if (_isBenchmarking) return;

    setState(() => _isBenchmarking = true);

    await _profilerService.benchmarkAllDefaultEndpoints();

    if (mounted) {
      setState(() {
        _isBenchmarking = false;
        _summary = _profilerService.getSessionSummary();
      });
    }
  }

  Future<void> _testCustomUrl() async {
    final url = _customUrlController.text.trim();
    if (url.isEmpty) return;

    setState(() => _isCustomTesting = true);

    await _profilerService.testCustomUrl(url);

    if (mounted) {
      setState(() {
        _isCustomTesting = false;
        _summary = _profilerService.getSessionSummary();
        _customUrlController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Benchmark URL kustom selesai!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getLatencyColor(int ms, bool isSuccess) {
    if (!isSuccess) return const Color(0xFFEF4444);
    if (ms < 250) return const Color(0xFF10B981);
    if (ms < 800) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
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
                          Icons.public_rounded,
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
                              "API LATENCY & DATA PROFILER",
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
                              "Audit respon server backend & kuota data",
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
                // Total Bandwidth Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.3)),
                  ),
                  child: Text(
                    "Data: ${_summary.formattedTotalBandwidth}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                      fontFamily: 'monospace',
                    ),
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
                // 1. Data Transfer Metrics (Download Rx & Upload Tx)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.download_rounded, color: Color(0xFF16A34A), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "DATA TERUNDUH (RX)",
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF15803D),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _summary.formattedTotalRx,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF166534),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.upload_rounded, color: Color(0xFF0284C7), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "DATA TERUNGGAH (TX)",
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0369A1),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _summary.formattedTotalTx,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF075985),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Endpoints Latency Header & Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "LATENSI ENDPOINT CLOUD & BACKEND",
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: DiagnosticsColors.textSubtle,
                        letterSpacing: 0.6,
                      ),
                    ),
                    InkWell(
                      onTap: _isBenchmarking ? null : _runAllBenchmarks,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          children: [
                            if (_isBenchmarking)
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0284C7),
                                ),
                              )
                            else
                              const Icon(Icons.refresh_rounded, size: 14, color: Color(0xFF0284C7)),
                            const SizedBox(width: 4),
                            const Text(
                              "Uji Ulang",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 3. Endpoint Latency List
                if (_summary.benchmarks.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: Color(0xFF0284C7)),
                    ),
                  )
                else
                  ..._summary.benchmarks.map((ep) => _buildEndpointRow(ep)),

                const SizedBox(height: 14),

                // 4. Custom Endpoint Tester Field
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
                      const Text(
                        "UJI ENDPOINT API KUSTOM",
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: DiagnosticsColors.textSubtle,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: _customUrlController,
                                style: const TextStyle(fontSize: 11.5, fontFamily: 'monospace'),
                                decoration: InputDecoration(
                                  hintText: "https://api.domain-anda.com/ping",
                                  hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 38,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _isCustomTesting ? null : _testCustomUrl,
                              child: _isCustomTesting
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Test",
                                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointRow(ApiEndpointBenchmark ep) {
    final latColor = _getLatencyColor(ep.latencyMs, ep.isSuccess);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: latColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ep.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: DiagnosticsColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  ep.url,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF94A3B8),
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ep.formattedLatency,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: latColor,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 1),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ep.isGzipCompressed) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        "GZIP",
                        style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    ep.statusCode > 0 ? "HTTP ${ep.statusCode}" : "Timeout",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: ep.isSuccess ? const Color(0xFF64748B) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
