import 'package:flutter/material.dart';
import '../models/display_and_sensors_data.dart';

class SensorsCatalogCard extends StatelessWidget {
  final SensorsCatalogData sensorsCatalog;

  const SensorsCatalogCard({
    super.key,
    required this.sensorsCatalog,
  });

  @override
  Widget build(BuildContext context) {
    final items = sensorsCatalog.checklist;
    final availableCount = sensorsCatalog.availableSensorsCount;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.sensors_rounded,
                        size: 18, color: Color(0xFF0284C7)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "HARDWARE SENSORS CHECKLIST",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sensorsCatalog.totalSensorsCount > 0
                      ? "${sensorsCatalog.totalSensorsCount} Sensor"
                      : "$availableCount/8 Terdeteksi",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Pemeriksaan ketersediaan modul sensor fisik yang tertanam pada motherboard perangkat.",
            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF64748B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          // 2-Column Grid of 8 Sensor Items
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.65,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _SensorTile(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _SensorTile extends StatelessWidget {
  final SensorChecklistItem item;

  const _SensorTile({required this.item});

  IconData _getIcon(String key) {
    switch (key) {
      case "gyroscope":
        return Icons.screen_rotation_rounded;
      case "accelerometer":
        return Icons.vibration_rounded;
      case "magnetometer":
        return Icons.explore_rounded;
      case "proximity":
        return Icons.contactless_rounded;
      case "light":
        return Icons.light_mode_rounded;
      case "barometer":
        return Icons.compress_rounded;
      case "step_counter":
        return Icons.directions_walk_rounded;
      case "gravity":
        return Icons.public_rounded;
      default:
        return Icons.sensors_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAvail = item.isAvailable;
    final primaryColor =
        isAvail ? const Color(0xFF10B981) : const Color(0xFF94A3B8);
    final bgColor =
        isAvail ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC);
    final borderColor =
        isAvail ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(_getIcon(item.keyName),
                    size: 13, color: primaryColor),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isAvail
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : const Color(0xFF94A3B8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAvail
                          ? Icons.check_circle_rounded
                          : Icons.cancel_outlined,
                      size: 9,
                      color: isAvail
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isAvail ? "Tersedia" : "Tidak Ada",
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        color: isAvail
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.hardwareName.isNotEmpty
                    ? item.hardwareName
                    : item.typeDescription,
                style: TextStyle(
                  fontSize: 8.0,
                  color: const Color(0xFF64748B),
                  fontWeight: item.hardwareName.isNotEmpty
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
