import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FaceIdBiometricScannerShowcase extends StatefulWidget {
  const FaceIdBiometricScannerShowcase({super.key});

  @override
  State<FaceIdBiometricScannerShowcase> createState() =>
      _FaceIdBiometricScannerShowcaseState();
}

enum _ScanState { idle, scanning, analyzing, success, failed }

class _FaceIdBiometricScannerShowcaseState
    extends State<FaceIdBiometricScannerShowcase>
    with SingleTickerProviderStateMixin {
  _ScanState _scanState = _ScanState.idle;
  String _statusText = 'Posisikan wajah Anda di dalam bingkai pemindai';
  bool _simulateSuccess = true;
  int _scanDurationMs = 2000;

  // Scanner animation controller
  late AnimationController _scannerAnimController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _scannerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scanLineAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _scannerAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerAnimController.dispose();
    super.dispose();
  }

  void _startScan() async {
    if (_scanState == _ScanState.scanning || _scanState == _ScanState.analyzing)
      return;

    HapticFeedback.mediumImpact();

    setState(() {
      _scanState = _ScanState.scanning;
      _statusText = 'Mendeteksi titik biometrik wajah...';
    });

    _scannerAnimController.repeat(reverse: true);

    // Step 1: Scanning phase
    await Future.delayed(
      Duration(milliseconds: (_scanDurationMs * 0.6).round()),
    );
    if (!mounted) return;

    setState(() {
      _scanState = _ScanState.analyzing;
      _statusText = 'Mencocokkan kontur 3D & retina AI...';
    });

    // Step 2: Analyzing phase
    await Future.delayed(
      Duration(milliseconds: (_scanDurationMs * 0.4).round()),
    );
    if (!mounted) return;

    _scannerAnimController.stop();

    setState(() {
      if (_simulateSuccess) {
        _scanState = _ScanState.success;
        _statusText = 'Autentikasi Berhasil! Selamat Datang.';
        HapticFeedback.lightImpact();
      } else {
        _scanState = _ScanState.failed;
        _statusText = 'Wajah tidak dikenali. Silakan coba lagi.';
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _resetScan() {
    _scannerAnimController.reset();
    setState(() {
      _scanState = _ScanState.idle;
      _statusText = 'Posisikan wajah Anda di dalam bingkai pemindai';
    });
  }

  Color _getStatusColor() {
    switch (_scanState) {
      case _ScanState.success:
        return const Color(0xFF10B981);
      case _ScanState.failed:
        return const Color(0xFFEF4444);
      case _ScanState.scanning:
      case _ScanState.analyzing:
        return const Color(0xFF38BDF8);
      case _ScanState.idle:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: Color(0xFF38BDF8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Face Biometric Scanner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Simulasi autentikasi biometrik wajah modern dengan laser scanning line, mesh landmarks, & haptic state feedback.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // VIEWFINDER SCANNER CAMERA CONTAINER
          Center(
            child: Container(
              width: 280,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.6),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. SILHOUETTE / FACE AVATAR
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 80,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 140,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 2. FACE MESH LANDMARK DOTS
                    CustomPaint(
                      size: const Size(280, 320),
                      painter: _FaceMeshPainter(
                        state: _scanState,
                        accentColor: statusColor,
                      ),
                    ),

                    // 3. SCANNING LASER BEAM
                    if (_scanState == _ScanState.scanning ||
                        _scanState == _ScanState.analyzing)
                      AnimatedBuilder(
                        animation: _scanLineAnimation,
                        builder: (context, child) {
                          return Positioned(
                            top: _scanLineAnimation.value * 300,
                            left: 20,
                            right: 20,
                            child: Column(
                              children: [
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF38BDF8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF38BDF8,
                                        ).withValues(alpha: 0.8),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 18,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(
                                          0xFF38BDF8,
                                        ).withValues(alpha: 0.3),
                                        const Color(
                                          0xFF38BDF8,
                                        ).withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    // 4. SUCCESS / FAILED RESULT OVERLAY
                    if (_scanState == _ScanState.success)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF10B981),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      )
                    else if (_scanState == _ScanState.failed)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEF4444),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // LIVE STATUS TEXT
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              _statusText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: statusColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 20),

          // MAIN ACTION BUTTONS
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed:
                      (_scanState == _ScanState.scanning ||
                              _scanState == _ScanState.analyzing)
                          ? null
                          : _startScan,
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: Text(
                    _scanState == _ScanState.idle
                        ? 'Mulai Pindai Wajah'
                        : 'Pindai Ulang',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _resetScan,
                tooltip: 'Reset Status',
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // SIMULATION CONTROLS CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengaturan Simulasi:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasil Simulasi Berhasil (Match)',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          Text(
                            'Nonaktifkan untuk menguji respon wajah gagal dikenali',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _simulateSuccess,
                      activeThumbColor: const Color(0xFF10B981),
                      onChanged: (val) {
                        setState(() => _simulateSuccess = val);
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kecepatan Scan:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Cepat (1.2s)')),
                            selected: _scanDurationMs == 1200,
                            onSelected: (val) {
                              if (val) setState(() => _scanDurationMs = 1200);
                            },
                            selectedColor: const Color(0xFF38BDF8),
                            backgroundColor: const Color(0xFF0F172A),
                            labelStyle: TextStyle(
                              color:
                                  _scanDurationMs == 1200
                                      ? Colors.black
                                      : Colors.white70,
                              fontSize: 11,
                              fontWeight:
                                  _scanDurationMs == 1200
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Akurat (2.5s)')),
                            selected: _scanDurationMs == 2500,
                            onSelected: (val) {
                              if (val) setState(() => _scanDurationMs = 2500);
                            },
                            selectedColor: const Color(0xFF38BDF8),
                            backgroundColor: const Color(0xFF0F172A),
                            labelStyle: TextStyle(
                              color:
                                  _scanDurationMs == 2500
                                      ? Colors.black
                                      : Colors.white70,
                              fontSize: 11,
                              fontWeight:
                                  _scanDurationMs == 2500
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
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
}

class _FaceMeshPainter extends CustomPainter {
  final _ScanState state;
  final Color accentColor;

  _FaceMeshPainter({required this.state, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Viewfinder Corner Brackets [ ]
    final cornerPaint =
        Paint()
          ..color = accentColor
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    const cornerLen = 24.0;
    const padding = 22.0;

    // Top-Left
    canvas.drawLine(
      const Offset(padding, padding),
      const Offset(padding + cornerLen, padding),
      cornerPaint,
    );
    canvas.drawLine(
      const Offset(padding, padding),
      const Offset(padding, padding + cornerLen),
      cornerPaint,
    );

    // Top-Right
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(size.width - padding - cornerLen, padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(size.width - padding, padding + cornerLen),
      cornerPaint,
    );

    // Bottom-Left
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(padding + cornerLen, size.height - padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(padding, size.height - padding - cornerLen),
      cornerPaint,
    );

    // Bottom-Right
    canvas.drawLine(
      Offset(size.width - padding, size.height - padding),
      Offset(size.width - padding - cornerLen, size.height - padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - padding, size.height - padding),
      Offset(size.width - padding, size.height - padding - cornerLen),
      cornerPaint,
    );

    // 2. Draw Facial Mesh Keypoints
    if (state == _ScanState.scanning || state == _ScanState.analyzing) {
      final dotPaint = Paint()..color = accentColor;
      final meshLinePaint =
          Paint()
            ..color = accentColor.withValues(alpha: 0.3)
            ..strokeWidth = 1.0;

      final keypoints = [
        Offset(size.width * 0.36, size.height * 0.36), // Left Eye
        Offset(size.width * 0.64, size.height * 0.36), // Right Eye
        Offset(size.width * 0.50, size.height * 0.44), // Nose Bridge
        Offset(size.width * 0.50, size.height * 0.52), // Nose Tip
        Offset(size.width * 0.40, size.height * 0.60), // Left Mouth
        Offset(size.width * 0.60, size.height * 0.60), // Right Mouth
        Offset(size.width * 0.50, size.height * 0.68), // Chin
        Offset(size.width * 0.28, size.height * 0.48), // Left Cheek
        Offset(size.width * 0.72, size.height * 0.48), // Right Cheek
      ];

      // Draw mesh connection lines
      if (state == _ScanState.analyzing) {
        for (int i = 0; i < keypoints.length; i++) {
          for (int j = i + 1; j < keypoints.length; j++) {
            final dist = (keypoints[i] - keypoints[j]).distance;
            if (dist < 75) {
              canvas.drawLine(keypoints[i], keypoints[j], meshLinePaint);
            }
          }
        }
      }

      // Draw points with halo
      for (final pt in keypoints) {
        canvas.drawCircle(pt, 3.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
