import 'package:flutter/material.dart';

class CategoryFilterChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  static const List<Map<String, dynamic>> categories = [
    {'label': 'Curated', 'icon': Icons.auto_awesome, 'query': ''},
    {'label': 'Nature', 'icon': Icons.forest_outlined, 'query': 'nature'},
    {'label': 'Architecture', 'icon': Icons.apartment_outlined, 'query': 'architecture'},
    {'label': 'Animals', 'icon': Icons.pets_outlined, 'query': 'animals'},
    {'label': 'Cyberpunk', 'icon': Icons.nightlife_outlined, 'query': 'cyberpunk neon'},
    {'label': 'Travel', 'icon': Icons.flight_takeoff, 'query': 'travel landscape'},
    {'label': 'Minimalist', 'icon': Icons.crop_square, 'query': 'minimalist aesthetic'},
    {'label': 'Coffee', 'icon': Icons.coffee_outlined, 'query': 'coffee cafe'},
    {'label': 'Food', 'icon': Icons.restaurant_outlined, 'query': 'food gourmet'},
    {'label': 'Wallpaper', 'icon': Icons.wallpaper, 'query': '4k wallpaper'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = categories[index];
          final label = item['label'] as String;
          final query = item['query'] as String;
          final icon = item['icon'] as IconData;

          final isSelected = (selectedCategory.isEmpty && label == 'Curated') ||
              selectedCategory.toLowerCase() == label.toLowerCase() ||
              selectedCategory.toLowerCase() == query.toLowerCase();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => onSelectCategory(query),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 15,
                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
