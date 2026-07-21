import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';

class VinylPlayer extends StatefulWidget {
  final bool isPlaying;
  final bool isDarkMode;
  final String title;
  final String artist;

  const VinylPlayer({
    super.key,
    required this.isPlaying,
    required this.isDarkMode,
    required this.title,
    required this.artist,
  });

  @override
  State<VinylPlayer> createState() => _VinylPlayerState();
}

class _VinylPlayerState extends State<VinylPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    if (widget.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VinylPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = GlossyMusicTheme.getTextColor(widget.isDarkMode);
    final Color subtextColor = GlossyMusicTheme.getSubtextColor(widget.isDarkMode);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Spinning Holographic Disk
        Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Outer Glow ring
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: widget.isPlaying
                    ? GlossyMusicTheme.premiumGlow(
                        GlossyMusicTheme.neonPurple,
                        radius: 40,
                        opacity: 0.25,
                      )
                    : [],
              ),
            ),

            // Neon cyan orbital path
            Container(
              width: 234,
              height: 234,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: GlossyMusicTheme.neonCyan.withOpacity(widget.isPlaying ? 0.35 : 0.1),
                  width: 1.5,
                ),
              ),
            ),

            // Rotating Core Disc
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Matte record plate with light ridges
                  Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.isDarkMode ? const Color(0xFF1C1335) : const Color(0xFFE4E9F5),
                          widget.isDarkMode ? const Color(0xFF0F0B1E) : const Color(0xFFD6DFEC),
                          widget.isDarkMode ? const Color(0xFF06030A) : const Color(0xFFC0CCDF),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(widget.isDarkMode ? 0.15 : 0.4),
                        width: 2,
                      ),
                    ),
                  ),

                  // Grooves details
                  ...List.generate(4, (index) {
                    final size = 210.0 - (index * 32.0);
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (widget.isDarkMode ? Colors.white : Colors.black)
                              .withOpacity(0.04 * (index + 1)),
                          width: 0.8,
                        ),
                      ),
                    );
                  }),

                  // Glowing center artwork (Glass Card style)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: GlossyMusicTheme.cyberDawnGradient,
                      boxShadow: GlossyMusicTheme.premiumGlow(
                        GlossyMusicTheme.neonPink,
                        radius: 15,
                        opacity: widget.isPlaying ? 0.5 : 0.15,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isDarkMode ? Colors.black38 : Colors.white60,
                            ),
                            child: Icon(
                              Icons.music_note_rounded,
                              color: widget.isDarkMode ? Colors.white70 : const Color(0xFF140D26),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Track Information Text with fading effect
        Text(
          widget.title,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.artist,
          style: TextStyle(
            color: subtextColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
