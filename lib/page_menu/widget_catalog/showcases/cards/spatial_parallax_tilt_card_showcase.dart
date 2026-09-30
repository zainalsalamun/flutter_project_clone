import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _CardThemePreset {
  spaceAurora('Space Aurora', [
    Color(0xFF0F172A),
    Color(0xFF312E81),
    Color(0xFF4C1D95),
  ], Color(0xFF818CF8)),
  cyberObsidian('Cyber Neon', [
    Color(0xFF090D16),
    Color(0xFF022C22),
    Color(0xFF064E3B),
  ], Color(0xFF34D399)),
  sunsetCosmos('Sunset Glow', [
    Color(0xFF1E1B4B),
    Color(0xFF831843),
    Color(0xFF9F1239),
  ], Color(0xFFF43F5E)),
  frostGlass('Crystal Ice', [
    Color(0xFF082F49),
    Color(0xFF0C4A6E),
    Color(0xFF164E63),
  ], Color(0xFF38BDF8));

  final String label;
  final List<Color> gradient;
  final Color accent;
  const _CardThemePreset(this.label, this.gradient, this.accent);
}

class SpatialParallaxTiltCardShowcase extends StatefulWidget {
  const SpatialParallaxTiltCardShowcase({super.key});

  @override
  State<SpatialParallaxTiltCardShowcase> createState() =>
      _SpatialParallaxTiltCardShowcaseState();
}

