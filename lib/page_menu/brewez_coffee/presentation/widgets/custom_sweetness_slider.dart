import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';

class CustomSweetnessSlider extends StatelessWidget {
  final int sweetnessLevel; // 0, 50, 70, 100
  final ValueChanged<int> onSweetnessChanged;

  const CustomSweetnessSlider({
    super.key,
    required this.sweetnessLevel,
    required this.onSweetnessChanged,
  });

  static const List<int> _levels = [0, 50, 70, 100];

  String _getSweetnessDescription(int level) {
    switch (level) {
      case 0:
        return BrewezLocalization.tr('sweet_0');
      case 50:
        return BrewezLocalization.tr('sweet_50');
      case 70:
        return BrewezLocalization.tr('sweet_70');
      case 100:
        return BrewezLocalization.tr('sweet_100');
      default:
        return BrewezLocalization.tr('sweetness_level');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              BrewezLocalization.tr('sweetness_level'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BrewezTheme.textDark,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Container(
                key: ValueKey<int>(sweetnessLevel),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BrewezTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.water_drop_rounded,
                      size: 14,
                      color: BrewezTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$sweetnessLevel%",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: BrewezTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stepped Selector Buttons
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: _levels.map((level) {
              final isSelected = sweetnessLevel == level;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSweetnessChanged(level),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? BrewezTheme.espresso : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: BrewezTheme.espresso.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$level%",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // Descriptive Caption
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _getSweetnessDescription(sweetnessLevel),
            key: ValueKey<String>("${sweetnessLevel}_${BrewezLocalization.currentLanguage.value}"),
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }
}
