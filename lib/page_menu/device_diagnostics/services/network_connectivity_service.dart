import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'diagnostics_logger_service.dart';

class NetworkInfoData {
  final String networkType; // 'wifi', 'cellular', 'ethernet', 'vpn', 'offline'
  final String networkName; // 'WiFi Network', 'Cellular (4G/5G)', 'Offline'
  final bool isOnline; // true if real internet packet reachability verified
  final String ipAddress; // e.g. '192.168.1.105'
  final int latencyMs; // e.g. 24 ms
  final String statusMessage; // 'Internet Connected', 'WiFi ON (No Internet)', 'Disconnected'
  final DateTime timestamp;

  const NetworkInfoData({
    required this.networkType,
    required this.networkName,
    required this.isOnline,
    required this.ipAddress,
    required this.latencyMs,
    required this.statusMessage,
    required this.timestamp,
  });

  factory NetworkInfoData.initial() {
    return NetworkInfoData(
      networkType: 'checking',
      networkName: 'Checking Connection...',
      isOnline: false,
      ipAddress: 'Detecting...',
      latencyMs: -1,
      statusMessage: 'Detecting network state...',
      timestamp: DateTime.now(),
    );
  }

  factory NetworkInfoData.offline() {
    return NetworkInfoData(
      networkType: 'offline',
      networkName: 'Disconnected / Offline',
      isOnline: false,
      ipAddress: 'N/A',
      latencyMs: -1,
      statusMessage: 'WiFi & Mobile Data OFF',
      timestamp: DateTime.now(),
    );
  }

  bool get isWifi => networkType == 'wifi';
  bool get isCellular => networkType == 'cellular';
  bool get isDisconnected => networkType == 'offline';
  String get connectionLabel => networkName;

  /// True if connection is poor, laggy (>= 150ms), or connected without real internet
  bool get isBadConnection =>
      (!isOnline && networkType != 'offline') ||
      (isOnline && latencyMs >= 150);

  String get qualityLabel {
    if (networkType == 'offline') return "OFFLINE";
    if (!isOnline) return "LIMITED / NO INTERNET";
    if (latencyMs < 0) return "DETECTING";
    if (latencyMs < 60) return "EXCELLENT";
    if (latencyMs < 150) return "GOOD";
    if (latencyMs < 300) return "UNSTABLE / HIGH PING";
    return "POOR / CRITICAL LAG";
  }

  NetworkInfoData copyWith({
    String? networkType,
    String? networkName,
    bool? isOnline,
    String? ipAddress,
    int? latencyMs,
    String? statusMessage,
    DateTime? timestamp,
  }) {
    return NetworkInfoData(
      networkType: networkType ?? this.networkType,
      networkName: networkName ?? this.networkName,
      isOnline: isOnline ?? this.isOnline,
      ipAddress: ipAddress ?? this.ipAddress,
      latencyMs: latencyMs ?? this.latencyMs,
      statusMessage: statusMessage ?? this.statusMessage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'networkType': networkType,
      'networkName': networkName,
      'isOnline': isOnline,
      'ipAddress': ipAddress,
      'latencyMs': latencyMs,
      'isBadConnection': isBadConnection,
      'qualityLabel': qualityLabel,
      'statusMessage': statusMessage,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }
}

class NetworkConnectivityService {
  static final NetworkConnectivityService instance =
      NetworkConnectivityService._internal();

  NetworkConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final StreamController<NetworkInfoData> _networkStreamController =
      StreamController<NetworkInfoData>.broadcast();

  Stream<NetworkInfoData> get networkStream =>
      _networkStreamController.stream;

  NetworkInfoData _currentInfo = NetworkInfoData.initial();
  NetworkInfoData get currentInfo => _currentInfo;

