import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../data/models/coffee_addon_model.dart';

class AnimatedCupVisualizer extends StatefulWidget {
  final String size; // 'S', 'M', 'L'
  final bool isHot; // true = Ceramic Mug, false = Tall Glass Tumbler
  final double fillPercent; // 0.0 to 1.0 (default 0.78)
  final String coffeeName;
  final int sweetness; // 0, 50, 70, 100
  final Set<AddonType> selectedAddons;

  const AnimatedCupVisualizer({
    super.key,
    required this.size,
    required this.isHot,
    this.fillPercent = 0.78,
    required this.coffeeName,
    this.sweetness = 70,
    required this.selectedAddons,
  });

  @override
  State<AnimatedCupVisualizer> createState() => _AnimatedCupVisualizerState();
}

class _AnimatedCupVisualizerState extends State<AnimatedCupVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _steamController;
  late AnimationController _iceBobController;
  late AnimationController _drizzleController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _iceBobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _drizzleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _steamController.dispose();
    _iceBobController.dispose();
    _drizzleController.dispose();
    super.dispose();
  }

  double _getCupHeight() {
    if (widget.isHot) {
      // Ceramic Mug: squatter, cozy proportion
      switch (widget.size) {
        case 'S':
          return 155.0;
        case 'M':
          return 180.0;
        case 'L':
          return 205.0;
        default:
          return 180.0;
      }
    } else {
      // Iced Glass Tumbler: tall, slender proportion
      switch (widget.size) {
        case 'S':
          return 185.0;
        case 'M':
          return 215.0;
        case 'L':
          return 245.0;
        default:
          return 215.0;
      }
    }
  }

  double _getCupTopWidth() {
    if (widget.isHot) {
      switch (widget.size) {
        case 'S':
          return 145.0;
        case 'M':
          return 165.0;
        case 'L':
          return 180.0;
        default:
          return 165.0;
      }
    } else {
      switch (widget.size) {
        case 'S':
          return 130.0;
        case 'M':
          return 148.0;
        case 'L':
          return 162.0;
        default:
          return 148.0;
      }
    }
  }

  double _getCupBottomWidth() {
    if (widget.isHot) {
      switch (widget.size) {
        case 'S':
          return 125.0;
        case 'M':
          return 140.0;
        case 'L':
          return 150.0;
        default:
          return 140.0;
      }
    } else {
      switch (widget.size) {
        case 'S':
          return 92.0;
        case 'M':
          return 102.0;
        case 'L':
          return 112.0;
        default:
          return 102.0;
      }
    }
  }

  bool get _hasOatMilk => widget.selectedAddons.contains(AddonType.oatMilk);
  bool get _hasAlmondMilk => widget.selectedAddons.contains(AddonType.almondMilk);
  bool get _hasPalmSugar => widget.selectedAddons.contains(AddonType.palmSugar);
  bool get _hasCaramel => widget.selectedAddons.contains(AddonType.caramelDrizzle);
  bool get _hasVanilla => widget.selectedAddons.contains(AddonType.vanillaSyrup);
  bool get _hasExtraShot => widget.selectedAddons.contains(AddonType.extraShot);
  bool get _hasExtraIce => widget.selectedAddons.contains(AddonType.extraIce);
  bool get _hasCinnamon => widget.selectedAddons.contains(AddonType.cinnamonDust);
  bool get _hasCheeseFoam => widget.selectedAddons.contains(AddonType.cheeseFoam);

  @override
  Widget build(BuildContext context) {
    final cupHeight = _getCupHeight();
    final topWidth = _getCupTopWidth();
    final bottomWidth = _getCupBottomWidth();

    return SizedBox(
      height: 310,
      width: 360,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Ambient Background Glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: topWidth + 90,
              height: cupHeight + 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isHot
                    ? (_hasExtraShot
                        ? Colors.deepOrange.withOpacity(0.18)
                        : BrewezTheme.primary.withOpacity(0.14))
                    : BrewezTheme.icedBlue.withOpacity(0.18),
              ),
            ),

            // Steam Particle Layer (Hot Ceramic Mug Only)
            if (widget.isHot)
              Positioned(
                top: 5,
                child: AnimatedBuilder(
                  animation: _steamController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(topWidth, 60),
                      painter: _SteamPainter(
                        progress: _steamController.value,
                        extraIntensity: _hasExtraShot ? 1.5 : 1.0,
                      ),
                    );
                  },
                ),
              ),

            // Main Cup Container
            Positioned(
              bottom: 24,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                width: topWidth + (widget.isHot ? 38 : 0), // Extra space for mug handle
                height: cupHeight,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    // Ceramic Mug Handle (Hot Mode Only)
                    if (widget.isHot)
                      Positioned(
                        right: 0,
                        top: cupHeight * 0.22,
                        child: CustomPaint(
                          size: Size(36, cupHeight * 0.55),
                          painter: _CeramicMugHandlePainter(),
                        ),
                      ),

                    // Cup Body & Liquid Clip
                    Positioned(
                      left: widget.isHot ? 0 : null,
                      child: ClipPath(
                        clipper: widget.isHot
                            ? _CeramicMugClipper(
                                topWidth: topWidth,
                                bottomWidth: bottomWidth,
                              )
                            : _TallGlassClipper(
                                topWidth: topWidth,
                                bottomWidth: bottomWidth,
                              ),
                        child: Container(
                          width: topWidth,
                          height: cupHeight,
                          decoration: BoxDecoration(
                            color: widget.isHot
                                ? const Color(0xFFFAF6F0) // Warm porcelain ceramic
                                : Colors.white.withOpacity(0.28), // Clear glass
                            border: Border.all(
                              color: widget.isHot
                                  ? const Color(0xFFE8DCC4)
                                  : Colors.white.withOpacity(0.7),
                              width: widget.isHot ? 2.5 : 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // 1. Dynamic Liquid Wave Animation
                              AnimatedBuilder(
                                animation: _waveController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: Size(topWidth, cupHeight),
                                    painter: _LiquidDynamicPainter(
                                      waveProgress: _waveController.value,
                                      fillPercent: widget.fillPercent,
                                      isHot: widget.isHot,
                                      hasOatMilk: _hasOatMilk,
                                      hasAlmondMilk: _hasAlmondMilk,
                                      hasPalmSugar: _hasPalmSugar,
                                      hasExtraShot: _hasExtraShot,
                                      hasCheeseFoam: _hasCheeseFoam,
                                      sweetness: widget.sweetness,
                                    ),
                                  );
                                },
                              ),

                              // 2. Thick Caramel Drizzle Stream
                              if (_hasCaramel)
                                AnimatedBuilder(
                                  animation: _drizzleController,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      size: Size(topWidth, cupHeight),
                                      painter: _CaramelDrizzlePainter(
                                        progress: _drizzleController.value,
                                        fillPercent: widget.fillPercent,
                                      ),
                                    );
                                  },
                                ),

                              // 3. Ice cubes (Iced Glass or Extra Ice)
                              if (!widget.isHot || _hasExtraIce)
                                AnimatedBuilder(
                                  animation: _iceBobController,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      size: Size(topWidth, cupHeight),
                                      painter: _DynamicIcePainter(
                                        bobbing: _iceBobController.value,
                                        fillPercent: widget.fillPercent,
                                        extraIce: _hasExtraIce,
                                      ),
                                    );
                                  },
                                ),

                              // 4. Cinnamon / Cocoa Sprinkles on Foam
                              if (_hasCinnamon)
                                CustomPaint(
                                  size: Size(topWidth, cupHeight),
                                  painter: _CinnamonSprinklesPainter(
                                    fillPercent: widget.fillPercent,
                                  ),
                                ),

                              // Cup Brand Sleeve / Badge
                              Positioned(
                                top: cupHeight * 0.44,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _hasExtraShot
                                        ? Colors.black.withOpacity(0.9)
                                        : BrewezTheme.espresso
                                            .withOpacity(0.88),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _hasExtraShot
                                            ? Icons.bolt_rounded
                                            : (widget.isHot
                                                ? Icons.coffee_rounded
                                                : Icons.local_cafe_rounded),
                                        color: _hasExtraShot
                                            ? Colors.amberAccent
                                            : BrewezTheme.primaryLight,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.isHot
                                            ? "MUG ${widget.size}"
                                            : "ICED ${widget.size}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Glass Condensation / Highlights
                    if (!widget.isHot)
                      Positioned(
                        child: CustomPaint(
                          size: Size(topWidth, cupHeight),
                          painter: _GlassCondensationPainter(
                            topWidth: topWidth,
                            bottomWidth: bottomWidth,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Base Saucer (Hot Mug) or Shadow (Iced Glass)
            Positioned(
              bottom: 12,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.isHot ? topWidth * 1.2 : bottomWidth * 1.15,
                height: widget.isHot ? 16 : 12,
                decoration: BoxDecoration(
                  color: widget.isHot
                      ? const Color(0xFFEFE8DB) // Ceramic Saucer plate
                      : null,
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(
                      widget.isHot ? topWidth * 1.2 : bottomWidth * 1.15,
                      widget.isHot ? 16 : 12,
                    ),
                  ),
                  border: widget.isHot
                      ? Border.all(color: const Color(0xFFDFD1B8), width: 1.5)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      blurRadius: widget.isHot ? 12 : 18,
                      spreadRadius: widget.isHot ? 0 : 2,
                    ),
                  ],
                ),
              ),
            ),

            // FLOATING REACTION BADGES
            // Left Badges
            Positioned(
              left: 12,
              top: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _animatedBadge(
                    active: _hasOatMilk,
                    icon: Icons.water_drop_outlined,
                    label: BrewezLocalization.tr('addon_oat_milk'),
                    color: const Color(0xFF8D6E63),
                  ),
                  _animatedBadge(
                    active: _hasAlmondMilk,
                    icon: Icons.spa_rounded,
                    label: BrewezLocalization.tr('addon_almond_milk'),
                    color: const Color(0xFF6D4C41),
                  ),
                  _animatedBadge(
                    active: _hasCaramel,
                    icon: Icons.grain_rounded,
                    label: BrewezLocalization.tr('addon_caramel'),
                    color: const Color(0xFFD48B30),
                  ),
                  _animatedBadge(
                    active: _hasExtraShot,
                    icon: Icons.bolt_rounded,
                    label: BrewezLocalization.tr('addon_extra_shot'),
                    color: const Color(0xFF2C1810),
                  ),
                ],
              ),
            ),

            // Right Badges
            Positioned(
              right: 12,
              top: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _animatedBadge(
                    active: _hasExtraIce,
                    icon: Icons.ac_unit_rounded,
                    label: BrewezLocalization.tr('addon_extra_ice'),
                    color: const Color(0xFF009688),
                  ),
                  _animatedBadge(
                    active: _hasCheeseFoam,
                    icon: Icons.cloud_rounded,
                    label: BrewezLocalization.tr('addon_cheese_foam'),
                    color: const Color(0xFFF9A825),
                  ),
                  _animatedBadge(
                    active: _hasCinnamon,
                    icon: Icons.flare_rounded,
                    label: BrewezLocalization.tr('addon_cinnamon'),
                    color: const Color(0xFF5D4037),
                  ),
                  _animatedBadge(
                    active: true,
                    icon: Icons.water_drop_rounded,
                    label: "${widget.sweetness}% ${BrewezLocalization.tr('sugar_label')}",
                    color: widget.sweetness == 0
                        ? Colors.blueGrey
                        : BrewezTheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedBadge({
    required bool active,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    if (!active) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.55), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ceramic Mug Clipper (Hot Mode - Rounded squatter base)
class _CeramicMugClipper extends CustomClipper<Path> {
  final double topWidth;
  final double bottomWidth;

  _CeramicMugClipper({required this.topWidth, required this.bottomWidth});

  @override
  Path getClip(Size size) {
    final path = Path();
    final horizontalInset = (topWidth - bottomWidth) / 2;

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 12, 0);
    path.lineTo(size.width - 12, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 10);

    path.lineTo(size.width - horizontalInset, size.height - 18);
    path.quadraticBezierTo(
      size.width - horizontalInset,
      size.height,
      size.width - horizontalInset - 20,
      size.height,
    );

    path.lineTo(horizontalInset + 20, size.height);
    path.quadraticBezierTo(
      horizontalInset,
      size.height,
      horizontalInset,
      size.height - 18,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _CeramicMugClipper oldClipper) => true;
}

/// Tall Glass Tumbler Clipper (Iced Mode - Sleek tapered glass)
class _TallGlassClipper extends CustomClipper<Path> {
  final double topWidth;
  final double bottomWidth;

  _TallGlassClipper({required this.topWidth, required this.bottomWidth});

  @override
  Path getClip(Size size) {
    final path = Path();
    final horizontalInset = (topWidth - bottomWidth) / 2;

    path.moveTo(0, 6);
    path.lineTo(size.width, 6);
    path.lineTo(size.width - horizontalInset, size.height - 6);
    path.quadraticBezierTo(
      size.width - horizontalInset,
      size.height,
      size.width - horizontalInset - 10,
      size.height,
    );
    path.lineTo(horizontalInset + 10, size.height);
    path.quadraticBezierTo(
      horizontalInset,
      size.height,
      horizontalInset,
      size.height - 6,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TallGlassClipper oldClipper) => true;
}

/// Ceramic Mug Handle Painter (Curved loop on side of mug)
class _CeramicMugHandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final handlePaint = Paint()
      ..color = const Color(0xFFE8DCC4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = const Color(0xFFFAF6F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(2, 6);
    path.cubicTo(
      size.width * 1.3,
      size.height * 0.1,
      size.width * 1.3,
      size.height * 0.9,
      2,
      size.height - 6,
    );

    canvas.drawPath(path, handlePaint);
    canvas.drawPath(path, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _CeramicMugHandlePainter oldDelegate) => false;
}

/// Dynamic Liquid Painter with Espresso, Milk Swirls, Cheese Foam, and Sweetness
class _LiquidDynamicPainter extends CustomPainter {
  final double waveProgress;
  final double fillPercent;
  final bool isHot;
  final bool hasOatMilk;
  final bool hasAlmondMilk;
  final bool hasPalmSugar;
  final bool hasExtraShot;
  final bool hasCheeseFoam;
  final int sweetness;

  _LiquidDynamicPainter({
    required this.waveProgress,
    required this.fillPercent,
    required this.isHot,
    required this.hasOatMilk,
    required this.hasAlmondMilk,
    required this.hasPalmSugar,
    required this.hasExtraShot,
    required this.hasCheeseFoam,
    required this.sweetness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final liquidHeight = size.height * fillPercent;
    final baseLiquidY = size.height - liquidHeight;

    // Espresso Dark Tone adjustments
    final Color espressoDark = hasExtraShot
        ? const Color(0xFF140702)
        : (hasPalmSugar
            ? const Color(0xFF2A1408)
            : (hasOatMilk || hasAlmondMilk
                ? const Color(0xFF5E3A1C)
                : const Color(0xFF381F12)));

    final Color espressoLight = hasExtraShot
        ? const Color(0xFF2E1205)
        : (hasOatMilk
            ? const Color(0xFFB88E68)
            : (hasAlmondMilk
                ? const Color(0xFFA88258)
                : const Color(0xFF6B3E1E)));

    // 1. Back Layer Wave
    final backPaint = Paint()
      ..shader = LinearGradient(
        colors: [espressoLight, espressoDark],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, baseLiquidY, size.width, liquidHeight));

    final backWavePath = Path();
    backWavePath.moveTo(0, size.height);
    backWavePath.lineTo(0, baseLiquidY);

    for (double x = 0; x <= size.width; x += 1) {
      final y = baseLiquidY +
          math.sin((x / size.width * 2 * math.pi) +
                  (waveProgress * 2 * math.pi)) *
              4.5;
      backWavePath.lineTo(x, y);
    }
    backWavePath.lineTo(size.width, size.height);
    backWavePath.close();
    canvas.drawPath(backWavePath, backPaint);

    // 2. Palm Sugar / Sweetness Layer (Amber Honey at Bottom)
    if (sweetness > 0 || hasPalmSugar) {
      final honeyFactor = hasPalmSugar ? 0.45 : (sweetness / 100) * 0.35;
      final honeyHeight = liquidHeight * honeyFactor;
      final honeyPaint = Paint()
        ..shader = LinearGradient(
          colors: hasPalmSugar
              ? [
                  const Color(0xFF68360F).withOpacity(0.95),
                  const Color(0xFF3A1C06),
                ]
              : [
                  const Color(0xFFE5A638).withOpacity(0.85),
                  const Color(0xFFC7771B).withOpacity(0.95),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(
            0, size.height - honeyHeight, size.width, honeyHeight));

      final honeyPath = Path();
      honeyPath.moveTo(0, size.height);
      honeyPath.lineTo(0, size.height - honeyHeight);
      for (double x = 0; x <= size.width; x += 2) {
        final y = (size.height - honeyHeight) +
            math.sin((x / size.width * 2 * math.pi) -
                    (waveProgress * 2 * math.pi)) *
                2.5;
        honeyPath.lineTo(x, y);
      }
      honeyPath.lineTo(size.width, size.height);
      honeyPath.close();
      canvas.drawPath(honeyPath, honeyPaint);
    }

    // 3. Front Layer Wave
    final frontPaint = Paint()
      ..shader = LinearGradient(
        colors: [espressoLight.withOpacity(0.92), espressoDark],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, baseLiquidY, size.width, liquidHeight));

    final frontWavePath = Path();
    frontWavePath.moveTo(0, size.height);
    frontWavePath.lineTo(0, baseLiquidY + 3);

    for (double x = 0; x <= size.width; x += 1) {
      final y = baseLiquidY +
          math.cos((x / size.width * 2 * math.pi) -
                  (waveProgress * 2 * math.pi)) *
              5.0;
      frontWavePath.lineTo(x, y);
    }
    frontWavePath.lineTo(size.width, size.height);
    frontWavePath.close();
    canvas.drawPath(frontWavePath, frontPaint);

    // 4. Plant-based Milk Swirl Layer (Oat Milk / Almond Milk)
    if (hasOatMilk || hasAlmondMilk) {
      final milkPaint = Paint()
        ..shader = LinearGradient(
          colors: hasAlmondMilk
              ? [
                  const Color(0xFFFAF3E6).withOpacity(0.92),
                  const Color(0xFFE8D7C0).withOpacity(0.7),
                ]
              : [
                  const Color(0xFFFFFDF5).withOpacity(0.95),
                  const Color(0xFFF3E7D8).withOpacity(0.75),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(
            Rect.fromLTWH(0, baseLiquidY, size.width, liquidHeight * 0.5));

      final milkPath = Path();
      milkPath.moveTo(0, baseLiquidY);
      for (double x = 0; x <= size.width; x += 2) {
        final y = baseLiquidY +
            math.sin((x / size.width * 3 * math.pi) +
                    (waveProgress * 2 * math.pi)) *
                4.0;
        milkPath.lineTo(x, y);
      }
      milkPath.lineTo(size.width, baseLiquidY + (liquidHeight * 0.45));
      milkPath.quadraticBezierTo(
        size.width * 0.5,
        baseLiquidY + (liquidHeight * 0.55),
        0,
        baseLiquidY + (liquidHeight * 0.4),
      );
      milkPath.close();
      canvas.drawPath(milkPath, milkPaint);
    }

    // 5. Cheese Foam / Macchiato Topping Layer
    if (hasCheeseFoam) {
      final foamHeight = liquidHeight * 0.28;
      final cheesePaint = Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFFFFDE8),
            Color(0xFFF6E7B8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, baseLiquidY, size.width, foamHeight));

      final cheesePath = Path();
      cheesePath.moveTo(0, baseLiquidY);
      for (double x = 0; x <= size.width; x += 2) {
        final y = baseLiquidY +
            math.cos((x / size.width * 2 * math.pi) +
                    (waveProgress * 2 * math.pi)) *
                3.0;
        cheesePath.lineTo(x, y);
      }
      cheesePath.lineTo(size.width, baseLiquidY + foamHeight);
      cheesePath.lineTo(0, baseLiquidY + foamHeight);
      cheesePath.close();
      canvas.drawPath(cheesePath, cheesePaint);
    }

    // 6. Top Froth / Rim line
    final frothPaint = Paint()
      ..color = hasCheeseFoam
          ? const Color(0xFFFFFCE0)
          : (isHot
              ? const Color(0xFFFFF3E0).withOpacity(0.85)
              : const Color(0xFFE0F7FA).withOpacity(0.65))
      ..strokeWidth = hasCheeseFoam ? 5.0 : 3.0
      ..style = PaintingStyle.stroke;

    final frothPath = Path();
    frothPath.moveTo(0, baseLiquidY + 3);
    for (double x = 0; x <= size.width; x += 2) {
      final y = baseLiquidY +
          math.cos((x / size.width * 2 * math.pi) -
                  (waveProgress * 2 * math.pi)) *
              5.0;
      frothPath.lineTo(x, y);
    }
    canvas.drawPath(frothPath, frothPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidDynamicPainter oldDelegate) => true;
}

/// Caramel Drizzle Painter
class _CaramelDrizzlePainter extends CustomPainter {
  final double progress;
  final double fillPercent;

  _CaramelDrizzlePainter({required this.progress, required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final baseLiquidY = size.height - (size.height * fillPercent);
    final caramelPaint = Paint()
      ..color = const Color(0xFFE68A00).withOpacity(0.95)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final d1Y = baseLiquidY + 12 + (progress * 30);
    final path1 = Path();
    path1.moveTo(size.width * 0.22, baseLiquidY - 4);
    path1.quadraticBezierTo(
        size.width * 0.28, baseLiquidY + 18, size.width * 0.24, d1Y);
    canvas.drawPath(path1, caramelPaint);

    final d2Y = baseLiquidY + 18 + (((progress + 0.5) % 1.0) * 35);
    final path2 = Path();
    path2.moveTo(size.width * 0.78, baseLiquidY - 4);
    path2.quadraticBezierTo(
        size.width * 0.72, baseLiquidY + 22, size.width * 0.76, d2Y);
    canvas.drawPath(path2, caramelPaint);

    final dropPaint = Paint()
      ..color = const Color(0xFFD47A00)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.24, d1Y + 4), 3.5, dropPaint);
    canvas.drawCircle(Offset(size.width * 0.76, d2Y + 4), 4.0, dropPaint);
  }

  @override
  bool shouldRepaint(covariant _CaramelDrizzlePainter oldDelegate) => true;
}

/// Dynamic Ice Cubes Painter
class _DynamicIcePainter extends CustomPainter {
  final double bobbing;
  final double fillPercent;
  final bool extraIce;

  _DynamicIcePainter({
    required this.bobbing,
    required this.fillPercent,
    required this.extraIce,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseLiquidY = size.height - (size.height * fillPercent);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    _drawIceCube(
        canvas, Offset(size.width * 0.35, baseLiquidY + 20 + (bobbing * 5)),
        22, paint, borderPaint, -0.2);
    _drawIceCube(
        canvas, Offset(size.width * 0.65, baseLiquidY + 26 - (bobbing * 4)),
        26, paint, borderPaint, 0.35);
    _drawIceCube(
        canvas, Offset(size.width * 0.48, baseLiquidY + 50 + (bobbing * 3)),
        20, paint, borderPaint, 0.1);

    if (extraIce) {
      _drawIceCube(
          canvas, Offset(size.width * 0.25, baseLiquidY + 44 - (bobbing * 4)),
          18, paint, borderPaint, 0.5);
      _drawIceCube(
          canvas, Offset(size.width * 0.75, baseLiquidY + 56 + (bobbing * 5)),
          19, paint, borderPaint, -0.4);
      _drawIceCube(
          canvas, Offset(size.width * 0.52, baseLiquidY + 16 - (bobbing * 3)),
          21, paint, borderPaint, 0.2);
    }
  }

  void _drawIceCube(
    Canvas canvas,
    Offset center,
    double size,
    Paint fill,
    Paint stroke,
    double angle,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: size, height: size),
      const Radius.circular(5),
    );
    canvas.drawRRect(rect, fill);
    canvas.drawRRect(rect, stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DynamicIcePainter oldDelegate) => true;
}

/// Cinnamon / Cocoa Sprinkles Painter
class _CinnamonSprinklesPainter extends CustomPainter {
  final double fillPercent;

  _CinnamonSprinklesPainter({required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final baseLiquidY = size.height - (size.height * fillPercent);
    final paint = Paint()
      ..color = const Color(0xFF6D3B18).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    const List<Offset> points = [
      Offset(0.30, 4),
      Offset(0.38, 7),
      Offset(0.45, 3),
      Offset(0.52, 8),
      Offset(0.60, 4),
      Offset(0.68, 6),
      Offset(0.42, 12),
      Offset(0.55, 13),
      Offset(0.34, 10),
      Offset(0.63, 11),
    ];

    for (final pt in points) {
      canvas.drawCircle(
        Offset(size.width * pt.dx, baseLiquidY + pt.dy),
        2.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CinnamonSprinklesPainter oldDelegate) => false;
}

/// Steam particles painter
class _SteamPainter extends CustomPainter {
  final double progress;
  final double extraIntensity;

  _SteamPainter({required this.progress, this.extraIntensity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final steamPaint = Paint()
      ..strokeWidth = 3.5 * extraIntensity
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _drawSteamWisp(
      canvas,
      startX: size.width * 0.3,
      startY: size.height,
      progress: (progress + 0.0) % 1.0,
      width: 14,
      paint: steamPaint,
    );
    _drawSteamWisp(
      canvas,
      startX: size.width * 0.5,
      startY: size.height,
      progress: (progress + 0.33) % 1.0,
      width: 18,
      paint: steamPaint,
    );
    _drawSteamWisp(
      canvas,
      startX: size.width * 0.7,
      startY: size.height,
      progress: (progress + 0.66) % 1.0,
      width: 14,
      paint: steamPaint,
    );
  }

  void _drawSteamWisp(
    Canvas canvas, {
    required double startX,
    required double startY,
    required double progress,
    required double width,
    required Paint paint,
  }) {
    final opacity = (1.0 - progress) * (progress < 0.2 ? progress / 0.2 : 1.0);
    paint.color = Colors.brown.shade200.withOpacity(opacity * 0.55);

    final path = Path();
    final currentY = startY - (progress * 55);

    path.moveTo(startX, startY);
    path.cubicTo(
      startX - width,
      startY - 15,
      startX + width,
      startY - 35,
      startX - (width / 2),
      currentY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SteamPainter oldDelegate) => true;
}

/// Glass Condensation and shine streaks
class _GlassCondensationPainter extends CustomPainter {
  final double topWidth;
  final double bottomWidth;

  _GlassCondensationPainter(
      {required this.topWidth, required this.bottomWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final dewPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Small droplets on glass wall
    const List<Offset> drops = [
      Offset(16, 40),
      Offset(22, 65),
      Offset(18, 95),
      Offset(24, 130),
      Offset(19, 160),
    ];

    for (final drop in drops) {
      canvas.drawCircle(drop, 2.0, dewPaint);
    }

    // Glass shine streak
    final shinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(8, 12, 10, size.height * 0.7))
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(10, 14),
      Offset(18, size.height * 0.75),
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassCondensationPainter oldDelegate) => false;
}
