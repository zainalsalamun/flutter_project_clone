import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/models/netflix_content.dart';

class MovieDetailSheet extends StatefulWidget {
  final NetflixContent content;
  final VoidCallback? onPlay;

  const MovieDetailSheet({
    super.key,
    required this.content,
    this.onPlay,
  });

  @override
  State<MovieDetailSheet> createState() => _MovieDetailSheetState();
}

class _MovieDetailSheetState extends State<MovieDetailSheet>
    with SingleTickerProviderStateMixin {
  bool _isInMyList = false;
  String _userRating = ''; // 'like', 'love', 'dislike'
  bool _isPlayingTrailer = true;
  int _selectedTabIndex = 0; // 0: Episodes, 1: More Like This
  final double _trailerProgress = 0.3;

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Scrollable Detail Body
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Simulated Video Player Banner
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 210,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: content.backdropUrl,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Dark Vignette
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.transparent,
                                const Color(0xFF141414),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Player Controls Overlay
                      Positioned.fill(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPlayingTrailer = !_isPlayingTrailer;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white38, width: 1),
                              ),
                              child: Icon(
                                _isPlayingTrailer
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Close Button at top right
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2B2B2B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),

                      // Video Scrubber Progress bar
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: LinearProgressIndicator(
                          value: _trailerProgress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFE50914)),
                          minHeight: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Info & Metadata
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          content.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Badges Row (Match score, Year, Rating, Quality)
                        Row(
                          children: [
                            Text(
                              content.matchScore,
                              style: const TextStyle(
                                color: Color(0xFF46D369),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '2024',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                content.maturityRating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              content.durationOrSeasons,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white38),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Text(
                                'HD',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Play Big Button
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow_rounded,
                                color: Colors.black, size: 26),
                            label: const Text(
                              'Play',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onPlay?.call();
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Download Button
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF262626),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            icon: const Icon(Icons.file_download_outlined,
                                color: Colors.white, size: 22),
                            label: const Text(
                              'Download',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Downloading ${content.title} for offline viewing...'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFFE50914),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Synopsis
                        Text(
                          content.synopsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Cast & Genres
                        Text(
                          'Starring: ${content.cast.join(', ')}',
                          style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Genres: ${content.genres.join(', ')}',
                          style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                        ),

                        const SizedBox(height: 20),

                        // Interactive Actions Row (My List, Rate, Share)
                        Row(
                          children: [
                            // My List Action
                            _buildDetailActionButton(
                              icon: _isInMyList
                                  ? Icons.check_rounded
                                  : Icons.add_rounded,
                              label: 'My List',
                              isActive: _isInMyList,
                              onTap: () {
                                setState(() {
                                  _isInMyList = !_isInMyList;
                                });
                              },
                            ),

                            const SizedBox(width: 32),

                            // Rate Action
                            _buildDetailActionButton(
                              icon: _userRating == 'love'
                                  ? Icons.thumb_up_alt
                                  : (_userRating == 'dislike'
                                      ? Icons.thumb_down_alt
                                      : Icons.thumb_up_alt_outlined),
                              label: 'Rate',
                              isActive: _userRating.isNotEmpty,
                              onTap: () => _showRatingDialog(context),
                            ),

                            const SizedBox(width: 32),

                            // Share Action
                            _buildDetailActionButton(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied link to clipboard!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Tab Bar: Episodes vs More Like This
                        Row(
                          children: [
                            _buildTabItem(0, 'Episodes'),
                            const SizedBox(width: 16),
                            _buildTabItem(1, 'More Like This'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab Content: Episodes List or More Like This Grid
                _selectedTabIndex == 0
                    ? _buildEpisodesList(content)
                    : _buildMoreLikeThisGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFE50914) : Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            width: 40,
            color: isSelected ? const Color(0xFFE50914) : Colors.transparent,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesList(NetflixContent content) {
    final episodes = content.episodes ??
        [
          const Episode(
            number: 1,
            title: 'Episode 1',
            duration: '45m',
            synopsis: 'The story begins with an unexpected event.',
            thumbnailUrl:
                'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400',
          ),
        ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final ep = episodes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Thumbnail with Play icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 100,
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: ep.thumbnailUrl,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 60,
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title & duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ep.number}. ${ep.title}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ep.duration,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.file_download_outlined,
                          color: Colors.white70, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  ep.synopsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.3),
                ),
              ],
            ),
          );
        },
        childCount: episodes.length,
      ),
    );
  }

  Widget _buildMoreLikeThisGrid() {
    final related = NetflixContent.trendingNow;
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = related[index % related.length];
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: item.posterUrl,
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: related.length,
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'What did you think of this title?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RatingOption(
                      icon: Icons.thumb_down_rounded,
                      label: 'Not for me',
                      isSelected: _userRating == 'dislike',
                      onTap: () {
                        setState(() => _userRating = 'dislike');
                        Navigator.pop(ctx);
                      },
                    ),
                    _RatingOption(
                      icon: Icons.thumb_up_rounded,
                      label: 'I like this',
                      isSelected: _userRating == 'like',
                      onTap: () {
                        setState(() => _userRating = 'like');
                        Navigator.pop(ctx);
                      },
                    ),
                    _RatingOption(
                      icon: Icons.favorite_rounded,
                      label: 'Love this!',
                      isSelected: _userRating == 'love',
                      onTap: () {
                        setState(() => _userRating = 'love');
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RatingOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatingOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE50914) : Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
