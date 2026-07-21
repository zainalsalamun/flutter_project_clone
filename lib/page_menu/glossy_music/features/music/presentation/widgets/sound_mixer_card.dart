import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/sound_preset_entity.dart';

class SoundMixerCard extends StatelessWidget {
  final SoundPresetEntity preset;
  final bool isDarkMode;
  final ValueChanged<double> onVolumeChanged;

  const SoundMixerCard({
    super.key,
    required this.preset,
    required this.isDarkMode,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = GlossyMusicTheme.getTextColor(isDarkMode);
    final Color subtextColor = GlossyMusicTheme.getSubtextColor(isDarkMode);

    return Stack(
      children: [
        // Pulsing Neon glow tied to volume
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: preset.volume * 0.45,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: preset.backgroundGradient,
                boxShadow: GlossyMusicTheme.premiumGlow(
                  preset.glowColor,
                  radius: 35,
                  opacity: 0.6,
                ),
              ),
            ),
          ),
        ),

        // Glassmorphic main card
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          borderRadius: BorderRadius.circular(22),
          opacity: isDarkMode ? 0.08 : 0.4,
          gradient: GlossyMusicTheme.getCardGradient(isDarkMode),
          border: GlossyMusicTheme.getCardBorder(isDarkMode),
          boxShadow: GlossyMusicTheme.getCardShadow(isDarkMode),
          child: Row(
            children: [
              // Icon with glowing container
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: preset.volume > 0.05
                      ? preset.backgroundGradient
                      : LinearGradient(
                          colors: isDarkMode
                              ? [Colors.white10, Colors.white24]
                              : [Colors.black12, Colors.black26],
                        ),
                  boxShadow: preset.volume > 0.05
                      ? GlossyMusicTheme.premiumGlow(preset.glowColor, radius: 10, opacity: 0.5)
                      : [],
                ),
                child: Icon(
                  preset.icon,
                  color: preset.volume > 0.05
                      ? Colors.white
                      : (isDarkMode ? Colors.white38 : Colors.black45),
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              // Title and Volume Slider
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          preset.name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          "${(preset.volume * 100).toInt()}%",
                          style: TextStyle(
                            color: preset.volume > 0.05
                                ? preset.glowColor
                                : subtextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Custom Glass Slider
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        activeTrackColor: isDarkMode ? Colors.white70 : const Color(0xFF140D26),
                        inactiveTrackColor: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.08),
                        thumbColor: preset.glowColor,
                        overlayColor: preset.glowColor.withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: SizedBox(
                        height: 24,
                        child: Slider(
                          value: preset.volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: onVolumeChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
