import 'package:flutter/material.dart';
import '../core/aura_colors.dart';
import '../core/aura_typography.dart';
import 'home/aura_habit_home_screen.dart';
import 'analytics/aura_habit_analytics_screen.dart';
import 'assistant/aura_habit_assistant_screen.dart';

class AuraHabitMainWrapper extends StatefulWidget {
  final int initialIndex;

  const AuraHabitMainWrapper({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<AuraHabitMainWrapper> createState() => _AuraHabitMainWrapperState();
}

class _AuraHabitMainWrapperState extends State<AuraHabitMainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      AuraHabitHomeScreen(
        onOpenAssistant: () => _onTabSelected(2),
        onOpenAnalytics: () => _onTabSelected(1),
      ),
      AuraHabitAnalyticsScreen(
        onBack: () => _onTabSelected(0),
      ),
      AuraHabitAssistantScreen(
        onBack: () => _onTabSelected(0),
      ),
      _buildSettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AuraColors.canvas,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AuraColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: const Border(
            top: BorderSide(color: AuraColors.borderLight, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.cottage_rounded,
                label: 'Beranda',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.bar_chart_rounded,
                label: 'Pelacak',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.auto_awesome_rounded,
                label: 'Asisten',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.settings_rounded,
                label: 'Pengaturan',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AuraColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AuraColors.primary : AuraColors.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AuraTypography.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AuraColors.primary : AuraColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return Scaffold(
      backgroundColor: AuraColors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Pengaturan & Preferensi",
              style: AuraTypography.displayMedium.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              "Kelola target harian, notifikasi pengingat, dan akun.",
              style: AuraTypography.bodySmall,
            ),
            const SizedBox(height: 20),

            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuraColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AuraColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AuraColors.primary, AuraColors.secondary],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "L",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lukman Hakim",
                          style: AuraTypography.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Member Premium Sejak 2026",
                          style: AuraTypography.bodySmall.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AuraColors.textMuted,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings Options List
            _buildSettingTile(
              icon: Icons.notifications_active_outlined,
              title: "Pengingat Rutinitas",
              subtitle: "Pemberitahuan minum air dan olahraga",
              value: "Aktif",
            ),
            _buildSettingTile(
              icon: Icons.dark_mode_outlined,
              title: "Tema Tampilan",
              subtitle: "Otomatis mengikuti sistem",
              value: "Terang",
            ),
            _buildSettingTile(
              icon: Icons.cloud_sync_outlined,
              title: "Sinkronisasi Cloud",
              subtitle: "Data tersimpan otomatis dan aman",
              value: "Tersambung",
            ),
            _buildSettingTile(
              icon: Icons.security_rounded,
              title: "Privasi & Keamanan",
              subtitle: "Enkripsi data kebiasaan pribadi",
              value: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AuraColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AuraColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AuraColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AuraTypography.titleMedium.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AuraTypography.bodySmall.copyWith(fontSize: 12)),
              ],
            ),
          ),
          if (value != null) ...[
            Text(
              value,
              style: AuraTypography.labelSmall.copyWith(
                color: AuraColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AuraColors.textMuted,
          ),
        ],
      ),
    );
  }
}
