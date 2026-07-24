import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmartDeviceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool initialPowerState;
  final Color activeColor;

  const SmartDeviceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.initialPowerState = false,
    this.activeColor = const Color(0xFFF59E0B), // Default Amber
  });

  @override
  State<SmartDeviceCard> createState() => _SmartDeviceCardState();
}

class _SmartDeviceCardState extends State<SmartDeviceCard>
    with SingleTickerProviderStateMixin {
  late bool isPoweredOn;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isPoweredOn = widget.initialPowerState;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePower() {
    setState(() {
      isPoweredOn = !isPoweredOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _togglePower();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPoweredOn ? widget.activeColor : const Color(0xFF2A2D3A),
            borderRadius: BorderRadius.circular(24),
            boxShadow:
                isPoweredOn
                    ? [
                      BoxShadow(
                        color: widget.activeColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                    : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    widget.icon,
                    size: 32,
                    color: isPoweredOn ? Colors.white : Colors.white54,
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: isPoweredOn,
                      onChanged: (val) => _togglePower(),
                      activeTrackColor: Colors.white.withOpacity(0.3),
                      inactiveTrackColor: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: isPoweredOn ? Colors.white : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: isPoweredOn ? Colors.white70 : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
