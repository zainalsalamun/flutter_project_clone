import 'package:flutter/material.dart';
import '../../core/aura_colors.dart';
import '../../core/aura_typography.dart';
import '../../models/habit_item.dart';
import '../../models/habit_metric.dart';
import '../../widgets/habit_metric_card.dart';
import '../../widgets/habit_progress_card.dart';
import '../../widgets/habit_checklist_tile.dart';

class AuraHabitHomeScreen extends StatefulWidget {
  final VoidCallback? onOpenAssistant;
  final VoidCallback? onOpenAnalytics;

  const AuraHabitHomeScreen({
    super.key,
    this.onOpenAssistant,
    this.onOpenAnalytics,
  });

  @override
  State<AuraHabitHomeScreen> createState() => _AuraHabitHomeScreenState();
}

class _AuraHabitHomeScreenState extends State<AuraHabitHomeScreen> {
  List<HabitItem> _habits = [
    const HabitItem(
      id: 'h1',
      title: 'Minum Air Berkala',
      subtitle: 'Tiap 30 menit • Target 8 gelas',
      icon: Icons.water_drop_rounded,
      iconColor: AuraColors.waterAccent,
      bgColor: AuraColors.waterBg,
      isCompleted: true,
      currentCount: 3,
      targetCount: 8,
      unit: 'Gelas',
    ),
    const HabitItem(
      id: 'h2',
      title: 'Latihan Fisik',
      subtitle: '30 menit peregangan & kardio',
      icon: Icons.fitness_center_rounded,
      iconColor: AuraColors.exerciseAccent,
      bgColor: AuraColors.exerciseBg,
      isCompleted: false,
      currentCount: 0,
      targetCount: 1,
      unit: 'Sesi',
    ),
    const HabitItem(
      id: 'h3',
      title: 'Menulis Jurnal Harian',
      subtitle: 'Refleksi syukur di akhir hari',
      icon: Icons.edit_note_rounded,
      iconColor: AuraColors.journalAccent,
      bgColor: AuraColors.journalBg,
      isCompleted: false,
      currentCount: 0,
      targetCount: 1,
      unit: 'Catatan',
    ),
    const HabitItem(
      id: 'h4',
      title: 'Membaca Buku 15 Menit',
      subtitle: 'Pengembangan diri & fokus',
      icon: Icons.menu_book_rounded,
      iconColor: AuraColors.sleepAccent,
      bgColor: AuraColors.sleepBg,
      isCompleted: false,
      currentCount: 0,
      targetCount: 1,
      unit: 'Bab',
    ),
    const HabitItem(
      id: 'h5',
      title: 'Tidur Tepat Waktu',
      subtitle: 'Maksimal jam 22.30 malam',
      icon: Icons.nightlight_round,
      iconColor: AuraColors.secondary,
      bgColor: AuraColors.sleepBg,
      isCompleted: true,
      currentCount: 1,
      targetCount: 1,
      unit: 'Malam',
    ),
  ];

  int get _completedCount => _habits.where((h) => h.isCompleted).length;

  void _toggleHabit(String id, bool value) {
    setState(() {
      _habits = _habits.map((h) {
        if (h.id == id) {
          return h.copyWith(isCompleted: value);
        }
        return h;
      }).toList();
    });
  }

