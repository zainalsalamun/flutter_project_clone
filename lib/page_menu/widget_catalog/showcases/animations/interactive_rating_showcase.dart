import 'package:flutter/material.dart';

class InteractiveRatingShowcase extends StatefulWidget {
  const InteractiveRatingShowcase({super.key});

  @override
  State<InteractiveRatingShowcase> createState() =>
      _InteractiveRatingShowcaseState();
}

class _InteractiveRatingShowcaseState extends State<InteractiveRatingShowcase> {
  int _rating = 4;

  final Map<int, Map<String, String>> _ratingFeelings = {
    1: {'emoji': '', 'text': 'Terrible experience'},
    2: {'emoji': '', 'text': 'Needs improvement'},
    3: {'emoji': '', 'text': 'Average / Okay'},
    4: {'emoji': '', 'text': 'Great experience!'},
    5: {'emoji': '', 'text': 'Absolutely Fantastic!'},
  };

  @override
  Widget build(BuildContext context) {
    final feeling = _ratingFeelings[_rating] ?? {'emoji': '⭐', 'text': ''};

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Text(
                feeling['emoji']!,
                key: ValueKey('emoji_$_rating'),
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                feeling['text']!,
                key: ValueKey('text_$_rating'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final starNumber = index + 1;
                final isFilled = starNumber <= _rating;

                return GestureDetector(
                  onTap: () => setState(() => _rating = starNumber),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      isFilled
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: isFilled ? Colors.amber : Colors.grey.shade300,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
