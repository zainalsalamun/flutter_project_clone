import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/ai_dashboard_mock_data.dart';
import '../theme/ai_dashboard_theme.dart';

class ModelDistributionDonutChart extends StatefulWidget {
  const ModelDistributionDonutChart({super.key});

  @override
  State<ModelDistributionDonutChart> createState() =>
      _ModelDistributionDonutChartState();
}

class _ModelDistributionDonutChartState
    extends State<ModelDistributionDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final totalTokens = AiDashboardMockData.models.fold<int>(
      0,
      (sum, m) => sum + m.totalTokens,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AiDashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Model Share & Spend",
                style: TextStyle(
                  color: AiDashboardTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.pie_chart_outline_rounded,
                color: AiDashboardTheme.textSecondary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Distribution across connected LLM engines",
            style: TextStyle(color: AiDashboardTheme.textMuted, fontSize: 11.5),
          ),
          const SizedBox(height: 16),

          // Donut Chart with Center Text
          SizedBox(
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex =
                              pieTouchResponse
                                  .touchedSection!
                                  .touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 3,
                    centerSpaceRadius: 52,
                    sections:
                        AiDashboardMockData.models.asMap().entries.map((e) {
                          final i = e.key;
                          final m = e.value;
                          final isTouched = i == _touchedIndex;
                          final double radius = isTouched ? 24.0 : 18.0;
                          final percent = (m.totalTokens / totalTokens) * 100;

                          return PieChartSectionData(
                            color: m.color,
                            value: percent,
                            title: '',
                            radius: radius,
                          );
                        }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "TOTAL",
                      style: TextStyle(
                        color: AiDashboardTheme.textMuted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      "${(totalTokens / 1000000).toStringAsFixed(1)}M",
                      style: const TextStyle(
                        color: AiDashboardTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      "Tokens",
                      style: TextStyle(
                        color: AiDashboardTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Legend list with cost & share %
          ...AiDashboardMockData.models.map((m) {
            final percent = (m.totalTokens / totalTokens) * 100;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: m.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      m.name,
                      style: const TextStyle(
                        color: AiDashboardTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "${percent.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: AiDashboardTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "\$${m.cost.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
