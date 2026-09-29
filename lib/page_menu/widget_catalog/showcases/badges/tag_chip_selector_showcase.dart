import 'package:flutter/material.dart';

class TagChipSelectorShowcase extends StatefulWidget {
  const TagChipSelectorShowcase({super.key});

  @override
  State<TagChipSelectorShowcase> createState() =>
      _TagChipSelectorShowcaseState();
}

class _TagChipSelectorShowcaseState extends State<TagChipSelectorShowcase> {
  final Set<String> _selectedTags = {'Flutter', 'UI/UX', 'Animation'};

  final List<String> _availableTags = [
    'Flutter',
    'Dart',
    'BLoC',
    'UI/UX',
    'Animation',
    'State Management',
    'Material 3',
    'Custom Painter',
    'Clean Architecture',
    'Responsive',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Interest Tags',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              '${_selectedTags.length} selected',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);

                return FilterTagChip(
                  label: tag,
                  isSelected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}

class FilterTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final Color primaryColor;

  const FilterTagChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.primaryColor = const Color(0xFF6366F1),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
