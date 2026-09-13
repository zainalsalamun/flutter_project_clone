import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class AnimatedSearchBar extends StatelessWidget {
  const AnimatedSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.active,
    required this.onChanged,
    required this.hintText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool active;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      height: 56,
      padding: EdgeInsets.only(left: active ? 18 : 16, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(active ? 21 : 18),
        border: Border.all(
          color: active ? FoodPromoTheme.orange : Colors.transparent,
          width: active ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: active ? 0.1 : 0.045),
            blurRadius: active ? 24 : 12,
            offset: Offset(0, active ? 13 : 6),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Icon(
              active ? Icons.search_rounded : Icons.search_outlined,
              key: ValueKey(active),
              color: active ? FoodPromoTheme.orange : FoodPromoTheme.muted,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: FoodPromoTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: active ? 38 : 34,
            height: active ? 38 : 34,
            decoration: BoxDecoration(
              color: active ? FoodPromoTheme.orange : FoodPromoTheme.softOrange,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: active ? Colors.white : FoodPromoTheme.orange,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}
