import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../data/models/travel_item_model.dart';

class TravelCategoryBar extends StatelessWidget {
  final TravelCategory selectedCategory;
  final ValueChanged<TravelCategory> onCategorySelected;

  const TravelCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      (category: TravelCategory.hotel, label: 'Hotel', icon: Icons.hotel_rounded),
      (category: TravelCategory.flight, label: 'Pesawat', icon: Icons.flight_rounded),
      (category: TravelCategory.train, label: 'Kereta', icon: Icons.train_rounded),
      (category: TravelCategory.experience, label: 'Wisata', icon: Icons.explore_rounded),
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TravelTheme.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: categories.map((item) {
          final isSelected = selectedCategory == item.category;

          return Expanded(
            child: GestureDetector(
              onTap: () => onCategorySelected(item.category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: isSelected ? TravelTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: TravelTheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected ? Colors.white : TravelTheme.muted,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : TravelTheme.darkMuted,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
