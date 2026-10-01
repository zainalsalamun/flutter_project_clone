import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/ai_dashboard_mock_data.dart';
import '../theme/ai_dashboard_theme.dart';

class LlmTokenUsageChart extends StatefulWidget {
  const LlmTokenUsageChart({super.key});

  @override
  State<LlmTokenUsageChart> createState() => _LlmTokenUsageChartState();
}

class _LlmTokenUsageChartState extends State<LlmTokenUsageChart> {
  bool _showClaude = true;
  bool _showGpt = true;
  bool _showGemini = true;
  String _timeRange = '24H'; // '24H', '7D', '30D'

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AiDashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title & Model Filter Pills & Time Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LLM Token Burn Rate",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AiDashboardTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Real-time token consumption across inference pipelines (Millions/hr)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AiDashboardTheme.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Time Range Selector
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AiDashboardTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children:
                      ['24H', '7D', '30D'].map((range) {
                        final isSel = _timeRange == range;
                        return InkWell(
                          onTap: () => setState(() => _timeRange = range),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSel
                                      ? AiDashboardTheme.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              range,
                              style: TextStyle(
                                color:
                                    isSel
                                        ? Colors.white
                                        : AiDashboardTheme.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Filter toggles (Claude, GPT, Gemini)
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildModelToggle(
                "Claude 3.5 Sonnet",
                const Color(0xFFD97706),
                _showClaude,
                () => setState(() => _showClaude = !_showClaude),
              ),
              _buildModelToggle(
                "GPT-4o",
                const Color(0xFF10B981),
                _showGpt,
                () => setState(() => _showGpt = !_showGpt),
              ),
              _buildModelToggle(
                "Gemini 1.5 Pro",
                const Color(0xFF3B82F6),
                _showGemini,
                () => setState(() => _showGemini = !_showGemini),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Chart Area
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 4,
                  getDrawingHorizontalLine:
                      (value) => FlLine(
                        color: AiDashboardTheme.borderLight.withOpacity(0.4),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 4,
                      getTitlesWidget: (val, meta) {
                        return Text(
                          "${val.toInt()}M",
                          style: const TextStyle(
                            color: AiDashboardTheme.textMuted,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        final index = val.toInt();
                        if (index >= 0 &&
                            index <
                                AiDashboardMockData.timeSeriesHourly.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              AiDashboardMockData
                                  .timeSeriesHourly[index]
                                  .timeLabel,
                              style: const TextStyle(
                                color: AiDashboardTheme.textMuted,
                                fontSize: 10.5,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX:
                    (AiDashboardMockData.timeSeriesHourly.length - 1)
                        .toDouble(),
                minY: 0,
                maxY: 16,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor:
                        (touchedSpot) => AiDashboardTheme.surfaceElevated,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isClaudeSpot =
                            spot.bar.color == const Color(0xFFD97706);
                        final isGptSpot =
                            spot.bar.color == const Color(0xFF10B981);
                        final name =
                            isClaudeSpot
                                ? "Claude 3.5"
                                : isGptSpot
                                ? "GPT-4o"
                                : "Gemini 1.5";
                        return LineTooltipItem(
                          "$name: ${spot.y.toStringAsFixed(1)}M tokens",
                          TextStyle(
                            color: spot.bar.color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  if (_showClaude)
                    _buildLineBar(
                      spots:
                          AiDashboardMockData.timeSeriesHourly
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value.claudeTokens,
                                ),
                              )
                              .toList(),
                      color: const Color(0xFFD97706),
                    ),
                  if (_showGpt)
                    _buildLineBar(
                      spots:
                          AiDashboardMockData.timeSeriesHourly
                              .asMap()
                              .entries
                              .map(
                                (e) =>
                                    FlSpot(e.key.toDouble(), e.value.gptTokens),
                              )
                              .toList(),
                      color: const Color(0xFF10B981),
                    ),
                  if (_showGemini)
                    _buildLineBar(
                      spots:
                          AiDashboardMockData.timeSeriesHourly
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value.geminiTokens,
                                ),
                              )
                              .toList(),
                      color: const Color(0xFF3B82F6),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLineBar({
    required List<FlSpot> spots,
    required Color color,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 2.8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter:
            (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 3.5,
              color: color,
              strokeWidth: 2,
              strokeColor: AiDashboardTheme.surface,
            ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.22), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildModelToggle(
    String label,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : AiDashboardTheme.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? color : AiDashboardTheme.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color:
                    isActive
                        ? AiDashboardTheme.textPrimary
                        : AiDashboardTheme.textMuted,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
