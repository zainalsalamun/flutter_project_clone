import 'package:flutter/material.dart';

class NavigationBarBasicShowcase extends StatefulWidget {
  const NavigationBarBasicShowcase({super.key});

  @override
  State<NavigationBarBasicShowcase> createState() =>
      _NavigationBarBasicShowcaseState();
}

class _NavigationBarBasicShowcaseState
    extends State<NavigationBarBasicShowcase> {
  int _selectedIndex = 0;
  NavigationDestinationLabelBehavior _labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  final List<String> _pageNames = [
    'Beranda (Home)',
    'Eksplorasi (Explore)',
    'Notifikasi (Inbox)',
    'Akun Profil (Profile)',
  ];
  final List<Color> _pageColors = [
    const Color(0xFF6366F1),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Scaffold(
            body: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _pageColors[_selectedIndex].withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _selectedIndex == 0
                          ? Icons.home_rounded
                          : _selectedIndex == 1
                          ? Icons.explore_rounded
                          : _selectedIndex == 2
                          ? Icons.notifications_rounded
                          : Icons.person_rounded,
                      color: _pageColors[_selectedIndex],
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _pageNames[_selectedIndex],
                      style: TextStyle(
                        color: _pageColors[_selectedIndex],
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              labelBehavior: _labelBehavior,
              indicatorColor: _pageColors[_selectedIndex].withValues(
                alpha: 0.25,
              ),
              onDestinationSelected:
                  (idx) => setState(() => _selectedIndex = idx),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore_rounded),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('3'),
                    child: Icon(Icons.notifications_outlined),
                  ),
                  selectedIcon: Badge(
                    label: Text('3'),
                    child: Icon(Icons.notifications_rounded),
                  ),
                  label: 'Inbox',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'NavigationBar (Material 3) Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Label Behavior:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<NavigationDestinationLabelBehavior>(
              value: _labelBehavior,
              isDense: true,
              items: const [
                DropdownMenuItem(
                  value: NavigationDestinationLabelBehavior.alwaysShow,
                  child: Text('alwaysShow', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: NavigationDestinationLabelBehavior.onlyShowSelected,
                  child: Text(
                    'onlyShowSelected',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                DropdownMenuItem(
                  value: NavigationDestinationLabelBehavior.alwaysHide,
                  child: Text('alwaysHide', style: TextStyle(fontSize: 11)),
                ),
              ],
              onChanged: (b) {
                if (b != null) setState(() => _labelBehavior = b);
              },
            ),
          ],
        ),
      ],
    );
  }
}
