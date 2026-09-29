import 'dart:async';
import 'package:flutter/material.dart';

class StoryAvatarRingShowcase extends StatefulWidget {
  const StoryAvatarRingShowcase({super.key});

  @override
  State<StoryAvatarRingShowcase> createState() =>
      _StoryAvatarRingShowcaseState();
}

class _StoryAvatarRingShowcaseState extends State<StoryAvatarRingShowcase> {
  double _avatarSize = 72.0;

  final List<_StoryUser> _stories = [
    _StoryUser(
      name: 'Zainal S.',
      handle: '@zainal.dev',
      avatarColor: const Color(0xFF6366F1),
      initials: 'ZS',
      status: _StoryStatus.unseen,
      slides: [
        _StorySlide(
          title: ' Launching Flutter 3.24',
          description: 'Fitur baru Impeller rendering engine super smooth!',
          color1: const Color(0xFF4F46E5),
          color2: const Color(0xFF06B6D4),
          icon: Icons.rocket_launch_rounded,
        ),
        _StorySlide(
          title: ' Coding Night in Bali',
          description: 'Slicing UI widget catalog dan generative widgets.',
          color1: const Color(0xFFEC4899),
          color2: const Color(0xFFF59E0B),
          icon: Icons.coffee_rounded,
        ),
      ],
    ),
    _StoryUser(
      name: 'Sarah Tech',
      handle: '@sarah.design',
      avatarColor: const Color(0xFFEC4899),
      initials: 'ST',
      status: _StoryStatus.live,
      slides: [
        _StorySlide(
          title: ' LIVE: Figma to Flutter',
          description: 'Tips merancang design system modern & scalable.',
          color1: const Color(0xFFDC2626),
          color2: const Color(0xFF7C3AED),
          icon: Icons.live_tv_rounded,
        ),
      ],
    ),
    _StoryUser(
      name: 'Alex Core',
      handle: '@alex.flutter',
      avatarColor: const Color(0xFF10B981),
      initials: 'AC',
      status: _StoryStatus.closeFriends,
      slides: [
        _StorySlide(
          title: ' Close Friends Only',
          description: 'Sneak peek project private startup AI 2026.',
          color1: const Color(0xFF059669),
          color2: const Color(0xFF10B981),
          icon: Icons.lock_outline_rounded,
        ),
      ],
    ),
    _StoryUser(
      name: 'Dika Studio',
      handle: '@dikastudio',
      avatarColor: const Color(0xFF64748B),
      initials: 'DS',
      status: _StoryStatus.seen,
      slides: [
        _StorySlide(
          title: ' New UI Kit Released',
          description: 'Check out the link in bio for full assets.',
          color1: const Color(0xFF475569),
          color2: const Color(0xFF334155),
          icon: Icons.palette_rounded,
        ),
      ],
    ),
  ];

