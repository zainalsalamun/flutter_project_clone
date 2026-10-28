import 'package:flutter/material.dart';
import 'core/aura_colors.dart';
import 'screens/aura_habit_main_wrapper.dart';

class AuraHabitPage extends StatelessWidget {
  const AuraHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AuraColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AuraColors.primary,
          primary: AuraColors.primary,
          secondary: AuraColors.secondary,
          surface: AuraColors.surface,
        ),
      ),
      child: const AuraHabitMainWrapper(),
    );
  }
}
