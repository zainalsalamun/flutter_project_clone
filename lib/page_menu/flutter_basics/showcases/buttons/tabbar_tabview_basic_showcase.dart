import 'package:flutter/material.dart';

class TabBarTabViewBasicShowcase extends StatefulWidget {
  const TabBarTabViewBasicShowcase({super.key});

  @override
  State<TabBarTabViewBasicShowcase> createState() =>
      _TabBarTabViewBasicShowcaseState();
}

class _TabBarTabViewBasicShowcaseState
    extends State<TabBarTabViewBasicShowcase> {
  bool _isScrollable = false;

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
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                toolbarHeight: 0,
                bottom: TabBar(
                  isScrollable: _isScrollable,
                  labelColor: const Color(0xFF6366F1),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF6366F1),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.flash_on_rounded, size: 18),
                      text: 'Populer',
                    ),
                    Tab(
                      icon: Icon(Icons.trending_up_rounded, size: 18),
                      text: 'Trending',
                    ),
                    Tab(
                      icon: Icon(Icons.new_releases_rounded, size: 18),
                      text: 'Terbaru',
                    ),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flash_on_rounded,
                          size: 40,
                          color: Color(0xFF6366F1),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Konten Tab 1: Populer ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Geser layar ke kiri/kanan',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 40,
                          color: Color(0xFF10B981),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Konten Tab 2: Trending ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Geser layar ke kiri/kanan',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.new_releases_rounded,
                          size: 40,
                          color: Color(0xFFF59E0B),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Konten Tab 3: Terbaru ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Geser layar ke kiri/kanan',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'TabBar Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'TabBar isScrollable (Tab banyak):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _isScrollable,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _isScrollable = v),
            ),
          ],
        ),
      ],
    );
  }
}
