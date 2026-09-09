import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/smart_device_model.dart';
import '../theme/lumina_theme.dart';
import 'modals/light_detail_modal.dart';
import 'modals/ac_detail_modal.dart';
import 'modals/tv_detail_modal.dart';
import 'modals/router_detail_modal.dart';

class SmartDeviceCard extends StatefulWidget {
  final SmartDeviceModel device;
  final VoidCallback onToggle;
  final VoidCallback onUpdate;

  const SmartDeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    required this.onUpdate,
  });

  @override
  State<SmartDeviceCard> createState() => _SmartDeviceCardState();
}

class _SmartDeviceCardState extends State<SmartDeviceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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

  void _openDetailModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        switch (widget.device.type) {
          case DeviceType.light:
            return LightDetailModal(
              device: widget.device,
              onUpdate: () {
                setState(() {});
                widget.onUpdate();
              },
            );
          case DeviceType.ac:
            return AcDetailModal(
              device: widget.device,
              onUpdate: () {
                setState(() {});
                widget.onUpdate();
              },
            );
          case DeviceType.tv:
            return TvDetailModal(
              device: widget.device,
              onUpdate: () {
                setState(() {});
                widget.onUpdate();
              },
            );
          case DeviceType.router:
            return RouterDetailModal(
              device: widget.device,
              onUpdate: () {
                setState(() {});
                widget.onUpdate();
              },
            );
          default:
            return LightDetailModal(
              device: widget.device,
              onUpdate: () {
                setState(() {});
                widget.onUpdate();
              },
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LuminaThemeScope.of(context).colors;
    final bool isPowered = widget.device.isPoweredOn;
    final Color cardActiveColor = widget.device.type == DeviceType.light
        ? widget.device.lightColor
        : widget.device.activeColor;

    // Dynamic contrast calculation for light/pastel backgrounds
    final bool isLightBg = isPowered && cardActiveColor.computeLuminance() > 0.55;
    final Color primaryTextColor = isPowered
        ? (isLightBg ? const Color(0xFF0F172A) : Colors.white)
        : theme.primaryText;
    final Color secondaryTextColor = isPowered
        ? (isLightBg ? const Color(0xFF475569) : Colors.white.withOpacity(0.85))
        : theme.secondaryText;
    final Color iconColor = isPowered
        ? (isLightBg ? const Color(0xFF0F172A) : Colors.white)
        : theme.inactiveIcon;
    final Color moreIconColor = isPowered
        ? (isLightBg ? const Color(0xFF475569) : Colors.white70)
        : theme.inactiveIcon;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onToggle();
      },
      onTapCancel: () => _controller.reverse(),
      onLongPress: _openDetailModal,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPowered ? cardActiveColor : theme.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPowered ? Colors.transparent : theme.cardBorder,
              width: 1,
            ),
            boxShadow: isPowered
                ? [
                    BoxShadow(
                      color: cardActiveColor.withOpacity(isLightBg ? 0.25 : 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Device Icon + Switch / Detail Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _openDetailModal,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isPowered
                            ? Colors.black.withOpacity(isLightBg ? 0.08 : 0.15)
                            : (theme.isDark ? Colors.black26 : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.device.icon,
                        size: 24,
                        color: iconColor,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openDetailModal,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isPowered
                                ? (isLightBg ? Colors.black.withOpacity(0.08) : Colors.white.withOpacity(0.2))
                                : (theme.isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            size: 16,
                            color: moreIconColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: isPowered,
                          onChanged: (val) => widget.onToggle(),
                          activeTrackColor: isLightBg 
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(0.35),
                          inactiveTrackColor: theme.isDark 
                              ? Colors.black.withOpacity(0.25)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Bottom Column: Device Title + Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.device.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPowered ? _getDynamicSubtitle() : 'Off',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryTextColor,
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

  String _getDynamicSubtitle() {
    switch (widget.device.type) {
      case DeviceType.light:
        return '${widget.device.brightness.toInt()}% Brightness';
      case DeviceType.ac:
        return '${widget.device.targetTemperature.toInt()}°C • ${widget.device.acMode}';
      case DeviceType.tv:
        return '${widget.device.activeSource} • Vol ${widget.device.volume}%';
      case DeviceType.router:
        return '${widget.device.connectedClients} Connected';
      default:
        return widget.device.subtitle;
    }
  }
}
