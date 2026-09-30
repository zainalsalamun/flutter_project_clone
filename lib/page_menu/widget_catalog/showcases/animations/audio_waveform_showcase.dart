import 'dart:math' as math;
import 'package:flutter/material.dart';

class AudioWaveformShowcase extends StatefulWidget {
  const AudioWaveformShowcase({super.key});

  @override
  State<AudioWaveformShowcase> createState() => _AudioWaveformShowcaseState();
}

class _AudioWaveformShowcaseState extends State<AudioWaveformShowcase>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _controller;
  double _playbackProgress = 0.42;

  final List<double> _waveformHeights = const [
    0.3,
    0.6,
    0.4,
    0.8,
    0.9,
    0.5,
    0.7,
    1.0,
    0.6,
    0.8,
    0.4,
    0.7,
    0.9,
    0.3,
    0.6,
    0.8,
    0.5,
    0.9,
    0.7,
    0.4,
    0.6,
    0.8,
    0.5,
    0.3,
    0.7,
    0.9,
    0.6,
    0.4,
    0.8,
    0.5,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Voice Note Bubble
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF6366F1),
                    child: Icon(
                      Icons.mic_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Project Voice Memo.m4a',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Recorded 2 mins ago',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Player Bar
              Row(
                children: [
                  // Play/Pause Button
                  GestureDetector(
                    onTap: _togglePlay,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Waveform visualizer with tap/drag scrub
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanUpdate: (details) {
                            final localX = details.localPosition.dx;
                            setState(() {
                              _playbackProgress = (localX /
                                      constraints.maxWidth)
                                  .clamp(0.0, 1.0);
                            });
                          },
                          onTapDown: (details) {
                            final localX = details.localPosition.dx;
                            setState(() {
                              _playbackProgress = (localX /
                                      constraints.maxWidth)
                                  .clamp(0.0, 1.0);
                            });
                          },
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return SizedBox(
                                height: 38,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    _waveformHeights.length,
                                    (index) {
                                      final baseHeight =
                                          _waveformHeights[index];
                                      // Add live oscillation wave when playing
                                      final waveOffset =
                                          _isPlaying
                                              ? math.sin(
                                                    (_controller.value *
                                                            2 *
                                                            math.pi) +
                                                        (index * 0.4),
                                                  ) *
                                                  0.25
                                              : 0.0;
                                      final normalizedHeight = (baseHeight +
                                              waveOffset)
                                          .clamp(0.2, 1.0);

                                      final isPlayed =
                                          (index / _waveformHeights.length) <=
                                          _playbackProgress;

                                      return Container(
                                        width: 3,
                                        height: 38 * normalizedHeight,
                                        decoration: BoxDecoration(
                                          color:
                                              isPlayed
                                                  ? const Color(0xFF6366F1)
                                                  : Colors.white.withValues(
                                                    alpha: 0.25,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Duration Stamp
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '01:14',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  Text(
                    '02:48',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
