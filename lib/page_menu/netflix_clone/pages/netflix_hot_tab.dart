import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/models/netflix_content.dart';

class NetflixHotTab extends StatefulWidget {
  const NetflixHotTab({super.key});

  @override
  State<NetflixHotTab> createState() => _NetflixHotTabState();
}

class _NetflixHotTabState extends State<NetflixHotTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _remindedIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'New & Hot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFE50914),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🍿 Coming Soon'),
                ],
              ),
            ),
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🔥 Everyone\'s Watching'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComingSoonList(),
          _buildEveryonesWatchingList(),
        ],
      ),
    );
  }

  Widget _buildComingSoonList() {
    final comingSoonItems = [
      {
        'id': 'cs_1',
        'month': 'NOV',
        'day': '08',
        'title': 'Squid Game: Season 2',
        'backdrop': 'https://images.unsplash.com/photo-1634157703702-3c124b455499?w=1200',
        'synopsis': 'Three years after winning Squid Game, Player 456 gave up going to the states and is back with a new resolution in his mind.',
        'genres': ['Gritty', 'Dark', 'Suspense', 'Korean'],
      },
      {
        'id': 'cs_2',
        'month': 'DEC',
        'day': '25',
        'title': 'Stranger Things 5',
        'backdrop': 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200',
        'synopsis': 'The final battle for Hawkins begins as the Upside Down bleeds into the real world.',
        'genres': ['Supernatural', 'Sci-Fi', 'Epic', 'Drama'],
      },
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: comingSoonItems.length,
      itemBuilder: (context, index) {
        final item = comingSoonItems[index];
        final id = item['id'] as String;
        final isReminded = _remindedIds.contains(id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Date Badge
              SizedBox(
                width: 55,
                child: Column(
                  children: [
                    Text(
                      item['month'] as String,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item['day'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Backdrop Video Clip simulation
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: item['backdrop'] as String,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.volume_off,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Title & Remind Me button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isReminded) {
                                  _remindedIds.remove(id);
                                } else {
                                  _remindedIds.add(id);
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isReminded
                                      ? 'Reminder removed'
                                      : 'Reminder set! We will notify you when released.'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFFE50914),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    isReminded
                                        ? Icons.notifications_active_rounded
                                        : Icons.notifications_none_rounded,
                                    key: ValueKey(isReminded),
                                    color: isReminded
                                        ? const Color(0xFFE50914)
                                        : Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isReminded ? 'Reminded' : 'Remind Me',
                                  style: TextStyle(
                                    color: isReminded ? Colors.white : Colors.white60,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Coming ${(item['month'] as String).toLowerCase()} ${item['day']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        item['synopsis'] as String,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEveryonesWatchingList() {
    final trending = NetflixContent.trendingNow;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: trending.length,
      itemBuilder: (context, index) {
        final item = trending[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.backdropUrl,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.synopsis,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
