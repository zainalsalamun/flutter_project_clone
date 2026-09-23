import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'diagnostics_logger_service.dart';

class PingJitterResult {
  final int minMs;
  final int maxMs;
  final int avgMs;
  final double jitterMs;
  final double packetLossPercent;
  final String targetHost;

  const PingJitterResult({
    required this.minMs,
    required this.maxMs,
    required this.avgMs,
    required this.jitterMs,
    required this.packetLossPercent,
    required this.targetHost,
  });

  factory PingJitterResult.empty() => const PingJitterResult(
        minMs: 0,
        maxMs: 0,
        avgMs: 0,
        jitterMs: 0.0,
        packetLossPercent: 0.0,
        targetHost: '1.1.1.1',
      );
}

class SpeedTestSummary {
  final double downloadMbps;
  final double uploadMbps;
  final int pingMs;
  final double jitterMs;
  final double packetLossPercent;
  final String serverName;
  final DateTime timestamp;

  const SpeedTestSummary({
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    required this.jitterMs,
    required this.packetLossPercent,
    required this.serverName,
    required this.timestamp,
  });

  String get gamingGrade {
    if (pingMs <= 0) return "-";
    if (pingMs < 30 && jitterMs < 5 && packetLossPercent == 0) return "A+ (Ultra Low Latency)";
    if (pingMs < 60 && jitterMs < 12) return "A (Competitive Ready)";
    if (pingMs < 110) return "B (Playable)";
    if (pingMs < 180) return "C (Noticeable Lag)";
    return "D (Severe Latency)";
  }

  String get streamingGrade {
    if (downloadMbps <= 0) return "-";
    if (downloadMbps >= 50) return "4K UHD / HDR (Flawless)";
    if (downloadMbps >= 25) return "4K UHD Stream";
    if (downloadMbps >= 10) return "1080p FHD (Smooth)";
    if (downloadMbps >= 5) return "720p HD";
    return "SD Standard (Buffering risk)";
  }

  String get videoCallGrade {
    if (downloadMbps <= 0 || uploadMbps <= 0) return "-";
    if (downloadMbps >= 10 && uploadMbps >= 5 && pingMs < 80) return "HD Group Conference (Excellent)";
    if (downloadMbps >= 4 && uploadMbps >= 2) return "1:1 HD Video Call (Good)";
    return "Audio Only / Low Quality";
  }
}

class WifiDetailedInfo {
  final bool isConnected;
  final bool isWifiEnabled;
  final String ssid;
  final String bssid;
  final int rssi; // dBm e.g. -55 dBm
  final int signalLevel; // 0 - 100 %
  final int linkSpeedMbps; // e.g. 433 Mbps
  final int frequencyMhz; // e.g. 5180 MHz
  final String band; // '2.4 GHz', '5 GHz', '6 GHz'
  final String localIp;
  final String gateway;
  final String dns1;
  final String dns2;
  final String netmask;

  const WifiDetailedInfo({
    required this.isConnected,
    required this.isWifiEnabled,
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.signalLevel,
    required this.linkSpeedMbps,
    required this.frequencyMhz,
    required this.band,
    required this.localIp,
    required this.gateway,
    required this.dns1,
    required this.dns2,
    required this.netmask,
  });

  factory WifiDetailedInfo.empty() => const WifiDetailedInfo(
        isConnected: false,
        isWifiEnabled: false,
        ssid: 'Not Connected',
        bssid: '00:00:00:00:00:00',
        rssi: -100,
        signalLevel: 0,
        linkSpeedMbps: 0,
        frequencyMhz: 0,
        band: 'Unknown',
        localIp: 'N/A',
        gateway: 'N/A',
        dns1: 'N/A',
        dns2: 'N/A',
        netmask: '255.255.255.0',
      );

