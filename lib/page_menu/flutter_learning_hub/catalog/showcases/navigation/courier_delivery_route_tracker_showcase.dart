import 'package:flutter/material.dart';

class CourierDeliveryRouteTrackerShowcase extends StatefulWidget {
  const CourierDeliveryRouteTrackerShowcase({super.key});

  @override
  State<CourierDeliveryRouteTrackerShowcase> createState() =>
      _CourierDeliveryRouteTrackerShowcaseState();
}

class _CourierDeliveryRouteTrackerShowcaseState
    extends State<CourierDeliveryRouteTrackerShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _routeAnimController;
  late Animation<double> _routeProgressAnimation;

  // Active step in the order pipeline (0 to 3)
  int _activeStep =
      2; // 0: Confirmed, 1: Picked Up, 2: On The Way, 3: Delivered
  double _animSpeedMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _routeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _routeProgressAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _routeAnimController, curve: Curves.easeInOut),
    )..addListener(() {
      final progress = _routeProgressAnimation.value;
      if (progress > 0.85 && _activeStep != 3) {
        setState(() => _activeStep = 3);
      } else if (progress <= 0.85 && _activeStep == 3) {
        setState(() => _activeStep = 2);
      }
    });

    _routeAnimController.repeat(reverse: false);
  }

  @override
  void dispose() {
    _routeAnimController.dispose();
    super.dispose();
  }

  void _setSpeed(double speed) {
    setState(() {
      _animSpeedMultiplier = speed;
      _routeAnimController.duration = Duration(
        milliseconds: (8000 / speed).round(),
      );
      if (_routeAnimController.isAnimating) {
        _routeAnimController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.two_wheeler_rounded,
                    color: Color(0xFF10B981),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Courier Route Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Peta rute kurir dinamis berbasis kurva Bezier dengan animasi pergerakan motor dan estimasi waktu tiba (ETA).',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LIVE MAP CANVAS
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  // 1. VECTOR ROADMAP & ANIMATED ROUTE PATH
                  AnimatedBuilder(
                    animation: _routeProgressAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, 250),
                        painter: _RoadmapPainter(
                          progress: _routeProgressAnimation.value,
                          accentColor: const Color(0xFF10B981),
                        ),
                      );
                    },
                  ),

                  // 2. MERCHANT START BADGE (TOP LEFT)
                  Positioned(
                    top: 24,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 6),
                          Text(
                            'Kopi Kenangan Senopati',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. DESTINATION END BADGE (BOTTOM RIGHT)
                  Positioned(
                    bottom: 24,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEF4444)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 6),
                          Text(
                            'Sudirman Tower Lt. 18',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. LIVE ETA PILL (TOP RIGHT)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: Colors.black,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'ETA 12 Menit',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
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

          const SizedBox(height: 18),

          // MILESTONE PROGRESS STEPPER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Pengiriman:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildStepItem(
                      0,
                      'Dikonfirmasi',
                      Icons.receipt_long_rounded,
                    ),
                    _buildStepDivider(0),
                    _buildStepItem(1, 'Disiapkan', Icons.soup_kitchen_rounded),
                    _buildStepDivider(1),
                    _buildStepItem(2, 'Diantar', Icons.two_wheeler_rounded),
                    _buildStepDivider(2),
                    _buildStepItem(3, 'Tiba', Icons.home_rounded),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // DRIVER PROFILE & CALL ACTIONS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    border: Border.all(
                      color: const Color(0xFF10B981),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text('', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Budi Santoso',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '⭐ 4.9',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Honda Vario • B 4128 NAL',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  tooltip: 'Hubungi Telepon',
                  icon: const Icon(
                    Icons.phone_rounded,
                    color: Color(0xFF10B981),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF10B981,
                    ).withValues(alpha: 0.15),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () {},
                  tooltip: 'Kirim Pesan',
                  icon: const Icon(
                    Icons.chat_bubble_rounded,
                    color: Color(0xFF38BDF8),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF38BDF8,
                    ).withValues(alpha: 0.15),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SPEED CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Kecepatan Simulasi:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 10),
              ...[1.0, 2.0, 4.0].map((spd) {
                final isSel = _animSpeedMultiplier == spd;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text('${spd.toInt()}x'),
                    selected: isSel,
                    onSelected: (val) {
                      if (val) _setSpeed(spd);
                    },
                    selectedColor: const Color(0xFF10B981),
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSel ? Colors.black : Colors.white70,
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepIndex, String title, IconData icon) {
    final isDone = stepIndex < _activeStep;
    final isCurrent = stepIndex == _activeStep;

    Color stepColor = Colors.grey;
    if (isDone || isCurrent) stepColor = const Color(0xFF10B981);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                (isDone || isCurrent)
                    ? const Color(0xFF10B981)
                    : const Color(0xFF334155),
            boxShadow:
                isCurrent
                    ? [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                    : null,
          ),
          child: Icon(
            isDone ? Icons.check_rounded : icon,
            color: (isDone || isCurrent) ? Colors.black : Colors.white60,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: stepColor,
            fontSize: 10,
            fontWeight:
                (isDone || isCurrent) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(int stepIndex) {
    final isPassed = stepIndex < _activeStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: isPassed ? const Color(0xFF10B981) : Colors.white12,
      ),
    );
  }
}

class _RoadmapPainter extends CustomPainter {
  final double progress;
  final Color accentColor;

  _RoadmapPainter({required this.progress, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw subtle grid streets in background
    final gridPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.04)
          ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Define Bezier S-Curve Delivery Path
    final path =
        Path()
          ..moveTo(size.width * 0.15, size.height * 0.28)
          ..cubicTo(
            size.width * 0.50,
            size.height * 0.15,
            size.width * 0.35,
            size.height * 0.85,
            size.width * 0.85,
            size.height * 0.72,
          );

    // Inactive Grey Road Track
    final roadPaint =
        Paint()
          ..color = const Color(0xFF334155)
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
    canvas.drawPath(path, roadPaint);

    // Dashed center lane
    final dashPaint =
        Paint()
          ..color = Colors.white24
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
    canvas.drawPath(path, dashPaint);

    // 3. Active Colored Passed Road Segment
    final pathMetrics = path.computeMetrics().first;
    final currentDistance = pathMetrics.length * progress;
    final extractedPath = pathMetrics.extractPath(0, currentDistance);

    final activeRoadPaint =
        Paint()
          ..color = accentColor
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
    canvas.drawPath(extractedPath, activeRoadPaint);

    // 4. Start & End Markers
    final startOffset = Offset(size.width * 0.15, size.height * 0.28);
    final endOffset = Offset(size.width * 0.85, size.height * 0.72);

    // Start Pin (Amber)
    canvas.drawCircle(startOffset, 8, Paint()..color = const Color(0xFFF59E0B));
    canvas.drawCircle(startOffset, 4, Paint()..color = Colors.white);

    // End Pin (Red)
    canvas.drawCircle(endOffset, 8, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(endOffset, 4, Paint()..color = Colors.white);

    // 5. Courier Position & Radar Ripple
    final tangent = pathMetrics.getTangentForOffset(currentDistance);
    if (tangent != null) {
      final courierPos = tangent.position;

      // Radar Ripple Pulse Halo
      final ripplePaint =
          Paint()
            ..color = accentColor.withValues(alpha: 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(courierPos, 18, ripplePaint);

      // Courier Point
      final courierPaint = Paint()..color = Colors.white;
      canvas.drawCircle(courierPos, 7, Paint()..color = accentColor);
      canvas.drawCircle(courierPos, 4, courierPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
