import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../theme/lumina_theme.dart';

class RoomThermostatCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onToggleMasterPower;
  final VoidCallback onIncreaseTemp;
  final VoidCallback onDecreaseTemp;

  const RoomThermostatCard({
    super.key,
    required this.room,
    required this.onToggleMasterPower,
    required this.onIncreaseTemp,
    required this.onDecreaseTemp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LuminaThemeScope.of(context).colors;

    // Gradient adapts to temperature when powered ON
    final bool isCool = room.temperature < 23.0;
    final List<Color> gradientColors = room.isMasterPowered
        ? (isCool
            ? const [Color(0xFF0284C7), Color(0xFF06B6D4)] // Cool Blue-Cyan
            : const [Color(0xFFF59E0B), Color(0xFFF97316)]) // Warm Amber-Orange
        : (theme.isDark
            ? const [Color(0xFF334155), Color(0xFF1E293B)] // Off/Muted Dark Slate
            : const [Color(0xFF94A3B8), Color(0xFF64748B)]); // Off Light Slate

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: room.isMasterPowered
            ? [
                BoxShadow(
                  color: gradientColors.first.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                if (!theme.isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
      ),
      child: Column(
        children: [
          // Top Row: Room title + Master Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room.devices.where((d) => d.isPoweredOn).length} of ${room.devices.length} devices active',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onToggleMasterPower,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(room.isMasterPowered ? 0.25 : 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(room.isMasterPowered ? 0.4 : 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: room.isMasterPowered ? Colors.white : Colors.white70,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 18),

          // Bottom Row: Temperature Adjustment + Humidity + Power KWh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Temperature Stepper
              Row(
                children: [
                  GestureDetector(
                    onTap: onDecreaseTemp,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${room.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onIncreaseTemp,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),

              // Humidity & Power usage
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop_outlined, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${room.humidity}% Humidity',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.bolt, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${room.powerUsageKwh} kWh / hr',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
