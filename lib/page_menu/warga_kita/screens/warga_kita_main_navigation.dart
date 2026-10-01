import 'package:flutter/material.dart';
import '../core/warga_kita_data.dart';
import '../core/warga_kita_theme.dart';
import '../models/warga_kita_models.dart';
import 'home/warga_kita_home_tab.dart';
import 'pesan/warga_kita_pesan_tab.dart';
import 'profil/warga_kita_profil_tab.dart';
import 'warga/warga_kita_warga_tab.dart';

class WargaKitaMainNavigation extends StatefulWidget {
  const WargaKitaMainNavigation({super.key});

  @override
  State<WargaKitaMainNavigation> createState() => _WargaKitaMainNavigationState();
}

class _WargaKitaMainNavigationState extends State<WargaKitaMainNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WargaKitaData().init();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      WargaKitaHomeTab(
        onNavigateToPesan: () => _onTabSelected(2),
        onNavigateToProfil: () => _onTabSelected(3),
      ),
      const WargaKitaWargaTab(),
      const WargaKitaPesanTab(),
      const WargaKitaProfilTab(),
    ];

    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ValueListenableBuilder<List<AnnouncementItem>>(
              valueListenable: WargaKitaData().announcementsNotifier,
              builder: (context, announcements, _) {
                final unreadCount = announcements.where((a) => a.isUnread).length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      activeIcon: Icons.home_rounded,
                      label: 'Beranda',
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.people_outline_rounded,
                      activeIcon: Icons.people_rounded,
                      label: 'Warga',
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.chat_bubble_outline_rounded,
                      activeIcon: Icons.chat_bubble_rounded,
                      label: 'Pesan',
                      badgeCount: unreadCount,
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profil',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? WargaKitaTheme.primary : WargaKitaTheme.textMuted;

    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6CF8BB).withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: color,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: WargaKitaTheme.crimsonSos,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: WargaKitaTheme.font(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
