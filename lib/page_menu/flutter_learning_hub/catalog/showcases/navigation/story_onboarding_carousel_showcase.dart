import 'dart:math' as math;
import 'package:flutter/material.dart';

class StoryOnboardingCarouselShowcase extends StatefulWidget {
  const StoryOnboardingCarouselShowcase({super.key});

  @override
  State<StoryOnboardingCarouselShowcase> createState() =>
      _StoryOnboardingCarouselShowcaseState();
}

class _StorySlideData {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;
  final String badgeText;

  const _StorySlideData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    required this.badgeText,
  });
}

class _StoryOnboardingCarouselShowcaseState
    extends State<StoryOnboardingCarouselShowcase>
    with SingleTickerProviderStateMixin {
  final List<_StorySlideData> _slides = const [
    _StorySlideData(
      title: 'Selamat Datang di NalTech UI',
      subtitle:
          'Koleksi komponen antarmuka Flutter terlengkap dan paling mutakhir untuk developer modern.',
      emoji: '',
      gradient: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      badgeText: 'EKOSISTEM MODERN',
    ),
    _StorySlideData(
      title: '100% Native & Performa 60 FPS',
      subtitle:
          'Setiap widget dibangun tanpa ketergantungan paket eksternal, ringan, responsif, dan layout-safe.',
      emoji: '',
      gradient: [Color(0xFF0284C7), Color(0xFF0D9488)],
      badgeText: 'ZERO DEPENDENCY',
    ),
    _StorySlideData(
      title: 'Keamanan Biometrik & Fisika Nyata',
      subtitle:
          'Dilengkapi simulasi Face ID, pola gesture sentuh mikro, dan animasi fisika partikel presisi tinggi.',
      emoji: '',
      gradient: [Color(0xFFDB2777), Color(0xFF9333EA)],
      badgeText: 'SECURITY & PHYSICS',
    ),
    _StorySlideData(
      title: 'Siap Bangun Aplikasi Impianmu?',
      subtitle:
          'Salin kode sumber langsung ke proyekmu dan mulai ciptakan aplikasi kelas dunia hari ini!',
      emoji: '',
      gradient: [Color(0xFFD97706), Color(0xFFDC2626)],
      badgeText: 'GET STARTED',
    ),
  ];

  int _currentIndex = 0;
  late AnimationController _progressController;
  final int _storyDurationSeconds = 4;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _storyDurationSeconds),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_currentIndex < _slides.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      // Loop back to first or stop
      setState(() {
        _currentIndex = 0;
      });
      _progressController.reset();
      _progressController.forward();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      _progressController.reset();
      _progressController.forward();
    }
  }

  void _onTapDown(TapDownDetails details, double containerWidth) {
    final dx = details.localPosition.dx;
    if (dx < containerWidth * 0.3) {
      _previousStory();
    } else {
      _nextStory();
    }
  }

  void _pauseProgress() {
    setState(() {
      _isPaused = true;
    });
    _progressController.stop();
  }

  void _resumeProgress() {
    setState(() {
      _isPaused = false;
    });
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides[_currentIndex];

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_motion_rounded,
                    color: Color(0xFF7C3AED),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Insta-Story Onboarding Flow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Tap kiri untuk kembali, tap kanan untuk lanjut, tahan sentuhan untuk pause cerita.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // STORY PHONE FRAME CONTAINER
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = math.min(constraints.maxWidth, 340.0);

              return GestureDetector(
                onTapDown: (d) => _onTapDown(d, cardWidth),
                onLongPressStart: (_) => _pauseProgress(),
                onLongPressEnd: (_) => _resumeProgress(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: cardWidth,
                  height: 480,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: currentSlide.gradient,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: currentSlide.gradient.first.withValues(
                          alpha: 0.4,
                        ),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                      const BoxShadow(
                        color: Colors.black54,
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // TOP SEGMENTED PROGRESS BARS
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: List.generate(_slides.length, (index) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (context, child) {
                                    double progressValue = 0.0;
                                    if (index < _currentIndex) {
                                      progressValue = 1.0;
                                    } else if (index == _currentIndex) {
                                      progressValue = _progressController.value;
                                    }

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: LinearProgressIndicator(
                                        value: progressValue,
                                        backgroundColor: Colors.white24,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        minHeight: 3.5,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // PAUSED INDICATOR OVERLAY
                      if (_isPaused)
                        Positioned(
                          top: 32,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.pause_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Paused',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // STORY CONTENT BODY
                      Positioned.fill(
                        top: 50,
                        left: 24,
                        right: 24,
                        bottom: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // BADGE CHIP
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Text(
                                currentSlide.badgeText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // EMOJI HERO
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: Colors.white38,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  currentSlide.emoji,
                                  style: const TextStyle(fontSize: 54),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // TITLE
                            Text(
                              currentSlide.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 12),

                            // SUBTITLE
                            Text(
                              currentSlide.subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const Spacer(),

                            // LAST SLIDE CTA ACTION
                            if (_currentIndex == _slides.length - 1)
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF10B981),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Onboarding Selesai! Selamat berkreasi.',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: currentSlide.gradient.last,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Mulai Sekarang ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            else
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tap untuk melanjutkan',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white54,
                                    size: 14,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // CONTROLS & MANUAL STEPPER
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _previousStory,
                tooltip: 'Story Sebelumnya',
                icon: const Icon(
                  Icons.skip_previous_rounded,
                  color: Colors.white70,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _isPaused ? _resumeProgress : _pauseProgress,
                tooltip: _isPaused ? 'Lanjutkan' : 'Jeda',
                icon: Icon(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: const Color(0xFF7C3AED),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _nextStory,
                tooltip: 'Story Berikutnya',
                icon: const Icon(
                  Icons.skip_next_rounded,
                  color: Colors.white70,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
