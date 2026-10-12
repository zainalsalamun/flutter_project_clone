import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmartThermostatDialShowcase extends StatefulWidget {
  const SmartThermostatDialShowcase({super.key});

  @override
  State<SmartThermostatDialShowcase> createState() =>
      _SmartThermostatDialShowcaseState();
}

enum HvacMode { cool, heat, eco, fan, off }

class _SmartThermostatDialShowcaseState
    extends State<SmartThermostatDialShowcase>
    with SingleTickerProviderStateMixin {
  double _targetTemp = 22.5; // In Celsius (15.0 to 32.0)
  final double _currentAmbientTemp = 25.0;
  final int _humidityPercent = 54;
  HvacMode _activeMode = HvacMode.cool;
  int _fanSpeed = 2; // 1: Low, 2: Med, 3: High, 4: Turbo
  bool _isScheduleActive = true;

  late AnimationController _pulseController;

  static const double _minTemp = 15.0;
  static const double _maxTemp = 32.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getModeColor() {
    switch (_activeMode) {
      case HvacMode.cool:
        return const Color(0xFF38BDF8); // Cyan / Cool Blue
      case HvacMode.heat:
        return const Color(0xFFF97316); // Vibrant Orange / Warm Red
      case HvacMode.eco:
        return const Color(0xFF10B981); // Emerald Green
      case HvacMode.fan:
        return const Color(0xFFA855F7); // Purple
      case HvacMode.off:
        return const Color(0xFF64748B); // Slate Grey
    }
  }

  void _updateTempFromAngle(Offset localPosition, Size dialSize) {
    if (_activeMode == HvacMode.off) return;

    final center = Offset(dialSize.width / 2, dialSize.height / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;

    // Angle in radians: -pi to +pi
    double angle = math.atan2(dy, dx);
    // Convert so 0 is at bottom-left (-135 deg to +135 deg dial range)
    // Dial starts at 135 deg (3*pi/4) and ends at 405 deg (9*pi/4) -> 270 deg sweep
    double normalizedAngle = (angle + (math.pi * 0.75)) % (2 * math.pi);
    if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;

    final sweep = math.pi * 1.5; // 270 degrees
    if (normalizedAngle <= sweep) {
      final fraction = (normalizedAngle / sweep).clamp(0.0, 1.0);
      final newTemp = _minTemp + (fraction * (_maxTemp - _minTemp));
      final roundedTemp = (newTemp * 2).round() / 2.0; // Round to 0.5 deg step

      if ((roundedTemp - _targetTemp).abs() >= 0.5) {
        HapticFeedback.selectionClick();
        setState(() {
          _targetTemp = roundedTemp;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final modeColor = _getModeColor();

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Status Banner (Room selector & Eco status)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: modeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.home_work_rounded,
                          color: modeColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Master Bedroom',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Living Room Gateway • Connected',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
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
                // Schedule toggle pill
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _isScheduleActive = !_isScheduleActive);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _isScheduleActive
                              ? const Color(0xFF10B981).withValues(alpha: 0.15)
                              : (isDark ? Colors.white10 : Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _isScheduleActive
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color:
                              _isScheduleActive
                                  ? const Color(0xFF10B981)
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isScheduleActive ? 'AUTO ON' : 'MANUAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color:
                                _isScheduleActive
                                    ? const Color(0xFF10B981)
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Thermostat Rotary Dial Glass Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.9,
                colors:
                    isDark
                        ? [
                          modeColor.withValues(alpha: 0.12),
                          const Color(0xFF1E293B),
                        ]
                        : [modeColor.withValues(alpha: 0.08), Colors.white],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: modeColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: modeColor.withValues(alpha: 0.18),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Dial Canvas with Gesture Detector
                SizedBox(
                  width: 280,
                  height: 280,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dialSize = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );

                      return GestureDetector(
                        onPanStart:
                            (details) => _updateTempFromAngle(
                              details.localPosition,
                              dialSize,
                            ),
                        onPanUpdate:
                            (details) => _updateTempFromAngle(
                              details.localPosition,
                              dialSize,
                            ),
                        onTapDown:
                            (details) => _updateTempFromAngle(
                              details.localPosition,
                              dialSize,
                            ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Custom Painted Dial & Glow Track
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: dialSize,
                                  painter: _ThermostatDialPainter(
                                    targetTemp: _targetTemp,
                                    ambientTemp: _currentAmbientTemp,
                                    minTemp: _minTemp,
                                    maxTemp: _maxTemp,
                                    modeColor: modeColor,
                                    isOff: _activeMode == HvacMode.off,
                                    pulseValue: _pulseController.value,
                                    isDark: isDark,
                                  ),
                                );
                              },
                            ),

                            // Center Display Bubble
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Mode Badge & Icon
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _activeMode == HvacMode.cool
                                          ? Icons.ac_unit_rounded
                                          : _activeMode == HvacMode.heat
                                          ? Icons.local_fire_department_rounded
                                          : _activeMode == HvacMode.eco
                                          ? Icons.eco_rounded
                                          : _activeMode == HvacMode.fan
                                          ? Icons.air_rounded
                                          : Icons.power_settings_new_rounded,
                                      size: 16,
                                      color: modeColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _activeMode.name.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: modeColor,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                // Big Target Temp Readout
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _activeMode == HvacMode.off
                                          ? '--'
                                          : _targetTemp.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 54,
                                        fontWeight: FontWeight.w900,
                                        height: 1.0,
                                        color:
                                            _activeMode == HvacMode.off
                                                ? Colors.grey
                                                : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        '°C',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Ambient Temp & Humidity Sub-readout
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? Colors.white10
                                            : Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Room: ${_currentAmbientTemp.toStringAsFixed(1)}°C • $_humidityPercent% RH',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Quick +/- Temp Step Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.remove_rounded),
                      tooltip: 'Decrease 0.5°C',
                      onPressed:
                          _activeMode == HvacMode.off || _targetTemp <= _minTemp
                              ? null
                              : () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _targetTemp = math.max(
                                    _minTemp,
                                    _targetTemp - 0.5,
                                  );
                                });
                              },
                    ),
                    const SizedBox(width: 24),
                    Text(
                      'Target Setpoint',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: modeColor,
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.add_rounded),
                      tooltip: 'Increase 0.5°C',
                      onPressed:
                          _activeMode == HvacMode.off || _targetTemp >= _maxTemp
                              ? null
                              : () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _targetTemp = math.min(
                                    _maxTemp,
                                    _targetTemp + 0.5,
                                  );
                                });
                              },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Mode Selector Segmented Bar
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Row(
              children:
                  HvacMode.values.map((mode) {
                    final isSelected = _activeMode == mode;
                    final label =
                        mode.name[0].toUpperCase() + mode.name.substring(1);
                    final icon =
                        mode == HvacMode.cool
                            ? Icons.ac_unit_rounded
                            : mode == HvacMode.heat
                            ? Icons.local_fire_department_rounded
                            : mode == HvacMode.eco
                            ? Icons.eco_rounded
                            : mode == HvacMode.fan
                            ? Icons.air_rounded
                            : Icons.power_settings_new_rounded;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _activeMode = mode);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? _getModeColor()
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                icon,
                                size: 20,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white60
                                            : Colors.black54),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.white70
                                              : Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Fan Speed & Air Flow Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.wind_power_rounded,
                            size: 18,
                            color: modeColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Blower Fan Speed',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _fanSpeed == 1
                          ? 'Level 1 (Quiet)'
                          : _fanSpeed == 2
                          ? 'Level 2 (Normal)'
                          : _fanSpeed == 3
                          ? 'Level 3 (High)'
                          : 'Turbo Boost',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: modeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 4-step fan speed tiles
                Row(
                  children: List.generate(4, (index) {
                    final speedLevel = index + 1;
                    final isActive = _fanSpeed >= speedLevel;
                    final isTarget = _fanSpeed == speedLevel;

                    return Expanded(
                      child: GestureDetector(
                        onTap:
                            _activeMode == HvacMode.off
                                ? null
                                : () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _fanSpeed = speedLevel);
                                },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 42,
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? modeColor.withValues(
                                      alpha: isTarget ? 1.0 : 0.4,
                                    )
                                    : (isDark
                                        ? Colors.white10
                                        : Colors.black.withValues(alpha: 0.05)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              speedLevel == 4 ? 'TURBO' : 'L$speedLevel',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:
                                    isActive && isTarget
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white70
                                            : Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Thermostat Radial Dial & Arc
// -------------------------------------------------------------
class _ThermostatDialPainter extends CustomPainter {
  final double targetTemp;
  final double ambientTemp;
  final double minTemp;
  final double maxTemp;
  final Color modeColor;
  final bool isOff;
  final double pulseValue;
  final bool isDark;

  _ThermostatDialPainter({
    required this.targetTemp,
    required this.ambientTemp,
    required this.minTemp,
    required this.maxTemp,
    required this.modeColor,
    required this.isOff,
    required this.pulseValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // 270 degree arc from 135 deg to 405 deg (math.pi * 0.75 to math.pi * 2.25)
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // Track Background Arc
    final bgPaint =
        Paint()
          ..color = isDark ? Colors.white10 : Colors.black12
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    if (!isOff) {
      final targetFraction = ((targetTemp - minTemp) / (maxTemp - minTemp))
          .clamp(0.0, 1.0);
      final activeSweep = targetFraction * sweepAngle;

      // Active Temperature Progress Arc
      final activePaint =
          Paint()
            ..shader = SweepGradient(
              startAngle: startAngle,
              endAngle: startAngle + sweepAngle,
              colors: [modeColor.withValues(alpha: 0.3), modeColor],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 14
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        activeSweep,
        false,
        activePaint,
      );

      // Target Setpoint Glowing Thumb Knob
      final thumbAngle = startAngle + activeSweep;
      final thumbPos = Offset(
        center.dx + radius * math.cos(thumbAngle),
        center.dy + radius * math.sin(thumbAngle),
      );

      // Outer glow circle
      final glowPaint =
          Paint()
            ..color = modeColor.withValues(alpha: 0.3 + (pulseValue * 0.2))
            ..style = PaintingStyle.fill;
      canvas.drawCircle(thumbPos, 14 + (pulseValue * 3), glowPaint);

      // Thumb knob
      final thumbPaint = Paint()..color = modeColor;
      canvas.drawCircle(thumbPos, 9, thumbPaint);
      canvas.drawCircle(thumbPos, 4, Paint()..color = Colors.white);

      // Ambient Room Temp Indicator Needle / Diamond on Arc
      final ambientFraction = ((ambientTemp - minTemp) / (maxTemp - minTemp))
          .clamp(0.0, 1.0);
      final ambientAngle = startAngle + (ambientFraction * sweepAngle);
      final ambientPos = Offset(
        center.dx + (radius - 16) * math.cos(ambientAngle),
        center.dy + (radius - 16) * math.sin(ambientAngle),
      );

      final ambientPaint =
          Paint()
            ..color = isDark ? Colors.white70 : Colors.black54
            ..style = PaintingStyle.fill;
      canvas.drawCircle(ambientPos, 3.5, ambientPaint);
    }

    // Dial Perimeter Tick Marks (every 1 degree)
    final int totalTicks = (maxTemp - minTemp).toInt();
    for (int i = 0; i <= totalTicks; i++) {
      final tickFraction = i / totalTicks;
      final tickAngle = startAngle + (tickFraction * sweepAngle);
      final isMajor = (i % 5 == 0);

      final innerR = radius + (isMajor ? 14 : 16);
      final outerR = radius + (isMajor ? 22 : 19);

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
            ..color =
                isMajor
                    ? (isDark ? Colors.white54 : Colors.black45)
                    : (isDark ? Colors.white24 : Colors.black26)
            ..strokeWidth = isMajor ? 2.0 : 1.0
            ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ThermostatDialPainter oldDelegate) =>
      oldDelegate.targetTemp != targetTemp ||
      oldDelegate.ambientTemp != ambientTemp ||
      oldDelegate.modeColor != modeColor ||
      oldDelegate.isOff != isOff ||
      oldDelegate.pulseValue != pulseValue;
}
