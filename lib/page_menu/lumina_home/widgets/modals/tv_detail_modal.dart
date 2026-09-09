import 'package:flutter/material.dart';
import '../../models/smart_device_model.dart';
import '../../theme/lumina_theme.dart';

class TvDetailModal extends StatefulWidget {
  final SmartDeviceModel device;
  final VoidCallback onUpdate;

  const TvDetailModal({
    super.key,
    required this.device,
    required this.onUpdate,
  });

  @override
  State<TvDetailModal> createState() => _TvDetailModalState();
}

class _TvDetailModalState extends State<TvDetailModal> {
  final List<String> _sources = ['Netflix', 'YouTube', 'Spotify', 'HDMI 1', 'Apple TV'];

  @override
  Widget build(BuildContext context) {
    final theme = LuminaThemeScope.of(context).colors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.modalBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.secondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.device.activeColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.device.icon,
                      color: widget.device.activeColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.device.title,
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.device.subtitle,
                        style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: widget.device.isPoweredOn,
                activeThumbColor: widget.device.activeColor,
                onChanged: (val) {
                  setState(() {
                    widget.device.isPoweredOn = val;
                  });
                  widget.onUpdate();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Input Source Selector
          Text(
            'Input Source / Application',
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _sources.map((source) {
                final isSelected = widget.device.activeSource == source;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.device.activeSource = source;
                      });
                      widget.onUpdate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? widget.device.activeColor : theme.pillBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        source,
                        style: TextStyle(
                          color: isSelected ? Colors.white : theme.secondaryText,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Volume Control Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.device.isMuted ? Icons.volume_off : Icons.volume_up,
                      color: widget.device.isMuted ? Colors.redAccent : theme.secondaryText,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.device.isMuted = !widget.device.isMuted;
                      });
                      widget.onUpdate();
                    },
                  ),
                  Text(
                    widget.device.isMuted ? 'Muted' : 'Volume Level',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.device.isMuted ? 0 : widget.device.volume}%',
                style: TextStyle(
                  color: widget.device.activeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.device.activeColor,
              inactiveTrackColor: theme.cardBorder,
              thumbColor: theme.isDark ? Colors.white : const Color(0xFF0F172A),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: widget.device.isMuted ? 0 : widget.device.volume.toDouble(),
              min: 0,
              max: 100,
              onChanged: (val) {
                setState(() {
                  widget.device.volume = val.toInt();
                  if (widget.device.isMuted && val > 0) {
                    widget.device.isMuted = false;
                  }
                });
                widget.onUpdate();
              },
            ),
          ),

          const SizedBox(height: 16),

          // Directional Pad / Navigation
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: theme.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: theme.cardBorder),
                boxShadow: [
                  if (!theme.isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 4,
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_up, color: theme.primaryText),
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_down, color: theme.primaryText),
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    left: 4,
                    child: IconButton(
                      icon: Icon(Icons.arrow_left, color: theme.primaryText),
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    right: 4,
                    child: IconButton(
                      icon: Icon(Icons.arrow_right, color: theme.primaryText),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.device.activeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
