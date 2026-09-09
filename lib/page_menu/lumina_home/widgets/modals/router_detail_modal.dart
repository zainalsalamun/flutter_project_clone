import 'package:flutter/material.dart';
import '../../models/smart_device_model.dart';
import '../../theme/lumina_theme.dart';

class RouterDetailModal extends StatefulWidget {
  final SmartDeviceModel device;
  final VoidCallback onUpdate;

  const RouterDetailModal({
    super.key,
    required this.device,
    required this.onUpdate,
  });

  @override
  State<RouterDetailModal> createState() => _RouterDetailModalState();
}

class _RouterDetailModalState extends State<RouterDetailModal> {
  bool _isGuestWifiEnabled = true;

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
                        'Wi-Fi 6 Mesh Network',
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

          // Bandwidth Statistics
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardBackground,
                    borderRadius: BorderRadius.circular(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_downward, color: widget.device.activeColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Download',
                            style: TextStyle(color: theme.secondaryText, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.device.downloadSpeed} Mbps',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardBackground,
                    borderRadius: BorderRadius.circular(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Color(0xFF38BDF8), size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Upload',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.device.uploadSpeed} Mbps',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Connected Devices List
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardBackground,
              borderRadius: BorderRadius.circular(20),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Connected Clients',
                      style: TextStyle(color: theme.primaryText, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.device.activeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.device.connectedClients} Online',
                        style: TextStyle(
                          color: widget.device.activeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: theme.cardBorder, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Guest Wi-Fi (Lumina_Guest)',
                      style: TextStyle(color: theme.secondaryText, fontSize: 13),
                    ),
                    Switch(
                      value: _isGuestWifiEnabled,
                      activeThumbColor: widget.device.activeColor,
                      onChanged: (val) {
                        setState(() {
                          _isGuestWifiEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Reboot Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Rebooting Lumina Mesh Router...'),
                    backgroundColor: theme.cardBackground,
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.restart_alt, size: 20),
              label: const Text('Reboot Gateway'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.pillBackground,
                foregroundColor: theme.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.cardBorder),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
