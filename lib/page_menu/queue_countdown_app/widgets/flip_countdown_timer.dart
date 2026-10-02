import 'package:flutter/material.dart';

/// Animated Countdown Timer widget with live second ticking, smooth digit slide transitions, and pulsing colon.
class FlipCountdownTimer extends StatelessWidget {
  final int totalSeconds;
  final bool? forceHours; // null = auto detect (Menit:Detik when < 1h)
  final VoidCallback? onTap;

  const FlipCountdownTimer({
    super.key,
    required this.totalSeconds,
    this.forceHours,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    // Determine if we should show Hours:Minutes or Minutes:Seconds
    final bool isHoursMode = forceHours ?? (totalSeconds >= 3600);

    final primaryVal = isHoursMode ? hours : minutes;
    final secondaryVal = isHoursMode ? minutes : seconds;

    final primaryLabel = isHoursMode ? "Jam" : "Menit";
    final secondaryLabel = isHoursMode ? "Menit" : "Detik";

    final primaryStr = primaryVal.toString().padLeft(2, '0');
    final secondaryStr = secondaryVal.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Box (Jam / Menit)
          _buildTimeBox(
            value: primaryStr,
            label: primaryLabel,
            isTicking: false,
          ),

          // Separator Colon (":")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                height: 1.0,
              ),
            ),
          ),

          // Right Box (Menit / Detik)
          _buildTimeBox(
            value: secondaryStr,
            label: secondaryLabel,
            isTicking: !isHoursMode,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox({
    required String value,
    required String label,
    required bool isTicking,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rounded Card Box
        Container(
          width: 62,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF2563EB), // Sleek Royal Blue Border
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, -0.35),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              value,
              key: ValueKey<String>("$label-$value"),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Label ("Jam", "Menit", "Detik")
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
