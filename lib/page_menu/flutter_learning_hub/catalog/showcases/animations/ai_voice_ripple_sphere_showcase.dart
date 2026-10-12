import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AiVoiceRippleSphereShowcase extends StatefulWidget {
  const AiVoiceRippleSphereShowcase({super.key});

  @override
  State<AiVoiceRippleSphereShowcase> createState() =>
      _AiVoiceRippleSphereShowcaseState();
}

enum _AiVoiceState { idle, listening, thinking, speaking }

class _AiVoiceRippleSphereShowcaseState
    extends State<AiVoiceRippleSphereShowcase>
    with SingleTickerProviderStateMixin {
  _AiVoiceState _state = _AiVoiceState.idle;
  late AnimationController _animController;
  String _transcriptText =
      'Tekan tombol mikrofon untuk mulai berbicara dengan asisten AI...';
  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _toggleMic() {
    HapticFeedback.mediumImpact();
    _simulationTimer?.cancel();

    if (_state == _AiVoiceState.idle) {
      // Transition: Listening -> Thinking -> Speaking -> Idle
      setState(() {
        _state = _AiVoiceState.listening;
        _transcriptText =
            'Mendengarkan suara Anda: "Bagaimana cara kerja AI Agent?"';
      });

      _simulationTimer = Timer(const Duration(milliseconds: 2500), () {
        if (!mounted) return;
        setState(() {
          _state = _AiVoiceState.thinking;
          _transcriptText = 'Memproses konteks & menyusun tanggapan...';
        });

        _simulationTimer = Timer(const Duration(milliseconds: 2000), () {
          if (!mounted) return;
          setState(() {
            _state = _AiVoiceState.speaking;
            _transcriptText =
                'AI Agent adalah sistem otonom yang mampu menerima tujuan, merencanakan langkah secara mandiri, dan mengeksekusi alat untuk menyelesaikan tugas.';
          });

          _simulationTimer = Timer(const Duration(milliseconds: 4000), () {
            if (!mounted) return;
            setState(() {
              _state = _AiVoiceState.idle;
              _transcriptText = 'Sesi selesai. Tekan mic untuk bertanya lagi.';
            });
          });
        });
      });
    } else {
      setState(() {
        _state = _AiVoiceState.idle;
        _transcriptText = 'Percakapan dihentikan.';
      });
    }
  }

  void _forceState(_AiVoiceState state) {
    _simulationTimer?.cancel();
    setState(() {
      _state = state;
      switch (state) {
        case _AiVoiceState.idle:
          _transcriptText = 'Mode Idle: Menunggu input suara.';
          break;
        case _AiVoiceState.listening:
          _transcriptText = 'Mode Mendengarkan: Merekam gelombang vokal...';
          break;
        case _AiVoiceState.thinking:
          _transcriptText = 'Mode Berpikir: Menganalisa query...';
          break;
        case _AiVoiceState.speaking:
          _transcriptText = 'Mode Berbicara: Menghasilkan suara sintesis AI...';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.record_voice_over_rounded,
                    color: Color(0xFF38BDF8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Voice Ripple Sphere',
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
                        'Visualisator bola suara berdenyut dinamis (Siri / Gemini Live) dengan transisi status multi-state.',
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

          const SizedBox(height: 24),

          // GLOWING AUDIO SPHERE CANVAS CONTAINER
          Container(
            width: double.infinity,
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. CUSTOM PAINTER AUDIO SPHERE & RIPPLES
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(280, 280),
                        painter: _VoiceSpherePainter(
                          progress: _animController.value,
                          state: _state,
                        ),
                      );
                    },
                  ),

                  // 2. STATE STATUS PILL (TOP CENTER)
                  Positioned(
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _getStateColor(_state)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStateColor(_state),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _state.name.toUpperCase(),
                            style: TextStyle(
                              color: _getStateColor(_state),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
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

          const SizedBox(height: 18),

          // LIVE TRANSCRIPT DISPLAY BOX
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.subtitles_rounded,
                      color: Color(0xFF38BDF8),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Transkrip Percakapan:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _transcriptText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // MIC TRIGGER BUTTON
          Center(
            child: GestureDetector(
              onTap: _toggleMic,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors:
                        _state != _AiVoiceState.idle
                            ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                            : [
                              const Color(0xFF38BDF8),
                              const Color(0xFF6366F1),
                            ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_state != _AiVoiceState.idle
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF38BDF8))
                          .withValues(alpha: 0.5),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _state != _AiVoiceState.idle
                      ? Icons.stop_rounded
                      : Icons.mic_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // STATE SWITCHER CHIPS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                _AiVoiceState.values.map((st) {
                  final isSel = _state == st;
                  return ChoiceChip(
                    label: Text(st.name.toUpperCase()),
                    selected: isSel,
                    onSelected: (val) {
                      if (val) _forceState(st);
                    },
                    selectedColor: _getStateColor(st),
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSel ? Colors.black : Colors.white70,
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(_AiVoiceState state) {
    switch (state) {
      case _AiVoiceState.idle:
        return const Color(0xFF64748B);
      case _AiVoiceState.listening:
        return const Color(0xFF38BDF8);
      case _AiVoiceState.thinking:
        return const Color(0xFFFACC15);
      case _AiVoiceState.speaking:
        return const Color(0xFFEC4899);
    }
  }
}

class _VoiceSpherePainter extends CustomPainter {
  final double progress;
  final _AiVoiceState state;

  _VoiceSpherePainter({required this.progress, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Concentric Ripple Rings (Listening / Speaking)
    if (state == _AiVoiceState.listening || state == _AiVoiceState.speaking) {
      for (int i = 1; i <= 3; i++) {
        final offsetProgress = (progress + (i * 0.3)) % 1.0;
        final rippleRadius = 45.0 + (offsetProgress * 45);
        final opacity = (1.0 - offsetProgress).clamp(0.0, 1.0) * 0.45;

        final ripplePaint =
            Paint()
              ..color = (state == _AiVoiceState.speaking
                      ? const Color(0xFFEC4899)
                      : const Color(0xFF38BDF8))
                  .withValues(alpha: opacity)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0;

        canvas.drawCircle(center, rippleRadius, ripplePaint);
      }
    }

    // 2. Orbiting Thinking Ring (Thinking state)
    if (state == _AiVoiceState.thinking) {
      final ringAngle = progress * math.pi * 2;
      final ringPaint =
          Paint()
            ..color = const Color(0xFFFACC15).withValues(alpha: 0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(ringAngle);
      canvas.drawOval(const Rect.fromLTWH(-60, -25, 120, 50), ringPaint);
      canvas.restore();
    }

    // 3. Ambient Glow Halo
    final baseRadius =
        (state == _AiVoiceState.speaking)
            ? 50.0 + (math.sin(progress * math.pi * 4) * 6)
            : (state == _AiVoiceState.listening)
            ? 46.0 + (math.sin(progress * math.pi * 2) * 3)
            : 42.0;

    final glowPaint =
        Paint()
          ..color = _getCoreColor(state).withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, baseRadius + 14, glowPaint);

    // 4. Core Sphere with Radial Gradient
    final coreGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 0.85,
      colors: _getGradientColors(state),
    );

    final corePaint =
        Paint()
          ..shader = coreGradient.createShader(
            Rect.fromCircle(center: center, radius: baseRadius),
          );

    canvas.drawCircle(center, baseRadius, corePaint);

    // 5. Specular Gloss Reflection
    final glossPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(
      Offset(center.dx - (baseRadius * 0.35), center.dy - (baseRadius * 0.35)),
      baseRadius * 0.25,
      glossPaint,
    );
  }

  Color _getCoreColor(_AiVoiceState state) {
    switch (state) {
      case _AiVoiceState.idle:
        return const Color(0xFF6366F1);
      case _AiVoiceState.listening:
        return const Color(0xFF38BDF8);
      case _AiVoiceState.thinking:
        return const Color(0xFFFACC15);
      case _AiVoiceState.speaking:
        return const Color(0xFFEC4899);
    }
  }

  List<Color> _getGradientColors(_AiVoiceState state) {
    switch (state) {
      case _AiVoiceState.idle:
        return const [Color(0xFF818CF8), Color(0xFF4F46E5), Color(0xFF312E81)];
      case _AiVoiceState.listening:
        return const [Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFF0C4A6E)];
      case _AiVoiceState.thinking:
        return const [Color(0xFFFDE047), Color(0xFFEAB308), Color(0xFF78350F)];
      case _AiVoiceState.speaking:
        return const [Color(0xFFF472B6), Color(0xFFDB2777), Color(0xFF701A75)];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
