import 'package:flutter/material.dart';

class FloatingPillNavBarShowcase extends StatefulWidget {
  const FloatingPillNavBarShowcase({super.key});

  @override
  State<FloatingPillNavBarShowcase> createState() =>
      _FloatingPillNavBarShowcaseState();
}

class _FloatingPillNavBarShowcaseState
    extends State<FloatingPillNavBarShowcase> {
  int _currentIndex = 0;

  final List<String> _pageNames = [
    'Home Feed',
    'Explore',
    'Saved Items',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _currentIndex == 0
                      ? Icons.home_rounded
                      : _currentIndex == 1
                      ? Icons.explore_rounded
                      : _currentIndex == 2
                      ? Icons.bookmark_rounded
                      : Icons.person_rounded,
                  size: 48,
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 8),
                Text(
                  'Active: ${_pageNames[_currentIndex]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: FloatingPillNavBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  FloatingNavItem(icon: Icons.home_rounded, label: 'Home'),
                  FloatingNavItem(
                    icon: Icons.explore_rounded,
                    label: 'Explore',
                  ),
                  FloatingNavItem(icon: Icons.bookmark_rounded, label: 'Saved'),
                  FloatingNavItem(icon: Icons.person_rounded, label: 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingNavItem {
  final IconData icon;
  final String label;

  const FloatingNavItem({required this.icon, required this.label});
}

class FloatingPillNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FloatingNavItem> items;
  final Color activeColor;

  const FloatingPillNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.activeColor = const Color(0xFF6366F1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          final item = items[index];

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16 : 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                    size: 20,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
