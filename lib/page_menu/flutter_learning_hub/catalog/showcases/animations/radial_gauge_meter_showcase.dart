import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadialGaugeMeterShowcase extends StatefulWidget {
  const RadialGaugeMeterShowcase({super.key});

  @override
  State<RadialGaugeMeterShowcase> createState() =>
      _RadialGaugeMeterShowcaseState();
}

class _RadialGaugeMeterShowcaseState extends State<RadialGaugeMeterShowcase>
    with SingleTickerProviderStateMixin {
  double _currentValue = 120.0; // 0.0 to 240.0
  bool _isAutoCruise = false;
  late AnimationController _cruiseController;

  @override
  void initState() {
    super.initState();
    _cruiseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
      if (_isAutoCruise) {
        setState(() {
          // Oscillate smoothly between 60 and 210
          _currentValue =
              60 + (math.sin(_cruiseController.value * 2 * math.pi) + 1) * 75;
        });
      }
    });
  }

  @override
  void dispose() {
    _cruiseController.dispose();
    super.dispose();
  }

  void _toggleAutoCruise() {
    setState(() {
      _isAutoCruise = !_isAutoCruise;
      if (_isAutoCruise) {
        _cruiseController.repeat();
      } else {
        _cruiseController.stop();
      }
    });
  }

  void _setPresetValue(double value) {
    if (_isAutoCruise) {
      setState(() => _isAutoCruise = false);
      _cruiseController.stop();
    }
    setState(() => _currentValue = value);
  }

  String _getModeLabel() {
    if (_currentValue < 80) return 'ECO DRIVE';
    if (_currentValue < 160) return 'DYNAMIC';
    return 'SPORT+';
  }

  Color _getModeColor() {
    if (_currentValue < 80) return const Color(0xFF10B981);
    if (_currentValue < 160) return const Color(0xFF38BDF8);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final modeColor = _getModeColor();
    final modeLabel = _getModeLabel();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Gauge Display Container Card
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
              // Top Mode Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: modeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: modeColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: modeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: modeColor.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      modeLabel,
                      style: TextStyle(
                        color: modeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Gauge Canvas & Readout Stack
              SizedBox(
                width: 250,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(250, 180),
                      painter: _RadialGaugePainter(value: _currentValue),
                    ),

                    // Center Digital Readout
                    Positioned(
                      bottom: 12,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentValue.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              letterSpacing: -1,
                            ),
                          ),
                          const Text(
                            'KM / H',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Live Speed Slider & Auto-Cruise Toggle
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kendali Kecepatan (Slider)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isAutoCruise
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      _isAutoCruise
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 14,
                    ),
                    label: Text(
                      _isAutoCruise ? 'Stop Cruise' : 'Auto Cruise',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _toggleAutoCruise,
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF6366F1),
                  thumbColor: const Color(0xFF6366F1),
                  inactiveTrackColor: Colors.grey.shade200,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _currentValue,
                  min: 0,
                  max: 240,
                  onChanged: (val) {
                    if (_isAutoCruise) {
                      setState(() => _isAutoCruise = false);
                      _cruiseController.stop();
                    }
                    setState(() => _currentValue = val);
                  },
                ),
              ),

              // Preset Mode Buttons
              Row(
                children: [
                  _buildPresetButton('Eco (45)', 45),
                  const SizedBox(width: 6),
                  _buildPresetButton('Cruising (110)', 110),
                  const SizedBox(width: 6),
                  _buildPresetButton('Sport (195)', 195),
                  const SizedBox(width: 6),
                  _buildPresetButton('Max (240)', 240),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButton(String label, double value) {
    final isSelected = (_currentValue - value).abs() < 5 && !_isAutoCruise;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _setPresetValue(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color:
                    isSelected ? const Color(0xFF6366F1) : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double value; // 0 to 240

  _RadialGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    final radius = size.width * 0.42;

    const startAngle = 3 * math.pi / 4; // 135 deg
    const sweepAngle = 3 * math.pi / 2; // 270 deg

    // 1. Background Track Arc
    final bgPaint =
        Paint()
          ..color = const Color(0xFF1E293B)
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // 2. Active Value Gradient Arc
    final progress = (value / 240.0).clamp(0.0, 1.0);
    final activeSweep = sweepAngle * progress;

    if (activeSweep > 0.01) {
      final activePaint =
          Paint()
            ..shader = const SweepGradient(
              startAngle: startAngle,
              endAngle: startAngle + sweepAngle,
              colors: [
                Color(0xFF10B981), // Green
                Color(0xFF38BDF8), // Cyan
                Color(0xFFF59E0B), // Amber
                Color(0xFFEF4444), // Red
              ],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..strokeWidth = 14
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        activeSweep,
        false,
        activePaint,
      );
    }

    // 3. Tick Marks
    const totalTicks = 12;
    for (int i = 0; i <= totalTicks; i++) {
      final tickAngle = startAngle + (sweepAngle * (i / totalTicks));
      final isMajor = i % 2 == 0;
      final innerR = radius - (isMajor ? 20 : 16);
      final outerR = radius - 10;

      final p1 = Offset(
        center.dx + innerR * math.cos(tickAngle),
        center.dy + innerR * math.sin(tickAngle),
      );
      final p2 = Offset(
        center.dx + outerR * math.cos(tickAngle),
        center.dy + outerR * math.sin(tickAngle),
      );

      final tickPaint =
          Paint()
            ..color = isMajor ? Colors.white70 : Colors.white30
            ..strokeWidth = isMajor ? 2.0 : 1.0;

      canvas.drawLine(p1, p2, tickPaint);
    }

    // 4. Animated Needle
    final needleAngle = startAngle + (sweepAngle * progress);
    final needleLength = radius - 15;

    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint =
        Paint()
          ..color = const Color(0xFFEF4444)
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center Needle Pivot Hub
    final hubPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7, hubPaint);

    final hubBorder =
        Paint()
          ..color = const Color(0xFFEF4444)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, 7, hubBorder);
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
