import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';
import '../../data/models/coffee_addon_model.dart';

class InteractiveAddonsSelector extends StatelessWidget {
  final Set<AddonType> selectedAddons;
  final ValueChanged<AddonType> onToggleAddon;

  const InteractiveAddonsSelector({
    super.key,
    required this.selectedAddons,
    required this.onToggleAddon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              BrewezLocalization.tr('custom_addons'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BrewezTheme.textDark,
              ),
            ),
            if (selectedAddons.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BrewezTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${selectedAddons.length} dipilih",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: BrewezTheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // 1. Kategori Susu (Milk Base)
        _buildCategorySection(
          titleKey: 'category_milk',
          category: AddonCategory.milk,
        ),
        const SizedBox(height: 18),

        // 2. Kategori Sirup & Pemanis (Syrups)
        _buildCategorySection(
          titleKey: 'category_syrup',
          category: AddonCategory.syrup,
        ),
        const SizedBox(height: 18),

        // 3. Kategori Booster Kopi & Es
        _buildCategorySection(
          titleKey: 'category_booster',
          category: AddonCategory.booster,
        ),
        const SizedBox(height: 18),

        // 4. Kategori Topping & Foam
        _buildCategorySection(
          titleKey: 'category_topping',
          category: AddonCategory.topping,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(AddonCategory category) {
    switch (category) {
      case AddonCategory.milk:
        return Icons.local_drink_rounded;
      case AddonCategory.syrup:
        return Icons.eco_rounded;
      case AddonCategory.booster:
        return Icons.bolt_rounded;
      case AddonCategory.topping:
        return Icons.auto_awesome_rounded;
    }
  }

  Widget _buildCategorySection({
    required String titleKey,
    required AddonCategory category,
  }) {
    final addons = CoffeeAddonModel.allAddons
        .where((a) => a.category == category)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 16,
              color: const Color(0xFF6B4226),
            ),
            const SizedBox(width: 6),
            Text(
              BrewezLocalization.tr(titleKey),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B4226),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Vertical List of Addon Items
        Column(
          children: addons.map((addon) {
            final isSelected = selectedAddons.contains(addon.type);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onToggleAddon(addon.type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (addon.isFree
                            ? const Color(0xFFE8F5E9)
                            : BrewezTheme.accentWarm.withOpacity(0.5))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? (addon.isFree
                              ? Colors.green.shade600
                              : BrewezTheme.primary)
                          : Colors.grey.shade200,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon Box
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (addon.isFree
                                  ? Colors.green.shade600
                                  : BrewezTheme.primary)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          addon.icon,
                          size: 18,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BrewezLocalization.tr(addon.translationKeyName),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: BrewezTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              BrewezLocalization.tr(addon.translationKeySub),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Price Tag (FREE vs +Rp xx.xxx)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: addon.isFree
                              ? Colors.green.shade50
                              : BrewezTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: addon.isFree
                                ? Colors.green.shade400
                                : BrewezTheme.primaryLight,
                          ),
                        ),
                        child: Text(
                          addon.isFree
                              ? BrewezLocalization.tr('free_badge')
                              : "+${BrewezCurrency.format(addon.price)}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: addon.isFree
                                ? Colors.green.shade700
                                : BrewezTheme.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Check / Radio indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (addon.isFree
                                  ? Colors.green.shade600
                                  : BrewezTheme.primary)
                              : Colors.transparent,
                          shape: category == AddonCategory.milk
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                          borderRadius: category == AddonCategory.milk
                              ? null
                              : BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