  void _openStoryViewer(_StoryUser user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Story Viewer',
      barrierColor: Colors.black.withValues(alpha: 0.9),
      pageBuilder: (ctx, anim1, anim2) {
        return _StoryViewerDialog(user: user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Story Avatars Horizontal Feed Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Stories Feed (Tap untuk Membuka)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Interactive',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children:
                      _stories.map((user) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () => _openStoryViewer(user),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _StoryAvatarRing(user: user, size: _avatarSize),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: _avatarSize + 8,
                                  child: Text(
                                    user.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Size & Status Controller Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ukuran Avatar Ring: ${_avatarSize.toInt()}px',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        [56.0, 72.0, 88.0].map((s) {
                          final isSelected = _avatarSize == s;
                          return GestureDetector(
                            onTap: () => setState(() => _avatarSize = s),
                            child: Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF6366F1)
                                        : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                s == 56.0
                                    ? 'S'
                                    : s == 72.0
                                    ? 'M'
                                    : 'L',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _LegendItem(
                    color: Color(0xFFEC4899),
                    label: 'Unseen (Rainbow)',
                  ),
                  _LegendItem(
                    color: Color(0xFF10B981),
                    label: 'Close Friends (Green)',
                  ),
                  _LegendItem(
                    color: Color(0xFFDC2626),
                    label: 'LIVE (Red Pulse)',
                  ),
                  _LegendItem(color: Color(0xFF94A3B8), label: 'Seen (Gray)'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _StoryStatus { unseen, closeFriends, live, seen }

class _StoryUser {
  final String name;
  final String handle;
  final Color avatarColor;
  final String initials;
  final _StoryStatus status;
  final List<_StorySlide> slides;

  _StoryUser({
    required this.name,
    required this.handle,
    required this.avatarColor,
    required this.initials,
    required this.status,
    required this.slides,
  });
}

class _StorySlide {
  final String title;
  final String description;
  final Color color1;
  final Color color2;
  final IconData icon;

  _StorySlide({
    required this.title,
    required this.description,
    required this.color1,
    required this.color2,
    required this.icon,
  });
}

class _StoryAvatarRing extends StatefulWidget {
  final _StoryUser user;
  final double size;

  const _StoryAvatarRing({required this.user, required this.size});

  @override
  State<_StoryAvatarRing> createState() => _StoryAvatarRingState();
}

class _StoryAvatarRingState extends State<_StoryAvatarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (widget.user.status != _StoryStatus.seen) {
      _rotateController.repeat();
    }
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  List<Color> _getRingColors() {
    switch (widget.user.status) {
      case _StoryStatus.unseen:
        return const [
          Color(0xFFF59E0B),
          Color(0xFFEC4899),
          Color(0xFF8B5CF6),
          Color(0xFF3B82F6),
          Color(0xFFF59E0B),
        ];
      case _StoryStatus.closeFriends:
        return const [
          Color(0xFF10B981),
          Color(0xFF34D399),
          Color(0xFF059669),
          Color(0xFF10B981),
        ];
      case _StoryStatus.live:
        return const [
          Color(0xFFDC2626),
          Color(0xFFEF4444),
          Color(0xFFF87171),
          Color(0xFFDC2626),
        ];
      case _StoryStatus.seen:
        return [Colors.grey.shade300, Colors.grey.shade400];
    }
  }

  @override
  Widget build(BuildContext context) {
    final ringColors = _getRingColors();
    final isLive = widget.user.status == _StoryStatus.live;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Outer Gradient Animated Ring
        RotationTransition(
          turns:
              widget.user.status != _StoryStatus.seen
                  ? _rotateController
                  : const AlwaysStoppedAnimation(0),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(colors: ringColors),
            ),
          ),
        ),

        // Inner White Gap Border
        Container(
          width: widget.size - 5,
          height: widget.size - 5,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),

        // Inner Avatar Image / Circle
        Container(
          width: widget.size - 10,
          height: widget.size - 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.user.avatarColor,
            boxShadow: [
              BoxShadow(
                color: widget.user.avatarColor.withValues(alpha: 0.3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.user.initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: widget.size * 0.35,
              ),
            ),
          ),
        ),

        // LIVE Badge
        if (isLive)
          Positioned(
            bottom: -3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// FULLSCREEN STORY VIEWER DIALOG
// ---------------------------------------------------------------------------
class _StoryViewerDialog extends StatefulWidget {
  final _StoryUser user;

  const _StoryViewerDialog({required this.user});

  @override
  State<_StoryViewerDialog> createState() => _StoryViewerDialogState();
}

class _StoryViewerDialogState extends State<_StoryViewerDialog> {
  int _currentSlideIndex = 0;
  double _progress = 0.0;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startStoryTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStoryTimer() {
    _timer?.cancel();
    _progress = 0.0;
    const tick = Duration(milliseconds: 50);
    const totalDuration = Duration(seconds: 4);
    final increment = tick.inMilliseconds / totalDuration.inMilliseconds;

    _timer = Timer.periodic(tick, (t) {
      if (!_isPaused) {
        setState(() {
          _progress += increment;
          if (_progress >= 1.0) {
            _nextSlide();
          }
        });
      }
    });
  }

  void _nextSlide() {
    if (_currentSlideIndex < widget.user.slides.length - 1) {
      setState(() {
        _currentSlideIndex++;
        _progress = 0.0;
      });
    } else {
      _timer?.cancel();
      Navigator.of(context).pop();
    }
  }

  void _prevSlide() {
    if (_currentSlideIndex > 0) {
      setState(() {
        _currentSlideIndex--;
        _progress = 0.0;
      });
    } else {
      setState(() => _progress = 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = widget.user.slides[_currentSlideIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onLongPressStart: (_) => setState(() => _isPaused = true),
          onLongPressEnd: (_) => setState(() => _isPaused = false),
          onTapDown: (details) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (details.localPosition.dx < screenWidth / 3) {
              _prevSlide();
            } else {
              _nextSlide();
            }
          },
          child: Stack(
            children: [
              // Slide Background Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [slide.color1, slide.color2],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              slide.icon,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Top Progress Bars
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: List.generate(widget.user.slides.length, (idx) {
                    double barVal = 0.0;
                    if (idx < _currentSlideIndex) {
                      barVal = 1.0;
                    } else if (idx == _currentSlideIndex) {
                      barVal = _progress;
                    }

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: barVal.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Header User Bar
              Positioned(
                top: 24,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: widget.user.avatarColor,
                      child: Text(
                        widget.user.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            widget.user.handle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Bottom Interactive Message Reply Field
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'Kirim pesan balasan...',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
