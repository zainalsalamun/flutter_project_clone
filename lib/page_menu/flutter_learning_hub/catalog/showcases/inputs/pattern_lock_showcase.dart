import 'package:flutter/material.dart';

class PatternLockShowcase extends StatefulWidget {
  const PatternLockShowcase({super.key});

  @override
  State<PatternLockShowcase> createState() => _PatternLockShowcaseState();
}

class _PatternLockShowcaseState extends State<PatternLockShowcase> {
  // Preset correct pattern: e.g., 'Z' shape: 0 -> 1 -> 2 -> 4 -> 6 -> 7 -> 8
  final List<int> _correctPattern = [0, 1, 2, 4, 6, 7, 8];

  List<int> _selectedDots = [];
  Offset? _currentTouchPoint;
  _PatternState _patternState = _PatternState.idle;
  String _statusMessage = 'Goreskan pola pembuka kunci (Contoh: Huruf Z)';

  void _onPanStart(DragStartDetails details, Size size) {
    setState(() {
      _selectedDots = [];
      _patternState = _PatternState.drawing;
      _statusMessage = 'Menghubungkan titik pola...';
      _checkHit(details.localPosition, size);
      _currentTouchPoint = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    setState(() {
      _checkHit(details.localPosition, size);
      _currentTouchPoint = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentTouchPoint = null;

      if (_selectedDots.length < 4) {
        _patternState = _PatternState.error;
        _statusMessage = 'Pola terlalu pendek (minimal 4 titik).';
      } else if (_isPatternCorrect(_selectedDots, _correctPattern)) {
        _patternState = _PatternState.success;
        _statusMessage = 'Pola Benar! Kunci berhasil dibuka.';
      } else {
        _patternState = _PatternState.error;
        _statusMessage = 'Pola Salah! Silakan coba lagi.';
      }
    });
  }

  bool _isPatternCorrect(List<int> entered, List<int> correct) {
    if (entered.length != correct.length) return false;
    for (int i = 0; i < entered.length; i++) {
      if (entered[i] != correct[i]) return false;
    }
    return true;
  }

  void _checkHit(Offset point, Size size) {
    const dotRadius = 26.0;
    final dotPositions = _getDotPositions(size);

    for (int i = 0; i < dotPositions.length; i++) {
      final dotCenter = dotPositions[i];
      final distance = (point - dotCenter).distance;

      if (distance <= dotRadius && !_selectedDots.contains(i)) {
        _selectedDots.add(i);
        break;
      }
    }
  }

  List<Offset> _getDotPositions(Size size) {
    final List<Offset> positions = [];
    final stepX = size.width / 4;
    final stepY = size.height / 4;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        positions.add(Offset(stepX * (col + 1), stepY * (row + 1)));
      }
    }
    return positions;
  }

  void _resetPattern() {
    setState(() {
      _selectedDots = [];
      _currentTouchPoint = null;
      _patternState = _PatternState.idle;
      _statusMessage = 'Goreskan pola pembuka kunci (Contoh: Huruf Z)';
    });
  }

  Color _getStatusColor() {
    switch (_patternState) {
      case _PatternState.drawing:
        return const Color(0xFF6366F1); // Indigo
      case _PatternState.success:
        return const Color(0xFF10B981); // Emerald Green
      case _PatternState.error:
        return const Color(0xFFEF4444); // Rose Red
      case _PatternState.idle:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Pattern Lock Board Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
              // Header Icon & Title
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _patternState == _PatternState.success
                      ? Icons.lock_open_rounded
                      : Icons.pattern_rounded,
                  size: 26,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 10),

              // Status Message
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 16),

              // 9-Dot Canvas Gesture Area
              LayoutBuilder(
                builder: (context, constraints) {
                  final canvasSize = Size(constraints.maxWidth, 240);

                  return GestureDetector(
                    onPanStart: (details) => _onPanStart(details, canvasSize),
                    onPanUpdate: (details) => _onPanUpdate(details, canvasSize),
                    onPanEnd: _onPanEnd,
                    child: Container(
                      width: canvasSize.width,
                      height: canvasSize.height,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                      ),
                      child: CustomPaint(
                        size: canvasSize,
                        painter: _PatternPainter(
                          selectedDots: _selectedDots,
                          currentTouchPoint: _currentTouchPoint,
                          dotPositions: _getDotPositions(canvasSize),
                          patternState: _patternState,
                          statusColor: statusColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Reset Button
              SizedBox(
                width: 140,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.restart_alt_rounded, size: 16),
                  label: const Text(
                    'Reset Pola',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _resetPattern,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Hint Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Kunci Demo: Tarik garis membentuk huruf "Z" (Kiri Atas -> Kanan Atas -> Tengah -> Kiri Bawah -> Kanan Bawah).',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _PatternState { idle, drawing, success, error }

class _PatternPainter extends CustomPainter {
  final List<int> selectedDots;
  final Offset? currentTouchPoint;
  final List<Offset> dotPositions;
  final _PatternState patternState;
  final Color statusColor;

  _PatternPainter({
    required this.selectedDots,
    required this.currentTouchPoint,
    required this.dotPositions,
    required this.patternState,
    required this.statusColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Connecting Lines
    if (selectedDots.isNotEmpty) {
      final linePaint =
          Paint()
            ..color = statusColor.withValues(alpha: 0.8)
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

      for (int i = 0; i < selectedDots.length - 1; i++) {
        final p1 = dotPositions[selectedDots[i]];
        final p2 = dotPositions[selectedDots[i + 1]];
        canvas.drawLine(p1, p2, linePaint);
      }

      // Line to current touch finger position
      if (currentTouchPoint != null && selectedDots.isNotEmpty) {
        final lastPoint = dotPositions[selectedDots.last];
        canvas.drawLine(lastPoint, currentTouchPoint!, linePaint);
      }
    }

    // 2. Draw 9 Grid Dots
    for (int i = 0; i < dotPositions.length; i++) {
      final pos = dotPositions[i];
      final isSelected = selectedDots.contains(i);

      if (isSelected) {
        // Outer Glowing Ring
        final auraPaint =
            Paint()
              ..color = statusColor.withValues(alpha: 0.25)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 22, auraPaint);

        final ringPaint =
            Paint()
              ..color = statusColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5;
        canvas.drawCircle(pos, 22, ringPaint);

        // Center Selected Dot
        final dotPaint =
            Paint()
              ..color = statusColor
              ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 7, dotPaint);
      } else {
        // Unselected Dot Base
        final unselectedPaint =
            Paint()
              ..color = const Color(0xFF64748B)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 6, unselectedPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) => true;
}
