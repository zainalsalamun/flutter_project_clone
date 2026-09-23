import 'package:flutter/material.dart';
import '../models/device_diagnostics_event.dart';
import '../theme/diagnostics_colors.dart';

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
              color: DiagnosticsColors.textSubtle,
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
                    ? DiagnosticsColors.success
                    : DiagnosticsColors.warning,
                title: "Battery Level",
                value: "${event.batteryLevel}%",
                subtitle: "${event.batteryState.toUpperCase()} • ${event.formattedBatteryTemp}",
                progress: (event.batteryLevel / 100.0).clamp(0.0, 1.0),
                progressColor: event.batteryLevel > 20
                    ? DiagnosticsColors.success
                    : DiagnosticsColors.danger,
                badgeText: event.batteryState == 'charging' ? "CHG" : null,
              ),
            ),
            const SizedBox(width: 8),

            // Sisa RAM Metric Tile
            Expanded(
              child: _MetricTile(
                icon: Icons.memory_rounded,
                iconColor: DiagnosticsColors.info,
                title: "Sisa RAM",
                value: event.formattedAvailableRam,
                subtitle: event.totalRamBytes > 0
                    ? "dari ${event.formattedTotalRam}"
                    : "Sys Memory",
                progress: event.ramFreeRatio,
                progressColor: DiagnosticsColors.info,
                badgeText: event.totalRamBytes > 0 ? "$freeRamPct% Sisa" : null,
              ),
            ),
            const SizedBox(width: 8),

            // Sisa Storage Metric Tile
            Expanded(
              child: _MetricTile(
                icon: Icons.storage_rounded,
                iconColor: DiagnosticsColors.pink,
                title: "Sisa Storage",
                value: event.formattedAvailableStorage,
                subtitle: event.totalStorageBytes > 0
                    ? "dari ${event.formattedTotalStorage}"
                    : "Flash Memory",
                progress: event.storageFreeRatio,
                progressColor: DiagnosticsColors.pink,
                badgeText: event.totalStorageBytes > 0 ? "$freeStoragePct% Sisa" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Comprehensive Thermal & Battery Health Diagnostics Card
        _BatteryThermalHealthCard(event: event),
        const SizedBox(height: 12),

        // Row 3: Comprehensive RAM & Storage Breakdown Detail Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: DiagnosticsColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: DiagnosticsColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
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
                      size: 16, color: DiagnosticsColors.primary),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "KAPASITAS MEMORI & PENYIMPANAN",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: DiagnosticsColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Storage Detail Section
              _CapacityBarSection(
                title: "Internal Storage (Penyimpanan HP)",
                icon: Icons.sd_storage_rounded,
                iconColor: DiagnosticsColors.pink,
                freeLabel: "Sisa Ruang",
                freeValue: event.formattedAvailableStorage,
                usedLabel: "Terpakai",
                usedValue: event.formattedUsedStorage,
                totalLabel: "Total Kapasitas",
                totalValue: event.formattedTotalStorage,
                usageRatio: event.storageUsageRatio,
                accentColor: DiagnosticsColors.pink,
              ),

              const Divider(height: 20, color: DiagnosticsColors.divider),

              // RAM Detail Section
              _CapacityBarSection(
                title: "RAM (Random Access Memory)",
                icon: Icons.developer_board_rounded,
                iconColor: DiagnosticsColors.info,
                freeLabel: "Sisa RAM Bebas",
                freeValue: event.formattedAvailableRam,
                usedLabel: "RAM Terpakai",
                usedValue: event.formattedUsedRam,
                totalLabel: "Total RAM",
                totalValue: event.formattedTotalRam,
                usageRatio: event.ramUsageRatio,
                accentColor: DiagnosticsColors.info,
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
        color: DiagnosticsColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DiagnosticsColors.border),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
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
                      color: iconColor.withValues(alpha: 0.12),
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
                color: DiagnosticsColors.textPrimary,
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
              color: DiagnosticsColors.textSubtle,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: DiagnosticsColors.surface,
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
              color: DiagnosticsColors.textMuted,
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
            Expanded(
              child: Row(
                children: [
                  Icon(icon, size: 14, color: iconColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: DiagnosticsColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                "$usedPct% terpakai",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
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
                  child: Container(color: DiagnosticsColors.success),
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
                dotColor: DiagnosticsColors.success,
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
                dotColor: DiagnosticsColors.textMuted,
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
                  color: DiagnosticsColors.textSubtle,
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
            color: DiagnosticsColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BatteryThermalHealthCard extends StatelessWidget {
  final DeviceDiagnosticsEvent event;

  const _BatteryThermalHealthCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final temp = event.temperatureCelsius;
    final Color thermalColor;
    final String thermalBadge;
    final IconData thermalIcon;

    if (temp < 37.0) {
      thermalColor = DiagnosticsColors.success;
      thermalBadge = "NORMAL";
      thermalIcon = Icons.thermostat_rounded;
    } else if (temp < 42.0) {
      thermalColor = DiagnosticsColors.warning;
      thermalBadge = "HANGAT";
      thermalIcon = Icons.thermostat_rounded;
    } else {
      thermalColor = DiagnosticsColors.danger;
      thermalBadge = "OVERHEAT";
      thermalIcon = Icons.local_fire_department_rounded;
    }

    final thermalProgress = ((temp - 20.0) / (55.0 - 20.0)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DiagnosticsColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: temp >= 42.0
              ? DiagnosticsColors.danger.withValues(alpha: 0.3)
              : DiagnosticsColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: thermalColor.withValues(alpha: 0.03),
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
              Expanded(
                child: Row(
                  children: [
                    Icon(thermalIcon, size: 16, color: thermalColor),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        "SUHU BATERAI & KESEHATAN",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: DiagnosticsColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: thermalColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: thermalColor.withValues(alpha: 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: thermalColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "$thermalBadge (${event.formattedBatteryTemp})",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: thermalColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3-Column Diagnostic Stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Suhu Sensor
              Expanded(
                child: _ThermalInfoTile(
                  icon: Icons.device_thermostat_rounded,
                  iconColor: thermalColor,
                  label: "Suhu Baterai",
                  value: event.formattedBatteryTemp,
                  subtitle: "Status: ${event.batteryTempStatus}",
                  progress: thermalProgress,
                  progressColor: thermalColor,
                ),
              ),
              const SizedBox(width: 8),

              // 2. Battery Health & Tech
              Expanded(
                child: _ThermalInfoTile(
                  icon: Icons.health_and_safety_rounded,
                  iconColor: DiagnosticsColors.primary,
                  label: "Kesehatan Baterai",
                  value: event.batteryHealth.toUpperCase(),
                  subtitle: "${event.batteryTechnology} • ${event.formattedVoltage}",
                  progress: 1.0,
                  progressColor: DiagnosticsColors.primary,
                ),
              ),
              const SizedBox(width: 8),

              // 3. Power Save Mode
              Expanded(
                child: _ThermalInfoTile(
                  icon: event.isPowerSaveMode
                      ? Icons.eco_rounded
                      : Icons.battery_charging_full_rounded,
                  iconColor: event.isPowerSaveMode
                      ? DiagnosticsColors.success
                      : DiagnosticsColors.textSubtle,
                  label: "Mode Hemat Daya",
                  value: event.isPowerSaveMode ? "Aktif" : "Nonaktif",
                  subtitle: event.isPowerSaveMode ? "Power Saver ON" : "Normal Mode",
                  progress: event.isPowerSaveMode ? 1.0 : 0.0,
                  progressColor: DiagnosticsColors.success,
                ),
              ),
            ],
          ),

          // Power Save Mode Warning Notice Banner if Active
          if (event.isPowerSaveMode) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: DiagnosticsColors.successBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: DiagnosticsColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.eco_rounded, size: 14, color: DiagnosticsColors.successDark),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Mode Hemat Daya Aktif: Sistem Android mungkin membatasi aktivitas latar belakang & sinkronisasi data.",
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThermalInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;
  final double progress;
  final Color progressColor;

  const _ThermalInfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: DiagnosticsColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DiagnosticsColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.0,
                    color: DiagnosticsColors.textSubtle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: DiagnosticsColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 8.5,
              color: DiagnosticsColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: DiagnosticsColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 3.5,
            ),
          ),
        ],
      ),
    );
  }
}
