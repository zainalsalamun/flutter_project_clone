import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';

class CoffeeFilterOptions {
  final String sortBy; // 'popular', 'price_low', 'price_high', 'name'
  final RangeValues priceRange;
  final double minRating; // 0.0, 4.5, 4.8

  const CoffeeFilterOptions({
    this.sortBy = 'popular',
    this.priceRange = const RangeValues(20000.0, 40000.0),
    this.minRating = 0.0,
  });

  bool get isDefault =>
      sortBy == 'popular' &&
      priceRange.start <= 20000.0 &&
      priceRange.end >= 40000.0 &&
      minRating == 0.0;

  int get activeFilterCount {
    int count = 0;
    if (sortBy != 'popular') count++;
    if (priceRange.start > 20000.0 || priceRange.end < 40000.0) count++;
    if (minRating > 0.0) count++;
    return count;
  }

  CoffeeFilterOptions copyWith({
    String? sortBy,
    RangeValues? priceRange,
    double? minRating,
  }) {
    return CoffeeFilterOptions(
      sortBy: sortBy ?? this.sortBy,
      priceRange: priceRange ?? this.priceRange,
      minRating: minRating ?? this.minRating,
    );
  }
}

class CoffeeFilterModalSheet extends StatefulWidget {
  final CoffeeFilterOptions currentFilter;
  final ValueChanged<CoffeeFilterOptions> onApply;

  const CoffeeFilterModalSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required CoffeeFilterOptions currentFilter,
    required ValueChanged<CoffeeFilterOptions> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CoffeeFilterModalSheet(
        currentFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CoffeeFilterModalSheet> createState() => _CoffeeFilterModalSheetState();
}

class _CoffeeFilterModalSheetState extends State<CoffeeFilterModalSheet> {
  late String _sortBy;
  late RangeValues _priceRange;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.currentFilter.sortBy;
    _priceRange = widget.currentFilter.priceRange;
    _minRating = widget.currentFilter.minRating;
  }

  void _reset() {
    setState(() {
      _sortBy = 'popular';
      _priceRange = const RangeValues(20000.0, 40000.0);
      _minRating = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: Title & Reset Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BrewezTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: BrewezTheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      BrewezLocalization.tr('filter_title'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: BrewezTheme.textDark,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    BrewezLocalization.tr('reset_filter'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: BrewezTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 18),

            // 1. Sort By
            Text(
              BrewezLocalization.tr('sort_by'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: BrewezTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _sortChip('popular', BrewezLocalization.tr('sort_popular'),
                    Icons.star_rounded),
                _sortChip('price_low', BrewezLocalization.tr('sort_price_low'),
                    Icons.arrow_downward_rounded),
                _sortChip('price_high', BrewezLocalization.tr('sort_price_high'),
                    Icons.arrow_upward_rounded),
                _sortChip('name', BrewezLocalization.tr('sort_name'),
                    Icons.sort_by_alpha_rounded),
              ],
            ),
            const SizedBox(height: 22),

            // 2. Price Range Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  BrewezLocalization.tr('price_range'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: BrewezTheme.textDark,
                  ),
                ),
                Text(
                  "${BrewezCurrency.format(_priceRange.start)} - ${BrewezCurrency.format(_priceRange.end)}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: BrewezTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            RangeSlider(
              values: _priceRange,
              min: 20000.0,
              max: 40000.0,
              divisions: 20,
              activeColor: BrewezTheme.primary,
              inactiveColor: Colors.grey.shade200,
              labels: RangeLabels(
                BrewezCurrency.format(_priceRange.start),
                BrewezCurrency.format(_priceRange.end),
              ),
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            const SizedBox(height: 18),

            // 3. Minimum Rating
            Text(
              BrewezLocalization.tr('min_rating'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: BrewezTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _ratingChip(0.0, BrewezLocalization.tr('all_coffee'), null),
                const SizedBox(width: 8),
                _ratingChip(4.5, '4.5+', Icons.star_rounded),
                const SizedBox(width: 8),
                _ratingChip(4.8, '4.8+', Icons.star_rounded),
              ],
            ),
            const SizedBox(height: 26),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onApply(
                    CoffeeFilterOptions(
                      sortBy: _sortBy,
                      priceRange: _priceRange,
                      minRating: _minRating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrewezTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      BrewezLocalization.tr('apply_filter'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortChip(String value, String label, IconData icon) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? BrewezTheme.espresso : const Color(0xFFF6F6F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? BrewezTheme.espresso : Colors.grey.shade200,
          ),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : BrewezTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingChip(double rating, String label, IconData? icon) {
    final isSelected = _minRating == rating;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _minRating = rating;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? BrewezTheme.primary : const Color(0xFFF6F6F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? BrewezTheme.primary : Colors.grey.shade200,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: BrewezTheme.primary.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : BrewezTheme.textDark,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? Colors.white : Colors.amber.shade700,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
