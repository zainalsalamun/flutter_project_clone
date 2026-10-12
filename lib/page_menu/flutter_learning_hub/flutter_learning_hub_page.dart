import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'basics/pages/flutter_basics_home_page.dart';
import 'catalog/pages/widget_catalog_home_page.dart';
import 'fundamentals/pages/fundamentals_home_page.dart';

/// Flutter Learning & Pro Widget Mastery Hub
/// Unified master page integrating:
/// 1. Fundamentals (Arsitektur, Lifecycle, State & Render Trees)
/// 2. Basic Widgets Catalog (Essential core Flutter UI components)
/// 3. Pro Widget Catalog (Advanced animations, shaders, charts & custom canvas widgets)
class FlutterLearningHubPage extends StatefulWidget {
  final int initialTabIndex;

  const FlutterLearningHubPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<FlutterLearningHubPage> createState() => _FlutterLearningHubPageState();
}

class _FlutterLearningHubPageState extends State<FlutterLearningHubPage> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    FundamentalsHomePage(),
    FlutterBasicsHomePage(),
    WidgetCatalogHomePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.auto_stories_rounded,
                  activeIcon: Icons.auto_stories,
                  label: "Fundamentals",
                  badgeText: "8 Modul",
                  activeColor: const Color(0xFF6366F1), // Indigo
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.flutter_dash_outlined,
                  activeIcon: Icons.flutter_dash,
                  label: "Basic Widgets",
                  badgeText: "30+ UI",
                  activeColor: const Color(0xFF0284C7), // Sky Blue
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.widgets_outlined,
                  activeIcon: Icons.widgets_rounded,
                  label: "Pro Catalog",
                  badgeText: "Pro Lab",
                  activeColor: const Color(0xFF8B5CF6), // Purple
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String badgeText,
    required Color activeColor,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? activeColor.withValues(alpha: 0.4)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? activeColor : const Color(0xFF94A3B8),
                  size: 22,
                ),
                if (isSelected)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
