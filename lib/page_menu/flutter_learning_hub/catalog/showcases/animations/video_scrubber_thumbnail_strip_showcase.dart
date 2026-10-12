import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoScrubberThumbnailStripShowcase extends StatefulWidget {
  const VideoScrubberThumbnailStripShowcase({super.key});

  @override
  State<VideoScrubberThumbnailStripShowcase> createState() =>
      _VideoScrubberThumbnailStripShowcaseState();
}

class _VideoFrameSample {
  final double timestampSeconds;
  final String title;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  const _VideoFrameSample({
    required this.timestampSeconds,
    required this.title,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });
}

class _VideoScrubberThumbnailStripShowcaseState
    extends State<VideoScrubberThumbnailStripShowcase>
    with SingleTickerProviderStateMixin {
  // Video playback duration: 180 seconds (3:00)
  static const double _totalDuration = 180.0;

  double _currentPosition = 35.0; // Current playback seconds
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  Timer? _playbackTimer;

  // Trimming Mode
  final bool _isTrimMode = false;
  double _trimStart = 15.0;
  double _trimEnd = 150.0;

  // Interactive scrubbing state
  bool _isScrubbing = false;
  double _scrubPreviewPosition = 35.0;

  late AnimationController _animController;

  final List<_VideoFrameSample> _frames = const [
    _VideoFrameSample(
      timestampSeconds: 0.0,
      title: 'Intro & Logo',
      primaryColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFF1D4ED8),
      icon: Icons.movie_filter_rounded,
    ),
    _VideoFrameSample(
      timestampSeconds: 20.0,
      title: 'Drone Flyover',
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFF047857),
      icon: Icons.flight_takeoff_rounded,
    ),
    _VideoFrameSample(
      timestampSeconds: 50.0,
      title: 'Cyber City',
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFF6D28D9),
      icon: Icons.location_city_rounded,
    ),
    _VideoFrameSample(
      timestampSeconds: 85.0,
      title: 'Action Sequence',
      primaryColor: Color(0xFFEF4444),
      secondaryColor: Color(0xFFB91C1C),
      icon: Icons.electric_bolt_rounded,
    ),
    _VideoFrameSample(
      timestampSeconds: 120.0,
      title: 'Sunset Beach',
      primaryColor: Color(0xFFF59E0B),
      secondaryColor: Color(0xFFD97706),
      icon: Icons.wb_sunny_rounded,
    ),
    _VideoFrameSample(
      timestampSeconds: 155.0,
      title: 'Credits & Outro',
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF4338CA),
      icon: Icons.flag_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  void _togglePlayPause() {
    HapticFeedback.lightImpact();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startPlayback();
      } else {
        _playbackTimer?.cancel();
      }
    });
  }

  void _startPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentPosition += 0.05 * _playbackSpeed;
        final maxPos = _isTrimMode ? _trimEnd : _totalDuration;
        final minPos = _isTrimMode ? _trimStart : 0.0;

        if (_currentPosition >= maxPos) {
          _currentPosition = minPos;
          _isPlaying = false;
          timer.cancel();
        }
      });
    });
  }

  void _seekRelative(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentPosition = (_currentPosition + delta).clamp(0.0, _totalDuration);
    });
  }

  void _seekFrame(int frameDelta) {
    // 30fps -> ~0.033s per frame
    final double timeDelta = frameDelta * (1.0 / 30.0);
    _seekRelative(timeDelta);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  String _formatTime(double seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    final int ms = ((seconds - seconds.floor()) * 100).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
  }

  _VideoFrameSample _getActiveFrame(double pos) {
    for (int i = _frames.length - 1; i >= 0; i--) {
      if (pos >= _frames[i].timestampSeconds) {
        return _frames[i];
      }
    }
    return _frames.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeFrame = _getActiveFrame(
      _isScrubbing ? _scrubPreviewPosition : _currentPosition,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Simulated Video Canvas Viewport
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: activeFrame.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dynamic Scene Background Gradient
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          activeFrame.primaryColor.withValues(alpha: 0.8),
                          activeFrame.secondaryColor,
                          const Color(0xFF090D16),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // Animated Visual Grid & Particles
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, 220),
                        painter: _VideoCanvasScenePainter(
                          progress: _animController.value,
                          isPlaying: _isPlaying,
                          icon: activeFrame.icon,
                          label: activeFrame.title,
                        ),
                      );
                    },
                  ),

                  // Video Overlay Top Badges (4K, FPS, Timecode)
                  Positioned(
                    top: 12,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _badge('4K HDR', Colors.amber),
                            const SizedBox(width: 6),
                            _badge('60 FPS', Colors.cyan),
                            if (_isTrimMode) ...[
                              const SizedBox(width: 6),
                              _badge('TRIM MODE', Colors.orange),
                            ],
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_formatTime(_currentPosition)} / ${_formatTime(_totalDuration)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Play / Pause Big Button
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38, width: 1.5),
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),

                  // Bottom Chapter Title Chip
                  Positioned(
                    bottom: 12,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            activeFrame.icon,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            activeFrame.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Playback Control Bar (Speed, Replay, Skip, Step)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // -10s
                IconButton(
                  tooltip: 'Back 10s',
                  icon: const Icon(Icons.replay_10_rounded),
                  onPressed: () => _seekRelative(-10.0),
                ),
                // -1 frame
                IconButton(
                  tooltip: 'Previous Frame',
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () => _seekFrame(-1),
                ),
                // Play/Pause
                FloatingActionButton.small(
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  onPressed: _togglePlayPause,
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                ),
                // +1 frame
                IconButton(
                  tooltip: 'Next Frame',
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () => _seekFrame(1),
                ),
                // +10s
                IconButton(
                  tooltip: 'Forward 10s',
                  icon: const Icon(Icons.forward_10_rounded),
                  onPressed: () => _seekRelative(10.0),
                ),
                // Speed dropdown
                DropdownButton<double>(
                  value: _playbackSpeed,
                  underline: const SizedBox(),
                  dropdownColor:
                      isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  items:
                      const [0.5, 1.0, 1.5, 2.0].map((s) {
                        return DropdownMenuItem<double>(
                          value: s,
                          child: Text('${s}x'),
                        );
                      }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _playbackSpeed = val);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 3. Filmstrip Thumbnail Scrubber & Trimmer Track
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isTrimMode
                          ? 'Video Trimmer Timeline'
                          : 'Filmstrip Timeline Scrubber',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatTime(_currentPosition),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filmstrip Track Container with Draggable scrubber & Floating Loupe
                LayoutBuilder(
                  builder: (context, constraints) {
                    final trackWidth = constraints.maxWidth;
                    final normPlayhead = (_currentPosition / _totalDuration)
                        .clamp(0.0, 1.0);
                    final playheadX = normPlayhead * trackWidth;

                    final normScrub = (_scrubPreviewPosition / _totalDuration)
                        .clamp(0.0, 1.0);
                    final scrubX = normScrub * trackWidth;

                    return Column(
                      children: [
                        // Floating Thumbnail Loupe Magnifier Bubble
                        SizedBox(
                          height: 52,
                          child: Stack(
                            children: [
                              Positioned(
                                left:
                                    (_isScrubbing ? scrubX : playheadX).clamp(
                                      35.0,
                                      trackWidth - 35.0,
                                    ) -
                                    35,
                                top: 0,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 150),
                                  opacity:
                                      _isScrubbing || _isPlaying ? 1.0 : 0.85,
                                  child: Container(
                                    width: 70,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: activeFrame.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.35,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          activeFrame.icon,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatTime(
                                            _isScrubbing
                                                ? _scrubPreviewPosition
                                                : _currentPosition,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Main Filmstrip Track with Gesture Detector
                        GestureDetector(
                          onHorizontalDragStart: (details) {
                            setState(() {
                              _isScrubbing = true;
                              final norm = (details.localPosition.dx /
                                      trackWidth)
                                  .clamp(0.0, 1.0);
                              _scrubPreviewPosition = norm * _totalDuration;
                              _currentPosition = _scrubPreviewPosition;
                            });
                          },
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              final norm = (details.localPosition.dx /
                                      trackWidth)
                                  .clamp(0.0, 1.0);
                              _scrubPreviewPosition = norm * _totalDuration;
                              _currentPosition = _scrubPreviewPosition;
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            setState(() {
                              _isScrubbing = false;
                              _currentPosition = _scrubPreviewPosition;
                            });
                          },
                          onTapDown: (details) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              final norm = (details.localPosition.dx /
                                      trackWidth)
                                  .clamp(0.0, 1.0);
                              _currentPosition = norm * _totalDuration;
                            });
                          },
                          child: Container(
                            height: 64,
                            width: trackWidth,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  // Filmstrip Thumbnail Frames Bar
                                  Row(
                                    children:
                                        _frames.map((f) {
                                          return Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    f.primaryColor,
                                                    f.secondaryColor,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(
                                                    f.icon,
                                                    color: Colors.white
                                                        .withValues(
                                                          alpha: 0.25,
                                                        ),
                                                    size: 24,
                                                  ),
                                                  // Sprotch sprocket holes decoration (Filmstrip aesthetic)
                                                  Positioned(
                                                    top: 2,
                                                    left: 2,
                                                    right: 2,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: List.generate(
                                                        3,
                                                        (i) => Container(
                                                          width: 4,
                                                          height: 4,
                                                          decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.6,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  1,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),

                                  // Audio Waveform Overlay at bottom of strip
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    height: 20,
                                    child: CustomPaint(
                                      painter: _AudioTrackWaveformPainter(),
                                    ),
                                  ),

                                  // Trim Selection Overlay (if Trim mode active)
                                  if (_isTrimMode) ...[
                                    Positioned(
                                      left: 0,
                                      width:
                                          (_trimStart / _totalDuration) *
                                          trackWidth,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left:
                                          (_trimEnd / _totalDuration) *
                                          trackWidth,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    // Trim In & Out active bounding border
                                    Positioned(
                                      left:
                                          (_trimStart / _totalDuration) *
                                          trackWidth,
                                      width:
                                          ((_trimEnd - _trimStart) /
                                              _totalDuration) *
                                          trackWidth,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.amber,
                                            width: 2.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  // Red Playhead Cursor Line
                                  Positioned(
                                    left: playheadX - 1.5,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 3,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(2),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.redAccent,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Trim range sliders (if trim mode active)
                if (_isTrimMode) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trim: ${_formatTime(_trimStart)} - ${_formatTime(_trimEnd)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      Text(
                        'Duration: ${_formatTime(_trimEnd - _trimStart)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_trimStart, _trimEnd),
                    min: 0.0,
                    max: _totalDuration,
                    activeColor: Colors.amber,
                    onChanged: (vals) {
                      setState(() {
                        _trimStart = vals.start;
                        _trimEnd = vals.end;
                        _currentPosition = _currentPosition.clamp(
                          _trimStart,
                          _trimEnd,
                        );
                      });
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Video Canvas Scene Background Dynamics
// -------------------------------------------------------------
class _VideoCanvasScenePainter extends CustomPainter {
  final double progress;
  final bool isPlaying;
  final IconData icon;
  final String label;

  _VideoCanvasScenePainter({
    required this.progress,
    required this.isPlaying,
    required this.icon,
    required this.label,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Floating dynamic particles
    final rnd = math.Random(42);
    final particlePaint = Paint()..color = Colors.white.withValues(alpha: 0.2);

    for (int i = 0; i < 15; i++) {
      final baseX = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final speed = 0.5 + rnd.nextDouble();
      final currentY =
          isPlaying ? (baseY - (progress * speed * 40)) % size.height : baseY;
      final radius = 1.5 + rnd.nextDouble() * 2.5;

      canvas.drawCircle(Offset(baseX, currentY), radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _VideoCanvasScenePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.isPlaying != isPlaying ||
      oldDelegate.icon != icon;
}

// -------------------------------------------------------------
// CustomPainter: Mini Audio Waveform Track
// -------------------------------------------------------------
class _AudioTrackWaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

    const int barCount = 45;
    final barWidth = size.width / barCount;
    final rnd = math.Random(1337);

    for (int i = 0; i < barCount; i++) {
      final heightFactor = 0.2 + (rnd.nextDouble() * 0.8);
      final barH = size.height * heightFactor;
      final x = i * barWidth;
      final y = size.height - barH;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 1, y, barWidth - 2, barH),
          const Radius.circular(1),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AudioTrackWaveformPainter oldDelegate) => false;
}
