import 'package:flutter/material.dart';

class StatusPillBadgeShowcase extends StatelessWidget {
  const StatusPillBadgeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: const [
          PulsingStatusBadge(
            label: 'System Online',
            color: Color(0xFF10B981),
            isPulsing: true,
          ),
          PulsingStatusBadge(
            label: 'Live Broadcast',
            color: Color(0xFFEF4444),
            isPulsing: true,
          ),
          PulsingStatusBadge(
            label: 'Maintenance',
            color: Color(0xFFF59E0B),
            isPulsing: false,
          ),
          PulsingStatusBadge(
            label: 'Offline Standby',
            color: Color(0xFF64748B),
            isPulsing: false,
          ),
        ],
      ),
    );
  }
}

class PulsingStatusBadge extends StatefulWidget {
  final String label;
  final Color color;
  final bool isPulsing;

  const PulsingStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.isPulsing = true,
  });

  @override
  State<PulsingStatusBadge> createState() => _PulsingStatusBadgeState();
}

class _PulsingStatusBadgeState extends State<PulsingStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.isPulsing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PulsingStatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isPulsing && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child:
                widget.isPulsing
                    ? AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.0 + (_controller.value * 0.8),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.color.withValues(
                                    alpha: (1.0 - _controller.value) * 0.6,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.color,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                    : Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color,
                      ),
                    ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
