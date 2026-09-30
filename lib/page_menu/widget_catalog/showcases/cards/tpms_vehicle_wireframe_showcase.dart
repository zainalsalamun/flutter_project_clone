import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _TirePosition {
  frontLeft('Depan Kiri (FL)'),
  frontRight('Depan Kanan (FR)'),
  rearLeft('Belakang Kiri (RL)'),
  rearRight('Belakang Kanan (RR)');

  final String label;
  const _TirePosition(this.label);
}

class _TireData {
  final _TirePosition position;
  double pressurePsi;
  double tempCelsius;

  _TireData({
    required this.position,
    required this.pressurePsi,
    required this.tempCelsius,
  });

  Color get statusColor {
    if (pressurePsi < 25.0) return const Color(0xFFEF4444); // Critical Red
    if (pressurePsi < 31.0) return const Color(0xFFF59E0B); // Low Amber
    if (pressurePsi > 38.0) return const Color(0xFF38BDF8); // Overpressure Cyan
    return const Color(0xFF10B981); // Normal Emerald Green
  }

  String get statusText {
    if (pressurePsi < 25.0) return 'KRITIS';
    if (pressurePsi < 31.0) return 'KURANG';
    if (pressurePsi > 38.0) return 'TINGGI';
    return 'NORMAL';
  }
}

class TpmsVehicleWireframeShowcase extends StatefulWidget {
  const TpmsVehicleWireframeShowcase({super.key});

  @override
  State<TpmsVehicleWireframeShowcase> createState() =>
      _TpmsVehicleWireframeShowcaseState();
}

