import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/models/netflix_content.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/content_row.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/hero_billboard.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/movie_detail_sheet.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/netflix_app_bar.dart';

class NetflixHomeTab extends StatefulWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const NetflixHomeTab({
    super.key,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  State<NetflixHomeTab> createState() => _NetflixHomeTabState();
}

class _NetflixHomeTabState extends State<NetflixHomeTab> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  String _activeFilter = 'All';
  bool _isHeroInMyList = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetailSheet(NetflixContent content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MovieDetailSheet(
        content: content,
        onPlay: () {
          _showVideoPlayerSimulation(content);
        },
      ),
    );
  }

  void _showVideoPlayerSimulation(NetflixContent content) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (ctx) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_filter_rounded,
                          color: Color(0xFFE50914), size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Now Playing: ${content.title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '4K Ultra HD • Spatial Audio Active',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          color: Color(0xFFE50914),
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hero = NetflixContent.featuredContent.first;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scrollable Home Feed
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Billboard
              SliverToBoxAdapter(
                child: HeroBillboard(
                  content: hero,
                  isInMyList: _isHeroInMyList,
                  onPlay: () => _showVideoPlayerSimulation(hero),
                  onInfo: () => _openDetailSheet(hero),
                  onToggleMyList: () {
                    setState(() {
                      _isHeroInMyList = !_isHeroInMyList;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isHeroInMyList
                            ? 'Added to My List'
                            : 'Removed from My List'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF262626),
                      ),
                    );
                  },
                ),
              ),

              // Continue Watching Row
              SliverToBoxAdapter(
                child: ContentRow(
                  title: 'Continue Watching for Alex',
                  contents: NetflixContent.continueWatching,
                  isContinueWatching: true,
                  onContentTap: _openDetailSheet,
                ),
              ),

              // Top 10 in Indonesia Today Row
              SliverToBoxAdapter(
                child: ContentRow(
                  title: 'Top 10 in Indonesia Today',
                  contents: NetflixContent.top10Today,
                  isTop10: true,
                  onContentTap: _openDetailSheet,
                ),
              ),

              // Trending Now Row
              SliverToBoxAdapter(
                child: ContentRow(
                  title: 'Trending Now',
                  contents: NetflixContent.trendingNow,
                  onContentTap: _openDetailSheet,
                ),
              ),

              // Anime Collection Row
              SliverToBoxAdapter(
                child: ContentRow(
                  title: 'Exciting Anime TV Series',
                  contents: NetflixContent.animeCollection,
                  onContentTap: _openDetailSheet,
                ),
              ),

              // Extra bottom padding for Bottom Navigation Bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),

          // Animated Floating App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NetflixAppBar(
              scrollOffset: _scrollOffset,
              activeFilter: _activeFilter,
              onSearchTap: widget.onSearchTap,
              onProfileTap: widget.onProfileTap,
              onCategorySelected: (cat) {
                setState(() => _activeFilter = cat);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Filtered by $cat'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
