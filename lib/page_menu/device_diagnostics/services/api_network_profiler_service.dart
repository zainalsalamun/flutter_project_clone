import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/api_network_profiler_model.dart';
import 'diagnostics_logger_service.dart';

class ApiNetworkProfilerService {
  static final ApiNetworkProfilerService instance =
      ApiNetworkProfilerService._internal();

  ApiNetworkProfilerService._internal();

  int _sessionRxBytes = 0;
  int _sessionTxBytes = 0;
  int _sessionRequestCount = 0;
  final List<ApiEndpointBenchmark> _lastBenchmarks = [];

  final StreamController<SessionBandwidthSummary> _summaryController =
      StreamController<SessionBandwidthSummary>.broadcast();

  Stream<SessionBandwidthSummary> get summaryStream => _summaryController.stream;

  final List<Map<String, String>> _defaultEndpoints = [
    {
      'id': 'cloudinary',
      'name': 'Cloudinary CDN Image Engine',
      'url': 'https://res.cloudinary.com',
      'method': 'HEAD',
    },
    {
      'id': 'firebase_auth',
      'name': 'Firebase Auth API Gateway',
      'url': 'https://identitytoolkit.googleapis.com',
      'method': 'HEAD',
    },
    {
      'id': 'cloudflare_edge',
      'name': 'Cloudflare Edge Anycast',
      'url': 'https://1.1.1.1/cdn-cgi/trace',
      'method': 'GET',
    },
    {
      'id': 'google_services',
      'name': 'Google Cloud Core API',
      'url': 'https://www.googleapis.com/discovery/v1/apis',
      'method': 'HEAD',
    },
    {
      'id': 'github_api',
      'name': 'GitHub REST API Engine',
      'url': 'https://api.github.com',
      'method': 'HEAD',
    },
  ];

  /// Records external network transfer from other services (e.g. upload/download speedtest, geotagging uploads)
  void recordTransfer({int rxBytes = 0, int txBytes = 0}) {
    _sessionRxBytes += rxBytes;
    _sessionTxBytes += txBytes;
    _sessionRequestCount++;
    _emitSummary();
  }

  /// Benchmarks a single URL and measures latency, status code, and compression
  Future<ApiEndpointBenchmark> benchmarkEndpoint({
    required String id,
    required String name,
    required String url,
    String method = 'GET',
  }) async {
    final client = http.Client();
    final sw = Stopwatch()..start();

    int statusCode = 0;
    bool isSuccess = false;
    bool isGzip = false;
    int respSize = 0;
    int estRequestBytes = url.length + 150; // Estimated HTTP headers overhead

    try {
      final uri = Uri.parse(url);
      http.Response response;

      if (method == 'HEAD') {
        response = await client
            .head(uri, headers: {'Accept-Encoding': 'gzip, deflate'})
            .timeout(const Duration(seconds: 8));
      } else {
        response = await client
            .get(uri, headers: {'Accept-Encoding': 'gzip, deflate'})
            .timeout(const Duration(seconds: 8));
      }

      sw.stop();
      statusCode = response.statusCode;
      isSuccess = statusCode >= 200 && statusCode < 400;

      final enc = response.headers['content-encoding'] ?? '';
      isGzip = enc.contains('gzip') || enc.contains('br') || enc.contains('deflate');
      respSize = response.bodyBytes.length;

      // Add to session bandwidth
      _sessionRxBytes += respSize + 200; // Response bytes + headers
      _sessionTxBytes += estRequestBytes;
      _sessionRequestCount++;
    } catch (_) {
      sw.stop();
      statusCode = 0;
      isSuccess = false;
    } finally {
      client.close();
    }

    final latency = sw.elapsedMilliseconds > 0 ? sw.elapsedMilliseconds : 1;

    final benchmark = ApiEndpointBenchmark(
      id: id,
      name: name,
      url: url,
      method: method,
      latencyMs: latency,
      statusCode: statusCode,
      isSuccess: isSuccess,
      isGzipCompressed: isGzip,
      responseSizeBytes: respSize,
      testedAt: DateTime.now(),
    );

    DiagnosticsLoggerService.instance.info(
      "API_BENCHMARK",
      "Benchmark $name: ${benchmark.formattedLatency} (HTTP ${benchmark.statusCode})",
      payload: {
        'url': url,
        'latencyMs': latency,
        'status': statusCode,
        'compressed': isGzip,
      },
    );

    return benchmark;
  }

  /// Runs concurrent benchmarks against all default endpoints
  Future<List<ApiEndpointBenchmark>> benchmarkAllDefaultEndpoints() async {
    final futures = _defaultEndpoints.map((ep) {
      return benchmarkEndpoint(
        id: ep['id']!,
        name: ep['name']!,
        url: ep['url']!,
        method: ep['method'] ?? 'GET',
      );
    }).toList();

    final results = await Future.wait(futures);
    _lastBenchmarks.clear();
    _lastBenchmarks.addAll(results);
    _emitSummary();
    return results;
  }

  /// Tests a custom URL provided by the user
  Future<ApiEndpointBenchmark> testCustomUrl(String customUrl) async {
    String formattedUrl = customUrl.trim();
    if (!formattedUrl.startsWith("http://") && !formattedUrl.startsWith("https://")) {
      formattedUrl = "https://$formattedUrl";
    }

    final result = await benchmarkEndpoint(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Custom Endpoint',
      url: formattedUrl,
      method: 'GET',
    );

    _lastBenchmarks.insert(0, result);
    _emitSummary();
    return result;
  }

  SessionBandwidthSummary getSessionSummary() {
    return SessionBandwidthSummary(
      totalRxBytes: _sessionRxBytes,
      totalTxBytes: _sessionTxBytes,
      totalRequestsCount: _sessionRequestCount,
      benchmarks: List.unmodifiable(_lastBenchmarks),
      updatedAt: DateTime.now(),
    );
  }

  void _emitSummary() {
    _summaryController.add(getSessionSummary());
  }

  void dispose() {
    _summaryController.close();
  }
}
