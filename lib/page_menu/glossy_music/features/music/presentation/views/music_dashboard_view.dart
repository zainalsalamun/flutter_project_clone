import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../state/music_notifier.dart';
import '../widgets/vinyl_player.dart';
import '../widgets/equalizer_visualizer.dart';
import '../widgets/sound_mixer_card.dart';

class MusicDashboardView extends StatelessWidget {
  final MusicNotifier notifier;

  const MusicDashboardView({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = notifier.isDarkMode;
    final Color textColor = GlossyMusicTheme.getTextColor(isDark);
    final Color subtextColor = GlossyMusicTheme.getSubtextColor(isDark);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Studio Ambient",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Ciptakan ruang fokus personal Anda",
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Theme Switcher Button
              GestureDetector(
                onTap: notifier.toggleTheme,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: textColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Central Player (Vinyl disk and equalizer)
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            borderRadius: BorderRadius.circular(28),
            opacity: isDark ? 0.05 : 0.45,
            gradient: GlossyMusicTheme.getCardGradient(isDark),
            border: GlossyMusicTheme.getCardBorder(isDark),
            boxShadow: GlossyMusicTheme.getCardShadow(isDark),
            child: Column(
              children: [
                // Animated Spinning Vinyl
                VinylPlayer(
                  isPlaying: notifier.isPlaying,
                  isDarkMode: isDark,
                  title: notifier.currentTrackTitle,
                  artist: notifier.currentArtist,
                ),

                const SizedBox(height: 18),

                // Live animated waveform
                EqualizerVisualizer(isPlaying: notifier.isPlaying),

                const SizedBox(height: 12),

                // Media Action controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Skip Previous
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded),
                      color: textColor.withOpacity(0.6),
                      iconSize: 32,
                      onPressed: () {},
                    ),

                    const SizedBox(width: 12),

                    // Floating Glass Play button
                    GestureDetector(
                      onTap: notifier.togglePlay,
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlossyMusicTheme.cyberDawnGradient,
                          boxShadow: GlossyMusicTheme.premiumGlow(
                            GlossyMusicTheme.neonPink,
                            radius: notifier.isPlaying ? 20 : 12,
                            opacity: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            notifier.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Skip Next
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      color: textColor.withOpacity(0.6),
                      iconSize: 32,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Ambient soundscapes Mixer Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Suara Atmosfer",
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                "Campur Preset",
                style: TextStyle(
                  color: GlossyMusicTheme.neonCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mixer List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifier.presets.length,
            itemBuilder: (context, index) {
              final preset = notifier.presets[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SoundMixerCard(
                  preset: preset,
                  isDarkMode: isDark,
                  onVolumeChanged: (value) =>
                      notifier.updateVolume(preset.id, value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
