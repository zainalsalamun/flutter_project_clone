import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmartLightingSceneShowcase extends StatefulWidget {
  const SmartLightingSceneShowcase({super.key});

  @override
  State<SmartLightingSceneShowcase> createState() =>
      _SmartLightingSceneShowcaseState();
}

enum LightingMode { rgb, kelvin }

class _LightScenePreset {
  final String title;
  final String emoji;
  final Color color;
  final double brightness;
  final int kelvin;

  const _LightScenePreset({
    required this.title,
    required this.emoji,
    required this.color,
    required this.brightness,
    required this.kelvin,
  });
}

class _SmartLightingSceneShowcaseState
    extends State<SmartLightingSceneShowcase> {
  LightingMode _mode = LightingMode.rgb;
  bool _isPoweredOn = true;
  double _brightness = 0.85; // 0.0 to 1.0
  Color _selectedColor = const Color(0xFF6366F1); // Indigo
  int _kelvinTemp = 4000; // 2000K to 6500K

  // Room Light Fixture Toggles
  bool _mainCeilingOn = true;
  bool _floorLampOn = true;
  bool _underglowStripOn = false;

  final List<_LightScenePreset> _presets = const [
    _LightScenePreset(
      title: 'Sunset Gold',
      emoji: '',
      color: Color(0xFFF97316),
      brightness: 0.85,
      kelvin: 2400,
    ),
    _LightScenePreset(
      title: 'Cyber Neon',
      emoji: '',
      color: Color(0xFFD946EF),
      brightness: 1.0,
      kelvin: 5000,
    ),
    _LightScenePreset(
      title: 'Zen Warmth',
      emoji: '',
      color: Color(0xFFFBBF24),
      brightness: 0.45,
      kelvin: 2700,
    ),
    _LightScenePreset(
      title: 'Deep Focus',
      emoji: '',
      color: Color(0xFF38BDF8),
      brightness: 1.0,
      kelvin: 6500,
    ),
    _LightScenePreset(
      title: 'Cinema Dim',
      emoji: '',
      color: Color(0xFF3B82F6),
      brightness: 0.20,
      kelvin: 3500,
    ),
  ];

  Color _getEffectiveColor() {
    if (!_isPoweredOn) return const Color(0xFF1E293B);
    if (_mode == LightingMode.kelvin) {
      return _kelvinToColor(_kelvinTemp);
    }
    return _selectedColor;
  }

  Color _kelvinToColor(int kelvin) {
    // Approximate Kelvin color temperature mapping
    final double t = (kelvin - 2000) / (6500 - 2000);
    if (t < 0.3) {
      // Warm Amber / Candlelight
      return Color.lerp(
        const Color(0xFFFF8C00),
        const Color(0xFFFFD59E),
        t / 0.3,
      )!;
    } else if (t < 0.7) {
      // Warm White to Neutral
      return Color.lerp(
        const Color(0xFFFFD59E),
        const Color(0xFFF8FAFC),
        (t - 0.3) / 0.4,
      )!;
    } else {
      // Cool Daylight White / Ice Blue
      return Color.lerp(
        const Color(0xFFF8FAFC),
        const Color(0xFFBAE6FD),
        (t - 0.7) / 0.3,
      )!;
    }
  }

  void _applyPreset(_LightScenePreset preset) {
    HapticFeedback.lightImpact();
    setState(() {
      _isPoweredOn = true;
      _selectedColor = preset.color;
      _brightness = preset.brightness;
      _kelvinTemp = preset.kelvin;
    });
  }

  void _updateColorFromWheel(Offset localPos, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final radius = size.width / 2;

    if (distance <= radius) {
      final angle = (math.atan2(dy, dx) * 180 / math.pi + 360) % 360;
      final saturation = (distance / radius).clamp(0.0, 1.0);
      final hsv = HSVColor.fromAHSV(1.0, angle, saturation, 1.0);

      setState(() {
        _selectedColor = hsv.toColor();
        _isPoweredOn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = _getEffectiveColor();
    final effectiveBrightness = _isPoweredOn ? _brightness : 0.0;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Simulated Room Lamp & Light Cone Viewport
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: activeColor.withValues(
                    alpha: effectiveBrightness * 0.4,
                  ),
                  blurRadius: 28,
                  spreadRadius: effectiveBrightness * 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Radial Glow Light Cone from top pendant
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.6),
                          radius: 1.1,
                          colors: [
                            activeColor.withValues(
                              alpha: effectiveBrightness * 0.85,
                            ),
                            activeColor.withValues(
                              alpha: effectiveBrightness * 0.35,
                            ),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Architectural Room Mockup Silhouettes
                  CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _RoomLampScenePainter(
                      lampColor: activeColor,
                      isLit: _isPoweredOn && effectiveBrightness > 0.05,
                      brightness: effectiveBrightness,
                    ),
                  ),

                  // Top Badges & Power Pill
                  Positioned(
                    top: 14,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            _isPoweredOn
                                ? '${(effectiveBrightness * 100).round()}% • ${_mode == LightingMode.kelvin ? '$_kelvinTemp K' : 'RGB Ambient'}'
                                : 'STANDBY OFF',
                            style: TextStyle(
                              color: _isPoweredOn ? Colors.white : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          value: _isPoweredOn,
                          activeTrackColor: activeColor,
                          onChanged: (val) {
                            HapticFeedback.lightImpact();
                            setState(() => _isPoweredOn = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Brightness Slider Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.brightness_6_rounded,
                          size: 18,
                          color: activeColor,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Brightness Dimmer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${(_brightness * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: activeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: activeColor,
                    inactiveTrackColor:
                        isDark ? Colors.white12 : Colors.black12,
                    thumbColor: activeColor,
                    overlayColor: activeColor.withValues(alpha: 0.2),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _brightness,
                    min: 0.05,
                    max: 1.0,
                    onChanged:
                        _isPoweredOn
                            ? (val) {
                              setState(() => _brightness = val);
                            }
                            : null,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Mode Toggle (RGB Spectrum vs Kelvin White Temperature)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text(' RGB Spectrum')),
                    selected: _mode == LightingMode.rgb,
                    selectedColor:
                        isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          _mode == LightingMode.rgb
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _mode = LightingMode.rgb);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text(' Kelvin Temperature')),
                    selected: _mode == LightingMode.kelvin,
                    selectedColor:
                        isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          _mode == LightingMode.kelvin
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _mode = LightingMode.kelvin);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Color Picker Card (RGB Disk or Kelvin Temperature Slider)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child:
                _mode == LightingMode.rgb
                    ? Column(
                      children: [
                        const Text(
                          'Touch & Drag on Color Wheel',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Circular HSV Color Wheel
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final size = Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              );
                              return GestureDetector(
                                onPanStart:
                                    (d) => _updateColorFromWheel(
                                      d.localPosition,
                                      size,
                                    ),
                                onPanUpdate:
                                    (d) => _updateColorFromWheel(
                                      d.localPosition,
                                      size,
                                    ),
                                onTapDown:
                                    (d) => _updateColorFromWheel(
                                      d.localPosition,
                                      size,
                                    ),
                                child: CustomPaint(
                                  size: size,
                                  painter: _RgbColorWheelPainter(
                                    selectedColor: _selectedColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Warm / Cool Balance',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '$_kelvinTemp K',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: activeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Kelvin Temperature Gradient Track
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF8C00), // 2000K Candlelight
                                Color(0xFFFFD59E), // 3000K Warm White
                                Color(0xFFF8FAFC), // 4500K Neutral
                                Color(0xFFBAE6FD), // 6500K Cool Daylight
                              ],
                            ),
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            thumbColor: activeColor,
                            overlayColor: activeColor.withValues(alpha: 0.2),
                          ),
                          child: Slider(
                            value: _kelvinTemp.toDouble(),
                            min: 2000,
                            max: 6500,
                            divisions: 45,
                            onChanged: (val) {
                              setState(() {
                                _kelvinTemp = val.round();
                                _isPoweredOn = true;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '2000K (Candle)',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '4000K (Neutral)',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '6500K (Daylight)',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),

          const SizedBox(height: 16),

          // 5. Quick Mood Presets Row
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
                const Text(
                  'Scene Mood Presets',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _presets.map((preset) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              onTap: () => _applyPreset(preset),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? const Color(0xFF273549)
                                          : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: preset.color.withValues(alpha: 0.6),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      preset.emoji,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      preset.title,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 6. Multi-Fixture Room Controls (Ceiling, Floor, LED Strip)
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
                const Text(
                  'Room Light Fixtures',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _fixtureTile(
                  'Main Ceiling Chandelier',
                  Icons.light_rounded,
                  _mainCeilingOn,
                  (val) {
                    setState(() => _mainCeilingOn = val);
                  },
                  activeColor,
                ),
                const Divider(height: 16),
                _fixtureTile(
                  'Floor Reading Lamp',
                  Icons.desk_rounded,
                  _floorLampOn,
                  (val) {
                    setState(() => _floorLampOn = val);
                  },
                  activeColor,
                ),
                const Divider(height: 16),
                _fixtureTile(
                  'Under-Cabinet LED Strip',
                  Icons.linear_scale_rounded,
                  _underglowStripOn,
                  (val) {
                    setState(() => _underglowStripOn = val);
                  },
                  activeColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _fixtureTile(
    String name,
    IconData icon,
    bool isOn,
    ValueChanged<bool> onChanged,
    Color tintColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isOn ? tintColor : Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isOn ? null : Colors.grey,
            ),
          ),
        ),
        Switch.adaptive(
          value: isOn,
          activeTrackColor: tintColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Room Mockup Scene Silhouette
// -------------------------------------------------------------
class _RoomLampScenePainter extends CustomPainter {
  final Color lampColor;
  final bool isLit;
  final double brightness;

  _RoomLampScenePainter({
    required this.lampColor,
    required this.isLit,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Pendant cord & fixture
    final cordPaint =
        Paint()
          ..color = Colors.white54
          ..strokeWidth = 2.0;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, 36), cordPaint);

    // Lamp Shade cone
    final shadePath =
        Path()
          ..moveTo(centerX - 18, 54)
          ..lineTo(centerX + 18, 54)
          ..lineTo(centerX + 10, 36)
          ..lineTo(centerX - 10, 36)
          ..close();

    final shadePaint =
        Paint()
          ..color = isLit ? lampColor : Colors.white24
          ..style = PaintingStyle.fill;
    canvas.drawPath(shadePath, shadePaint);

    // Glowing bulb circle
    final bulbPaint =
        Paint()
          ..color = isLit ? Colors.white : Colors.white12
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, 54), 6, bulbPaint);

    // Floor horizon line
    final floorPaint =
        Paint()
          ..color = Colors.white10
          ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(20, size.height - 30),
      Offset(size.width - 20, size.height - 30),
      floorPaint,
    );

    // Lounge sofa silhouette at bottom
    final sofaPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;

    final sofaRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, size.height - 36),
        width: 140,
        height: 26,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(sofaRect, sofaPaint);
  }

  @override
  bool shouldRepaint(covariant _RoomLampScenePainter oldDelegate) =>
      oldDelegate.lampColor != lampColor ||
      oldDelegate.isLit != isLit ||
      oldDelegate.brightness != brightness;
}

// -------------------------------------------------------------
// CustomPainter: Interactive Circular HSV Color Wheel
// -------------------------------------------------------------
class _RgbColorWheelPainter extends CustomPainter {
  final Color selectedColor;

  _RgbColorWheelPainter({required this.selectedColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw multi-stop sweep gradient for hue wheel
    const List<Color> hueColors = [
      Color(0xFFFF0000), // Red 0
      Color(0xFFFFFF00), // Yellow 60
      Color(0xFF00FF00), // Green 120
      Color(0xFF00FFFF), // Cyan 180
      Color(0xFF0000FF), // Blue 240
      Color(0xFFFF00FF), // Magenta 300
      Color(0xFFFF0000), // Red 360
    ];

    final sweepPaint =
        Paint()
          ..shader = const SweepGradient(
            colors: hueColors,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sweepPaint);

    // White saturation center overlay
    final satPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.white, Colors.white.withValues(alpha: 0.0)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, satPaint);

    // Selected Color Indicator Ring
    final hsv = HSVColor.fromColor(selectedColor);
    final selAngle = hsv.hue * math.pi / 180;
    final selRadius = hsv.saturation * radius;

    final selPos = Offset(
      center.dx + selRadius * math.cos(selAngle),
      center.dy + selRadius * math.sin(selAngle),
    );

    // Indicator border
    canvas.drawCircle(selPos, 12, Paint()..color = Colors.black45);
    canvas.drawCircle(selPos, 10, Paint()..color = Colors.white);
    canvas.drawCircle(selPos, 7, Paint()..color = selectedColor);
  }

  @override
  bool shouldRepaint(covariant _RgbColorWheelPainter oldDelegate) =>
      oldDelegate.selectedColor != selectedColor;
}
