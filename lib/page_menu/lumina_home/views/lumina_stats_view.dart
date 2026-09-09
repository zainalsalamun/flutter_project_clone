import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';

class LuminaStatsView extends StatefulWidget {
  const LuminaStatsView({super.key});

  @override
  State<LuminaStatsView> createState() => _LuminaStatsViewState();
}

class _LuminaStatsViewState extends State<LuminaStatsView> {
  int _selectedPeriodIndex = 0; // 0: Weekly, 1: Monthly

  final List<double> _weeklyUsage = [12.4, 15.2, 14.8, 18.6, 16.2, 21.4, 19.8];
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final theme = LuminaThemeScope.of(context).colors;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Energy Analytics',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Power consumption & eco insights',
                        style: TextStyle(color: theme.secondaryText, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.cardBorder),
                      boxShadow: [
                        if (!theme.isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Eco Mode ON',
                          style: TextStyle(
                            color: Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Summary Hero Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total This Week',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '118.4 kWh',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.trending_down, color: Color(0xFF86EFAC), size: 16),
                              SizedBox(width: 4),
                              Text(
                                '-14.2%',
                                style: TextStyle(
                                  color: Color(0xFF86EFAC),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Cost: Rp 168.500', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('Efficiency Score: 92/100', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Period Toggle & Chart Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Consumption',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.pillBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _buildPeriodButton('Week', 0),
                        _buildPeriodButton('Month', 1),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Custom Bar Chart Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(_weeklyUsage.length, (index) {
                          final value = _weeklyUsage[index];
                          final maxVal = _weeklyUsage.reduce((a, b) => a > b ? a : b);
                          final heightFactor = value / maxVal;
                          final isPeak = value == maxVal;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  color: isPeak ? const Color(0xFFF59E0B) : theme.secondaryText,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 22,
                                height: 110 * heightFactor,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isPeak
                                        ? [const Color(0xFFF59E0B), const Color(0xFFF97316)]
                                        : [const Color(0xFF38BDF8), const Color(0xFF0284C7)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isPeak
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFF59E0B).withOpacity(0.4),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : [],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _days[index],
                                style: TextStyle(
                                  color: isPeak ? theme.primaryText : theme.secondaryText,
                                  fontSize: 11,
                                  fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Breakdown Section
              Text(
                'Usage Breakdown by Category',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _buildCategoryRow('Air Conditioner (AC)', '54%', const Color(0xFF3B82F6), Icons.ac_unit, theme),
              _buildCategoryRow('Smart Lighting', '22%', const Color(0xFFF59E0B), Icons.lightbulb_outline, theme),
              _buildCategoryRow('Entertainment (TV/Audio)', '14%', const Color(0xFF8B5CF6), Icons.tv, theme),
              _buildCategoryRow('Network & IoT Sensors', '10%', const Color(0xFF10B981), Icons.router, theme),

              const SizedBox(height: 24),

              // Eco Tip Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.energy_savings_leaf_outlined, color: Color(0xFF10B981), size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Eco Saving Recommendation',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Setting AC temperature to 24°C during night hours can save up to 18% energy.',
                            style: TextStyle(color: theme.isDark ? Colors.white70 : const Color(0xFF334155), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String text, int index) {
    final isSelected = _selectedPeriodIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriodIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF59E0B) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String title, String percent, Color color, IconData icon, LuminaThemeColors theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          if (!theme.isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(color: theme.primaryText, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            percent,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
