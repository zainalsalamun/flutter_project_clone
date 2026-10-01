import 'package:flutter/material.dart';
import '../data/ai_dashboard_mock_data.dart';
import '../theme/ai_dashboard_theme.dart';

class GlobalRegionLatencyGrid extends StatelessWidget {
  const GlobalRegionLatencyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AiDashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Global Edge Cluster Latency",
                    style: TextStyle(
                      color: AiDashboardTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Live multi-region gateway routing & telemetry",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AiDashboardTheme.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AiDashboardTheme.success.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_tethering_rounded,
                      color: AiDashboardTheme.success,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Global CDN Sync",
                      style: TextStyle(
                        color: AiDashboardTheme.success,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2x2 Grid of Regions
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AiDashboardMockData.regions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final reg = AiDashboardMockData.regions[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AiDashboardTheme.surfaceElevated.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AiDashboardTheme.borderLight.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Text(reg.countryFlag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  reg.locationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AiDashboardTheme.textPrimary,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: reg.statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${reg.pingMs} ms",
                                style: TextStyle(
                                  color:
                                      reg.pingMs < 100
                                          ? AiDashboardTheme.success
                                          : AiDashboardTheme.warning,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "${reg.throughputRps.toStringAsFixed(0)} rps",
                                style: const TextStyle(
                                  color: AiDashboardTheme.textMuted,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
