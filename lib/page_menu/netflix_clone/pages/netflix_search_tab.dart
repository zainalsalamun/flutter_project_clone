import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/models/netflix_content.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/movie_detail_sheet.dart';

class NetflixSearchTab extends StatefulWidget {
  const NetflixSearchTab({super.key});

  @override
  State<NetflixSearchTab> createState() => _NetflixSearchTabState();
}

class _NetflixSearchTabState extends State<NetflixSearchTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<NetflixContent> get _allMovies => [
        ...NetflixContent.featuredContent,
        ...NetflixContent.top10Today,
        ...NetflixContent.trendingNow,
        ...NetflixContent.continueWatching,
        ...NetflixContent.animeCollection,
      ];

  List<NetflixContent> get _filteredMovies {
    if (_searchQuery.trim().isEmpty) return _allMovies;
    return _allMovies
        .where((m) =>
            m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m.genres.any(
                (g) => g.toLowerCase().contains(_searchQuery.toLowerCase())))
        .toList();
  }

  void _openDetailSheet(NetflixContent content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MovieDetailSheet(content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2B2B2B),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search games, shows, movies...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : const Icon(Icons.mic_none_rounded, color: Colors.white38, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (val) {
              setState(() => _searchQuery = val);
            },
          ),
        ),
      ),
      body: _searchQuery.isEmpty
          ? _buildTopSearchesList()
          : _buildSearchResultsGrid(),
    );
  }

  Widget _buildTopSearchesList() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Top Searches',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final item in _allMovies.take(8)) ...[
          InkWell(
            onTap: () => _openDetailSheet(item),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              color: const Color(0xFF1A1A1A),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.backdropUrl,
                    width: 120,
                    height: 68,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResultsGrid() {
    final results = _filteredMovies;
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No matches found.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.68,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return GestureDetector(
          onTap: () => _openDetailSheet(item),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: item.posterUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
