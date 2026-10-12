import 'dart:async';
import 'package:flutter/material.dart';

class FingerprintScannerShowcase extends StatefulWidget {
  const FingerprintScannerShowcase({super.key});

  @override
  State<FingerprintScannerShowcase> createState() =>
      _FingerprintScannerShowcaseState();
}

class _FingerprintScannerShowcaseState extends State<FingerprintScannerShowcase>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _laserController;
  late AnimationController _holdProgressController;

  _ScanState _scanState = _ScanState.idle;
  bool _simulateFailureMode = false;
  String _statusText = 'Sentuh & Tahan sensor sidik jari';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _holdProgressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finishScan();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _laserController.dispose();
    _holdProgressController.dispose();
    super.dispose();
  }

  void _onPressStart() {
    if (_scanState == _ScanState.success) return;

    setState(() {
      _scanState = _ScanState.scanning;
      _statusText = 'Memindai biometrik sidik jari...';
    });

    _laserController.repeat(reverse: true);
    _holdProgressController.forward(from: 0.0);
  }

  void _onPressEnd() {
    if (_scanState == _ScanState.scanning) {
      _laserController.stop();
      _holdProgressController.reset();
      setState(() {
        _scanState = _ScanState.idle;
        _statusText = 'Pemindaian dibatalkan. Tahan lebih lama.';
      });
    }
  }

  void _finishScan() {
    _laserController.stop();

    setState(() {
      if (_simulateFailureMode) {
        _scanState = _ScanState.failed;
        _statusText = 'Gagal! Sidik jari tidak dikenali.';
      } else {
        _scanState = _ScanState.success;
        _statusText = 'Autentikasi Berhasil! Identitas Terverifikasi.';
      }
    });

    // Auto reset after 3 seconds if needed
    Timer(const Duration(seconds: 3), () {
      if (mounted && _scanState != _ScanState.scanning) {
        setState(() {
          _scanState = _ScanState.idle;
          _statusText = 'Sentuh & Tahan sensor sidik jari';
          _holdProgressController.reset();
        });
      }
    });
  }

  Color _getPrimaryColor() {
    switch (_scanState) {
      case _ScanState.idle:
        return const Color(0xFF38BDF8); // Cyan
      case _ScanState.scanning:
        return const Color(0xFF6366F1); // Indigo
      case _ScanState.success:
        return const Color(0xFF10B981); // Emerald Green
      case _ScanState.failed:
        return const Color(0xFFEF4444); // Rose Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _getPrimaryColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Biometric Scanner Card Box
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Security Shield Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security_rounded, size: 16, color: activeColor),
                  const SizedBox(width: 6),
                  Text(
                    'BIOMETRIC AUTHENTICATION',
                    style: TextStyle(
                      color: activeColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Interactive Fingerprint Sensor Radar Stack
              GestureDetector(
                onTapDown: (_) => _onPressStart(),
                onTapUp: (_) => _onPressEnd(),
                onTapCancel: () => _onPressEnd(),
                child: SizedBox(
                  width: 170,
                  height: 170,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Expanding Radar Pulse Waves
                      if (_scanState == _ScanState.idle ||
                          _scanState == _ScanState.scanning)
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(170, 170),
                              painter: _PulseRingsPainter(
                                progress: _pulseController.value,
                                color: activeColor,
                              ),
                            );
                          },
                        ),

                      // Circular Progress Ring during Hold
                      AnimatedBuilder(
                        animation: _holdProgressController,
                        builder: (context, child) {
                          return SizedBox(
                            width: 124,
                            height: 124,
                            child: CircularProgressIndicator(
                              value: _holdProgressController.value,
                              strokeWidth: 3.5,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                activeColor,
                              ),
                            ),
                          );
                        },
                      ),

                      // Central Fingerprint Button
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: activeColor.withValues(alpha: 0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.3),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(54),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Fingerprint Icon or Checkmark
                              Icon(
                                _scanState == _ScanState.success
                                    ? Icons.check_circle_rounded
                                    : _scanState == _ScanState.failed
                                    ? Icons.error_rounded
                                    : Icons.fingerprint_rounded,
                                size: 58,
                                color: activeColor,
                              ),

                              // Scanning Laser Light Beam Bar
                              if (_scanState == _ScanState.scanning)
                                AnimatedBuilder(
                                  animation: _laserController,
                                  builder: (context, child) {
                                    return Positioned(
                                      top: _laserController.value * 90 + 5,
                                      left: 10,
                                      right: 10,
                                      child: Container(
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF38BDF8),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF38BDF8,
                                              ).withValues(alpha: 0.8),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Status Message Readout
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _statusText,
                  key: ValueKey<String>(_statusText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Simulation Mode Toggle Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _simulateFailureMode
                        ? Icons.bug_report_rounded
                        : Icons.verified_user_rounded,
                    size: 18,
                    color:
                        _simulateFailureMode
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _simulateFailureMode
                        ? 'Mode: Simulasi Sidik Jari Salah'
                        : 'Mode: Autentikasi Normal (Valid)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              Switch.adaptive(
                value: _simulateFailureMode,
                activeColor: const Color(0xFFEF4444),
                onChanged: (val) => setState(() => _simulateFailureMode = val),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _ScanState { idle, scanning, success, failed }

// ---------------------------------------------------------------------------
// CONCENTRIC PULSE RADAR RINGS PAINTER
// ---------------------------------------------------------------------------
class _PulseRingsPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;

  _PulseRingsPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 2; i++) {
      final ringProgress = (progress + (i * 0.5)) % 1.0;
      final radius = 54 + (maxRadius - 54) * ringProgress;
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.4;

      final paint =
          Paint()
            ..color = color.withValues(alpha: opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulseRingsPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