  /// Starts listening to real-time network toggle events (WiFi ON/OFF, Cellular ON/OFF)
  void startMonitoring() {
    _connectivitySubscription?.cancel();

    // Query immediate status
    checkCurrentNetwork();

    // Listen to live stream
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final info = await _resolveNetworkInfo(results);
        _currentInfo = info;
        _networkStreamController.add(info);

        DiagnosticsLoggerService.instance.info(
          "NETWORK_STATE_CHANGED",
          "Network status changed to '${info.networkName}' [Online: ${info.isOnline}] (IP: ${info.ipAddress}, Ping: ${info.latencyMs >= 0 ? '${info.latencyMs}ms' : 'N/A'})",
          payload: info.toJson(),
        );
      },
    );
  }

  /// Manually checks and refreshes network status & ping latency
  Future<NetworkInfoData> checkCurrentNetwork() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final info = await _resolveNetworkInfo(results);
      _currentInfo = info;
      _networkStreamController.add(info);
      return info;
    } catch (_) {
      final fallback = NetworkInfoData.offline();
      _currentInfo = fallback;
      _networkStreamController.add(fallback);
      return fallback;
    }
  }

  /// Probes real internet ping latency in milliseconds
  Future<int> probePingLatency() async {
    if (kIsWeb) return -1;
    try {
      final stopwatch = Stopwatch()..start();
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      stopwatch.stop();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return stopwatch.elapsedMilliseconds;
      }
    } catch (_) {}
    return -1;
  }

  /// Resolves detailed network state, IP address, and reachability
  Future<NetworkInfoData> _resolveNetworkInfo(
      List<ConnectivityResult> results) async {
    // 1. Determine hardware transport type
    String type = 'offline';
    String name = 'Disconnected / Offline';

    if (results.contains(ConnectivityResult.wifi)) {
      type = 'wifi';
      name = 'WiFi Network';
    } else if (results.contains(ConnectivityResult.mobile)) {
      type = 'cellular';
      name = 'Cellular Data (4G/5G)';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      type = 'ethernet';
      name = 'Ethernet Wired';
    } else if (results.contains(ConnectivityResult.vpn)) {
      type = 'vpn';
      name = 'VPN Tunnel';
    } else {
      return NetworkInfoData.offline();
    }

    // 2. Resolve local device IP address
    String ipAddress = '127.0.0.1';
    try {
      if (!kIsWeb) {
        final interfaces = await NetworkInterface.list(
          includeLoopback: false,
          type: InternetAddressType.IPv4,
        );
        for (final iface in interfaces) {
          for (final addr in iface.addresses) {
            if (!addr.isLoopback && addr.address.isNotEmpty) {
              ipAddress = addr.address;
              break;
            }
          }
          if (ipAddress != '127.0.0.1') break;
        }
      }
    } catch (_) {}

    // 3. Verify actual Internet reachability & measure latency
    bool isOnline = false;
    int latencyMs = -1;
    String statusMsg = "Connected";

    if (!kIsWeb) {
      try {
        final stopwatch = Stopwatch()..start();
        final lookup = await InternetAddress.lookup('google.com')
            .timeout(const Duration(milliseconds: 2500));
        stopwatch.stop();

        if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
          isOnline = true;
          latencyMs = stopwatch.elapsedMilliseconds;
          statusMsg = "Internet Online (${latencyMs}ms)";
        } else {
          isOnline = false;
          statusMsg = "$name ON (No Internet)";
        }
      } catch (_) {
        isOnline = false;
        statusMsg = "$name ON (No Internet Access)";
      }
    } else {
      isOnline = type != 'offline';
      statusMsg = "Web Connected";
    }

    return NetworkInfoData(
      networkType: type,
      networkName: name,
      isOnline: isOnline,
      ipAddress: ipAddress,
      latencyMs: latencyMs,
      statusMessage: statusMsg,
      timestamp: DateTime.now(),
    );
  }

  /// Toggles or triggers a bad connection state (high ping spike 385ms) for animation demo
  void simulateBadConnection() {
    final isAlreadyBad = _currentInfo.isBadConnection;
    if (isAlreadyBad) {
      // Re-probe real connection to reset
      checkCurrentNetwork();
      return;
    }

    final simulated = NetworkInfoData(
      networkType: _currentInfo.networkType == 'offline' ? 'wifi' : _currentInfo.networkType,
      networkName: _currentInfo.networkType == 'offline' ? 'WiFi Network' : _currentInfo.networkName,
      isOnline: true,
      ipAddress: _currentInfo.ipAddress,
      latencyMs: 385, // High latency / Lag
      statusMessage: "Koneksi Tidak Stabil (High Ping 385ms)",
      timestamp: DateTime.now(),
    );
    _currentInfo = simulated;
    _networkStreamController.add(simulated);
    DiagnosticsLoggerService.instance.warn(
      "NETWORK_WARNING",
      "Koneksi jaringan terdeteksi JELEK / UNSTABLE! (Ping: 385ms, High Latency Spike)",
      payload: simulated.toJson(),
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStreamController.close();
  }
}
