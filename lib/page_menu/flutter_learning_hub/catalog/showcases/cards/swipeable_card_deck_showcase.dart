import 'package:flutter/material.dart';

class SwipeableCardDeckShowcase extends StatefulWidget {
  const SwipeableCardDeckShowcase({super.key});

  @override
  State<SwipeableCardDeckShowcase> createState() =>
      _SwipeableCardDeckShowcaseState();
}

class _CardProfile {
  final String id;
  final String name;
  final int age;
  final String title;
  final String location;
  final List<String> tags;
  final List<Color> gradientColors;
  final String emoji;
  final String bio;

  const _CardProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.title,
    required this.location,
    required this.tags,
    required this.gradientColors,
    required this.emoji,
    required this.bio,
  });
}

class _SwipeableCardDeckShowcaseState extends State<SwipeableCardDeckShowcase>
    with SingleTickerProviderStateMixin {
  final List<_CardProfile> _allProfiles = const [
    _CardProfile(
      id: '1',
      name: 'Alya Sabrina',
      age: 24,
      title: 'UI/UX Designer',
      location: 'Jakarta Selatan',
      tags: [' Figma', ' Kopi Latte', ' Cat Lover', ' Traveling'],
      gradientColors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
      emoji: '‍',
      bio:
          'Suka mendesain antarmuka yang intuitif dan hunting coffee shop aesthetic di akhir pekan!',
    ),
    _CardProfile(
      id: '2',
      name: 'Rian Pratama',
      age: 27,
      title: 'Flutter Lead Architect',
      location: 'Bandung',
      tags: [' Flutter', ' Startup', ' Gitar Akustik', ' Cycling'],
      gradientColors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
      emoji: '‍',
      bio:
          'Bikin aplikasi mobile dengan performa 60 FPS dan pecinta cold brew.',
    ),
    _CardProfile(
      id: '3',
      name: 'Chelsea Wijaya',
      age: 23,
      title: 'Digital Marketing & Content',
      location: 'Surabaya',
      tags: [' Fotografi', ' Kuliner Pedas', ' Film Indie', ' Podcasts'],
      gradientColors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      emoji: '',
      bio:
          'Bercerita lewat visual dan video. Selalu mencari petualangan baru di kota.',
    ),
    _CardProfile(
      id: '4',
      name: 'Dimas Aditya',
      age: 28,
      title: 'Product Manager & AI Enthusiast',
      location: 'Yogyakarta',
      tags: [' GenAI', ' Buku Non-Fiksi', ' Camping', ' Catur'],
      gradientColors: [Color(0xFF10B981), Color(0xFF047857)],
      emoji: '‍',
      bio:
          'Menggabungkan teknologi dengan solusi praktis sehari-hari. Mari berdiskusi ide seru!',
    ),
    _CardProfile(
      id: '5',
      name: 'Nadia Putri',
      age: 25,
      title: 'Illustrator & 3D Artist',
      location: 'Bali',
      tags: [' Blender 3D', '‍ Surfing', ' Sunset', ' Nature'],
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
      emoji: '',
      bio:
          'Digital nomad yang mencintai laut Bali dan melukis lanskap fiksi ilmiah.',
    ),
  ];

  late List<_CardProfile> _activeDeck;
  final List<_CardProfile> _swipedHistory = [];

  // Pan gesture tracking
  Offset _dragOffset = Offset.zero;

  // Animation controller for snap back / fly off / undo
  late AnimationController _animController;
  Animation<Offset>? _flyAnimation;

  // Last swipe direction
  String _lastActionText =
      'Geser kartu ke kanan untuk LIKE, ke kiri untuk PASS!';
  Color _lastActionColor = Colors.white70;

  @override
  void initState() {
    super.initState();
    _activeDeck = List.from(_allProfiles);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (_animController.isAnimating || _activeDeck.isEmpty) return;
    setState(() {
      _dragOffset = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_animController.isAnimating || _activeDeck.isEmpty) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_animController.isAnimating || _activeDeck.isEmpty) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_dragOffset.dx > threshold) {
      _animateSwipe(const Offset(600, 0), isLike: true);
    } else if (_dragOffset.dx < -threshold) {
      _animateSwipe(const Offset(-600, 0), isLike: false);
    } else if (_dragOffset.dy < -threshold) {
      _animateSwipe(const Offset(0, -600), isSuperLike: true);
    } else {
      // Spring back to center
      _animateSpringBack();
    }
  }

  void _animateSpringBack() {
    final start = _dragOffset;
    _flyAnimation = Tween<Offset>(begin: start, end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward(from: 0.0).then((_) {
      setState(() {
        _dragOffset = Offset.zero;
        _flyAnimation = null;
      });
    });
  }

  void _animateSwipe(
    Offset targetOffset, {
    bool isLike = false,
    bool isSuperLike = false,
  }) {
    final start = _dragOffset;
    _flyAnimation = Tween<Offset>(begin: start, end: targetOffset).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutQuad),
    );

    _animController.forward(from: 0.0).then((_) {
      if (_activeDeck.isNotEmpty) {
        final removed = _activeDeck.removeAt(0);
        _swipedHistory.add(removed);

        setState(() {
          _dragOffset = Offset.zero;
          _flyAnimation = null;

          if (isSuperLike) {
            _lastActionText = '⭐ SUPER LIKED ${removed.name}!';
            _lastActionColor = const Color(0xFF38BDF8);
          } else if (isLike) {
            _lastActionText = ' LIKED ${removed.name}!';
            _lastActionColor = const Color(0xFF4ADE80);
          } else {
            _lastActionText = ' PASSED ${removed.name}';
            _lastActionColor = const Color(0xFFF87171);
          }
        });
      }
    });
  }

  void _triggerProgrammaticSwipe({required bool isRight, bool isUp = false}) {
    if (_animController.isAnimating || _activeDeck.isEmpty) return;

    if (isUp) {
      _dragOffset = const Offset(0, -20);
      _animateSwipe(const Offset(0, -600), isSuperLike: true);
    } else if (isRight) {
      _dragOffset = const Offset(20, 0);
      _animateSwipe(const Offset(600, 50), isLike: true);
    } else {
      _dragOffset = const Offset(-20, 0);
      _animateSwipe(const Offset(-600, 50), isLike: false);
    }
  }

  void _undoLastSwipe() {
    if (_animController.isAnimating || _swipedHistory.isEmpty) return;

    final restored = _swipedHistory.removeLast();
    setState(() {
      _activeDeck.insert(0, restored);
      _dragOffset = const Offset(0, -100);
      _lastActionText = ' Kartu ${restored.name} dikembalikan!';
      _lastActionColor = const Color(0xFFFACC15);
    });

    _animateSpringBack();
  }

  void _resetDeck() {
    setState(() {
      _activeDeck = List.from(_allProfiles);
      _swipedHistory.clear();
      _dragOffset = Offset.zero;
      _lastActionText = 'Deck telah direset ke awal!';
      _lastActionColor = Colors.white70;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // STATUS MESSAGE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _lastActionColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _lastActionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _lastActionColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 20),

          // CARD STACK AREA
          SizedBox(
            height: 420,
            width: double.infinity,
            child: Center(
              child:
                  _activeDeck.isEmpty
                      ? _buildEmptyState()
                      : Stack(
                        alignment: Alignment.center,
                        children: [
                          // BACKGROUND CARDS (DEPTH PREVIEW)
                          if (_activeDeck.length > 2)
                            _buildCardItem(
                              profile: _activeDeck[2],
                              scale: 0.88,
                              translateY: 20,
                              opacity: 0.5,
                              isInteractive: false,
                            ),
                          if (_activeDeck.length > 1)
                            _buildCardItem(
                              profile: _activeDeck[1],
                              scale: 0.94,
                              translateY: 10,
                              opacity: 0.8,
                              isInteractive: false,
                            ),
                          // TOP CARD (INTERACTIVE)
                          _buildTopCard(),
                        ],
                      ),
            ),
          ),

          const SizedBox(height: 24),

          // BOTTOM ACTION CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // REWIND / UNDO
              _buildActionButton(
                icon: Icons.replay_rounded,
                color: Colors.amber,
                size: 48,
                iconSize: 22,
                isEnabled: _swipedHistory.isNotEmpty,
                onTap: _undoLastSwipe,
              ),
              const SizedBox(width: 14),

              // DISLIKE / PASS
              _buildActionButton(
                icon: Icons.close_rounded,
                color: const Color(0xFFEF4444),
                size: 58,
                iconSize: 30,
                isEnabled: _activeDeck.isNotEmpty,
                onTap: () => _triggerProgrammaticSwipe(isRight: false),
              ),
              const SizedBox(width: 14),

              // SUPER LIKE
              _buildActionButton(
                icon: Icons.star_rounded,
                color: const Color(0xFF38BDF8),
                size: 48,
                iconSize: 24,
                isEnabled: _activeDeck.isNotEmpty,
                onTap:
                    () => _triggerProgrammaticSwipe(isRight: false, isUp: true),
              ),
              const SizedBox(width: 14),

              // LIKE / HEART
              _buildActionButton(
                icon: Icons.favorite_rounded,
                color: const Color(0xFF10B981),
                size: 58,
                iconSize: 30,
                isEnabled: _activeDeck.isNotEmpty,
                onTap: () => _triggerProgrammaticSwipe(isRight: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BUILD THE INTERACTIVE TOP CARD
  Widget _buildTopCard() {
    final currentOffset =
        _flyAnimation != null ? _flyAnimation!.value : _dragOffset;
    final screenWidth = MediaQuery.of(context).size.width;
    final rotationAngle = (currentOffset.dx / screenWidth) * 0.35;

    final likeOpacity = (currentOffset.dx / 120).clamp(0.0, 1.0);
    final nopeOpacity = (-currentOffset.dx / 120).clamp(0.0, 1.0);
    final superLikeOpacity = (-currentOffset.dy / 100).clamp(0.0, 1.0);

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: currentOffset,
        child: Transform.rotate(
          angle: rotationAngle,
          child: Stack(
            children: [
              _buildCardContent(_activeDeck.first),

              // LIKE STAMP BADGE
              if (likeOpacity > 0.05)
                Positioned(
                  top: 24,
                  left: 24,
                  child: Opacity(
                    opacity: likeOpacity,
                    child: Transform.rotate(
                      angle: -0.25,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF4ADE80),
                            width: 3,
                          ),
                        ),
                        child: const Text(
                          'LIKE ',
                          style: TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // NOPE STAMP BADGE
              if (nopeOpacity > 0.05)
                Positioned(
                  top: 24,
                  right: 24,
                  child: Opacity(
                    opacity: nopeOpacity,
                    child: Transform.rotate(
                      angle: 0.25,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEF4444),
                            width: 3,
                          ),
                        ),
                        child: const Text(
                          'NOPE ',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // SUPER LIKE STAMP BADGE
              if (superLikeOpacity > 0.1 && currentOffset.dy < -30)
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(
                      opacity: superLikeOpacity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'SUPER LIKE ⭐',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD CARD ITEM FOR DEPTH STACK
  Widget _buildCardItem({
    required _CardProfile profile,
    required double scale,
    required double translateY,
    required double opacity,
    required bool isInteractive,
  }) {
    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: Opacity(opacity: opacity, child: _buildCardContent(profile)),
      ),
    );
  }

  // BUILD VISUAL CARD CONTENT
  Widget _buildCardContent(_CardProfile profile) {
    return Container(
      width: 320,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: profile.gradientColors,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // EMOJI HERO BANNER
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                    border: Border.all(color: Colors.white38, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      profile.emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ),
            ),

            // CARD BOTTOM INFO OVERLAY
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${profile.name}, ${profile.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF38BDF8),
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Pro',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline_rounded,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            profile.title,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            profile.location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile.bio,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          profile.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EMPTY DECK STATE
  Widget _buildEmptyState() {
    return Container(
      width: 320,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF38BDF8),
              size: 48,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Semua Kartu Selesai!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kamu telah melihat seluruh profil di deck ini. Silakan muat ulang atau kembalikan kartu terakhir.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _resetDeck,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Muat Ulang Deck'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC4899),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM ACTION BUTTON HELPER
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(size / 2),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.4,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E293B),
              border: Border.all(
                color:
                    isEnabled ? color.withValues(alpha: 0.5) : Colors.white12,
                width: 2,
              ),
              boxShadow:
                  isEnabled
                      ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
        ),
      ),
    );
  }
}
