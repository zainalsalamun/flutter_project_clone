import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _ChargingSpeedMode {
  unplugged('Tidak Terhubung', 0.0, Icons.power_off_rounded, Colors.grey),
  acHome('AC Home 7.4 kW', 7.4, Icons.home_rounded, Color(0xFF38BDF8)),
  dcFast('DC Fast 150 kW', 150.0, Icons.bolt_rounded, Color(0xFFF59E0B)),
  supercharger(
    'Supercharger 250 kW',
    250.0,
    Icons.electric_bolt_rounded,
    Color(0xFF10B981),
  );

  final String label;
  final double powerKw;
  final IconData icon;
  final Color color;
  const _ChargingSpeedMode(this.label, this.powerKw, this.icon, this.color);
}

class EvBatteryStateOfChargeShowcase extends StatefulWidget {
  const EvBatteryStateOfChargeShowcase({super.key});

  @override
  State<EvBatteryStateOfChargeShowcase> createState() =>
      _EvBatteryStateOfChargeShowcaseState();
}

class _EvBatteryStateOfChargeShowcaseState
    extends State<EvBatteryStateOfChargeShowcase>
    with SingleTickerProviderStateMixin {
  // Battery specifications
  final double _batteryCapacityKwh = 82.0; // 82 kWh pack
  final double _maxRangeKm = 560.0; // 560 km total WLTP range

  // State
  double _currentSoc = 64.0; // Current % (0 - 100)
  double _targetChargeLimit = 80.0; // Daily commute 80% default
  _ChargingSpeedMode _chargingMode = _ChargingSpeedMode.dcFast;
  bool _isPreconditioning = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Range remaining
  double get _currentRangeKm => (_currentSoc / 100.0) * _maxRangeKm;

  // Time to target limit in minutes
  int get _minutesToTarget {
    if (_chargingMode.powerKw == 0.0 || _currentSoc >= _targetChargeLimit) {
      return 0;
    }
    final neededKwh =
        ((_targetChargeLimit - _currentSoc) / 100.0) * _batteryCapacityKwh;
    final hours = neededKwh / _chargingMode.powerKw;
    return (hours * 60).toInt();
  }

  Color get _socColor {
    if (_currentSoc < 20.0) return const Color(0xFFEF4444); // Red warning
    if (_currentSoc < 50.0) return const Color(0xFFF59E0B); // Amber
    if (_chargingMode != _ChargingSpeedMode.unplugged) {
      return const Color(0xFF10B981); // Emerald charging
    }
    return const Color(0xFF38BDF8); // Cyan normal
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                    color: _socColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.ev_station_rounded,
                    color: _socColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EV State-of-Charge & Hub',
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
                        '82 kWh Lithium-Ion Battery Telematics',
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
                    color: _chargingMode.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _chargingMode.color.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _chargingMode.icon,
                        size: 13,
                        color: _chargingMode.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _chargingMode == _ChargingSpeedMode.unplugged
                            ? 'DISCHARGING'
                            : 'CHARGING',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _chargingMode.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. RADIAL BATTERY ARC GAUGE CARD
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.0,
                colors:
                    isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF090D16)]
                        : [Colors.white, const Color(0xFFF1F5F9)],
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
                // Custom Painter Arc Gauge
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(260, 190),
                      painter: _EvRadialBatteryArcPainter(
                        soc: _currentSoc,
                        targetLimit: _targetChargeLimit,
                        socColor: _socColor,
                        isCharging:
                            _chargingMode != _ChargingSpeedMode.unplugged,
                        pulseValue: _pulseController.value,
                        isDark: isDark,
                      ),
                      child: SizedBox(
                        width: 260,
                        height: 190,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 14),
                            // Large SoC percentage text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_currentSoc.toInt()}',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.5,
                                    color:
                                        isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _socColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Range remaining badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.black45 : Colors.white)
                                    .withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      isDark ? Colors.white12 : Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.near_me_rounded,
                                    size: 13,
                                    color: _socColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${_currentRangeKm.toInt()} km tersisa',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Sub-Telematics Row (Power delivery & Time to Target)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Daya Pengisian',
                          '${_chargingMode.powerKw.toStringAsFixed(1)} kW',
                          Icons.bolt_rounded,
                          _chargingMode.color,
                          isDark,
                        ),
                      ),
                      _buildDivider(isDark),
                      Expanded(
                        child: _buildMetricItem(
                          'Estimasi Selesai',
                          _minutesToTarget > 0
                              ? '$_minutesToTarget Mnt'
                              : 'Selesai',
                          Icons.timelapse_rounded,
                          const Color(0xFF38BDF8),
                          isDark,
                        ),
                      ),
                      _buildDivider(isDark),
                      Expanded(
                        child: _buildMetricItem(
                          'Batas Target',
                          '${_targetChargeLimit.toInt()}%',
                          Icons.flag_rounded,
                          const Color(0xFFA855F7),
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. CHARGING SPEED SELECTOR PRESETS
          Text(
            'MODE PENGISIAN DAYA (CHARGER SOURCE)',
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
                  _ChargingSpeedMode.values.map((mode) {
                    final isSelected = _chargingMode == mode;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(mode.label),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _chargingMode = mode);
                          }
                        },
                        avatar: Icon(
                          mode.icon,
                          size: 16,
                          color: isSelected ? Colors.white : mode.color,
                        ),
                        selectedColor: mode.color,
                        backgroundColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
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

          const SizedBox(height: 16),

          // 4. INTERACTIVE CONTROLS (SOC & TARGET LIMIT SLIDERS)
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
              children: [
                // Current SoC Simulator Slider
                Row(
                  children: [
                    Icon(
                      Icons.battery_charging_full_rounded,
                      size: 18,
                      color: _socColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Simulasi Persentase Baterai (SoC)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentSoc.toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _socColor,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _currentSoc,
                  min: 5.0,
                  max: 100.0,
                  divisions: 19,
                  activeColor: _socColor,
                  onChanged: (val) {
                    setState(() => _currentSoc = val);
                  },
                ),

                const Divider(height: 16),

                // Target Charge Limit Slider
                Row(
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: Color(0xFFA855F7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Batas Target (Limit)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_targetChargeLimit.toInt()}% ${(_targetChargeLimit == 80.0) ? "(Harian)" : ""}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA855F7),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _targetChargeLimit,
                  min: 50.0,
                  max: 100.0,
                  divisions: 10,
                  activeColor: const Color(0xFFA855F7),
                  onChanged: (val) {
                    setState(() => _targetChargeLimit = val);
                  },
                ),

                const Divider(height: 16),

                // Battery Pre-conditioning Toggle Switch
                Row(
                  children: [
                    Icon(
                      Icons.thermostat_rounded,
                      size: 20,
                      color:
                          _isPreconditioning
                              ? const Color(0xFFEF4444)
                              : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Battery Pre-Conditioning',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Optimasi suhu sel baterai untuk fast charging',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isPreconditioning,
                      activeThumbColor: const Color(0xFFEF4444),
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        setState(() => _isPreconditioning = val);
                      },
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

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 22,
      color: isDark ? Colors.white12 : Colors.black12,
    );
  }
}

// -------------------------------------------------------------
// 240° RADIAL BATTERY ARC GAUGE PAINTER
// -------------------------------------------------------------
class _EvRadialBatteryArcPainter extends CustomPainter {
  final double soc;
  final double targetLimit;
  final Color socColor;
  final bool isCharging;
  final double pulseValue;
  final bool isDark;

  _EvRadialBatteryArcPainter({
    required this.soc,
    required this.targetLimit,
    required this.socColor,
    required this.isCharging,
    required this.pulseValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = size.width / 2 - 20;

    const startAngle = math.pi * 0.75; // 135 degrees
    const totalSweep = math.pi * 1.5; // 270 degrees total sweep

    // 1. Background Inactive Track Arc
    final bgPaint =
        Paint()
          ..color = (isDark ? Colors.white12 : Colors.black12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14.0
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      bgPaint,
    );

    // 2. Active SoC Progress Arc
    final currentSweep = (soc / 100.0).clamp(0.0, 1.0) * totalSweep;

    final activePaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: startAngle,
            endAngle: startAngle + totalSweep,
            colors: [socColor.withValues(alpha: 0.6), socColor],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14.0
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentSweep,
      false,
      activePaint,
    );

    // 3. Pulsing Glow when Charging
    if (isCharging) {
      final glowPaint =
          Paint()
            ..color = socColor.withValues(alpha: 0.15 + pulseValue * 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 22.0
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        currentSweep,
        false,
        glowPaint,
      );
    }

    // 4. Target Charge Limit Marker Needle / Dot
    final targetSweep = (targetLimit / 100.0).clamp(0.0, 1.0) * totalSweep;
    final targetAngle = startAngle + targetSweep;
    final markerX = center.dx + radius * math.cos(targetAngle);
    final markerY = center.dy + radius * math.sin(targetAngle);

    final markerPaint =
        Paint()
          ..color = const Color(0xFFA855F7)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(markerX, markerY), 6, markerPaint);

    final markerStroke =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(markerX, markerY), 6, markerStroke);
  }

  @override
  bool shouldRepaint(covariant _EvRadialBatteryArcPainter oldDelegate) => true;
}
