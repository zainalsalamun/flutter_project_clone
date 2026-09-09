import 'package:flutter/material.dart';
import '../../models/smart_device_model.dart';
import '../../theme/lumina_theme.dart';

class LightDetailModal extends StatefulWidget {
  final SmartDeviceModel device;
  final VoidCallback onUpdate;

  const LightDetailModal({
    super.key,
    required this.device,
    required this.onUpdate,
  });

  @override
  State<LightDetailModal> createState() => _LightDetailModalState();
}

class _LightDetailModalState extends State<LightDetailModal> {
  final List<Color> _presetColors = const [
    Color(0xFFF59E0B), // Warm Amber
    Color(0xFFFEF3C7), // Warm White
    Color(0xFFE0F2FE), // Cool White
    Color(0xFF38BDF8), // Sky Blue
    Color(0xFFA855F7), // Cyber Purple
    Color(0xFFEC4899), // Pink Sunset
  ];

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
                      color: widget.device.lightColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.device.icon,
                      color: widget.device.lightColor,
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
                activeThumbColor: widget.device.lightColor,
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

          // Brightness Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Brightness Level',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.device.brightness.toInt()}%',
                style: TextStyle(
                  color: widget.device.lightColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.device.lightColor,
              inactiveTrackColor: theme.cardBorder,
              thumbColor: theme.isDark ? Colors.white : const Color(0xFF0F172A),
              overlayColor: widget.device.lightColor.withOpacity(0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: widget.device.brightness,
              min: 0,
              max: 100,
              onChanged: (val) {
                setState(() {
                  widget.device.brightness = val;
                  if (val > 0 && !widget.device.isPoweredOn) {
                    widget.device.isPoweredOn = true;
                  }
                });
                widget.onUpdate();
              },
            ),
          ),

          const SizedBox(height: 20),

          // Color Temperature & Presets
          Text(
            'Ambient Color Presets',
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _presetColors.map((color) {
              final isSelected = widget.device.lightColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    widget.device.lightColor = color;
                  });
                  widget.onUpdate();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? (theme.isDark ? Colors.white : const Color(0xFF0F172A)) : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.black, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.timer_outlined, size: 18),
                  label: const Text('Set Timer (1h)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryText,
                    side: BorderSide(color: theme.cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.done, size: 18),
                  label: const Text('Save Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.device.lightColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
