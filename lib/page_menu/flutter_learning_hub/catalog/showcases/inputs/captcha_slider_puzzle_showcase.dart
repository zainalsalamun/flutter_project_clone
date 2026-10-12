import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaptchaSliderPuzzleShowcase extends StatefulWidget {
  const CaptchaSliderPuzzleShowcase({super.key});

  @override
  State<CaptchaSliderPuzzleShowcase> createState() =>
      _CaptchaSliderPuzzleShowcaseState();
}

enum _CaptchaStatus { idle, dragging, success, failed }

class _CaptchaSliderPuzzleShowcaseState
    extends State<CaptchaSliderPuzzleShowcase>
    with SingleTickerProviderStateMixin {
  // Puzzle Target Position (0.35 to 0.85)
  double _targetX = 0.65;
  double _targetY = 0.45;

  // Slider Drag Position (0.0 to 1.0)
  double _sliderValue = 0.0;
  _CaptchaStatus _status = _CaptchaStatus.idle;
  String _message = 'Geser slider di bawah untuk melengkapi puzzle';

  // Animation controller for snapping / shake
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  final math.Random _random = math.Random();

  DateTime? _dragStartTime;
  double _tolerance = 0.04; // ~10 pixels

  @override
  void initState() {
    super.initState();
    _randomizeTarget();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _randomizeTarget() {
    setState(() {
      _targetX = 0.35 + (_random.nextDouble() * 0.45);
      _targetY = 0.25 + (_random.nextDouble() * 0.40);
      _sliderValue = 0.0;
      _status = _CaptchaStatus.idle;
      _message = 'Geser slider di bawah untuk melengkapi puzzle';
    });
  }

  void _onSliderChanged(double value) {
    if (_status == _CaptchaStatus.success) return;

    _dragStartTime ??= DateTime.now();

    setState(() {
      _sliderValue = value;
      _status = _CaptchaStatus.dragging;
      _message = 'Posisikan potongan puzzle tepat di lubang sasaran';
    });
  }

  void _onSliderChangeEnd(double value) {
    if (_status == _CaptchaStatus.success) return;

    final elapsedMs =
        _dragStartTime != null
            ? DateTime.now().difference(_dragStartTime!).inMilliseconds
            : 800;
    _dragStartTime = null;

    final diff = (_sliderValue - _targetX).abs();

    if (diff <= _tolerance) {
      // SUCCESS MATCH
      HapticFeedback.lightImpact();
      setState(() {
        _status = _CaptchaStatus.success;
        _sliderValue = _targetX; // Snap exactly
        _message =
            ' Verifikasi Berhasil! (${(elapsedMs / 1000).toStringAsFixed(1)}s)';
      });
    } else {
      // FAILED MATCH
      HapticFeedback.heavyImpact();
      setState(() {
        _status = _CaptchaStatus.failed;
        _message = 'Posisi puzzle meleset. Coba lagi!';
      });

      _shakeController.forward(from: 0.0).then((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _status == _CaptchaStatus.failed) {
            _randomizeTarget();
          }
        });
      });
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case _CaptchaStatus.success:
        return const Color(0xFF10B981);
      case _CaptchaStatus.failed:
        return const Color(0xFFEF4444);
      case _CaptchaStatus.dragging:
        return const Color(0xFF38BDF8);
      case _CaptchaStatus.idle:
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
                    Icons.security_rounded,
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
                        'Fintech Slider Puzzle CAPTCHA',
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
                        'Verifikasi keamanan bot anti-spam dengan menggeser potongan puzzle ke lubang sasaran.',
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

          const SizedBox(height: 20),

          // PUZZLE CARD CONTAINER
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              );
            },
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // PUZZLE GRAPHIC BACKDROP CANVAS
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 190,
                      child: Stack(
                        children: [
                          // 1. GRADIENT BACKDROP ARTWORK
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF0F172A),
                                  Color(0xFF1E1B4B),
                                  Color(0xFF311042),
                                ],
                              ),
                            ),
                          ),

                          // VECTOR MOUNTAIN SILHOUETTE
                          CustomPaint(
                            size: const Size(360, 190),
                            painter: _BackdropIllustrationPainter(),
                          ),

                          // 2. TARGET PUZZLE CUTOUT (HOLE)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final targetPixelX =
                                  _targetX * (constraints.maxWidth - 46);
                              final targetPixelY = _targetY * (190 - 46);

                              return Positioned(
                                left: targetPixelX,
                                top: targetPixelY,
                                child: CustomPaint(
                                  size: const Size(46, 46),
                                  painter: _PuzzlePiecePainter(
                                    isCutoutHole: true,
                                    fillColor: Colors.black.withValues(
                                      alpha: 0.65,
                                    ),
                                    strokeColor: Colors.white60,
                                  ),
                                ),
                              );
                            },
                          ),

                          // 3. SLIDING PUZZLE PIECE
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final piecePixelX =
                                  _sliderValue * (constraints.maxWidth - 46);
                              final piecePixelY = _targetY * (190 - 46);

                              return Positioned(
                                left: piecePixelX,
                                top: piecePixelY,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CustomPaint(
                                    size: const Size(46, 46),
                                    painter: _PuzzlePiecePainter(
                                      isCutoutHole: false,
                                      fillColor:
                                          _status == _CaptchaStatus.success
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFF38BDF8),
                                      strokeColor: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // REFRESH BUTTON (TOP RIGHT)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              onPressed: _randomizeTarget,
                              tooltip: 'Acak Posisi Puzzle',
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black45,
                                padding: const EdgeInsets.all(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // STATUS TEXT
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 14),

                  // SLIDER TRACK
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: statusColor,
                      inactiveTrackColor: const Color(0xFF334155),
                      trackHeight: 12,
                      thumbColor: statusColor,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 16,
                      ),
                      overlayColor: statusColor.withValues(alpha: 0.2),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 24,
                      ),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: _onSliderChanged,
                      onChangeEnd: _onSliderChangeEnd,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CONTROLS & TOLERANCE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tingkat Toleransi Akurasi:',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text(
                          _tolerance == 0.04
                              ? 'Normal (±10px)'
                              : 'Ketat (±5px)',
                          textAlign: TextAlign.center,
                        ),
                        selected: _tolerance == 0.02,
                        onSelected: (val) {
                          setState(() {
                            _tolerance = val ? 0.02 : 0.04;
                          });
                        },
                        selectedColor: const Color(0xFF38BDF8),
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: TextStyle(
                          color:
                              _tolerance == 0.02
                                  ? Colors.black
                                  : Colors.white70,
                          fontSize: 11,
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
    );
  }
}

