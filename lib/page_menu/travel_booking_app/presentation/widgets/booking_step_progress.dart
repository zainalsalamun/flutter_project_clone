import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';

class BookingStepProgress extends StatelessWidget {
  final int currentStep; // 0: Jadwal, 1: Data Penumpang, 2: Pembayaran, 3: E-Ticket
  final ValueChanged<int>? onStepTapped;

  const BookingStepProgress({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  static const List<String> stepLabels = [
    'Jadwal & Kamar',
    'Data Penumpang',
    'Pembayaran',
    'E-Ticket',
  ];

  static const List<IconData> stepIcons = [
    Icons.calendar_month_rounded,
    Icons.person_pin_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.airplane_ticket_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final stepCount = stepLabels.length;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Custom Painter connecting line
              Positioned(
                top: 18,
                left: 20,
                right: 20,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  tween: Tween<double>(
                    begin: 0,
                    end: (currentStep / (stepCount - 1)).clamp(0.0, 1.0),
                  ),
                  builder: (context, progress, child) {
                    return CustomPaint(
                      size: Size(totalWidth - 40, 4),
                      painter: _StepConnectorLinePainter(progress: progress),
                    );
                  },
                ),
              ),

              // Step Nodes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(stepCount, (index) {
                  final isDone = index < currentStep;
                  final isActive = index == currentStep;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (onStepTapped != null && index <= currentStep) {
                          onStepTapped!(index);
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            width: isActive ? 38 : 34,
                            height: isActive ? 38 : 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? TravelTheme.emerald
                                  : isActive
                                      ? TravelTheme.primary
                                      : TravelTheme.surface,
                              border: Border.all(
                                color: isActive
                                    ? TravelTheme.primaryLight
                                    : isDone
                                        ? TravelTheme.emerald
                                        : TravelTheme.border,
                                width: isActive ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isActive
                                      ? TravelTheme.primary.withValues(alpha: 0.35)
                                      : (isDone
                                          ? TravelTheme.emerald.withValues(alpha: 0.25)
                                          : Colors.transparent),
                                  blurRadius: isActive ? 10 : (isDone ? 8 : 0),
                                  offset: isActive
                                      ? const Offset(0, 4)
                                      : (isDone ? const Offset(0, 2) : Offset.zero),
                                ),
                              ],
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : Icon(
                                      stepIcons[index],
                                      color: isActive ? Colors.white : TravelTheme.muted,
                                      size: isActive ? 18 : 16,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive || isDone ? FontWeight.w700 : FontWeight.w500,
                              color: isActive
                                  ? TravelTheme.primary
                                  : isDone
                                      ? TravelTheme.emerald
                                      : TravelTheme.muted,
                            ),
                            child: Text(
                              stepLabels[index],
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepConnectorLinePainter extends CustomPainter {
  final double progress;

  _StepConnectorLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = TravelTheme.border
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw background track
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      bgPaint,
    );

    if (progress > 0) {
      final activePaint = Paint()
        ..shader = const LinearGradient(
          colors: [TravelTheme.emerald, TravelTheme.primaryLight],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width * progress, size.height / 2),
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StepConnectorLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