  void _showAddHabitDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AuraColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AuraColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Tambah Kebiasaan Baru",
                style: AuraTypography.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                "Buat rutinitas kecil yang mudah dipertahankan setiap hari.",
                style: AuraTypography.bodySmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Nama Kebiasaan",
                  labelStyle: AuraTypography.bodySmall,
                  hintText: "Contoh: Meditasi 10 Menit",
                  filled: true,
                  fillColor: AuraColors.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subtitleController,
                decoration: InputDecoration(
                  labelText: "Keterangan atau Waktu",
                  labelStyle: AuraTypography.bodySmall,
                  hintText: "Contoh: Setiap pagi setelah bangun tidur",
                  filled: true,
                  fillColor: AuraColors.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isNotEmpty) {
                      setState(() {
                        _habits.add(
                          HabitItem(
                            id: 'h_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            subtitle: subtitleController.text.trim().isEmpty
                                ? 'Rutinitas harian'
                                : subtitleController.text.trim(),
                            icon: Icons.check_circle_outline_rounded,
                            iconColor: AuraColors.primary,
                            bgColor: AuraColors.primarySoft,
                            isCompleted: false,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AuraColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Simpan Kebiasaan",
                    style: AuraTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextPending = _habits.firstWhere(
      (h) => !h.isCompleted,
      orElse: () => _habits.first,
    );

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
            stops: [0.0, 0.28, 0.6],
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

              // Greeting Row
              _buildGreetingSection(),
              const SizedBox(height: 20),

              // Trio Quick Metrics Cards
              Row(
                children: [
                  HabitMetricCard(
                    metric: const HabitMetric(
                      label: "Air Minum",
                      value: "3",
                      unit: "Gelas",
                      icon: Icons.water_drop_rounded,
                      iconColor: AuraColors.waterAccent,
                      bgColor: AuraColors.waterBg,
                    ),
                    onTap: widget.onOpenAnalytics,
                  ),
                  const SizedBox(width: 10),
                  HabitMetricCard(
                    metric: const HabitMetric(
                      label: "Waktu Tidur",
                      value: "8.5",
                      unit: "Jam",
                      icon: Icons.nightlight_round,
                      iconColor: AuraColors.sleepAccent,
                      bgColor: AuraColors.sleepBg,
                    ),
                    onTap: widget.onOpenAnalytics,
                  ),
                  const SizedBox(width: 10),
                  HabitMetricCard(
                    metric: const HabitMetric(
                      label: "Olahraga",
                      value: "18.6",
                      unit: "Km Sepeda",
                      icon: Icons.directions_bike_rounded,
                      iconColor: AuraColors.exerciseAccent,
                      bgColor: AuraColors.exerciseBg,
                    ),
                    onTap: widget.onOpenAnalytics,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Progress Highlight Banner
              HabitProgressCard(
                completedCount: _completedCount,
                totalCount: _habits.length,
                nextHabitTitle: nextPending.title,
                onNextTap: () {
                  _toggleHabit(nextPending.id, true);
                },
              ),
              const SizedBox(height: 24),

              // Habits Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kebiasaan Hari Ini",
                    style: AuraTypography.titleLarge.copyWith(fontSize: 17),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AuraColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AuraColors.borderLight),
                        ),
                        child: const Icon(
                          Icons.grid_view_rounded,
                          size: 16,
                          color: AuraColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _showAddHabitDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AuraColors.textPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Habits Checklist
              ..._habits.map((item) {
                return HabitChecklistTile(
                  item: item,
                  onToggle: (val) => _toggleHabit(item.id, val),
                );
              }),

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
        // Drawer Menu Button
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AuraColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AuraColors.borderLight),
          ),
          child: const Icon(
            Icons.menu_rounded,
            size: 20,
            color: AuraColors.textPrimary,
          ),
        ),

        // Search & AI Assistant Quick Pill
        GestureDetector(
          onTap: widget.onOpenAssistant,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AuraColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AuraColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: AuraColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  "Tanya Asisten",
                  style: AuraTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AuraColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Motivational Status Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AuraColors.exerciseBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AuraColors.exerciseAccent.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AuraColors.exerciseAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "Fokus & Teratur",
                style: AuraTypography.labelSmall.copyWith(
                  color: AuraColors.exerciseAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, Lukman",
              style: AuraTypography.displayMedium.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 3),
            Text(
              "Siap melangkah hari ini?",
              style: AuraTypography.bodyMedium.copyWith(
                color: AuraColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),

        // Mini Companion Status Badge
        GestureDetector(
          onTap: widget.onOpenAssistant,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AuraColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AuraColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AuraColors.primary, AuraColors.secondary],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bubble_chart_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "Aura Aktif",
                  style: AuraTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AuraColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
