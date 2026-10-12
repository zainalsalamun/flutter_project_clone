import 'dart:math' as math;
import 'package:flutter/material.dart';

class DayNightSwitchShowcase extends StatefulWidget {
  const DayNightSwitchShowcase({super.key});

  @override
  State<DayNightSwitchShowcase> createState() => _DayNightSwitchShowcaseState();
}

class _DayNightSwitchShowcaseState extends State<DayNightSwitchShowcase> {
  bool _isNight = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isNight ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isNight ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isNight ? 'Night Mode Active ' : 'Day Mode Active ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: _isNight ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the switch below to toggle theme state',
              style: TextStyle(
                fontSize: 12,
                color: _isNight ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            DayNightSwitch(
              isNight: _isNight,
              onChanged: (val) {
                setState(() => _isNight = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DayNightSwitch extends StatefulWidget {
  final bool isNight;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;

  const DayNightSwitch({
    super.key,
    required this.isNight,
    required this.onChanged,
    this.width = 110,
    this.height = 54,
  });

  @override
  State<DayNightSwitch> createState() => _DayNightSwitchState();
}

class _DayNightSwitchState extends State<DayNightSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: widget.isNight ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
  }

  @override
  void didUpdateWidget(covariant DayNightSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isNight != oldWidget.isNight) {
      if (widget.isNight) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbSize = widget.height - 8;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isNight);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final progress = _animation.value;

          // Background sky interpolation (Day Blue -> Night Deep Navy)
          final skyColor =
              Color.lerp(
                const Color(0xFF38BDF8), // Day sky blue
                const Color(0xFF1E1B4B), // Night deep navy
                progress,
              )!;

          return Container(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: skyColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: skyColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Day Clouds
                Positioned(
                  right: 10,
                  top: 10,
                  child: Opacity(
                    opacity: (1.0 - progress * 1.5).clamp(0.0, 1.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_rounded,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.cloud_rounded,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),

                // Night Twinkling Stars
                Positioned(
                  left: 14,
                  top: 8,
                  child: Opacity(
                    opacity: ((progress - 0.3) * 1.5).clamp(0.0, 1.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Colors.amber.shade200,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.star_rounded,
                          size: 8,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sliding Celestial Thumb (Sun <-> Moon)
                Positioned(
                  left: progress * (widget.width - thumbSize - 8),
                  top: 0,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: progress * math.pi,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors:
                              progress > 0.5
                                  ? [
                                    const Color(0xFFF1F5F9),
                                    const Color(0xFFCBD5E1),
                                  ]
                                  : [
                                    const Color(0xFFFDE047),
                                    const Color(0xFFF59E0B),
                                  ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                progress > 0.5
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.amber.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (progress > 0.5) ...[
                            // Moon Craters
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400.withValues(
                                    alpha: 0.7,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400.withValues(
                                    alpha: 0.7,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ] else ...[
                            // Sun Core
                            const Icon(
                              Icons.wb_sunny_rounded,
                              size: 20,
                              color: Colors.white70,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
