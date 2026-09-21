import 'dart:ui';
import 'package:flutter/material.dart';

class NetflixAppBar extends StatelessWidget {
  final double scrollOffset;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;
  final ValueChanged<String>? onCategorySelected;
  final String activeFilter;

  const NetflixAppBar({
    super.key,
    required this.scrollOffset,
    required this.onSearchTap,
    required this.onProfileTap,
    this.onCategorySelected,
    this.activeFilter = 'All',
  });

  @override
  Widget build(BuildContext context) {
    // Opacity smoothly increases from 0.0 to 1.0 between scrollOffset 0 and 150
    final bgOpacity = (scrollOffset / 150).clamp(0.0, 1.0);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: bgOpacity * 10,
          sigmaY: bgOpacity * 10,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: Colors.black.withValues(alpha: bgOpacity * 0.92),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 6,
            left: 16,
            right: 16,
            bottom: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Logo, Cast, Search, Avatar
              Row(
                children: [
                  // Netflix 'N' Logo
                  Container(
                    width: 28,
                    height: 38,
                    alignment: Alignment.center,
                    child: const Text(
                      'N',
                      style: TextStyle(
                        color: Color(0xFFE50914),
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'sans-serif',
                        letterSpacing: -1,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Cast Icon
                  IconButton(
                    icon: const Icon(Icons.cast_rounded, color: Colors.white, size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Searching for Cast-enabled devices...'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  // Search Icon
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
                    onPressed: onSearchTap,
                  ),

                  const SizedBox(width: 4),

                  // Profile Avatar
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF0071EB),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Center(
                        child: Icon(Icons.sentiment_satisfied_alt_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Filter Sub-header (TV Shows, Movies, Categories)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterPill(context, 'TV Shows'),
                  _buildFilterPill(context, 'Movies'),
                  _buildFilterPill(context, 'Categories ▾', isDropdown: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(BuildContext context, String title, {bool isDropdown = false}) {
    final isSelected = activeFilter == title.replaceAll(' ▾', '');

    return GestureDetector(
      onTap: () {
        if (isDropdown) {
          _showCategoriesModal(context);
        } else {
          onCategorySelected?.call(isSelected ? 'All' : title);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
            width: 0.8,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showCategoriesModal(BuildContext context) {
    final categories = [
      'Home',
      'My List',
      'Thrillers',
      'Anime',
      'Action & Adventure',
      'Comedies',
      'Documentaries',
      'Dramas',
      'Horror',
      'Sci-Fi & Fantasy',
      'Indonesian Movies & Shows',
      'Award-Winning',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        onCategorySelected?.call(cat);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: cat == 'Home' ? Colors.white : Colors.white70,
                              fontSize: 16,
                              fontWeight:
                                  cat == 'Home' ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
