import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/models/netflix_content.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/top_ten_badge.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<NetflixContent> contents;
  final ValueChanged<NetflixContent> onContentTap;
  final bool isTop10;
  final bool isContinueWatching;

  const ContentRow({
    super.key,
    required this.title,
    required this.contents,
    required this.onContentTap,
    this.isTop10 = false,
    this.isContinueWatching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 18.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),

        // Horizontal List
        SizedBox(
          height: isTop10 ? 155 : (isContinueWatching ? 175 : 150),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: isTop10
                    ? _buildTop10Item(content, index + 1)
                    : (isContinueWatching
                        ? _buildContinueWatchingItem(content)
                        : _buildStandardItem(content)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStandardItem(NetflixContent content) {
    return _AnimatedMovieCard(
      onTap: () => onContentTap(content),
      child: Stack(
        children: [
          Container(
            width: 105,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF1E293B),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: content.posterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF1F2937),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF334155),
                  child: Center(
                    child: Text(
                      content.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Netflix 'N' Badge
          if (content.isOriginal)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                width: 12,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'N',
                  style: TextStyle(
                    color: Color(0xFFE50914),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTop10Item(NetflixContent content, int rank) {
    return _AnimatedMovieCard(
      onTap: () => onContentTap(content),
      child: SizedBox(
        width: 150,
        height: 155,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Left Huge 3D Rank Number
            Positioned(
              left: 0,
              bottom: -4,
              child: TopTenRankNumber(rank: rank),
            ),

            // Right Poster
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF1E293B),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: content.posterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF1F2937),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWatchingItem(NetflixContent content) {
    return _AnimatedMovieCard(
      onTap: () => onContentTap(content),
      child: Container(
        width: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xFF1F1F1F),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail / Poster with Center Play Icon
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: content.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Play overlay circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar
            LinearProgressIndicator(
              value: content.watchProgress ?? 0.5,
              backgroundColor: const Color(0xFF374151),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
              minHeight: 3,
            ),

            // Bottom Info Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white54, size: 16),
                  const Icon(Icons.more_vert, color: Colors.white54, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedMovieCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedMovieCard({
    required this.child,
    required this.onTap,
  });

  @override
  State<_AnimatedMovieCard> createState() => _AnimatedMovieCardState();
}

class _AnimatedMovieCardState extends State<_AnimatedMovieCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
