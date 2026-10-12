import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HydrationWaterIntakeTrackerShowcase extends StatefulWidget {
  const HydrationWaterIntakeTrackerShowcase({super.key});

  @override
  State<HydrationWaterIntakeTrackerShowcase> createState() =>
      _HydrationWaterIntakeTrackerShowcaseState();
}

class _WaterLog {
  final String id;
  final int amountMl;
  final String time;
  final String label;

  _WaterLog({
    required this.id,
    required this.amountMl,
    required this.time,
    required this.label,
  });
}

class _HydrationWaterIntakeTrackerShowcaseState
    extends State<HydrationWaterIntakeTrackerShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  final int _targetIntakeMl = 2500;
  int _currentIntakeMl = 1250;

  final List<_WaterLog> _logs = [
    _WaterLog(
      id: '1',
      amountMl: 250,
      time: '07:30',
      label: 'Segelas Air Hangat',
    ),
    _WaterLog(
      id: '2',
      amountMl: 500,
      time: '09:15',
      label: 'Botol Olahraga Pagi',
    ),
    _WaterLog(
      id: '3',
      amountMl: 500,
      time: '12:45',
      label: 'Setelah Makan Siang',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _addIntake(int amount, String label) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentIntakeMl += amount;
      final now = DateTime.now();
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _logs.insert(
        0,
        _WaterLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amountMl: amount,
          time: timeStr,
          label: label,
        ),
      );
    });
  }

  void _removeLog(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      final index = _logs.indexWhere((l) => l.id == id);
      if (index != -1) {
        _currentIntakeMl = math.max(
          0,
          _currentIntakeMl - _logs[index].amountMl,
        );
        _logs.removeAt(index);
      }
    });
  }

  void _resetIntake() {
    setState(() {
      _currentIntakeMl = 0;
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIntakeMl / _targetIntakeMl).clamp(0.0, 1.5);
    final remainingMl = math.max(0, _targetIntakeMl - _currentIntakeMl);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // GLASS WATER BOTTLE CONTAINER WITH WAVE PAINTER
          Center(
            child: Container(
              width: 170,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFFE0F2FE),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(37),
                child: Stack(
                  children: [
                    // Dynamic Sine Wave Water Fill
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(170, 250),
                          painter: _WaterWavePainter(
                            waveProgress: _waveController.value,
                            fillProgress: math.min(progress, 1.0),
                            waterColor: const Color(0xFF38BDF8),
                          ),
                        );
                      },
                    ),

                    // Centered Text Details Overlay
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color:
                                  isDark
                                      ? Colors.white
                                      : const Color(0xFF0369A1),
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_currentIntakeMl / $_targetIntakeMl ml',
                            style: TextStyle(
                              color:
                                  isDark
                                      ? Colors.white70
                                      : const Color(0xFF075985),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // REMAINING INTAKE SUBTITLE
          Text(
            remainingMl > 0
                ? ' Butuh $remainingMl ml lagi untuk mencapai target harian!'
                : ' Luar biasa! Target hidrasi 2500 ml hari ini telah tercapai!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  remainingMl > 0
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF10B981),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          // QUICK ADD WATER BUTTONS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildQuickAddBtn(250, ' 250 ml', 'Gelas', isDark),
              _buildQuickAddBtn(500, ' 500 ml', 'Botol', isDark),
              _buildQuickAddBtn(750, ' 750 ml', 'Tumbler', isDark),
              _buildQuickAddBtn(1000, ' 1000 ml', 'Besar', isDark),
            ],
          ),

          const SizedBox(height: 20),

          // DRINK TIMELINE / LOGS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
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
                    Text(
                      'Riwayat Minum Hari Ini:',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                      onPressed: _resetIntake,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_logs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Belum ada catatan asupan air.',
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  ..._logs.take(4).map((log) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF38BDF8,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.water_drop_rounded,
                              color: Color(0xFF38BDF8),
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.label,
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  log.time,
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? Colors.white38
                                            : Colors.black38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+${log.amountMl} ml',
                            style: const TextStyle(
                              color: Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _removeLog(log.id),
                            child: Icon(
                              Icons.close_rounded,
                              color: isDark ? Colors.white38 : Colors.black38,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddBtn(
    int amount,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => _addIntake(amount, subtitle),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Water Bottle Wave
// -------------------------------------------------------------
class _WaterWavePainter extends CustomPainter {
  final double waveProgress;
  final double fillProgress;
  final Color waterColor;

  _WaterWavePainter({
    required this.waveProgress,
    required this.fillProgress,
    required this.waterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (fillProgress <= 0.0) return;

    final waterHeight = size.height * fillProgress;
    final baseHeight = size.height - waterHeight;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    const waveCount = 1.5;
    const waveHeight = 6.0;

    for (double x = 0; x <= size.width; x++) {
      final y =
          baseHeight +
          math.sin(
                (x / size.width * waveCount * 2 * math.pi) +
                    (waveProgress * 2 * math.pi),
              ) *
              waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [waterColor.withValues(alpha: 0.8), waterColor],
          ).createShader(Rect.fromLTWH(0, baseHeight, size.width, waterHeight))
          ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaterWavePainter oldDelegate) =>
      oldDelegate.waveProgress != waveProgress ||
      oldDelegate.fillProgress != fillProgress;
}