class _TpmsVehicleWireframeShowcaseState
    extends State<TpmsVehicleWireframeShowcase> {
  // 4 Tires
  late List<_TireData> _tires;
  _TirePosition _selectedTirePos = _TirePosition.frontLeft;

  // Telematics
  final double _frontAwdRatio = 45.0; // 45% Front / 55% Rear AWD split
  bool _useBarUnit = false; // PSI vs Bar

  @override
  void initState() {
    super.initState();
    _tires = [
      _TireData(
        position: _TirePosition.frontLeft,
        pressurePsi: 33.5,
        tempCelsius: 34.0,
      ),
      _TireData(
        position: _TirePosition.frontRight,
        pressurePsi: 33.8,
        tempCelsius: 35.0,
      ),
      _TireData(
        position: _TirePosition.rearLeft,
        pressurePsi: 28.2, // Simulated slightly low
        tempCelsius: 32.0,
      ),
      _TireData(
        position: _TirePosition.rearRight,
        pressurePsi: 34.0,
        tempCelsius: 33.0,
      ),
    ];
  }

  _TireData get _selectedTire =>
      _tires.firstWhere((t) => t.position == _selectedTirePos);

  String _formatPressure(double psi) {
    if (_useBarUnit) {
      final bar = psi * 0.0689476;
      return '${bar.toStringAsFixed(2)} Bar';
    }
    return '${psi.toStringAsFixed(1)} PSI';
  }

  void _simulatePuncture() {
    HapticFeedback.heavyImpact();
    setState(() {
      _selectedTire.pressurePsi = 22.0; // drops to hazard level
      _selectedTire.tempCelsius = 42.0; // friction heat
    });
  }

  void _resetPressures() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (final t in _tires) {
        t.pressurePsi = 33.5;
        t.tempCelsius = 32.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fl = _tires[0];
    final fr = _tires[1];
    final rl = _tires[2];
    final rr = _tires[3];

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
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Color(0xFF38BDF8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TPMS & Vehicle Diagnostics',
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
                        'Aero Chassis Blueprint & 4-Wheel Sensors',
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
                // Unit Switcher (PSI / Bar)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _useBarUnit = !_useBarUnit);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      _useBarUnit ? 'BAR' : 'PSI',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. VEHICLE WIREFRAME & 4-TIRE HUD BOARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0),
                radius: 0.9,
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
                // Top Row: Front-Left & Front-Right HUD Tiles
                Row(
                  children: [
                    Expanded(child: _buildTireHudCard(fl, isDark)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTireHudCard(fr, isDark)),
                  ],
                ),

                // Center: Top-Down Chassis Wireframe Blueprint
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _CarBlueprintPainter(
                      tires: _tires,
                      selectedPosition: _selectedTirePos,
                      isDark: isDark,
                    ),
                  ),
                ),

                // Bottom Row: Rear-Left & Rear-Right HUD Tiles
                Row(
                  children: [
                    Expanded(child: _buildTireHudCard(rl, isDark)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTireHudCard(rr, isDark)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. AWD TORQUE SPLIT VISUALIZER
          Container(
            padding: const EdgeInsets.all(14),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.all_inclusive_rounded,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'AWD Dual-Motor Torque Split',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'F: ${_frontAwdRatio.toInt()}% • R: ${(100 - _frontAwdRatio).toInt()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: _frontAwdRatio.toInt(),
                          child: Container(color: const Color(0xFF38BDF8)),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: (100 - _frontAwdRatio).toInt(),
                          child: Container(color: const Color(0xFFA855F7)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. INTERACTIVE PRESSURE ADJUSTER & LEAK SIMULATOR
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
                // Header of active selected tire
                Row(
                  children: [
                    Icon(
                      Icons.tire_repair_rounded,
                      size: 18,
                      color: _selectedTire.statusColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kalibrasi ${_selectedTire.position.label}',
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
                      _formatPressure(_selectedTire.pressurePsi),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _selectedTire.statusColor,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _selectedTire.pressurePsi,
                  min: 15.0,
                  max: 45.0,
                  divisions: 30,
                  activeColor: _selectedTire.statusColor,
                  onChanged: (val) {
                    setState(() {
                      _selectedTire.pressurePsi = val;
                    });
                  },
                ),

                const Divider(height: 16),

                // Action Buttons (Simulate Leak & Reset All)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.warning_amber_rounded, size: 16),
                        label: const Text(
                          'Simulasi Bocor',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _simulatePuncture,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.restart_alt_rounded, size: 16),
                        label: const Text(
                          'Reset Ideal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _resetPressures,
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

  Widget _buildTireHudCard(_TireData tire, bool isDark) {
    final isSelected = _selectedTirePos == tire.position;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedTirePos = tire.position);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? tire.statusColor.withValues(alpha: 0.15)
                  : (isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected
                    ? tire.statusColor
                    : (isDark ? Colors.white12 : Colors.black12),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tire.position.label.split(' ')[0], // e.g. Depan / Belakang
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: tire.statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tire.statusText,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: tire.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formatPressure(tire.pressurePsi),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: tire.statusColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.thermostat_rounded,
                  size: 11,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(width: 3),
                Text(
                  '${tire.tempCelsius.toStringAsFixed(0)}°C',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// TOP-DOWN CAR BLUEPRINT VECTOR PAINTER
// -------------------------------------------------------------
class _CarBlueprintPainter extends CustomPainter {
  final List<_TireData> tires;
  final _TirePosition selectedPosition;
  final bool isDark;

  _CarBlueprintPainter({
    required this.tires,
    required this.selectedPosition,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Vehicle dimensions
    const carWidth = 90.0;
    const carHeight = 150.0;

    final chassisPaint =
        Paint()
          ..color = (isDark ? Colors.white24 : Colors.black26)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // 1. Aerodynamic Chassis Outer Shell
    final chassisPath = Path();
    // Nose hood
    chassisPath.moveTo(center.dx - 28, center.dy - carHeight / 2);
    chassisPath.quadraticBezierTo(
      center.dx,
      center.dy - carHeight / 2 - 8,
      center.dx + 28,
      center.dy - carHeight / 2,
    );
    // Front right fender
    chassisPath.quadraticBezierTo(
      center.dx + carWidth / 2,
      center.dy - 35,
      center.dx + carWidth / 2,
      center.dy,
    );
    // Rear right fender & tail
    chassisPath.quadraticBezierTo(
      center.dx + carWidth / 2,
      center.dy + carHeight / 2 - 10,
      center.dx + 24,
      center.dy + carHeight / 2,
    );
    // Rear bumper
    chassisPath.lineTo(center.dx - 24, center.dy + carHeight / 2);
    // Rear left fender
    chassisPath.quadraticBezierTo(
      center.dx - carWidth / 2,
      center.dy + carHeight / 2 - 10,
      center.dx - carWidth / 2,
      center.dy,
    );
    // Front left fender
    chassisPath.quadraticBezierTo(
      center.dx - carWidth / 2,
      center.dy - 35,
      center.dx - 28,
      center.dy - carHeight / 2,
    );
    chassisPath.close();

    canvas.drawPath(chassisPath, chassisPaint);

    // 2. Windshield & Panoramic Glass Roof
    final glassPaint =
        Paint()
          ..color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
              .withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;

    final glassStroke =
        Paint()
          ..color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
              .withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    final roofRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 5),
        width: 44,
        height: 75,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(roofRect, glassPaint);
    canvas.drawRRect(roofRect, glassStroke);

    // 3. Front & Rear Axles
    final axlePaint =
        Paint()
          ..color = (isDark ? Colors.white12 : Colors.black12)
          ..strokeWidth = 2.0;
    canvas.drawLine(
      Offset(center.dx - carWidth / 2 - 8, center.dy - 45),
      Offset(center.dx + carWidth / 2 + 8, center.dy - 45),
      axlePaint,
    );
    canvas.drawLine(
      Offset(center.dx - carWidth / 2 - 8, center.dy + 45),
      Offset(center.dx + carWidth / 2 + 8, center.dy + 45),
      axlePaint,
    );

    // 4. Draw 4 Tires with Status Glow
    _drawTirePill(
      canvas,
      center.dx - carWidth / 2 - 4,
      center.dy - 45,
      tires[0],
      selectedPosition == _TirePosition.frontLeft,
    );
    _drawTirePill(
      canvas,
      center.dx + carWidth / 2 + 4,
      center.dy - 45,
      tires[1],
      selectedPosition == _TirePosition.frontRight,
    );
    _drawTirePill(
      canvas,
      center.dx - carWidth / 2 - 4,
      center.dy + 45,
      tires[2],
      selectedPosition == _TirePosition.rearLeft,
    );
    _drawTirePill(
      canvas,
      center.dx + carWidth / 2 + 4,
      center.dy + 45,
      tires[3],
      selectedPosition == _TirePosition.rearRight,
    );
  }

  void _drawTirePill(
    Canvas canvas,
    double cx,
    double cy,
    _TireData tire,
    bool isSelected,
  ) {
    const w = 12.0;
    const h = 28.0;

    // Glowing aura if selected or hazard
    if (isSelected || tire.pressurePsi < 25.0) {
      final glowPaint =
          Paint()
            ..color = tire.statusColor.withValues(alpha: 0.35)
            ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: w + 10,
            height: h + 10,
          ),
          const Radius.circular(8),
        ),
        glowPaint,
      );
    }

    // Tire Body
    final tirePaint =
        Paint()
          ..color = tire.statusColor
          ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
        const Radius.circular(4),
      ),
      tirePaint,
    );

    // Outer stroke
    final strokePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.0 : 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
        const Radius.circular(4),
      ),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CarBlueprintPainter oldDelegate) => true;
}
