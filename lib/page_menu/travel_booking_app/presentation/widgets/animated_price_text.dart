import 'package:flutter/material.dart';
import '../../core/utils/travel_currency.dart';

class AnimatedPriceText extends StatelessWidget {
  final num price;
  final TextStyle? style;
  final Duration duration;

  const AnimatedPriceText({
    super.key,
    required this.price,
    this.style,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: price.toDouble(), end: price.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          formatTravelCurrency(value),
          style: style,
        );
      },
    );
  }
}
