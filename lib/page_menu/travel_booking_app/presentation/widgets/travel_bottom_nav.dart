import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';

class TravelBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final GlobalKey? orderKey;
  final int orderCount;
  final Animation<double>? bounceAnimation;

  const TravelBottomNav({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.orderKey,
    this.orderCount = 0,
    this.bounceAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      (icon: Icons.explore_rounded, label: 'Eksplor', isOrder: false),
      (icon: Icons.confirmation_number_rounded, label: 'Pesanan', isOrder: true),
      (icon: Icons.favorite_rounded, label: 'Favorit', isOrder: false),
      (icon: Icons.person_rounded, label: 'Akun', isOrder: false),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: TravelTheme.dark,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = currentIndex == index;
          final item = navItems[index];

          Widget navContent = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? TravelTheme.primaryLight : Colors.white60,
                    size: 20,
                  ),
                  if (item.isOrder && orderCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: TravelTheme.accent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          '$orderCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          );

          if (item.isOrder && bounceAnimation != null) {
            navContent = ScaleTransition(
              scale: bounceAnimation!,
              child: navContent,
            );
          }

          return GestureDetector(
            key: item.isOrder ? orderKey : null,
            onTap: () => onIndexChanged(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16 : 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? TravelTheme.primaryLight.withValues(alpha: 0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: navContent,
            ),
          );
        }),
      ),
    );
  }
}
