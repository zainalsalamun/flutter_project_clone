import 'package:flutter/material.dart';
import '../../../core/theme/travel_theme.dart';
import '../../../core/utils/travel_page_routes.dart';
import '../../../data/models/travel_item_model.dart';
import '../../../data/repositories/travel_repository.dart';
import '../../widgets/animated_travel_card.dart';
import '../travel_detail_screen.dart';

class FavoritesTabView extends StatefulWidget {
  final VoidCallback onExploreTapped;

  const FavoritesTabView({super.key, required this.onExploreTapped});

  @override
  State<FavoritesTabView> createState() => _FavoritesTabViewState();
}

class _FavoritesTabViewState extends State<FavoritesTabView> {
  final TravelRepository _repo = TravelRepository();
  late List<DestinationItem> _favoriteItems;
  int _selectedFilter = 0; // 0: Semua, 1: Hotel, 2: Wisata

  @override
  void initState() {
    super.initState();
    _favoriteItems = List.from(_repo.getFeaturedDestinations());
  }

  void _removeFavorite(String id) {
    setState(() {
      _favoriteItems.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Dihapus dari daftar favorit 🤍'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          'Destinasi & Wishlist Favorit',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua (${_favoriteItems.length})', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Hotel & Resort Mewah', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('Wisata & Alam', 2),
                ],
              ),
            ),
          ),

          // List of Favorites
          Expanded(
            child:
                _favoriteItems.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                      itemCount: _favoriteItems.length,
                      itemBuilder: (context, index) {
                        final dest = _favoriteItems[index];
                        return AnimatedTravelCard(
                          destination: dest,
                          isFavorite: true,
                          heroTagPrefix: 'fav',
                          onFavoriteToggle: () => _removeFavorite(dest.id),
                          onTap: () {
                            Navigator.push(
                              context,
                              TravelPageRoute(
                                page: TravelDetailScreen(
                                  destination: dest,
                                  heroTag: 'fav-${dest.heroTag}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TravelTheme.primary : TravelTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? TravelTheme.primary : TravelTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : TravelTheme.darkMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: TravelTheme.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 54,
                color: TravelTheme.accent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada destinasi favorit',
              style: TextStyle(
                color: TravelTheme.dark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simpan hotel, paket petualangan, dan tempat impian Anda dengan menekan ikon hati.',
              textAlign: TextAlign.center,
              style: TextStyle(color: TravelTheme.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: widget.onExploreTapped,
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text('Mulai Jelajahi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TravelTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
