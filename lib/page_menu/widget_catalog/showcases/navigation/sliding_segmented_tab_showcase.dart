import 'package:flutter/material.dart';

class SlidingSegmentedTabShowcase extends StatefulWidget {
  const SlidingSegmentedTabShowcase({super.key});

  @override
  State<SlidingSegmentedTabShowcase> createState() =>
      _SlidingSegmentedTabShowcaseState();
}

class _SlidingSegmentedTabShowcaseState
    extends State<SlidingSegmentedTabShowcase> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlidingSegmentedTab(
          tabs: _tabs,
          selectedIndex: _selectedIndex,
          onTabChanged: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Text(
                'Showing Analytics for "${_tabs[_selectedIndex]}"',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('Total Views', '${(_selectedIndex + 1) * 2450}'),
                  _statItem('Revenue', '\$${(_selectedIndex + 1) * 890}'),
                  _statItem('Growth', '+${(_selectedIndex + 2) * 4.5}%'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class SlidingSegmentedTab extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final Color activeColor;

  const SlidingSegmentedTab({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.activeColor = const Color(0xFF6366F1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth) / tabs.length;

          return Stack(
            children: [
              // Sliding Indicator Pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                left: selectedIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab text buttons
              Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTabChanged(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color:
                                isSelected ? activeColor : Colors.grey.shade600,
                          ),
                          child: Text(tabs[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
