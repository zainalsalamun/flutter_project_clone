import 'package:flutter/material.dart';
import '../models/display_and_sensors_data.dart';

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
                    Icon(Icons.screenshot_monitor_rounded,
                        size: 18, color: Color(0xFF0284C7)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "DISPLAY & SCREEN SPECIFICATIONS",
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
                  color: isHighRefresh
                      ? const Color(0xFF10B981).withValues(alpha: 0.12)
                      : const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  displaySpecs.formattedRefreshRate,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isHighRefresh
                        ? const Color(0xFF10B981)
                        : const Color(0xFF0284C7),
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
                    ? [const Color(0xFFECFDF5), const Color(0xFFF0FDF4)]
                    : [const Color(0xFFF0F9FF), const Color(0xFFF8FAFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isHighRefresh
                    ? const Color(0xFFA7F3D0)
                    : const Color(0xFFBAE6FD),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: isHighRefresh
                        ? const Color(0xFF10B981)
                        : const Color(0xFF0284C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.speed_rounded,
                      color: Colors.white, size: 18),
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
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF0369A1),
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (isHighRefresh)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "HIGH REFRESH",
                                style: TextStyle(
                                  color: Colors.white,
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
                              ? const Color(0xFF047857).withValues(alpha: 0.9)
                              : const Color(0xFF64748B),
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
          const Divider(height: 16, color: Color(0xFFF1F5F9)),

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
          const Divider(height: 16, color: Color(0xFFF1F5F9)),

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
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
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