  String get signalQualityText {
    if (!isConnected) return "Disconnected";
    if (rssi >= -50) return "Sangat Bagus (Excellent)";
    if (rssi >= -65) return "Bagus (Good)";
    if (rssi >= -75) return "Cukup (Fair)";
    if (rssi >= -85) return "Lemah (Weak)";
    return "Sangat Lemah (Poor)";
  }
}

class NetworkTrafficData {
  final int totalRxBytes;
  final int totalTxBytes;
  final int totalRxPackets;
  final int totalTxPackets;
  final int mobileRxBytes;
  final int mobileTxBytes;

  const NetworkTrafficData({
    required this.totalRxBytes,
    required this.totalTxBytes,
    required this.totalRxPackets,
    required this.totalTxPackets,
    required this.mobileRxBytes,
    required this.mobileTxBytes,
  });

  factory NetworkTrafficData.empty() => const NetworkTrafficData(
        totalRxBytes: 0,
        totalTxBytes: 0,
        totalRxPackets: 0,
        totalTxPackets: 0,
        mobileRxBytes: 0,
        mobileTxBytes: 0,
      );

  String get formattedTotalRx => _formatBytes(totalRxBytes);
  String get formattedTotalTx => _formatBytes(totalTxBytes);
  String get formattedMobileRx => _formatBytes(mobileRxBytes);
  String get formattedMobileTx => _formatBytes(mobileTxBytes);

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    i = i.clamp(0, suffixes.length - 1);
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}

class LanDevice {
  final String ip;
  final String hostname;
  final int responseTimeMs;
  final List<int> openPorts;
  final String deviceType;
  final bool isGateway;

  const LanDevice({
    required this.ip,
    required this.hostname,
    required this.responseTimeMs,
    required this.openPorts,
    required this.deviceType,
    this.isGateway = false,
  });
}

class WebServiceStatus {
  final String name;
  final String url;
  final String host;
  final bool isReachable;
  final int latencyMs;
  final int statusCode;

  const WebServiceStatus({
    required this.name,
    required this.url,
    required this.host,
    required this.isReachable,
    required this.latencyMs,
    required this.statusCode,
  });
}

class NetworkSpeedTestService {
  static final NetworkSpeedTestService instance = NetworkSpeedTestService._internal();
  NetworkSpeedTestService._internal();

  static const MethodChannel _platformChannel =
      MethodChannel('com.naltech.project_clone/device_diagnostics');

  // CDN download test URLs with fast global anycast edge
  static const List<String> _downloadTestUrls = [
    'https://speed.cloudflare.com/__down?bytes=10485760', // 10 MB Cloudflare
    'https://speed.hetzner.de/10MB.bin',
  ];

