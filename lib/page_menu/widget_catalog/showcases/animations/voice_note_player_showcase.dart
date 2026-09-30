import 'dart:async';
import 'package:flutter/material.dart';

class VoiceNotePlayerShowcase extends StatefulWidget {
  const VoiceNotePlayerShowcase({super.key});

  @override
  State<VoiceNotePlayerShowcase> createState() =>
      _VoiceNotePlayerShowcaseState();
}

class _VoiceNotePlayerShowcaseState extends State<VoiceNotePlayerShowcase> {
  bool _isPlaying = false;
  double _currentSeconds = 0.0;
  double _totalSeconds = 38.0;
  double _playbackSpeed = 1.0; // 1.0, 1.5, 2.0
  Timer? _playbackTimer;

  int _selectedNoteIndex = 0;

  final List<Map<String, dynamic>> _voiceNotes = [
    {
      'sender': 'Rian Dwi',
      'role': 'Product Lead',
      'title': 'Voice Note: Update Sprint & Desain',
      'duration': 38.0,
      'time': '14:24',
      'avatarColor': const Color(0xFF6366F1),
      'waveAmplitudes': [
        0.2,
        0.35,
        0.6,
        0.85,
        0.4,
        0.7,
        0.95,
        0.5,
        0.3,
        0.75,
        0.9,
        0.45,
        0.8,
        0.6,
        0.35,
        0.85,
        1.0,
        0.7,
        0.4,
        0.65,
        0.9,
        0.55,
        0.3,
        0.7,
        0.85,
        0.4,
        0.6,
        0.9,
        0.75,
        0.35,
        0.5,
        0.8,
        0.65,
        0.4,
        0.25,
        0.15,
      ],
    },
    {
      'sender': 'Siti Rahma',
      'role': 'UI Designer',
      'title': 'Voice Note: Revisi Token Warna & FAB',
      'duration': 22.0,
      'time': '14:31',
      'avatarColor': const Color(0xFF10B981),
      'waveAmplitudes': [
        0.4,
        0.7,
        0.9,
        0.5,
        0.3,
        0.8,
        0.65,
        0.4,
        0.85,
        1.0,
        0.6,
        0.45,
        0.7,
        0.9,
        0.8,
        0.35,
        0.5,
        0.85,
        0.7,
        0.4,
        0.6,
        0.95,
        0.5,
        0.3,
        0.75,
        0.6,
        0.4,
        0.8,
        0.55,
        0.35,
        0.65,
        0.4,
        0.8,
        0.5,
        0.3,
        0.2,
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadNote(0);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _loadNote(int index) {
    _playbackTimer?.cancel();
    setState(() {
      _selectedNoteIndex = index;
      _isPlaying = false;
      _currentSeconds = 0.0;
      _totalSeconds = _voiceNotes[index]['duration'] as double;
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pausePlayback();
    } else {
      _startPlayback();
    }
  }

  void _startPlayback() {
    if (_currentSeconds >= _totalSeconds) {
      _currentSeconds = 0.0;
    }

    setState(() => _isPlaying = true);
    _playbackTimer?.cancel();

    const tickMs = 50;
    _playbackTimer = Timer.periodic(const Duration(milliseconds: tickMs), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentSeconds += (tickMs / 1000) * _playbackSpeed;
        if (_currentSeconds >= _totalSeconds) {
          _currentSeconds = _totalSeconds;
          _isPlaying = false;
          timer.cancel();
        }
      });
    });
  }

  void _pausePlayback() {
    _playbackTimer?.cancel();
    setState(() => _isPlaying = false);
  }

  void _cycleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });

    if (_isPlaying) {
      _startPlayback(); // Restart timer with new speed rate
    }
  }

  void _seekToPosition(double relativeFraction) {
    final newSeconds = (relativeFraction.clamp(0.0, 1.0)) * _totalSeconds;
    setState(() {
      _currentSeconds = newSeconds;
    });
    if (_isPlaying) {
      _startPlayback();
    }
  }

  String _formatTime(double sec) {
    final m = (sec ~/ 60).toString();
    final s = (sec % 60).toInt().toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final note = _voiceNotes[_selectedNoteIndex];
    final amplitudes = note['waveAmplitudes'] as List<double>;
    final progressRatio = (_currentSeconds / _totalSeconds).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. NOTE SELECTOR TABS ----------------
        Row(
          children: List.generate(_voiceNotes.length, (idx) {
            final isSelected = _selectedNoteIndex == idx;
            final n = _voiceNotes[idx];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: idx == 0 ? 8 : 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _loadNote(idx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? (n['avatarColor'] as Color).withValues(
                                alpha: 0.12,
                              )
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? (n['avatarColor'] as Color)
                                : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: n['avatarColor'] as Color,
                          child: Text(
                            (n['sender'] as String)[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            n['sender'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected
                                      ? (n['avatarColor'] as Color)
                                      : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. VOICE NOTE MESSAGE BUBBLE ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(6),
            ),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Sender & Mic Badge
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: note['avatarColor'] as Color,
                    child: Text(
                      (note['sender'] as String)[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note['sender'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          note['role'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: (note['avatarColor'] as Color).withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic_rounded,
                          size: 13,
                          color: note['avatarColor'] as Color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Pesan Suara',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: note['avatarColor'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Player Controls & Scrubbing Waveform Row
              Row(
                children: [
                  // Play/Pause Button
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            note['avatarColor'] as Color,
                            (note['avatarColor'] as Color).withValues(
                              alpha: 0.85,
                            ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (note['avatarColor'] as Color).withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Interactive Waveform Area
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) {
                            final fraction =
                                details.localPosition.dx / constraints.maxWidth;
                            _seekToPosition(fraction);
                          },
                          onHorizontalDragUpdate: (details) {
                            final fraction =
                                details.localPosition.dx / constraints.maxWidth;
                            _seekToPosition(fraction);
                          },
                          child: SizedBox(
                            height: 38,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(amplitudes.length, (i) {
                                final barFraction = (i + 1) / amplitudes.length;
                                final isPlayed = barFraction <= progressRatio;
                                final height = (amplitudes[i] * 32).clamp(
                                  4.0,
                                  32.0,
                                );

                                return Container(
                                  width: 3.2,
                                  height: height,
                                  decoration: BoxDecoration(
                                    color:
                                        isPlayed
                                            ? (note['avatarColor'] as Color)
                                            : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Speed Multiplier Button
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _cycleSpeed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        '${_playbackSpeed}x',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Bottom Footer: Time Elapsed / Total Duration & Read Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatTime(_currentSeconds)} / ${_formatTime(_totalSeconds)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        note['time'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all_rounded,
                        size: 15,
                        color: Color(0xFF0284C7), // WhatsApp Blue Read Ticks
                      ),
                    ],
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
