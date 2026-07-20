import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../state/music_notifier.dart';

class AiComposerView extends StatefulWidget {
  final MusicNotifier notifier;

  const AiComposerView({
    super.key,
    required this.notifier,
  });

  @override
  State<AiComposerView> createState() => _AiComposerViewState();
}

class _AiComposerViewState extends State<AiComposerView> {
  final TextEditingController _promptController = TextEditingController();
  int _loadingStep = 0;
  final List<String> _simulatedSteps = [
    "Menginisialisasi Jaringan Syaraf Musik...",
    "Menganalisis gelombang frekuensi santai...",
    "Menyintesis ketukan dasar & bassline...",
    "Menyinkronkan efek alam ambient...",
    "Merender track audio esensi penuh..."
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _triggerGeneration() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    // Start simulation steps
    setState(() {
      _loadingStep = 0;
    });

    _animateProgress();
    widget.notifier.generateAiMusic(prompt);
    _promptController.clear();
    FocusScope.of(context).unfocus();
  }

  void _animateProgress() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        _loadingStep = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.notifier.isDarkMode;
    final Color textColor = GlossyMusicTheme.getTextColor(isDark);
    final Color subtextColor = GlossyMusicTheme.getSubtextColor(isDark);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          Text(
            "Komposer AI",
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Rancang track frekuensi audio kustom Anda",
            style: TextStyle(
              color: subtextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          // Core Prompt Box (Glassmorphism card)
          GlassCard(
            padding: const EdgeInsets.all(18),
            borderRadius: BorderRadius.circular(26),
            opacity: isDark ? 0.06 : 0.45,
            gradient: GlossyMusicTheme.getCardGradient(isDark),
            border: GlossyMusicTheme.getCardBorder(isDark),
            boxShadow: GlossyMusicTheme.getCardShadow(isDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlossyMusicTheme.neonPink.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: GlossyMusicTheme.neonPink,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Pencipta Musik AI",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                
                // Prompt text field inside premium glass outline
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black12 : Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black12,
                      width: 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: TextField(
                    controller: _promptController,
                    style: TextStyle(color: textColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Cth: Ketukan lo-fi hujan rileks...",
                      hintStyle: TextStyle(color: subtextColor.withOpacity(0.6), fontSize: 13),
                      border: InputBorder.none,
                    ),
                    maxLines: 2,
                  ),
                ),
                
                const SizedBox(height: 14),
                
                // Glowing Generate Button
                GestureDetector(
                  onTap: widget.notifier.isGenerating ? null : _triggerGeneration,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: GlossyMusicTheme.cyberDawnGradient,
                      boxShadow: GlossyMusicTheme.premiumGlow(
                        GlossyMusicTheme.neonPink,
                        radius: 12,
                        opacity: widget.notifier.isGenerating ? 0.2 : 0.45,
                      ),
                    ),
                    child: Center(
                      child: widget.notifier.isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              "Rancang Melodi AI",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Loading Progress Card (Shown when generating)
          if (widget.notifier.isGenerating)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: widget.notifier.isGenerating ? 1.0 : 0.0,
              child: GlassCard(
                padding: const EdgeInsets.all(18),
                borderRadius: BorderRadius.circular(24),
                opacity: 0.1,
                border: Border.all(color: GlossyMusicTheme.neonCyan.withOpacity(0.3)),
                boxShadow: GlossyMusicTheme.premiumGlow(GlossyMusicTheme.neonCyan, radius: 15, opacity: 0.15),
                child: Column(
                  children: [
                    // Spinning Holographic Ring
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        valueColor: AlwaysStoppedAnimation(GlossyMusicTheme.neonCyan),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Menciptakan Audio AI...",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _simulatedSteps[_loadingStep],
                      style: TextStyle(
                        color: GlossyMusicTheme.neonCyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Generated Tracks history section
          Text(
            "Koleksi Track Anda",
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 14),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.notifier.aiTracks.length,
            itemBuilder: (context, index) {
              final track = widget.notifier.aiTracks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  borderRadius: BorderRadius.circular(18),
                  opacity: isDark ? 0.04 : 0.35,
                  gradient: GlossyMusicTheme.getCardGradient(isDark),
                  border: GlossyMusicTheme.getCardBorder(isDark),
                  child: Row(
                    children: [
                      // Glowing vinyl icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlossyMusicTheme.neonPurple.withOpacity(0.12),
                        ),
                        child: const Icon(
                          Icons.album_outlined,
                          color: GlossyMusicTheme.neonPurple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Track details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track["result"]!,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              track["prompt"]!,
                              style: TextStyle(
                                color: subtextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Play Track Button
                      GestureDetector(
                        onTap: () => widget.notifier.selectTrack(
                          track["result"]!,
                          "AI Generated Track",
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: textColor.withOpacity(0.05),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: GlossyMusicTheme.neonCyan,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
