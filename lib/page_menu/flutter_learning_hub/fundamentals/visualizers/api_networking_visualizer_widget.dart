import 'package:flutter/material.dart';

class ApiNetworkingVisualizerWidget extends StatefulWidget {
  const ApiNetworkingVisualizerWidget({super.key});

  @override
  State<ApiNetworkingVisualizerWidget> createState() =>
      _ApiNetworkingVisualizerWidgetState();
}

class _ApiNetworkingVisualizerWidgetState
    extends State<ApiNetworkingVisualizerWidget> {
  int _selectedScenario = 0;
  bool _isLoading = false;
  List<String> _interceptorLogs = [];
  Map<String, dynamic>? _activeResponse;
  int _statusCode = 200;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': '1. GET Request + Bearer JWT',
      'endpoint': 'GET https://api.naltech.id/v1/users/profile',
      'headers': 'Authorization: Bearer eyJhbGciOiJIUzI1Ni...',
      'statusCode': 200,
      'statusText': '200 OK',
      'logs': [
        '[Dio.onRequest]: Menambahkan header Authorization: Bearer JWT',
        '[Dio.onRequest]: Request dikirim ke server...',
        '[Dio.onResponse]: Menerima respon status 200 OK (240ms)',
      ],
      'response': {
        'status': 'success',
        'data': {
          'id': 'USR-902',
          'name': 'Zainal Salamun',
          'role': 'Senior Flutter Engineer',
          'email': 'zainal@naltech.id',
        },
      },
    },
    {
      'title': '2. POST + Request Body',
      'endpoint': 'POST https://api.naltech.id/v1/orders/checkout',
      'headers': 'Content-Type: application/json\nAuthorization: Bearer eyJhbGciOi...',
      'statusCode': 201,
      'statusText': '201 Created',
      'logs': [
        '[Dio.onRequest]: Validasi payload JSON sebelum kirim',
        '[Dio.onRequest]: Mengirim body: {"item_id": "PRD-1", "qty": 2}',
        '[Dio.onResponse]: Transaksi sukses, order ID dibuat: ORD-7789',
      ],
      'response': {
        'status': 'created',
        'order_id': 'ORD-7789',
        'total_amount': 450000,
        'payment_status': 'PENDING_PAYMENT',
      },
    },
    {
      'title': '3. 401 Token Refresh Interceptor',
      'endpoint': 'GET https://api.naltech.id/v1/analytics/dashboard',
      'headers': 'Authorization: Bearer EXPIRED_TOKEN',
      'statusCode': 200,
      'statusText': '200 OK (After Auto-Refresh)',
      'logs': [
        '[Dio.onRequest]: Mengirim request dengan token lama',
        '[Dio.onError]: Menerima 401 Unauthorized (Token Kedaluwarsa)',
        '[Interceptor]: Mengunci request queue & memanggil POST /auth/refresh-token',
        '[Interceptor]: Token baru didapatkan: eyJhbGciOiJIUzI1Ni.NEW_TOKEN',
        '[Dio.retry]: Mengirim ulang request awal dengan Token Baru -> Sukses 200 OK!',
      ],
      'response': {
        'status': 'success',
        'data': {
          'views_today': 14820,
          'active_sessions': 342,
          'token_refreshed': true,
        },
      },
    },
    {
      'title': '4. Offline Fallback (Cache First)',
      'endpoint': 'GET https://api.naltech.id/v1/news/feed',
      'headers': 'Cache-Control: max-age=3600',
      'statusCode': 200,
      'statusText': '200 OK (From Local Cache)',
      'logs': [
        '[Connectivity]: Perangkat sedang Offline (Tidak ada sinyal)',
        '[CacheInterceptor]: Mencegat request sebelum memicu SocketException',
        '[HiveStorage]: Membaca snapshot cache data lokal terakhir',
        '[Repository]: Mengembalikan 10 artikel berita tersimpan secara instan',
      ],
      'response': {
        'source': 'LOCAL_HIVE_CACHE',
        'cached_at': '2026-09-23 20:00:00',
        'articles_count': 10,
        'is_offline': true,
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadScenario(0);
  }

  void _loadScenario(int index) {
    setState(() {
      _selectedScenario = index;
      _isLoading = true;
      _interceptorLogs = [];
      _activeResponse = null;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final sc = _scenarios[index];
        setState(() {
          _isLoading = false;
          _interceptorLogs = List<String>.from(sc['logs'] as List);
          _activeResponse = sc['response'] as Map<String, dynamic>;
          _statusCode = sc['statusCode'] as int;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cur = _scenarios[_selectedScenario];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.http_rounded, color: Color(0xFF38BDF8), size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Simulator Alur REST API & Interceptors',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Scenario Selection Tabs
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _scenarios.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final isSel = _selectedScenario == index;
                final sc = _scenarios[index];
                final title = sc['title'].toString().split('. ')[1];

                return InkWell(
                  onTap: () => _loadScenario(index),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSel ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isSel ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Endpoint & Method Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cur['endpoint'].toString().startsWith('GET')
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        cur['endpoint'].toString().split(' ')[0],
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cur['endpoint'].toString().split(' ')[1],
                        style: const TextStyle(
                          color: Color(0xFF7DD3FC),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  cur['headers'] as String,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Interceptor Timeline Logs
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.alt_route_rounded, color: Color(0xFFF59E0B), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Log Interceptor & Pipeline:',
                      style: TextStyle(color: Color(0xFFFBBF24), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ..._interceptorLogs.map((log) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      log,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.5,
                        color: log.contains('401')
                            ? const Color(0xFFF87171)
                            : log.contains('Sukses') || log.contains('200')
                                ? const Color(0xFF4ADE80)
                                : const Color(0xFFCBD5E1),
                        height: 1.3,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Response Status & Payload
          if (_activeResponse != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _statusCode == 200 || _statusCode == 201
                      ? const Color(0xFF22C55E).withValues(alpha: 0.4)
                      : const Color(0xFFEF4444).withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusCode == 200 || _statusCode == 201
                              ? const Color(0xFF15803D)
                              : const Color(0xFFB91C1C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          cur['statusText'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Response Payload (JSON):',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    _activeResponse.toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF38BDF8),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
