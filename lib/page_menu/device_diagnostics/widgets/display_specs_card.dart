import 'package:flutter/material.dart';
import '../models/display_and_sensors_data.dart';
import '../theme/diagnostics_colors.dart';

class DisplaySpecsCard extends StatelessWidget {
  final DisplaySpecsData displaySpecs;

  const DisplaySpecsCard({
    super.key,
    required this.displaySpecs,
  });

  @override
  Widget build(BuildContext context) {
    final isHighRefresh = displaySpecs.refreshRate >= 90;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DiagnosticsColors.cardBg,
        borderRadius: BorderRadius.circular(20),
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.screenshot_monitor_rounded,
                        size: 18, color: DiagnosticsColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "DISPLAY & SCREEN SPECIFICATIONS",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
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
                    color: isHighRefresh
                        ? DiagnosticsColors.success.withValues(alpha: 0.12)
                        : DiagnosticsColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    displaySpecs.formattedRefreshRate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isHighRefresh
                          ? DiagnosticsColors.success
                          : DiagnosticsColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Refresh Rate Highlight Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isHighRefresh
                    ? [DiagnosticsColors.successBg, const Color(0xFFECFDF5)]
                    : [DiagnosticsColors.primaryBg, DiagnosticsColors.surfaceSubtle],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isHighRefresh
                    ? DiagnosticsColors.successBorder
                    : DiagnosticsColors.primaryBorder,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: isHighRefresh
                        ? DiagnosticsColors.success
                        : DiagnosticsColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.speed_rounded,
                      color: DiagnosticsColors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            displaySpecs.refreshRateCategory,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: isHighRefresh
                                  ? DiagnosticsColors.successDark
                                  : DiagnosticsColors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (isHighRefresh)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: DiagnosticsColors.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "HIGH REFRESH",
                                style: TextStyle(
                                  color: DiagnosticsColors.white,
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Supported Modes: ${displaySpecs.supportedRefreshRates.map((r) => '$r Hz').join(', ')}",
                        style: TextStyle(
                          fontSize: 10,
                          color: isHighRefresh
                              ? DiagnosticsColors.successDark.withValues(alpha: 0.9)
                              : DiagnosticsColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2-Column Grid of Screen Specs
          // Row 1: Resolution & Density DPI
          Row(
            children: [
              Expanded(
                child: _DisplaySpecItem(
                  icon: Icons.aspect_ratio_rounded,
                  label: "Resolusi Layar (Px)",
                  value: displaySpecs.resolutionString,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DisplaySpecItem(
                  icon: Icons.density_medium_rounded,
                  label: "Screen Density (DPI)",
                  value: displaySpecs.densityDpiString,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: DiagnosticsColors.divider),

          // Row 2: Aspect Ratio & Diagonal Size
          Row(
            children: [
              Expanded(
                child: _DisplaySpecItem(
                  icon: Icons.crop_portrait_rounded,
                  label: "Rasio Aspek Layar",
                  value: displaySpecs.aspectRatioString,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DisplaySpecItem(
                  icon: Icons.straighten_rounded,
                  label: "Estimasi Ukuran Fisik",
                  value: displaySpecs.screenDiagonalInches,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: DiagnosticsColors.divider),

          // Row 3: Pixel Scale & HDR Status
          Row(
            children: [
              Expanded(
                child: _DisplaySpecItem(
                  icon: Icons.zoom_in_rounded,
                  label: "Device Pixel Ratio",
                  value: displaySpecs.scaleString,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DisplaySpecItem(
                  icon: displaySpecs.isHdr
                      ? Icons.hdr_on_rounded
                      : Icons.hdr_off_rounded,
                  label: "Dukungan HDR Display",
                  value: displaySpecs.isHdr ? "HDR10 / Wide Gamut" : "SDR Display",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DisplaySpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DisplaySpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: DiagnosticsColors.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: DiagnosticsColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: DiagnosticsColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