class _SpatialParallaxTiltCardShowcaseState
    extends State<SpatialParallaxTiltCardShowcase>
    with TickerProviderStateMixin {
  // Tilt coordinates (-1.0 to 1.0)
  double _tiltX = 0.0; // Horizontal tilt (rotates around Y axis)
  double _tiltY = 0.0; // Vertical tilt (rotates around X axis)

  // Settings
  double _parallaxIntensity = 1.0; // Multiplier
  final double _maxTiltAngleDeg = 24.0;
  bool _isGyroSimActive = false;
  _CardThemePreset _currentTheme = _CardThemePreset.spaceAurora;

  // Spring-back animation controller
  late AnimationController _springController;
  late Animation<double> _springAnimX;
  late Animation<double> _springAnimY;

  // Wobble animation ticker
  late AnimationController _wobbleController;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..addListener(() {
      if (_isGyroSimActive) {
        final t = _wobbleController.value * 2 * math.pi;
        setState(() {
          _tiltX = math.sin(t) * 0.55;
          _tiltY = math.cos(t * 1.5) * 0.45;
        });
      }
    });
  }

  @override
  void dispose() {
    _springController.dispose();
    _wobbleController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, Size cardSize) {
    if (_isGyroSimActive) return;

    final dx = (details.localPosition.dx / cardSize.width - 0.5) * 2.0;
    final dy = (details.localPosition.dy / cardSize.height - 0.5) * 2.0;

    setState(() {
      _tiltX = dx.clamp(-1.0, 1.0);
      _tiltY = dy.clamp(-1.0, 1.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isGyroSimActive) return;

    final startX = _tiltX;
    final startY = _tiltY;

    _springAnimX = Tween<double>(begin: startX, end: 0.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    );
    _springAnimY = Tween<double>(begin: startY, end: 0.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    );

    _springController.reset();
    _springController.forward();
    _springController.addListener(_handleSpringUpdate);
  }

  void _handleSpringUpdate() {
    if (_springController.isAnimating) {
      setState(() {
        _tiltX = _springAnimX.value;
        _tiltY = _springAnimY.value;
      });
    }
  }

  void _toggleGyroSim(bool value) {
    HapticFeedback.selectionClick();
    setState(() {
      _isGyroSimActive = value;
    });
    if (value) {
      _wobbleController.repeat();
    } else {
      _wobbleController.stop();
      setState(() {
        _tiltX = 0.0;
        _tiltY = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final rotX = -_tiltY * (_maxTiltAngleDeg * math.pi / 180.0);
    final rotY = _tiltX * (_maxTiltAngleDeg * math.pi / 180.0);

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HEADER BANNER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [Colors.white, const Color(0xFFF1F5F9)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _currentTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.view_in_ar_rounded,
                    color: _currentTheme.accent,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3D Spatial Parallax Card',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'VisionOS Multi-Layer Depth & Specular Glare',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (_isGyroSimActive
                            ? const Color(0xFF10B981)
                            : Colors.grey)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (_isGyroSimActive
                              ? const Color(0xFF10B981)
                              : Colors.grey)
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isGyroSimActive
                            ? Icons.screen_rotation_rounded
                            : Icons.touch_app_rounded,
                        size: 13,
                        color:
                            _isGyroSimActive
                                ? const Color(0xFF10B981)
                                : (isDark ? Colors.white70 : Colors.black87),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _isGyroSimActive ? 'GYRO' : 'TOUCH',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:
                              _isGyroSimActive
                                  ? const Color(0xFF10B981)
                                  : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. 3D SPATIAL PARALLAX VIEWPORT
          Center(
            child: SizedBox(
              height: 250,
              width: 350,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return GestureDetector(
                    onPanUpdate: (details) => _onPanUpdate(details, cardSize),
                    onPanEnd: _onPanEnd,
                    child: Transform(
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.0015) // Perspective distortion
                            ..rotateX(rotX)
                            ..rotateY(rotY),
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: _currentTheme.accent.withValues(
                                alpha: isDark ? 0.25 : 0.15,
                              ),
                              blurRadius: 30,
                              spreadRadius: -4,
                              offset: Offset(
                                -_tiltX * 20 * _parallaxIntensity,
                                -_tiltY * 20 * _parallaxIntensity + 12,
                              ),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.6 : 0.15,
                              ),
                              blurRadius: 20,
                              offset: Offset(
                                -_tiltX * 15 * _parallaxIntensity,
                                -_tiltY * 15 * _parallaxIntensity + 8,
                              ),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // LAYER 0: Background Deep Space Gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment(
                                      -_tiltX * 0.4,
                                      -_tiltY * 0.4,
                                    ),
                                    radius: 1.2,
                                    colors: _currentTheme.gradient,
                                  ),
                                ),
                              ),

                              // LAYER 1: Parallax Grid Lines (Deep Background Layer)
                              Transform.translate(
                                offset: Offset(
                                  -_tiltX * 12 * _parallaxIntensity,
                                  -_tiltY * 12 * _parallaxIntensity,
                                ),
                                child: CustomPaint(
                                  painter: _SpatialGridPainter(
                                    accentColor: _currentTheme.accent
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                              ),

                              // LAYER 2: Floating 3D Glowing Orb & Ring (Mid-ground Layer)
                              Transform.translate(
                                offset: Offset(
                                  _tiltX * 22 * _parallaxIntensity,
                                  _tiltY * 22 * _parallaxIntensity,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          _currentTheme.accent.withValues(
                                            alpha: 0.45,
                                          ),
                                          _currentTheme.accent.withValues(
                                            alpha: 0.1,
                                          ),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.6, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // LAYER 3: Frosted Glass UI Overlay (Foreground Layer)
                              Transform.translate(
                                offset: Offset(
                                  _tiltX * 14 * _parallaxIntensity,
                                  _tiltY * 14 * _parallaxIntensity,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Top Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Spatial Tag
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.25,
                                                ),
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .spatial_audio_off_rounded,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'SPATIAL 3D',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Floating 3D Badge
                                          Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withValues(
                                                alpha: 0.15,
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.auto_awesome_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Center Floating Title & Subtitle
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Vision Immersion',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: -0.5,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black45,
                                                  blurRadius: 8,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Infinite Canvas • 4K Spatial Audio',
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Bottom Action Bar
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Spatial Level Bar
                                          Row(
                                            children: List.generate(4, (index) {
                                              return Container(
                                                width: 5,
                                                height: 14.0 + (index * 4),
                                                margin: const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _currentTheme.accent,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              );
                                            }),
                                          ),
                                          // Elevated Glass Pill Button
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withValues(
                                                    alpha: 0.35,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: 0.15,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Enter World',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // LAYER 4: Dynamic Specular Glare / Sheen Reflection
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _SpecularGlarePainter(
                                    tiltX: _tiltX,
                                    tiltY: _tiltY,
                                  ),
                                ),
                              ),

                              // LAYER 5: Frosted Glowing Border Stroke
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha:
                                          0.25 +
                                          (_tiltX.abs() + _tiltY.abs()) * 0.15,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. SPATIAL TILT COORDINATES & DRAG HINT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem(
                  'Pitch (X)',
                  '${(-_tiltY * _maxTiltAngleDeg).toStringAsFixed(1)}°',
                  Icons.swap_vert_rounded,
                  isDark,
                ),
                _buildDivider(isDark),
                _buildMetricItem(
                  'Yaw (Y)',
                  '${(_tiltX * _maxTiltAngleDeg).toStringAsFixed(1)}°',
                  Icons.swap_horiz_rounded,
                  isDark,
                ),
                _buildDivider(isDark),
                _buildMetricItem(
                  'Parallax',
                  '${(_parallaxIntensity * 100).toInt()}%',
                  Icons.layers_rounded,
                  isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. THEME SELECTOR CHIPS
          Text(
            'PILIHAN TEMA SPATIAL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _CardThemePreset.values.map((themePreset) {
                    final isSelected = _currentTheme == themePreset;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(themePreset.label),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _currentTheme = themePreset);
                          }
                        },
                        avatar: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: themePreset.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        selectedColor: themePreset.accent.withValues(
                          alpha: 0.25,
                        ),
                        backgroundColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? themePreset.accent
                                  : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 5. INTERACTIVE CONTROLS (PARALLAX & GYRO SWITCH)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gyro Simulation Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.screen_rotation_rounded,
                          size: 20,
                          color: _currentTheme.accent,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gyroscope Auto-Wobble',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Simulasi gerakan sensor gravitasi device',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _isGyroSimActive,
                      activeThumbColor: _currentTheme.accent,
                      onChanged: _toggleGyroSim,
                    ),
                  ],
                ),
                const Divider(height: 22),

                // Parallax Multiplier Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r'Kedalaman Parallax (Z-Depth)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      '${(_parallaxIntensity * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _currentTheme.accent,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _parallaxIntensity,
                  min: 0.2,
                  max: 2.0,
                  divisions: 18,
                  activeColor: _currentTheme.accent,
                  onChanged: (val) {
                    setState(() => _parallaxIntensity = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _currentTheme.accent),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      color: isDark ? Colors.white12 : Colors.black12,
    );
  }
}

class _SpatialGridPainter extends CustomPainter {
  final Color accentColor;
  _SpatialGridPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = accentColor
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;

    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpatialGridPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}

class _SpecularGlarePainter extends CustomPainter {
  final double tiltX;
  final double tiltY;

  _SpecularGlarePainter({required this.tiltX, required this.tiltY});

  @override
  void paint(Canvas canvas, Size size) {
    // Dynamic specular sheen center mapping
    final centerX = size.width * (0.5 - tiltX * 0.45);
    final centerY = size.height * (0.5 - tiltY * 0.45);

    final glarePaint =
        Paint()
          ..shader = RadialGradient(
            center: Alignment(
              (centerX / size.width - 0.5) * 2.0,
              (centerY / size.height - 0.5) * 2.0,
            ),
            radius: 0.9,
            colors: [
              Colors.white.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.08),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glarePaint);
  }

  @override
  bool shouldRepaint(covariant _SpecularGlarePainter oldDelegate) =>
      oldDelegate.tiltX != tiltX || oldDelegate.tiltY != tiltY;
}
