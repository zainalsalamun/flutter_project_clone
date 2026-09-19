import 'package:flutter/material.dart';
import '../../core/theme/brewez_theme.dart';

class AnimatedSizeSelector extends StatelessWidget {
  final String selectedSize;
  final ValueChanged<String> onSizeChanged;

  const AnimatedSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeChanged,
  });

  static const List<Map<String, dynamic>> _sizeOptions = [
    {'size': 'S', 'label': 'Small', 'volume': '250ml', 'iconSize': 18.0},
    {'size': 'M', 'label': 'Medium', 'volume': '350ml', 'iconSize': 22.0},
    {'size': 'L', 'label': 'Large', 'volume': '450ml', 'iconSize': 26.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _sizeOptions.map((option) {
        final size = option['size'] as String;
        final label = option['label'] as String;
        final volume = option['volume'] as String;
        final iconSize = option['iconSize'] as double;
        final isSelected = selectedSize == size;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => onSizeChanged(size),
              child: AnimatedScale(
                scale: isSelected ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? BrewezTheme.primary : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? BrewezTheme.primary
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? BrewezTheme.glowShadow(BrewezTheme.primary)
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.coffee_rounded,
                        size: iconSize,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        size,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        volume,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
