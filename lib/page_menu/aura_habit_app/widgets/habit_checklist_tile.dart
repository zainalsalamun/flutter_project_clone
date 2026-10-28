import 'package:flutter/material.dart';
import '../core/aura_colors.dart';
import '../core/aura_typography.dart';
import '../models/habit_item.dart';

class HabitChecklistTile extends StatelessWidget {
  final HabitItem item;
  final ValueChanged<bool> onToggle;

  const HabitChecklistTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.isCompleted
              ? AuraColors.exerciseAccent.withValues(alpha: 0.3)
              : AuraColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              color: item.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Title & Schedule Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: AuraTypography.titleMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: item.isCompleted
                        ? AuraColors.textMuted
                        : AuraColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: AuraTypography.bodySmall.copyWith(
                    fontSize: 12,
                    color: AuraColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Checkbox Action Button
          GestureDetector(
            onTap: () => onToggle(!item.isCompleted),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isCompleted
                    ? AuraColors.exerciseAccent
                    : Colors.transparent,
                border: Border.all(
                  color: item.isCompleted
                      ? AuraColors.exerciseAccent
                      : AuraColors.border,
                  width: 2,
                ),
              ),
              child: item.isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
