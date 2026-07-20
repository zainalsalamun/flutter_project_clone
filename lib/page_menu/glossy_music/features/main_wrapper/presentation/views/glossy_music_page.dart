import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../music/presentation/state/music_notifier.dart';
import '../../../music/presentation/views/music_dashboard_view.dart';
import '../../../music/presentation/views/ai_composer_view.dart';

class GlossyMusicPage extends StatefulWidget {
  const GlossyMusicPage({super.key});

  @override
  State<GlossyMusicPage> createState() => _GlossyMusicPageState();
}

class _GlossyMusicPageState extends State<GlossyMusicPage> with SingleTickerProviderStateMixin {
  late MusicNotifier _notifier;
  int _currentIndex = 0;
  
  // Animation properties for floating glowing background bubbles
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();
    _notifier = MusicNotifier();
    
    // Slow pulsation for background neon bubbles (wow factor!)
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    
    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    // Attach listener to trigger rebuild when theme/play changes
    _notifier.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChange);
    _notifier.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = _notifier.isDarkMode;
    
    return Scaffold(
      backgroundColor: GlossyMusicTheme.getBackgroundColor(isDark),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Glow Particle 1 (Pulsating Hot Pink Blob)
          AnimatedBuilder(
            animation: _bubbleAnimation,
            builder: (context, child) {
              final val = _bubbleAnimation.value;
              return Positioned(
                top: -50 + (val * 100),
                left: -30 + (val * 50),
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        GlossyMusicTheme.neonPink.withOpacity(isDark ? 0.18 : 0.12),
                        GlossyMusicTheme.neonPink.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Background Glow Particle 2 (Pulsating Cyber Cyan Blob)
          AnimatedBuilder(
            animation: _bubbleAnimation,
            builder: (context, child) {
              final val = _bubbleAnimation.value;
              return Positioned(
                bottom: 100 - (val * 100),
                right: -60 - (val * 50),
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        GlossyMusicTheme.neonCyan.withOpacity(isDark ? 0.18 : 0.10),
                        GlossyMusicTheme.neonCyan.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Background Glow Particle 3 (Static Purple Blob in center)
          Positioned(
            top: 250,
            left: 100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GlossyMusicTheme.neonPurple.withOpacity(isDark ? 0.12 : 0.08),
                    GlossyMusicTheme.neonPurple.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main View Content with safe area
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: [
                MusicDashboardView(notifier: _notifier),
                AiComposerView(notifier: _notifier),
              ],
            ),
          ),

          // Floating Glass Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderRadius: BorderRadius.circular(24),
              opacity: isDark ? 0.06 : 0.45,
              gradient: GlossyMusicTheme.getCardGradient(isDark),
              border: GlossyMusicTheme.getCardBorder(isDark),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : const Color(0xFF5A4D78))
                      .withOpacity(isDark ? 0.45 : 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    index: 0,
                    icon: Icons.graphic_eq_rounded,
                    label: "Studio",
                    isDark: isDark,
                  ),
                  _navItem(
                    index: 1,
                    icon: Icons.auto_awesome_rounded,
                    label: "Komposer",
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final Color activeColor = GlossyMusicTheme.neonCyan;
    final Color inactiveColor = GlossyMusicTheme.getSubtextColor(isDark).withOpacity(0.7);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04))
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? GlossyMusicTheme.getTextColor(isDark)
                    : inactiveColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
