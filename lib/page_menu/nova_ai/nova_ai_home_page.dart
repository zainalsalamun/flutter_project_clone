import 'package:flutter/material.dart';
import 'views/nova_dashboard_view.dart';
import 'views/nova_chat_view.dart';
import 'views/nova_vision_view.dart';
import 'widgets/glassy_nav_bar.dart';

class NovaAiHomePage extends StatefulWidget {
  const NovaAiHomePage({super.key});

  @override
  State<NovaAiHomePage> createState() => _NovaAiHomePageState();
}

class _NovaAiHomePageState extends State<NovaAiHomePage> {
  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      NovaDashboardView(
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const NovaChatView(),
      const NovaVisionView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate Dark Mode
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withOpacity(0.1),
              ),
            ),
          ),

          // Main Content
          SafeArea(child: IndexedStack(index: _currentIndex, children: pages)),

          // Floating Glassy Navigation Bar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GlassyNavBar(
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