  /// Measures multi-server Ping and Jitter
  Future<PingJitterResult> measurePingAndJitter({String host = '1.1.1.1'}) async {
    try {
      // 1. Try Native ICMP ping
      final dynamic res = await _platformChannel.invokeMethod('pingHostNative', {
        'host': host,
        'count': 4,
        'timeout': 2,
      });

      if (res is Map && res['success'] == true) {
        final avg = (res['avgMs'] as num?)?.round() ?? 0;
        final min = (res['minMs'] as num?)?.round() ?? 0;
        final max = (res['maxMs'] as num?)?.round() ?? 0;
        final jitter = (res['jitterMs'] as num?)?.toDouble() ?? 0.0;
        final loss = (res['packetLossPercent'] as num?)?.toDouble() ?? 0.0;

        return PingJitterResult(
          minMs: min,
          maxMs: max,
          avgMs: avg,
          jitterMs: jitter,
          packetLossPercent: loss,
          targetHost: host,
        );
      }
    } catch (_) {}

    // Fallback: Socket connection measurement in Dart
    final latencies = <int>[];
    for (int i = 0; i < 4; i++) {
      final sw = Stopwatch()..start();
      try {
        final socket = await Socket.connect(host, 53, timeout: const Duration(seconds: 2));
        sw.stop();
        latencies.add(sw.elapsedMilliseconds);
        socket.destroy();
      } catch (_) {
        sw.stop();
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (latencies.isEmpty) {
      return PingJitterResult.empty();
    }

    final min = latencies.reduce(math.min);
    final max = latencies.reduce(math.max);
    final avg = (latencies.reduce((a, b) => a + b) / latencies.length).round();

    double jitter = 0.0;
    if (latencies.length > 1) {
      double diffSum = 0.0;
      for (int i = 1; i < latencies.length; i++) {
        diffSum += (latencies[i] - latencies[i - 1]).abs();
      }
      jitter = diffSum / (latencies.length - 1);
    }

    final loss = ((4 - latencies.length) / 4.0) * 100.0;

    return PingJitterResult(
      minMs: min,
      maxMs: max,
      avgMs: avg,
      jitterMs: jitter,
      packetLossPercent: loss,
      targetHost: host,
    );
  }

  /// Runs High-Speed Download Benchmark in real-time
  Stream<double> runDownloadBenchmark({
    Duration duration = const Duration(seconds: 6),
    void Function(double currentMbps, double progress)? onProgress,
  }) async* {
    final client = http.Client();
    final stopwatch = Stopwatch()..start();
    int totalBytesReceived = 0;
    final samples = <double>[];

    try {
      final url = Uri.parse(_downloadTestUrls[0]);
      final request = http.Request('GET', url);
      final response = await client.send(request);

      double lastEmittedMbps = 0.0;
      int lastCheckpointBytes = 0;
      int lastCheckpointTimeMs = 0;

      await for (final chunk in response.stream) {
        totalBytesReceived += chunk.length;
        final currentMs = stopwatch.elapsedMilliseconds;

        if (currentMs - lastCheckpointTimeMs >= 200) {
          final deltaBytes = totalBytesReceived - lastCheckpointBytes;
          final deltaTimeSec = (currentMs - lastCheckpointTimeMs) / 1000.0;

          // Instantaneous Mbps = (Bytes * 8) / (Time * 1,000,000)
          final instantMbps = (deltaBytes * 8.0) / (deltaTimeSec * 1000000.0);
          lastEmittedMbps = (lastEmittedMbps * 0.4) + (instantMbps * 0.6); // Smoothing
          samples.add(lastEmittedMbps);

          final progress = (currentMs / duration.inMilliseconds).clamp(0.0, 1.0);
          onProgress?.call(lastEmittedMbps, progress);
          yield lastEmittedMbps;

          lastCheckpointBytes = totalBytesReceived;
          lastCheckpointTimeMs = currentMs;
        }

        if (stopwatch.elapsed >= duration) {
          break;
        }
      }
    } catch (e) {
      DiagnosticsLoggerService.instance.warn("DOWNLOAD_TEST_WARN", "Download stream ended: $e");
    } finally {
      client.close();
      stopwatch.stop();
    }

    // Calculate final smoothed average Mbps
    if (samples.isNotEmpty) {
      final validSamples = samples.skip(1).toList(); // Skip first ramp-up sample
      final avg = validSamples.isNotEmpty
          ? validSamples.reduce((a, b) => a + b) / validSamples.length
          : samples.last;
      yield avg;
    } else {
      yield 0.0;
    }
  }

  /// Runs High-Speed Upload Benchmark in real-time
  Stream<double> runUploadBenchmark({
    Duration duration = const Duration(seconds: 5),
    void Function(double currentMbps, double progress)? onProgress,
  }) async* {
    final stopwatch = Stopwatch()..start();
    final client = http.Client();
    final samples = <double>[];

    try {
      // 512 KB payload chunk
      final chunkBytes = List<int>.filled(512 * 1024, 65);
      final uploadUrl = Uri.parse('https://speed.cloudflare.com/__up');

      int chunksSent = 0;
      double lastEmittedMbps = 0.0;

      while (stopwatch.elapsed < duration) {
        final chunkStart = stopwatch.elapsedMilliseconds;
        final res = await client.post(uploadUrl, body: chunkBytes);
        final chunkEnd = stopwatch.elapsedMilliseconds;

        if (res.statusCode == 200) {
          chunksSent++;
          final deltaMs = chunkEnd - chunkStart;
          if (deltaMs > 0) {
            final instantMbps = (chunkBytes.length * 8.0) / ((deltaMs / 1000.0) * 1000000.0);
            lastEmittedMbps = (lastEmittedMbps * 0.3) + (instantMbps * 0.7);
            samples.add(lastEmittedMbps);

            final progress = (stopwatch.elapsedMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
            onProgress?.call(lastEmittedMbps, progress);
            yield lastEmittedMbps;
          }
        }
      }
    } catch (e) {
      DiagnosticsLoggerService.instance.warn("UPLOAD_TEST_WARN", "Upload stream ended: $e");
    } finally {
      client.close();
      stopwatch.stop();
    }

    if (samples.isNotEmpty) {
      final avg = samples.reduce((a, b) => a + b) / samples.length;
      yield avg;
    } else {
      yield 0.0;
    }
  }

  /// Gets detailed Wi-Fi information from Android Native layer
  Future<WifiDetailedInfo> getWifiDetailedInfo() async {
    try {
      final dynamic res = await _platformChannel.invokeMethod('getDetailedWifiInfo');
      if (res is Map) {
        return WifiDetailedInfo(
          isConnected: res['isConnected'] == true,
          isWifiEnabled: res['isWifiEnabled'] == true,
          ssid: res['ssid']?.toString() ?? 'Unknown',
          bssid: res['bssid']?.toString() ?? '00:00:00:00:00:00',
          rssi: (res['rssi'] as num?)?.toInt() ?? -100,
          signalLevel: (res['signalLevel'] as num?)?.toInt() ?? 0,
          linkSpeedMbps: (res['linkSpeedMbps'] as num?)?.toInt() ?? 0,
          frequencyMhz: (res['frequencyMhz'] as num?)?.toInt() ?? 0,
          band: res['band']?.toString() ?? 'Unknown',
          localIp: res['localIp']?.toString() ?? 'N/A',
          gateway: res['gateway']?.toString() ?? 'N/A',
          dns1: res['dns1']?.toString() ?? 'N/A',
          dns2: res['dns2']?.toString() ?? 'N/A',
          netmask: res['netmask']?.toString() ?? '255.255.255.0',
        );
      }
    } catch (e) {
      DiagnosticsLoggerService.instance.warn("WIFI_INFO_ERROR", "Gagal membaca detail Wi-Fi: $e");
    }
    return WifiDetailedInfo.empty();
  }

  /// Gets Network Traffic statistics (Rx / Tx in Bytes & Packets)
  Future<NetworkTrafficData> getNetworkTrafficStats() async {
    try {
      final dynamic res = await _platformChannel.invokeMethod('getNetworkTrafficStats');
      if (res is Map) {
        return NetworkTrafficData(
          totalRxBytes: (res['totalRxBytes'] as num?)?.toInt() ?? 0,
          totalTxBytes: (res['totalTxBytes'] as num?)?.toInt() ?? 0,
          totalRxPackets: (res['totalRxPackets'] as num?)?.toInt() ?? 0,
          totalTxPackets: (res['totalTxPackets'] as num?)?.toInt() ?? 0,
          mobileRxBytes: (res['mobileRxBytes'] as num?)?.toInt() ?? 0,
          mobileTxBytes: (res['mobileTxBytes'] as num?)?.toInt() ?? 0,
        );
      }
    } catch (_) {}
    return NetworkTrafficData.empty();
  }

  /// Scans the local Wi-Fi subnet (/24 e.g. 192.168.1.1 - 192.168.1.254) for active devices
  Stream<LanDevice> scanLocalSubnet({
    String? localIp,
    String? gatewayIp,
    void Function(int scanned, int total)? onProgress,
  }) async* {
    String baseSubnet = "192.168.1";
    if (localIp != null && localIp.contains('.')) {
      final parts = localIp.split('.');
      if (parts.length == 4) {
        baseSubnet = "${parts[0]}.${parts[1]}.${parts[2]}";
      }
    }

    const totalHosts = 254;
    int scannedCount = 0;

    // Common ports to probe: 80 (HTTP), 443 (HTTPS), 53 (DNS), 8080 (Web), 22 (SSH)
    const probePorts = [80, 443, 53, 8080, 22];

    // Scan in concurrent batches of 25 IPs for high performance
    const batchSize = 25;
    for (int i = 1; i <= totalHosts; i += batchSize) {
      final batchFutures = <Future<LanDevice?>>[];
      final end = math.min(i + batchSize - 1, totalHosts);

      for (int host = i; host <= end; host++) {
        final targetIp = "$baseSubnet.$host";
        final isGw = targetIp == gatewayIp;

        batchFutures.add(() async {
          final sw = Stopwatch()..start();
          final openPorts = <int>[];
          bool responded = false;

          for (final port in probePorts) {
            try {
              final socket = await Socket.connect(targetIp, port,
                  timeout: const Duration(milliseconds: 300));
              responded = true;
              openPorts.add(port);
              socket.destroy();
            } catch (_) {}
          }

          sw.stop();
          if (responded || isGw) {
            String deviceType = "Device / Host";
            if (isGw) {
              deviceType = "Wi-Fi Router / Gateway";
            } else if (openPorts.contains(80) || openPorts.contains(8080)) {
              deviceType = "Web Server / IoT Hub";
            } else if (openPorts.contains(443)) {
              deviceType = "Secure Server / Smart TV";
            }

            return LanDevice(
              ip: targetIp,
              hostname: isGw ? "Default Gateway ($targetIp)" : "Host ($targetIp)",
              responseTimeMs: sw.elapsedMilliseconds,
              openPorts: openPorts,
              deviceType: deviceType,
              isGateway: isGw,
            );
          }
          return null;
        }());
      }

      final results = await Future.wait(batchFutures);
      scannedCount += (end - i + 1);
      onProgress?.call(scannedCount, totalHosts);

      for (final dev in results) {
        if (dev != null) {
          yield dev;
        }
      }
    }
  }

  /// Checks reachability and response latency to major Web & Cloud services
  Future<List<WebServiceStatus>> checkWebServices() async {
    final targets = [
      {'name': 'Cloudinary CDN', 'url': 'https://api.cloudinary.com/ping', 'host': 'api.cloudinary.com'},
      {'name': 'Google Services', 'url': 'https://www.google.com/generate_204', 'host': 'www.google.com'},
      {'name': 'Cloudflare DNS', 'url': 'https://1.1.1.1', 'host': '1.1.1.1'},
      {'name': 'Firebase Auth', 'url': 'https://identitytoolkit.googleapis.com', 'host': 'identitytoolkit.googleapis.com'},
      {'name': 'WhatsApp Relay', 'url': 'https://web.whatsapp.com', 'host': 'web.whatsapp.com'},
      {'name': 'GitHub API', 'url': 'https://api.github.com', 'host': 'api.github.com'},
    ];

    final client = http.Client();
    final results = <WebServiceStatus>[];

    for (final t in targets) {
      final sw = Stopwatch()..start();
      try {
        final res = await client
            .get(Uri.parse(t['url']!))
            .timeout(const Duration(seconds: 4));
        sw.stop();

        results.add(WebServiceStatus(
          name: t['name']!,
          url: t['url']!,
          host: t['host']!,
          isReachable: res.statusCode < 500,
          latencyMs: sw.elapsedMilliseconds,
          statusCode: res.statusCode,
        ));
      } catch (e) {
        sw.stop();
        results.add(WebServiceStatus(
          name: t['name']!,
          url: t['url']!,
          host: t['host']!,
          isReachable: false,
          latencyMs: sw.elapsedMilliseconds,
          statusCode: 0,
        ));
      }
    }

    client.close();
    return results;
  }
}
