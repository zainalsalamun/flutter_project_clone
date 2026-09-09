import 'package:flutter/material.dart';
import '../../models/smart_device_model.dart';
import '../../theme/lumina_theme.dart';

class AcDetailModal extends StatefulWidget {
  final SmartDeviceModel device;
  final VoidCallback onUpdate;

  const AcDetailModal({
    super.key,
    required this.device,
    required this.onUpdate,
  });

  @override
  State<AcDetailModal> createState() => _AcDetailModalState();
}

class _AcDetailModalState extends State<AcDetailModal> {
  final List<String> _modes = ['Cool', 'Eco', 'Dry', 'Turbo'];
  final List<String> _fanSpeeds = ['Quiet', 'Low', 'Med', 'Auto'];

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

          // Temperature Dial Stepper
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.cardBackground,
                borderRadius: BorderRadius.circular(24),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: theme.primaryText, size: 32),
                    onPressed: () {
                      if (widget.device.targetTemperature > 16.0) {
                        setState(() {
                          widget.device.targetTemperature -= 1.0;
                        });
                        widget.onUpdate();
                      }
                    },
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text(
                        '${widget.device.targetTemperature.toInt()}°C',
                        style: TextStyle(
                          color: widget.device.activeColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Target Temperature',
                        style: TextStyle(color: theme.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: theme.primaryText, size: 32),
                    onPressed: () {
                      if (widget.device.targetTemperature < 30.0) {
                        setState(() {
                          widget.device.targetTemperature += 1.0;
                        });
                        widget.onUpdate();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Modes Selection
          Text(
            'Operation Mode',
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _modes.map((mode) {
              final isSelected = widget.device.acMode == mode;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.device.acMode = mode;
                      });
                      widget.onUpdate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? widget.device.activeColor : theme.pillBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          mode,
                          style: TextStyle(
                            color: isSelected ? Colors.white : theme.secondaryText,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Fan Speed Selection
          Text(
            'Fan Speed',
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _fanSpeeds.map((speed) {
              final isSelected = widget.device.fanSpeed == speed;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.device.fanSpeed = speed;
                      });
                      widget.onUpdate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (theme.isDark ? Colors.white : const Color(0xFF0F172A))
                            : theme.pillBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          speed,
                          style: TextStyle(
                            color: isSelected 
                                ? (theme.isDark ? Colors.black : Colors.white)
                                : theme.secondaryText,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
