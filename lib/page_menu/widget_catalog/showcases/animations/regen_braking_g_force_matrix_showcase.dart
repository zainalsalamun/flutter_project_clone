import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _DriveMode {
  eco('Eco Range', Color(0xFF10B981), Icons.eco_rounded),
  comfort('Comfort', Color(0xFF38BDF8), Icons.directions_car_rounded),
  sport('Sport Plus', Color(0xFFF59E0B), Icons.speed_rounded),
  track('Track Launch', Color(0xFFEC4899), Icons.sports_score_rounded);

  final String label;
  final Color themeColor;
  final IconData icon;
  const _DriveMode(this.label, this.themeColor, this.icon);
}

enum _RegenLevel {
  off('Off (Coasting)', 0.0),
  low('Low', 0.33),
  standard('Standard', 0.66),
  onePedal('One-Pedal Drive', 1.0);

  final String label;
  final double intensity;
  const _RegenLevel(this.label, this.intensity);
}

class RegenBrakingGForceMatrixShowcase extends StatefulWidget {
  const RegenBrakingGForceMatrixShowcase({super.key});

  @override
  State<RegenBrakingGForceMatrixShowcase> createState() =>
      _RegenBrakingGForceMatrixShowcaseState();
}

class _RegenBrakingGForceMatrixShowcaseState
    extends State<RegenBrakingGForceMatrixShowcase>
    with SingleTickerProviderStateMixin {
  // Telemetry dynamics
  final double _speedKmh = 98.0; // 0 - 250 km/h
  double _powerKw = 45.0; // -120 kW (regen) to +320 kW (boost)
  double _lateralG = 0.22; // -1.5G (Left) to +1.5G (Right)
  double _longitudinalG = 0.15; // -1.5G (Brake) to +1.5G (Accel)

  _DriveMode _driveMode = _DriveMode.sport;
  _RegenLevel _regenLevel = _RegenLevel.standard;

  // G-Force trail history
  final List<Offset> _gTrail = [];

  // Animation controller for idle telemetry pulsing
  late AnimationController _idleTicker;

  @override
  void initState() {
    super.initState();
    _idleTicker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(() {
      if (_gTrail.length > 25) {
        _gTrail.removeAt(0);
      }
    });
    _idleTicker.repeat();
  }

  @override
  void dispose() {
    _idleTicker.dispose();
    super.dispose();
  }

  void _onGForcePanUpdate(DragUpdateDetails details, Size padSize) {
    final center = Offset(padSize.width / 2, padSize.height / 2);
    final maxRadius = padSize.width / 2 - 12;

    final dx = (details.localPosition.dx - center.dx) / maxRadius;
    final dy = (details.localPosition.dy - center.dy) / maxRadius;

    setState(() {
      _lateralG = (dx * 1.5).clamp(-1.5, 1.5);
      // Invert Y: dragging up is positive acceleration G, dragging down is braking G
      _longitudinalG = (-dy * 1.5).clamp(-1.5, 1.5);

      // Map longitudinal G to kW power output
      if (_longitudinalG >= 0) {
        _powerKw = _longitudinalG * 200.0; // Acceleration power
      } else {
        _powerKw =
            _longitudinalG *
            90.0 *
            _regenLevel.intensity; // Regen power (negative)
      }

      _gTrail.add(Offset(_lateralG, _longitudinalG));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isRegenActive = _powerKw < 0;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HEADER INFO BANNER
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
                    color: _driveMode.themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: _driveMode.themeColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dynamic G-Force & Regen',
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
                        'Friction Circle & Bi-Directional Power Gauge',
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
                    color: _driveMode.themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _driveMode.themeColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    _driveMode.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _driveMode.themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. SPEEDOMETER & BI-DIRECTIONAL POWER / REGEN GAUGE
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 1.0,
                colors:
                    isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF090D16)]
                        : [Colors.white, const Color(0xFFF8FAFC)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Digital Speedometer Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${_speedKmh.toInt()}',
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2.0,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'KM/H',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Bi-directional Power Bar (Regen vs Power Output)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.restart_alt_rounded,
                              size: 13,
                              color: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'REGEN',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color:
                                    isRegenActive
                                        ? const Color(0xFF10B981)
                                        : (isDark
                                            ? Colors.white38
                                            : Colors.black38),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          isRegenActive
                              ? '${_powerKw.abs().toInt()} kW REGEN'
                              : '${_powerKw.toInt()} kW POWER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                isRegenActive
                                    ? const Color(0xFF10B981)
                                    : _driveMode.themeColor,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'BOOST',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color:
                                    !isRegenActive
                                        ? _driveMode.themeColor
                                        : (isDark
                                            ? Colors.white38
                                            : Colors.black38),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.electric_bolt_rounded,
                              size: 13,
                              color: _driveMode.themeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Dual Bi-directional Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 12,
                        color: isDark ? Colors.white12 : Colors.black12,
                        child: Row(
                          children: [
                            // Left Half: Regen Bar (0 to 100 kW)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      isRegenActive
                                          ? (_powerKw.abs() / 120.0).clamp(
                                            0.0,
                                            1.0,
                                          )
                                          : 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF34D399),
                                          const Color(0xFF10B981),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Center zero-point divider line
                            Container(
                              width: 3,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            // Right Half: Power Bar (0 to 300 kW)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      !isRegenActive
                                          ? (_powerKw / 300.0).clamp(0.0, 1.0)
                                          : 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _driveMode.themeColor,
                                          const Color(0xFFEF4444),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. 2D G-FORCE FRICTION CIRCLE PAD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '2D G-FORCE FRICTION CIRCLE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lat: ${_lateralG.toStringAsFixed(2)}G • Long: ${_longitudinalG.toStringAsFixed(2)}G',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: _driveMode.themeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Interactive Touch G-Pad
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const padSize = Size(200, 200);

                      return GestureDetector(
                        onPanUpdate:
                            (details) => _onGForcePanUpdate(details, padSize),
                        child: CustomPaint(
                          size: padSize,
                          painter: _GForceFrictionCirclePainter(
                            lateralG: _lateralG,
                            longitudinalG: _longitudinalG,
                            trail: _gTrail,
                            themeColor: _driveMode.themeColor,
                            isDark: isDark,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sentuh & drag lingkaran di atas untuk mensimulasikan gaya G kemudi/akselerasi',
                  style: TextStyle(
                    fontSize: 9,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. DRIVE MODE & REGEN LEVEL SELECTION
          Text(
            'PILIHAN DRIVE MODE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children:
                _DriveMode.values.map((mode) {
                  final isSel = _driveMode == mode;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _driveMode = mode);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSel
                                  ? mode.themeColor.withValues(alpha: 0.18)
                                  : (isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSel
                                    ? mode.themeColor
                                    : (isDark
                                        ? Colors.white12
                                        : Colors.black12),
                            width: isSel ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              mode.icon,
                              size: 18,
                              color:
                                  isSel
                                      ? mode.themeColor
                                      : (isDark
                                          ? Colors.white54
                                          : Colors.black45),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mode.label.split(' ')[0],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight:
                                    isSel ? FontWeight.bold : FontWeight.normal,
                                color:
                                    isSel
                                        ? mode.themeColor
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

          const SizedBox(height: 16),

          // 5. REGENERATIVE BRAKING STRENGTH CHIPS
          Text(
            'TINGKAT REGENERATIVE BRAKING',
            style: TextStyle(
              fontSize: 10,
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
                  _RegenLevel.values.map((lvl) {
                    final isSelected = _regenLevel == lvl;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(lvl.label),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _regenLevel = lvl);
                          }
                        },
                        selectedColor: const Color(0xFF10B981),
                        backgroundColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 2D G-FORCE FRICTION CIRCLE PAINTER
// -------------------------------------------------------------
class _GForceFrictionCirclePainter extends CustomPainter {
  final double lateralG;
  final double longitudinalG;
  final List<Offset> trail;
  final Color themeColor;
  final bool isDark;

  _GForceFrictionCirclePainter({
    required this.lateralG,
    required this.longitudinalG,
    required this.trail,
    required this.themeColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 12;

    // 1. Concentric G-Force Rings (0.5G, 1.0G, 1.5G)
    final ringPaint =
        Paint()
          ..color = (isDark ? Colors.white12 : Colors.black12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final r = maxRadius * (i / 3.0);
      canvas.drawCircle(center, r, ringPaint);
    }

    // 2. Axis Crosshair
    final axisPaint =
        Paint()
          ..color = (isDark ? Colors.white10 : Colors.black12)
          ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx, 10),
      Offset(center.dx, size.height - 10),
      axisPaint,
    );
    canvas.drawLine(
      Offset(10, center.dy),
      Offset(size.width - 10, center.dy),
      axisPaint,
    );

    // 3. Fading G-Force Trail Dots
    for (int i = 0; i < trail.length; i++) {
      final g = trail[i];
      final px = center.dx + (g.dx / 1.5) * maxRadius;
      final py = center.dy - (g.dy / 1.5) * maxRadius;
      final alpha = ((i + 1) / trail.length * 0.45).clamp(0.05, 0.45);

      final trailPaint =
          Paint()
            ..color = themeColor.withValues(alpha: alpha)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(px, py), 3, trailPaint);
    }

    // 4. Current G-Point Node
    final currentPx = center.dx + (lateralG / 1.5) * maxRadius;
    final currentPy = center.dy - (longitudinalG / 1.5) * maxRadius;
    final currentPos = Offset(currentPx, currentPy);

    // Vector line from center
    final linePaint =
        Paint()
          ..color = themeColor.withValues(alpha: 0.5)
          ..strokeWidth = 1.5;
    canvas.drawLine(center, currentPos, linePaint);

    // Glowing Aura
    final auraPaint =
        Paint()
          ..color = themeColor.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(currentPos, 14, auraPaint);

    // Node Circle
    final nodePaint =
        Paint()
          ..color = themeColor
          ..style = PaintingStyle.fill;
    canvas.drawCircle(currentPos, 7, nodePaint);

    final strokePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
    canvas.drawCircle(currentPos, 7, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _GForceFrictionCirclePainter oldDelegate) =>
      true;
}
