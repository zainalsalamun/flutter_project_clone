import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnergyConsumptionFlowGraphShowcase extends StatefulWidget {
  const EnergyConsumptionFlowGraphShowcase({super.key});

  @override
  State<EnergyConsumptionFlowGraphShowcase> createState() =>
      _EnergyConsumptionFlowGraphShowcaseState();
}

class _EnergyConsumptionFlowGraphShowcaseState
    extends State<EnergyConsumptionFlowGraphShowcase>
    with SingleTickerProviderStateMixin {
  // Environmental & Appliance states
  double _sunIntensity = 0.85; // 0.0 (Night) to 1.0 (Peak Sun)
  bool _evChargerActive = false; // +7.2 kW
  bool _hvacActive = true; // +2.4 kW
  bool _kitchenOvenActive = false; // +2.0 kW
  final int _batterySoc = 82; // Battery %

  late AnimationController _flowAnimController;

  @override
  void initState() {
    super.initState();
    _flowAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _flowAnimController.dispose();
    super.dispose();
  }

  // Calculate dynamic power flows (in kW)
  double get _solarGeneration => 5.4 * _sunIntensity; // 0 to 5.4 kW

  double get _homeConsumption {
    double base = 1.2; // Base household consumption
    if (_hvacActive) base += 2.4;
    if (_kitchenOvenActive) base += 2.0;
    if (_evChargerActive) base += 7.2;
    return base;
  }

  // Net balance: positive means excess solar, negative means deficit
  double get _netSolarBalance => _solarGeneration - _homeConsumption;

  // Battery flow (+ charging, - discharging)
  double get _batteryFlow {
    if (_netSolarBalance > 0) {
      // Excess solar charges battery up to max 3.2 kW charge rate
      return math.min(3.2, _netSolarBalance * 0.7);
    } else {
      // Deficit discharges battery (if SOC > 10%)
      if (_batterySoc > 10) {
        return math.max(-4.0, _netSolarBalance);
      }
      return 0.0;
    }
  }

  // Grid flow (+ exporting to grid, - importing from grid)
  double get _gridFlow {
    final double remainder = _netSolarBalance - _batteryFlow;
    return remainder; // positive: export, negative: import
  }

  double get _gridIndependencePercent {
    final double totalNeeded = _homeConsumption;
    final double fromGrid = _gridFlow < 0 ? -_gridFlow : 0.0;
    final double cleanUsed = math.max(0.0, totalNeeded - fromGrid);
    return ((cleanUsed / totalNeeded) * 100).clamp(0.0, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final solarKw = _solarGeneration;
    final homeKw = _homeConsumption;
    final batKw = _batteryFlow;
    final gridKw = _gridFlow;
    final independence = _gridIndependencePercent;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Metrics Banner (Independence, Self-Powered)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [Colors.white, const Color(0xFFF8FAFC)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricItem(
                  'Self-Sufficiency',
                  '${independence.round()}%',
                  Icons.verified_rounded,
                  independence > 70 ? const Color(0xFF10B981) : Colors.amber,
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                _metricItem(
                  'Solar Gen',
                  '${solarKw.toStringAsFixed(1)} kW',
                  Icons.wb_sunny_rounded,
                  const Color(0xFFF59E0B),
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                _metricItem(
                  'Home Load',
                  '${homeKw.toStringAsFixed(1)} kW',
                  Icons.home_rounded,
                  const Color(0xFF38BDF8),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Animated Flow Network Topology Graph
          Container(
            height: 290,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161E2E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _flowAnimController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _EnergyFlowTopologyPainter(
                    progress: _flowAnimController.value,
                    solarKw: solarKw,
                    homeKw: homeKw,
                    batteryKw: batKw,
                    gridKw: gridKw,
                    batterySoc: _batterySoc,
                    isDark: isDark,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 3. Sun Intensity Environment Slider
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
                      children: const [
                        Icon(
                          Icons.wb_sunny_rounded,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Solar Radiation Intensity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _sunIntensity == 0.0
                          ? 'Night (0%)'
                          : '${(_sunIntensity * 100).round()}% (${solarKw.toStringAsFixed(1)} kW)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFF59E0B),
                    inactiveTrackColor:
                        isDark ? Colors.white12 : Colors.black12,
                    thumbColor: const Color(0xFFF59E0B),
                    overlayColor: const Color(
                      0xFFF59E0B,
                    ).withValues(alpha: 0.2),
                    trackHeight: 5,
                  ),
                  child: Slider(
                    value: _sunIntensity,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (val) {
                      setState(() => _sunIntensity = val);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Interactive Household Appliance Load Controls
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
                    Text(
                      'Active Consumer Loads',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Total: ${homeKw.toStringAsFixed(1)} kW',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Appliance Toggles
                _applianceTile(
                  'EV Fast Charger',
                  '+7.2 kW',
                  Icons.electric_car_rounded,
                  _evChargerActive,
                  const Color(0xFFEC4899),
                  (val) {
                    HapticFeedback.lightImpact();
                    setState(() => _evChargerActive = val);
                  },
                ),
                const Divider(height: 14),
                _applianceTile(
                  'HVAC Climate Heat Pump',
                  '+2.4 kW',
                  Icons.local_fire_department_rounded,
                  _hvacActive,
                  const Color(0xFFF97316),
                  (val) {
                    HapticFeedback.lightImpact();
                    setState(() => _hvacActive = val);
                  },
                ),
                const Divider(height: 14),
                _applianceTile(
                  'Induction Cooktop & Oven',
                  '+2.0 kW',
                  Icons.soup_kitchen_rounded,
                  _kitchenOvenActive,
                  const Color(0xFF8B5CF6),
                  (val) {
                    HapticFeedback.lightImpact();
                    setState(() => _kitchenOvenActive = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _applianceTile(
    String title,
    String powerBadge,
    IconData icon,
    bool isActive,
    Color activeColor,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isActive ? activeColor : Colors.grey).withValues(
              alpha: 0.15,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? activeColor : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? null : Colors.grey,
                ),
              ),
              Text(
                powerBadge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isActive ? activeColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: isActive,
          activeTrackColor: activeColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Animated Energy Topology Node Network
// -------------------------------------------------------------
class _EnergyFlowTopologyPainter extends CustomPainter {
  final double progress;
  final double solarKw;
  final double homeKw;
  final double batteryKw;
  final double gridKw;
  final int batterySoc;
  final bool isDark;

  _EnergyFlowTopologyPainter({
    required this.progress,
    required this.solarKw,
    required this.homeKw,
    required this.batteryKw,
    required this.gridKw,
    required this.batterySoc,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Node Positions
    final solarPos = Offset(size.width / 2, 40);
    final homePos = Offset(size.width - 50, size.height / 2);
    final batteryPos = Offset(size.width / 2, size.height - 40);
    final gridPos = Offset(50, size.height / 2);

    // Draw connecting paths & pulse streams
    // 1. Solar to Inverter Center
    if (solarKw > 0.05) {
      _drawPulseStream(
        canvas,
        solarPos,
        center,
        const Color(0xFFF59E0B),
        solarKw,
        false,
      );
    }

    // 2. Inverter to Home
    if (homeKw > 0.05) {
      _drawPulseStream(
        canvas,
        center,
        homePos,
        const Color(0xFF38BDF8),
        homeKw,
        false,
      );
    }

    // 3. Battery flow (Charging: Inverter -> Battery, Discharging: Battery -> Inverter)
    if (batteryKw.abs() > 0.05) {
      final isCharging = batteryKw > 0;
      final start = isCharging ? center : batteryPos;
      final end = isCharging ? batteryPos : center;
      _drawPulseStream(
        canvas,
        start,
        end,
        const Color(0xFF10B981),
        batteryKw.abs(),
        false,
      );
    }

    // 4. Grid flow (Exporting: Inverter -> Grid, Importing: Grid -> Inverter)
    if (gridKw.abs() > 0.05) {
      final isExporting = gridKw > 0;
      final start = isExporting ? center : gridPos;
      final end = isExporting ? gridPos : center;
      final color =
          isExporting ? const Color(0xFF10B981) : const Color(0xFFF97316);
      _drawPulseStream(canvas, start, end, color, gridKw.abs(), false);
    }

    // Draw Central Inverter Hub Node
    _drawCenterHub(canvas, center);

    // Draw 4 Surrounding Nodes
    _drawNode(
      canvas,
      solarPos,
      'SOLAR',
      '${solarKw.toStringAsFixed(1)} kW',
      Icons.wb_sunny_rounded,
      const Color(0xFFF59E0B),
    );
    _drawNode(
      canvas,
      homePos,
      'HOME',
      '${homeKw.toStringAsFixed(1)} kW',
      Icons.home_rounded,
      const Color(0xFF38BDF8),
    );
    _drawNode(
      canvas,
      batteryPos,
      'BATTERY',
      '$batterySoc% (${batteryKw >= 0 ? '+' : ''}${batteryKw.toStringAsFixed(1)}kW)',
      Icons.battery_charging_full_rounded,
      const Color(0xFF10B981),
    );
    _drawNode(
      canvas,
      gridPos,
      'GRID',
      gridKw > 0
          ? 'Export ${gridKw.toStringAsFixed(1)}kW'
          : 'Import ${(-gridKw).toStringAsFixed(1)}kW',
      Icons.electric_bolt_rounded,
      gridKw >= 0 ? const Color(0xFF10B981) : const Color(0xFFF97316),
    );
  }

  void _drawPulseStream(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Color color,
    double flowRate,
    bool curved,
  ) {
    // Base pipe track
    final pipePaint =
        Paint()
          ..color = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.08,
          )
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(p1, p2, pipePaint);

    // Dynamic moving pulse dots
    final double distance = (p2 - p1).distance;
    final int dotCount = math.max(2, (distance / 35).round());

    for (int i = 0; i < dotCount; i++) {
      final double dotFraction = (progress + (i / dotCount)) % 1.0;
      final dotPos = Offset.lerp(p1, p2, dotFraction)!;

      // Glow behind particle
      final glowPaint =
          Paint()
            ..color = color.withValues(alpha: 0.35)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(dotPos, 6, glowPaint);

      // Core particle
      final dotPaint = Paint()..color = color;
      canvas.drawCircle(dotPos, 3, dotPaint);
    }
  }

  void _drawCenterHub(Canvas canvas, Offset pos) {
    final bgPaint =
        Paint()
          ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, 22, bgPaint);

    final borderPaint =
        Paint()
          ..color = isDark ? Colors.white24 : Colors.black26
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
    canvas.drawCircle(pos, 22, borderPaint);

    final iconPaint = Paint()..color = const Color(0xFF6366F1);
    canvas.drawCircle(pos, 8, iconPaint);
  }

  void _drawNode(
    Canvas canvas,
    Offset pos,
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
  ) {
    final nodeR = 26.0;

    // Node background shadow & circle
    final bgPaint =
        Paint()
          ..color = isDark ? const Color(0xFF1E293B) : Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, nodeR, bgPaint);

    final borderPaint =
        Paint()
          ..color = accentColor.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
    canvas.drawCircle(pos, nodeR, borderPaint);

    // Draw title & subtitle text beneath/above node
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: accentColor,
              letterSpacing: 0.5,
            ),
          ),
          TextSpan(
            text: subtitle,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      pos.dx - (textPainter.width / 2),
      pos.dy + nodeR + 4,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _EnergyFlowTopologyPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.solarKw != solarKw ||
      oldDelegate.homeKw != homeKw ||
      oldDelegate.batteryKw != batteryKw ||
      oldDelegate.gridKw != gridKw;
}
