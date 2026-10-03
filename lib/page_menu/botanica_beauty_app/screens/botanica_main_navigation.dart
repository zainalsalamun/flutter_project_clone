import 'package:flutter/material.dart';
import '../core/botanica_data.dart';
import '../core/botanica_theme.dart';
import '../models/botanica_models.dart';
import 'explore/botanica_explore_tab.dart';
import 'home/botanica_home_tab.dart';
import 'profile/botanica_profile_tab.dart';
import 'wishlist/botanica_wishlist_tab.dart';

class BotanicaMainNavigation extends StatefulWidget {
  const BotanicaMainNavigation({super.key});

  @override
  State<BotanicaMainNavigation> createState() => _BotanicaMainNavigationState();
}

class _BotanicaMainNavigationState extends State<BotanicaMainNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      BotanicaHomeTab(
        onNavigateTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const BotanicaExploreTab(),
      BotanicaWishlistTab(
        onExploreTap: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      const BotanicaProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.spa_outlined, Icons.spa_rounded, 'Beranda'),
                _buildNavItem(1, Icons.grid_view_outlined, Icons.grid_view_rounded, 'Eksplor'),
                _buildWishlistNavItem(2, 'Wishlist'),
                _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? BotanicaTheme.primaryTint : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: isSelected ? BotanicaTheme.primary : BotanicaTheme.textTertiary,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: BotanicaTheme.font(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BotanicaTheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistNavItem(int index, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: ValueListenableBuilder<List<BotanicaProduct>>(
        valueListenable: BotanicaData().productsNotifier,
        builder: (context, products, _) {
          final count = products.where((p) => p.isWishlist).length;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? BotanicaTheme.primaryTint : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isSelected ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      color: isSelected ? BotanicaTheme.accentRose : BotanicaTheme.textTertiary,
                      size: 22,
                    ),
                    if (count > 0 && !isSelected)
                      Positioned(
                        top: -2,
                        right: -3,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: BotanicaTheme.accentRose,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                          child: Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: BotanicaTheme.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BotanicaTheme.accentRose,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
