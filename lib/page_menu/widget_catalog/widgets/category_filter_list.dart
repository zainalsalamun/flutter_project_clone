import 'package:flutter/material.dart';
import '../models/widget_category.dart';

class CategoryFilterList extends StatelessWidget {
  final WidgetCategory selectedCategory;
  final ValueChanged<WidgetCategory> onCategorySelected;
  final Map<WidgetCategory, int> categoryCounts;

  const CategoryFilterList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categoryCounts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: WidgetCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = WidgetCategory.values[index];
          final isSelected = selectedCategory == category;
          final count = categoryCounts[category] ?? 0;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF0F172A)
                          : Colors.grey.shade200,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 16,
                    color: isSelected ? Colors.white : category.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
