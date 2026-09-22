import 'package:flutter/material.dart';
import '../models/device_diagnostics_event.dart';

class MetricsOverviewCard extends StatelessWidget {
  final DeviceDiagnosticsEvent event;

  const MetricsOverviewCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final freeRamPct = (event.ramFreeRatio * 100).toStringAsFixed(0);
    final freeStoragePct = (event.storageFreeRatio * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            "HARDWARE METRICS & TELEMETRY",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Row 1: 3 Quick Metric Overview Tiles
        Row(
          children: [
            // Battery Metric Tile
            Expanded(
              child: _MetricTile(
                icon: event.batteryState == 'charging'
                    ? Icons.battery_charging_full_rounded
                    : Icons.battery_std_rounded,
                iconColor: event.batteryState == 'charging'
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B),
                title: "Battery Level",
                value: "${event.batteryLevel}%",
                subtitle: event.batteryState.toUpperCase(),
                progress: (event.batteryLevel / 100.0).clamp(0.0, 1.0),
                progressColor: event.batteryLevel > 20
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                badgeText: event.batteryState == 'charging' ? "CHG" : null,
              ),
            ),
            const SizedBox(width: 8),

            // Sisa RAM Metric Tile
            Expanded(
              child: _MetricTile(
                icon: Icons.memory_rounded,
                iconColor: const Color(0xFF6366F1),
                title: "Sisa RAM",
                value: event.formattedAvailableRam,
                subtitle: event.totalRamBytes > 0
                    ? "dari ${event.formattedTotalRam}"
                    : "Sys Memory",
                progress: event.ramFreeRatio,
                progressColor: const Color(0xFF6366F1),
                badgeText: event.totalRamBytes > 0 ? "$freeRamPct% Sisa" : null,
              ),
            ),
            const SizedBox(width: 8),

            // Sisa Storage Metric Tile
            Expanded(
              child: _MetricTile(
                icon: Icons.storage_rounded,
                iconColor: const Color(0xFFEC4899),
                title: "Sisa Storage",
                value: event.formattedAvailableStorage,
                subtitle: event.totalStorageBytes > 0
                    ? "dari ${event.formattedTotalStorage}"
                    : "Flash Memory",
                progress: event.storageFreeRatio,
                progressColor: const Color(0xFFEC4899),
                badgeText: event.totalStorageBytes > 0 ? "$freeStoragePct% Sisa" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Comprehensive RAM & Storage Breakdown Detail Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Icon(Icons.pie_chart_outline_rounded,
                      size: 16, color: Color(0xFF0284C7)),
                  SizedBox(width: 6),
                  Text(
                    "KAPASITAS MEMORI & PENYIMPANAN",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Storage Detail Section
              _CapacityBarSection(
                title: "Internal Storage (Penyimpanan HP)",
                icon: Icons.sd_storage_rounded,
                iconColor: const Color(0xFFEC4899),
                freeLabel: "Sisa Ruang",
                freeValue: event.formattedAvailableStorage,
                usedLabel: "Terpakai",
                usedValue: event.formattedUsedStorage,
                totalLabel: "Total Kapasitas",
                totalValue: event.formattedTotalStorage,
                usageRatio: event.storageUsageRatio,
                accentColor: const Color(0xFFEC4899),
              ),

              const Divider(height: 20, color: Color(0xFFF1F5F9)),

              // RAM Detail Section
              _CapacityBarSection(
                title: "RAM (Random Access Memory)",
                icon: Icons.developer_board_rounded,
                iconColor: const Color(0xFF6366F1),
                freeLabel: "Sisa RAM Bebas",
                freeValue: event.formattedAvailableRam,
                usedLabel: "RAM Terpakai",
                usedValue: event.formattedUsedRam,
                totalLabel: "Total RAM",
                totalValue: event.formattedTotalRam,
                usageRatio: event.ramUsageRatio,
                accentColor: const Color(0xFF6366F1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;
  final double progress;
  final Color progressColor;
  final String? badgeText;

  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.progressColor,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (badgeText != null)
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 8.5,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CapacityBarSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String freeLabel;
  final String freeValue;
  final String usedLabel;
  final String usedValue;
  final String totalLabel;
  final String totalValue;
  final double usageRatio;
  final Color accentColor;

  const _CapacityBarSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.freeLabel,
    required this.freeValue,
    required this.usedLabel,
    required this.usedValue,
    required this.totalLabel,
    required this.totalValue,
    required this.usageRatio,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final usedPct = (usageRatio * 100).clamp(0, 100).toStringAsFixed(1);
    final freePct = ((1.0 - usageRatio) * 100).clamp(0, 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Text(
              "$usedPct% terpakai",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Multi-segment Visual Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 7,
            child: Row(
              children: [
                Expanded(
                  flex: ((usageRatio * 1000).toInt()).clamp(1, 1000),
                  child: Container(color: accentColor),
                ),
                Expanded(
                  flex: (((1.0 - usageRatio) * 1000).toInt()).clamp(1, 1000),
                  child: Container(color: const Color(0xFF10B981)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 3-Column Stats (Sisa, Terpakai, Total)
        Row(
          children: [
            // Sisa / Free
            Expanded(
              child: _MiniStat(
                dotColor: const Color(0xFF10B981),
                label: freeLabel,
                value: freeValue,
                subValue: "$freePct%",
              ),
            ),
            // Terpakai / Used
            Expanded(
              child: _MiniStat(
                dotColor: accentColor,
                label: usedLabel,
                value: usedValue,
                subValue: "$usedPct%",
              ),
            ),
            // Total
            Expanded(
              child: _MiniStat(
                dotColor: const Color(0xFF94A3B8),
                label: totalLabel,
                value: totalValue,
                subValue: "100%",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String value;
  final String subValue;

  const _MiniStat({
    required this.dotColor,
    required this.label,
    required this.value,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
