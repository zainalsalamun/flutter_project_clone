import 'package:flutter/material.dart';
import '../../core/aura_colors.dart';
import '../../core/aura_typography.dart';
import '../../models/habit_metric.dart';
import '../../widgets/weekly_calendar_strip.dart';
import '../../widgets/sleep_bar_chart_card.dart';

class AuraHabitAnalyticsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AuraHabitAnalyticsScreen({
    super.key,
    this.onBack,
  });

  @override
  State<AuraHabitAnalyticsScreen> createState() => _AuraHabitAnalyticsScreenState();
}

class _AuraHabitAnalyticsScreenState extends State<AuraHabitAnalyticsScreen> {
  int _selectedDay = 3; // Wednesday (Rab)

  final List<DailySleepRecord> _sleepRecords = const [
    DailySleepRecord(dayName: 'M', hours: 7.2),
    DailySleepRecord(dayName: 'S', hours: 6.8),
    DailySleepRecord(dayName: 'S', hours: 8.0),
    DailySleepRecord(dayName: 'R', hours: 8.5, isHighlight: true),
    DailySleepRecord(dayName: 'K', hours: 7.0),
    DailySleepRecord(dayName: 'J', hours: 7.5),
    DailySleepRecord(dayName: 'S', hours: 8.2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.canvas,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AuraColors.gradientStart,
              AuraColors.gradientMid,
              AuraColors.canvas,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.25, 0.55],
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // Top Bar
              _buildTopBar(),
              const SizedBox(height: 16),

              // Streak Celebration Card
              _buildStreakCard(),
              const SizedBox(height: 18),

              // Weekly Calendar Timeline Strip
              WeeklyCalendarStrip(
                selectedDayIndex: _selectedDay,
                onDaySelected: (idx) {
                  setState(() {
                    _selectedDay = idx;
                  });
                },
              ),
              const SizedBox(height: 18),

              // Two Analytics Cards (Sleep & Workout)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SleepBarChartCard(records: _sleepRecords),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: WorkoutRadialCard(
                      progress: 0.75,
                      hoursToday: "3 Jam Hari Ini",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Habit Detailed Breakdown
              _buildDetailedBreakdown(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AuraColors.textPrimary,
        ),
        Text(
          "Pelacak Kebiasaan",
          style: AuraTypography.titleLarge.copyWith(fontSize: 17),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AuraColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AuraColors.borderLight),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 16,
                color: AuraColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AuraColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AuraColors.borderLight),
              ),
              child: const Icon(
                Icons.share_outlined,
                size: 16,
                color: AuraColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AuraColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Solar Energy Flame Badge (Replaces cartoon fire animal)
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFED7AA),
                  const Color(0xFFFDBA74),
                  AuraColors.streakBg,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AuraColors.streakOrange.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AuraColors.streakOrange.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: AuraColors.streakOrange,
                  size: 34,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Streak Title
          Text(
            "4 Hari Beruntun",
            style: AuraTypography.displayMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),

          // Motivation Subtitle
          Text(
            "Konsistensi yang mengagumkan. Pertahankan ritmemu!",
            style: AuraTypography.bodySmall.copyWith(
              color: AuraColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBreakdown() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AuraColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rincian Rutinitas",
            style: AuraTypography.titleMedium.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),

          // Drink Water Row
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AuraColors.waterBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AuraColors.waterAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Minum Air",
                          style: AuraTypography.titleMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Kurang",
                            style: AuraTypography.labelSmall.copyWith(
                              color: const Color(0xFFEF4444),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 8 Capsules Hydration Progress Track
                    Row(
                      children: List.generate(8, (index) {
                        final isFilled = index < 3;
                        return Expanded(
                          child: Container(
                            height: 6,
                            margin: EdgeInsets.only(
                              right: index < 7 ? 4 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: isFilled
                                  ? AuraColors.waterAccent
                                  : AuraColors.borderLight,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "3/8",
                style: AuraTypography.titleMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AuraColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AuraColors.borderLight, height: 1),
          const SizedBox(height: 16),

          // Workout Row
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AuraColors.exerciseBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AuraColors.exerciseAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Latihan Fisik",
                          style: AuraTypography.titleMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AuraColors.exerciseBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Tercapai",
                            style: AuraTypography.labelSmall.copyWith(
                              color: AuraColors.exerciseAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Linear bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: const LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 6,
                        backgroundColor: AuraColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AuraColors.exerciseAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "45 Menit",
                style: AuraTypography.titleMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AuraColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