class _PuzzlePiecePainter extends CustomPainter {
  final bool isCutoutHole;
  final Color fillColor;
  final Color strokeColor;

  _PuzzlePiecePainter({
    required this.isCutoutHole,
    required this.fillColor,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(0, 0);

    // Top edge with protruding tab
    path.lineTo(w * 0.38, 0);
    path.arcToPoint(
      Offset(w * 0.62, 0),
      radius: const Radius.circular(7),
      clockwise: false,
    );
    path.lineTo(w, 0);

    // Right edge with protruding tab
    path.lineTo(w, h * 0.38);
    path.arcToPoint(
      Offset(w, h * 0.62),
      radius: const Radius.circular(7),
      clockwise: true,
    );
    path.lineTo(w, h);

    // Bottom edge with indented socket
    path.lineTo(w * 0.62, h);
    path.arcToPoint(
      Offset(w * 0.38, h),
      radius: const Radius.circular(7),
      clockwise: false,
    );
    path.lineTo(0, h);

    // Left edge straight
    path.close();

    final fillPaint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = strokeColor
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BackdropIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Cyberpunk mountain backdrop
    final mountainPaint1 =
        Paint()..color = const Color(0xFF3B82F6).withValues(alpha: 0.25);
    final mountainPaint2 =
        Paint()..color = const Color(0xFF8B5CF6).withValues(alpha: 0.35);

    // Distant Mountain
    final p1 =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width * 0.2, size.height * 0.4)
          ..lineTo(size.width * 0.5, size.height * 0.7)
          ..lineTo(size.width * 0.8, size.height * 0.3)
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(p1, mountainPaint1);

    // Foreground Mountain
    final p2 =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width * 0.4, size.height * 0.55)
          ..lineTo(size.width * 0.7, size.height * 0.8)
          ..lineTo(size.width, size.height * 0.5)
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(p2, mountainPaint2);

    // Stars / City Lights
    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.2),
      2.0,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.45, size.height * 0.15),
      1.5,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.22),
      2.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
