import 'package:flutter/material.dart';

class AnimatedDropdownShowcase extends StatefulWidget {
  const AnimatedDropdownShowcase({super.key});

  @override
  State<AnimatedDropdownShowcase> createState() =>
      _AnimatedDropdownShowcaseState();
}

class _AnimatedDropdownShowcaseState extends State<AnimatedDropdownShowcase> {
  String? _selectedFruit = 'Apple';
  String? _selectedCategory = 'Technology';

  final List<DropdownItemData> _fruitItems = const [
    DropdownItemData(
      title: 'Apple',
      icon: Icons.apple_rounded,
      subtitle: 'Sweet & Crisp',
    ),
    DropdownItemData(
      title: 'Banana',
      icon: Icons.eco_rounded,
      subtitle: 'Rich in Potassium',
    ),
    DropdownItemData(
      title: 'Orange',
      icon: Icons.bubble_chart_rounded,
      subtitle: 'Full of Vitamin C',
    ),
    DropdownItemData(
      title: 'Strawberry',
      icon: Icons.local_florist_rounded,
      subtitle: 'Fresh & Juicy',
    ),
  ];

  final List<DropdownItemData> _categoryItems = const [
    DropdownItemData(
      title: 'Technology',
      icon: Icons.computer_rounded,
      subtitle: 'Hardware & Software',
    ),
    DropdownItemData(
      title: 'Design',
      icon: Icons.brush_rounded,
      subtitle: 'UI/UX & Branding',
    ),
    DropdownItemData(
      title: 'Marketing',
      icon: Icons.campaign_rounded,
      subtitle: 'Growth & Ads',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Product Category',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        CustomAnimatedDropdown(
          items: _categoryItems,
          selectedValue: _selectedCategory,
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
        const SizedBox(height: 20),
        const Text(
          'Select Favorite Fruit',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        CustomAnimatedDropdown(
          items: _fruitItems,
          selectedValue: _selectedFruit,
          primaryColor: const Color(0xFF10B981),
          onChanged: (val) => setState(() => _selectedFruit = val),
        ),
      ],
    );
  }
}

class DropdownItemData {
  final String title;
  final String? subtitle;
  final IconData icon;

  const DropdownItemData({
    required this.title,
    this.subtitle,
    required this.icon,
  });
}

class CustomAnimatedDropdown extends StatefulWidget {
  final List<DropdownItemData> items;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final Color primaryColor;

  const CustomAnimatedDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.primaryColor = const Color(0xFF6366F1),
  });

  @override
  State<CustomAnimatedDropdown> createState() => _CustomAnimatedDropdownState();
}

class _CustomAnimatedDropdownState extends State<CustomAnimatedDropdown>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items.firstWhere(
      (item) => item.title == widget.selectedValue,
      orElse: () => widget.items.first,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(14),
                bottom: Radius.circular(_isExpanded ? 0 : 14),
              ),
              border: Border.all(
                color: _isExpanded ? widget.primaryColor : Colors.grey.shade300,
                width: _isExpanded ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    currentItem.icon,
                    color: widget.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentItem.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (currentItem.subtitle != null)
                        Text(
                          currentItem.subtitle!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color:
                        _isExpanded
                            ? widget.primaryColor
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child:
              _isExpanded
                  ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14),
                      ),
                      border: Border(
                        left: BorderSide(
                          color: widget.primaryColor,
                          width: 1.5,
                        ),
                        right: BorderSide(
                          color: widget.primaryColor,
                          width: 1.5,
                        ),
                        bottom: BorderSide(
                          color: widget.primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children:
                          widget.items.map((item) {
                            final isSelected =
                                item.title == widget.selectedValue;
                            return InkWell(
                              onTap: () {
                                widget.onChanged(item.title);
                                setState(() => _isExpanded = false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                color:
                                    isSelected
                                        ? widget.primaryColor.withValues(
                                          alpha: 0.08,
                                        )
                                        : Colors.transparent,
                                child: Row(
                                  children: [
                                    Icon(
                                      item.icon,
                                      color:
                                          isSelected
                                              ? widget.primaryColor
                                              : Colors.grey.shade600,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isSelected
                                                  ? widget.primaryColor
                                                  : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_rounded,
                                        color: widget.primaryColor,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
