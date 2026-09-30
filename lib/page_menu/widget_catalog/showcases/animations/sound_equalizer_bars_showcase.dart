import 'dart:math' as math;
import 'package:flutter/material.dart';

class SoundEqualizerBarsShowcase extends StatefulWidget {
  const SoundEqualizerBarsShowcase({super.key});

  @override
  State<SoundEqualizerBarsShowcase> createState() =>
      _SoundEqualizerBarsShowcaseState();
}

class _SoundEqualizerBarsShowcaseState extends State<SoundEqualizerBarsShowcase>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  int _selectedPresetIndex = 0; // 0: EDM, 1: Bass Boost, 2: Vocal, 3: Flat

  late AnimationController _spectrumController;
  final math.Random _random = math.Random();

  // 16-channel frequency levels (0.0 to 1.0) and peak hold caps
  final List<double> _channelLevels = List.filled(16, 0.0);
  final List<double> _peakHoldCaps = List.filled(16, 0.0);

  final List<String> _presets = [
    'EDM / Dance',
    'Bass Boost',
    'Vocal Clear',
    'Flat',
  ];

  final List<String> _freqLabels = [
    '60',
    '125',
    '250',
    '500',
    '1k',
    '2k',
    '4k',
    '8k',
    '16k',
  ];

  @override
  void initState() {
    super.initState();
    _spectrumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(_updateSpectrum);
    _spectrumController.repeat();
  }

  @override
  void dispose() {
    _spectrumController.dispose();
    super.dispose();
  }

  void _updateSpectrum() {
    if (!mounted) return;

    final t = DateTime.now().millisecondsSinceEpoch / 250.0;

    for (int i = 0; i < _channelLevels.length; i++) {
      if (!_isPlaying) {
        _channelLevels[i] = (_channelLevels[i] * 0.85).clamp(0.0, 1.0);
        _peakHoldCaps[i] = (_peakHoldCaps[i] * 0.9).clamp(0.0, 1.0);
        continue;
      }

      // Base curve from preset
      double baseMultiplier = 1.0;
      if (_selectedPresetIndex == 0) {
        // EDM / V-Shape
        baseMultiplier = (i < 4 || i > 11) ? 1.3 : 0.8;
      } else if (_selectedPresetIndex == 1) {
        // Bass Boost
        baseMultiplier = (i < 5) ? 1.5 : 0.6;
      } else if (_selectedPresetIndex == 2) {
        // Vocal Clarity
        baseMultiplier = (i >= 5 && i <= 10) ? 1.4 : 0.7;
      }

      // Harmonic sinusoidal dancing noise
      final harmonic1 = math.sin(t * 1.5 + (i * 0.6)) * 0.35;
      final harmonic2 = math.cos(t * 2.8 - (i * 0.4)) * 0.25;
      final noise = (_random.nextDouble() * 0.2) - 0.1;

      final target = ((0.55 + harmonic1 + harmonic2 + noise) * baseMultiplier)
          .clamp(0.08, 1.0);

      _channelLevels[i] = target;

      // Update falling peak hold cap
      if (target >= _peakHoldCaps[i]) {
        _peakHoldCaps[i] = target;
      } else {
        _peakHoldCaps[i] = (_peakHoldCaps[i] - 0.025).clamp(0.0, 1.0);
      }
    }

    setState(() {});
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. EQUALIZER SPECTRUM STAGE ----------------
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
            children: [
              // Track Info & Master VU Header
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.graphic_eq_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cyberpunk Synthwave 2026',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'FLAC 96kHz / 24-bit • 16-Band Realtime DSP',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: const Color(0xFF6366F1),
                      size: 32,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 16-Channel Segmented LED Spectrum Canvas
              SizedBox(
                height: 140,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _EqualizerBarsPainter(
                    levels: _channelLevels,
                    peakCaps: _peakHoldCaps,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Frequency Legend Scale (60Hz to 16kHz)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    _freqLabels.map((f) {
                      return Text(
                        f,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 8.5,
                          fontFamily: 'monospace',
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. EQUALIZER PRESET CHIPS BAR ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune_rounded, size: 16, color: Color(0xFF6366F1)),
                  SizedBox(width: 6),
                  Text(
                    'Preset Kurva Frekuensi DSP:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Presets Choice Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_presets.length, (idx) {
                    final isSel = _selectedPresetIndex == idx;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_presets[idx]),
                        selected: isSel,
                        selectedColor: const Color(0xFF6366F1),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : const Color(0xFF334155),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedPresetIndex = idx);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CUSTOM PAINTER FOR MULTI-SEGMENT LED EQUALIZER BARS & PEAK HOLD CAPS
// ---------------------------------------------------------------------------
class _EqualizerBarsPainter extends CustomPainter {
  final List<double> levels;
  final List<double> peakCaps;

  _EqualizerBarsPainter({required this.levels, required this.peakCaps});

  @override
  void paint(Canvas canvas, Size size) {
    const segmentCount = 14;
    final channelCount = levels.length;
    final slotWidth = size.width / channelCount;
    final barWidth = slotWidth * 0.65;
    const segmentGap = 2.0;

    final totalHeight = size.height;
    final segmentHeight = (totalHeight / segmentCount) - segmentGap;

    for (int col = 0; col < channelCount; col++) {
      final level = levels[col];
      final peak = peakCaps[col];
      final activeSegments = (level * segmentCount).round();
      final peakSegment = (peak * segmentCount).round().clamp(1, segmentCount);

      final barLeft = (col * slotWidth) + ((slotWidth - barWidth) / 2);

      // 1. Draw 14 LED segments
      for (int seg = 0; seg < segmentCount; seg++) {
        final segY = totalHeight - ((seg + 1) * (segmentHeight + segmentGap));
        final isActive = seg < activeSegments;

        Color segColor;
        if (seg < 8) {
          segColor = const Color(0xFF10B981); // Green Normal
        } else if (seg < 11) {
          segColor = const Color(0xFFF59E0B); // Yellow Warning
        } else {
          segColor = const Color(0xFFEF4444); // Red Peak
        }

        final paint =
            Paint()
              ..color =
                  isActive
                      ? segColor
                      : segColor.withValues(alpha: 0.1) // Dim unlit segment
              ..style = PaintingStyle.fill;

        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(barLeft, segY, barWidth, segmentHeight),
          const Radius.circular(1.5),
        );
        canvas.drawRRect(rrect, paint);
      }

      // 2. Draw Falling Peak Hold Cap Line
      final peakY = totalHeight - (peakSegment * (segmentHeight + segmentGap));
      final peakPaint =
          Paint()
            ..color = const Color(0xFF00E5FF)
            ..style = PaintingStyle.fill;

      final capRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barLeft, peakY, barWidth, 2.5),
        const Radius.circular(1),
      );
      canvas.drawRRect(capRRect, peakPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EqualizerBarsPainter oldDelegate) => true;
}
