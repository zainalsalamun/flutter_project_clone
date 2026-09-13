import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';

class AnimatedBottomNav extends StatelessWidget {
  const AnimatedBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);
    final items = [
      (Icons.home_rounded, l.home),
      (Icons.explore_rounded, l.explore),
      (Icons.receipt_long_rounded, l.orders),
      (Icons.favorite_rounded, l.favorites),
      (Icons.person_rounded, l.profile),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      height: 72,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: FoodPromoTheme.ink,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: FoodPromoTheme.ink.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final selected = selectedIndex == index;
          final item = items[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.12 : 0.9,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        item.$1,
                        color: selected ? FoodPromoTheme.orange : Colors.white54,
                        size: 23,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          selected
                              ? Text(
                                item.$2,
                                key: ValueKey(item.$2),
                                style: const TextStyle(
                                  color: FoodPromoTheme.ink,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                              : const SizedBox(
                                height: 0,
                                key: ValueKey('empty'),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
