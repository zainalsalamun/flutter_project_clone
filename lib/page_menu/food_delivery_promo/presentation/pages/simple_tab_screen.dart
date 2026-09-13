import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class SimpleTabScreen extends StatelessWidget {
  const SimpleTabScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  final String title;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: FoodPromoTheme.softOrange,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: FoodPromoTheme.orange, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: FoodPromoTheme.ink,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FoodPromoTheme.muted,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
