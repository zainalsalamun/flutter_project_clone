import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_event.dart';
import '../bloc/language/language_state.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        final isIndonesian = state.language == FoodLanguage.id;
        return GestureDetector(
          onTap: () => context.read<LanguageBloc>().add(const ToggleLanguageEvent()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: 58,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isIndonesian ? FoodPromoTheme.ink : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    isIndonesian
                        ? FoodPromoTheme.ink
                        : FoodPromoTheme.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                isIndonesian ? 'ID' : 'EN',
                key: ValueKey(state.language),
                style: TextStyle(
                  color: isIndonesian ? Colors.white : FoodPromoTheme.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
