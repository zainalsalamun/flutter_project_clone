import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/food_item_model.dart';

class AddonChip extends StatelessWidget {
  const AddonChip({
    super.key,
    required this.addon,
    required this.selected,
    required this.onTap,
  });

  final AddonOption addon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.05 : 1,
        duration: const Duration(milliseconds: 210),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? FoodPromoTheme.softOrange : Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? FoodPromoTheme.orange : FoodPromoTheme.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline,
                  key: ValueKey(selected),
                  color: selected ? FoodPromoTheme.orange : FoodPromoTheme.muted,
                  size: 18,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                '${l.optionLabel(addon.name)}  +${formatRupiah(addon.price)}',
                style: const TextStyle(
                  color: FoodPromoTheme.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
