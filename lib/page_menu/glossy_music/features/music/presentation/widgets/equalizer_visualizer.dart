import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';

class EqualizerVisualizer extends StatefulWidget {
  final bool isPlaying;

  const EqualizerVisualizer({
    super.key,
    required this.isPlaying,
  });

  @override
  State<EqualizerVisualizer> createState() => _EqualizerVisualizerState();
}

class _EqualizerVisualizerState extends State<EqualizerVisualizer> {
  late List<double> _heights;
  Timer? _timer;
  final math.Random _random = math.Random();
  final int _barCount = 15;

  @override
  void initState() {
    super.initState();
    _heights = List.generate(_barCount, (index) => 4.0);
    if (widget.isPlaying) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant EqualizerVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) return;
      setState(() {
        for (int i = 0; i < _barCount; i++) {
          // Bouncing between 5% and 100% of maximum height (40dp)
          _heights[i] = 4.0 + _random.nextDouble() * 36.0;
        }
      });
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() {
        // Flatline animation when paused
        _heights = List.generate(_barCount, (index) => 4.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            width: 5,
            height: _heights[index],
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: const LinearGradient(
                colors: [
                  GlossyMusicTheme.neonCyan,
                  GlossyMusicTheme.neonPurple,
                  GlossyMusicTheme.neonPink,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              boxShadow: widget.isPlaying
                  ? [
                      BoxShadow(
                        color: GlossyMusicTheme.neonCyan.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      )
                    ]
                  : [],
            ),
          );
        }),
      ),
    );
  }
}
