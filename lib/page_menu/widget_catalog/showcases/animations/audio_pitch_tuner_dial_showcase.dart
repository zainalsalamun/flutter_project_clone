import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioPitchTunerDialShowcase extends StatefulWidget {
  const AudioPitchTunerDialShowcase({super.key});

  @override
  State<AudioPitchTunerDialShowcase> createState() =>
      _AudioPitchTunerDialShowcaseState();
}

enum TunerMode { chromatic, guitar, bass, ukulele, violin }

class TunerString {
  final String note;
  final int octave;
  final double targetFrequency;
  final String label;

  const TunerString({
    required this.note,
    required this.octave,
    required this.targetFrequency,
    required this.label,
  });

  String get fullNote => '$note$octave';
}

class _AudioPitchTunerDialShowcaseState
    extends State<AudioPitchTunerDialShowcase>
    with SingleTickerProviderStateMixin {
  // Calibration & mode
  int _referenceA4 = 440; // 432, 440, 442
  TunerMode _currentMode = TunerMode.guitar;
  int _selectedStringIndex = 0;
  bool _isStrobeMode = false;

  // Pitch state
  double _currentCents = 0.0; // -50.0 to +50.0
  double _currentFrequency = 329.63; // E4
  String _detectedNote = 'E';
  int _detectedOctave = 4;
  bool _isInTune = false;

  // Waveform animation
  late AnimationController _waveController;
  Timer? _simulationTimer;
  Timer? _vibrationTimer;
  double _stringVibrationIntensity = 0.0;

  // Strobe rotation angle
  double _strobeAngle = 0.0;

  final Map<TunerMode, List<TunerString>> _instrumentPresets = {
    TunerMode.guitar: const [
      TunerString(note: 'E', octave: 2, targetFrequency: 82.41, label: '6E'),
      TunerString(note: 'A', octave: 2, targetFrequency: 110.00, label: '5A'),
      TunerString(note: 'D', octave: 3, targetFrequency: 146.83, label: '4D'),
      TunerString(note: 'G', octave: 3, targetFrequency: 196.00, label: '3G'),
      TunerString(note: 'B', octave: 3, targetFrequency: 246.94, label: '2B'),
      TunerString(note: 'E', octave: 4, targetFrequency: 329.63, label: '1E'),
    ],
    TunerMode.bass: const [
      TunerString(note: 'E', octave: 1, targetFrequency: 41.20, label: '4E'),
      TunerString(note: 'A', octave: 1, targetFrequency: 55.00, label: '3A'),
      TunerString(note: 'D', octave: 2, targetFrequency: 73.42, label: '2D'),
      TunerString(note: 'G', octave: 2, targetFrequency: 98.00, label: '1G'),
    ],
    TunerMode.ukulele: const [
      TunerString(note: 'G', octave: 4, targetFrequency: 392.00, label: '4G'),
      TunerString(note: 'C', octave: 4, targetFrequency: 261.63, label: '3C'),
      TunerString(note: 'E', octave: 4, targetFrequency: 329.63, label: '2E'),
      TunerString(note: 'A', octave: 4, targetFrequency: 440.00, label: '1A'),
    ],
    TunerMode.violin: const [
      TunerString(note: 'G', octave: 3, targetFrequency: 196.00, label: '4G'),
      TunerString(note: 'D', octave: 4, targetFrequency: 293.66, label: '3D'),
      TunerString(note: 'A', octave: 4, targetFrequency: 440.00, label: '2A'),
      TunerString(note: 'E', octave: 5, targetFrequency: 659.25, label: '1E'),
    ],
    TunerMode.chromatic: const [
      TunerString(note: 'C', octave: 4, targetFrequency: 261.63, label: 'C4'),
      TunerString(note: 'D', octave: 4, targetFrequency: 293.66, label: 'D4'),
      TunerString(note: 'E', octave: 4, targetFrequency: 329.63, label: 'E4'),
      TunerString(note: 'F', octave: 4, targetFrequency: 349.23, label: 'F4'),
      TunerString(note: 'G', octave: 4, targetFrequency: 392.00, label: 'G4'),
      TunerString(note: 'A', octave: 4, targetFrequency: 440.00, label: 'A4'),
      TunerString(note: 'B', octave: 4, targetFrequency: 493.88, label: 'B4'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      if (_isStrobeMode && mounted) {
        setState(() {
          // Rotate strobe wheel according to cents error
          _strobeAngle += (_currentCents * 0.003);
        });
      }
    });
    _waveController.repeat();

    _selectInitialString();
  }

  void _selectInitialString() {
    final list = _instrumentPresets[_currentMode]!;
    if (list.isNotEmpty) {
      _selectedStringIndex = list.length - 1; // Default top string
      _applyString(list[_selectedStringIndex]);
    }
  }

  void _applyString(TunerString s) {
    _detectedNote = s.note;
    _detectedOctave = s.octave;
    _currentFrequency = s.targetFrequency;
    _currentCents = 0.0;
    _checkInTune();
  }

  void _checkInTune() {
    final bool inTune = _currentCents.abs() <= 3.0;
    if (inTune && !_isInTune) {
      HapticFeedback.mediumImpact();
    }
    _isInTune = inTune;
  }

  void _pluckString(int index) {
    HapticFeedback.lightImpact();
    final strings = _instrumentPresets[_currentMode]!;
    if (index >= strings.length) return;

    final target = strings[index];
    setState(() {
      _selectedStringIndex = index;
      _detectedNote = target.note;
      _detectedOctave = target.octave;
      _stringVibrationIntensity = 1.0;
    });

    // Animate string attack: starts slightly off (e.g. +18 cents sharp on pluck), settles into in-tune (0 cents)
    _simulationTimer?.cancel();
    double simulatedCents = (math.Random().nextDouble() * 30 - 15);
    if (simulatedCents.abs() < 5)
      simulatedCents = 18.0; // Give a nice pluck transient

    int steps = 0;
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 60), (
      timer,
    ) {
      steps++;
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        // Damping towards in tune (0 cents)
        simulatedCents = simulatedCents * 0.92;
        if (steps > 25 || simulatedCents.abs() < 0.5) {
          simulatedCents = 0.0;
          timer.cancel();
        }
        _currentCents = simulatedCents;
        // Calculate frequency from cents deviation: f = f0 * 2^(cents/1200)
        _currentFrequency =
            target.targetFrequency * math.pow(2.0, _currentCents / 1200.0);
        _checkInTune();
        _stringVibrationIntensity = math.max(0.0, 1.0 - (steps / 25));
      });
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _simulationTimer?.cancel();
    _vibrationTimer?.cancel();
    super.dispose();
  }

  Color _getTuningColor(BuildContext context) {
    if (_isInTune) {
      return const Color(0xFF10B981); // Emerald / Green
    }
    final double absCents = _currentCents.abs();
    if (absCents < 15) {
      return const Color(0xFFF59E0B); // Amber / Yellow
    }
    return _currentCents < 0
        ? const Color(0xFF3B82F6)
        : const Color(0xFFEF4444); // Blue for flat, Red for sharp
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = _instrumentPresets[_currentMode] ?? [];
    final tuningColor = _getTuningColor(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instrument & Tuning Selector Bar
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    TunerMode.values.map((mode) {
                      final isSelected = _currentMode == mode;
                      final label =
                          mode.name[0].toUpperCase() + mode.name.substring(1);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          avatar: Icon(
                            mode == TunerMode.guitar
                                ? Icons.music_note
                                : mode == TunerMode.bass
                                ? Icons.speaker
                                : mode == TunerMode.ukulele
                                ? Icons.waves
                                : mode == TunerMode.violin
                                ? Icons.graphic_eq
                                : Icons.speed,
                            size: 16,
                            color:
                                isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                          ),
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _currentMode = mode;
                                _selectInitialString();
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Main Tuner Dial & Gauge Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                        : [Colors.white, const Color(0xFFF9FAFB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    _isInTune
                        ? const Color(0xFF10B981).withValues(alpha: 0.6)
                        : (isDark ? Colors.white10 : Colors.black12),
                width: _isInTune ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _isInTune
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: _isInTune ? 24 : 12,
                  spreadRadius: _isInTune ? 2 : 0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Calibration header badge & Strobe toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'A4=',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          DropdownButton<int>(
                            value: _referenceA4,
                            underline: const SizedBox(),
                            isDense: true,
                            dropdownColor:
                                isDark ? const Color(0xFF1F2937) : Colors.white,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            items:
                                const [432, 440, 442].map((hz) {
                                  return DropdownMenuItem<int>(
                                    value: hz,
                                    child: Text('${hz}Hz'),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _referenceA4 = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // In Tune Status Banner
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: tuningColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: tuningColor, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isInTune
                                    ? Icons.check_circle_rounded
                                    : (_currentCents < 0
                                        ? Icons.arrow_downward_rounded
                                        : Icons.arrow_upward_rounded),
                                color: tuningColor,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isInTune
                                    ? 'PERFECT IN TUNE'
                                    : (_currentCents < 0
                                        ? 'FLAT (${_currentCents.toStringAsFixed(1)}¢)'
                                        : 'SHARP (+${_currentCents.toStringAsFixed(1)}¢)'),
                                style: TextStyle(
                                  color: tuningColor,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Strobe visualizer switch
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Toggle Peterson Strobe View',
                      icon: Icon(
                        _isStrobeMode
                            ? Icons.radar_rounded
                            : Icons.speed_rounded,
                        color:
                            _isStrobeMode
                                ? theme.colorScheme.primary
                                : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isStrobeMode = !_isStrobeMode);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Gauge or Strobe Wheel Canvas
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!_isStrobeMode)
                        CustomPaint(
                          size: const Size(280, 190),
                          painter: _TunerArcPainter(
                            cents: _currentCents,
                            isInTune: _isInTune,
                            gaugeColor: tuningColor,
                            isDark: isDark,
                          ),
                        )
                      else
                        CustomPaint(
                          size: const Size(200, 190),
                          painter: _StrobeWheelPainter(
                            rotationAngle: _strobeAngle,
                            cents: _currentCents,
                            strobeColor: tuningColor,
                            isDark: isDark,
                          ),
                        ),

                      // Center Note & Octave Display
                      Positioned(
                        bottom: 18,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _detectedNote,
                                  style: TextStyle(
                                    fontSize: 58,
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                    color:
                                        _isInTune
                                            ? const Color(0xFF10B981)
                                            : theme.colorScheme.onSurface,
                                    shadows:
                                        _isInTune
                                            ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF10B981,
                                                ).withValues(alpha: 0.8),
                                                blurRadius: 18,
                                              ),
                                            ]
                                            : [],
                                  ),
                                ),
                                Text(
                                  '$_detectedOctave',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_currentFrequency.toStringAsFixed(1)} Hz',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Interactive Cent Deviation Slider (Manual Pitch Bend simulator)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Manual Pitch Simulator (Cents)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${_currentCents >= 0 ? '+' : ''}${_currentCents.toStringAsFixed(1)} ¢',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: tuningColor,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: tuningColor,
                          inactiveTrackColor:
                              isDark ? Colors.white12 : Colors.black12,
                          thumbColor: tuningColor,
                          overlayColor: tuningColor.withValues(alpha: 0.2),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _currentCents,
                          min: -50.0,
                          max: 50.0,
                          onChanged: (val) {
                            setState(() {
                              _currentCents = val;
                              final targetF =
                                  strings.isNotEmpty &&
                                          _selectedStringIndex < strings.length
                                      ? strings[_selectedStringIndex]
                                          .targetFrequency
                                      : 440.0;
                              _currentFrequency =
                                  targetF *
                                  math.pow(2.0, _currentCents / 1200.0);
                              _checkInTune();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pluckable Strings / Note Keys Board
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tap to Pluck & Tune String',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${strings.length} Strings',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Interactive string list buttons
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(strings.length, (idx) {
                    final s = strings[idx];
                    final isCurrent = _selectedStringIndex == idx;
                    return GestureDetector(
                      onTap: () => _pluckString(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 72,
                        constraints: const BoxConstraints(minWidth: 70),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isCurrent
                                  ? (_isInTune
                                      ? const Color(0xFF10B981)
                                      : theme.colorScheme.primary)
                                  : (isDark
                                      ? const Color(0xFF21262D)
                                      : const Color(0xFFF3F4F6)),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                isCurrent
                                    ? Colors.transparent
                                    : (isDark
                                        ? Colors.white12
                                        : Colors.black12),
                          ),
                          boxShadow:
                              isCurrent
                                  ? [
                                    BoxShadow(
                                      color: (_isInTune
                                              ? const Color(0xFF10B981)
                                              : theme.colorScheme.primary)
                                          .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: Column(
                          children: [
                            Text(
                              s.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    isCurrent
                                        ? Colors.white70
                                        : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.note,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color:
                                    isCurrent
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${s.targetFrequency.toStringAsFixed(1)}Hz',
                              style: TextStyle(
                                fontSize: 10,
                                color: isCurrent ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Real-time Sound Waveform Canvas Visualizer
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _AudioWaveformPainter(
                    progress: _waveController.value,
                    vibrationIntensity: _stringVibrationIntensity,
                    waveColor: tuningColor,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Semicircular Cent Needle Gauge
// -------------------------------------------------------------
class _TunerArcPainter extends CustomPainter {
  final double cents; // -50 to +50
  final bool isInTune;
  final Color gaugeColor;
  final bool isDark;

  _TunerArcPainter({
    required this.cents,
    required this.isInTune,
    required this.gaugeColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width * 0.42;

    const startAngle = math.pi * 1.15;
    const sweepAngle = math.pi * 0.7;

    // Track Background Arc
    final bgPaint =
        Paint()
          ..color = isDark ? Colors.white12 : Colors.black12
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Target In-Tune Center Zone (Center +/- 3 cents)
    const inTuneArcWidth = (6.0 / 100.0) * sweepAngle;
    final inTuneStart = startAngle + (sweepAngle / 2) - (inTuneArcWidth / 2);
    final targetZonePaint =
        Paint()
          ..color = const Color(0xFF10B981).withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      inTuneStart,
      inTuneArcWidth,
      false,
      targetZonePaint,
    );

    // Cent Tick Marks (-50 to +50, step of 10)
    for (int c = -50; c <= 50; c += 10) {
      final normalized = (c + 50) / 100.0;
      final tickAngle = startAngle + (normalized * sweepAngle);
      final isMajor = (c % 25 == 0);
      final isCenter = (c == 0);

      final tickInnerR = radius - (isCenter ? 14 : (isMajor ? 10 : 6));
      final tickOuterR = radius + (isCenter ? 10 : (isMajor ? 8 : 4));

      final tickPaint =
          Paint()
            ..color =
                isCenter
                    ? const Color(0xFF10B981)
                    : (isDark ? Colors.white38 : Colors.black38)
            ..strokeWidth = isCenter ? 3.0 : (isMajor ? 2.0 : 1.2)
            ..strokeCap = StrokeCap.round;

      final p1 = Offset(
        center.dx + tickInnerR * math.cos(tickAngle),
        center.dy + tickInnerR * math.sin(tickAngle),
      );
      final p2 = Offset(
        center.dx + tickOuterR * math.cos(tickAngle),
        center.dy + tickOuterR * math.sin(tickAngle),
      );

      canvas.drawLine(p1, p2, tickPaint);
    }

    // Needle Gauge Indicator
    final clampedCents = cents.clamp(-50.0, 50.0);
    final needleNormalized = (clampedCents + 50.0) / 100.0;
    final needleAngle = startAngle + (needleNormalized * sweepAngle);

    final needleLength = radius + 6;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint =
        Paint()
          ..color = gaugeColor
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round;

    // Needle glow if in tune
    if (isInTune) {
      final glowPaint =
          Paint()
            ..color = const Color(0xFF10B981).withValues(alpha: 0.6)
            ..strokeWidth = 8.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawLine(center, needleEnd, glowPaint);
    }

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center pivot knob
    final pivotPaint = Paint()..color = gaugeColor;
    canvas.drawCircle(center, 7, pivotPaint);
    canvas.drawCircle(center, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _TunerArcPainter oldDelegate) =>
      oldDelegate.cents != cents ||
      oldDelegate.isInTune != isInTune ||
      oldDelegate.gaugeColor != gaugeColor;
}

// -------------------------------------------------------------
// CustomPainter: Peterson Style Strobe Wheel
// -------------------------------------------------------------
class _StrobeWheelPainter extends CustomPainter {
  final double rotationAngle;
  final double cents;
  final Color strobeColor;
  final bool isDark;

  _StrobeWheelPainter({
    required this.rotationAngle,
    required this.cents,
    required this.strobeColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height * 0.42;

    final bgPaint =
        Paint()
          ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw rotating concentric strobe bars
    final int bands = 3;
    for (int b = 0; b < bands; b++) {
      final bandRadius = radius * (0.45 + (b * 0.22));
      final int spokes = 12 + (b * 6);
      final double bandWidth = 8.0;

      final spokePaint =
          Paint()
            ..color = (cents.abs() <= 3.0
                    ? const Color(0xFF10B981)
                    : strobeColor)
                .withValues(alpha: 0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = bandWidth;

      for (int i = 0; i < spokes; i++) {
        final angle =
            rotationAngle * (b % 2 == 0 ? 1 : -1) + (i * 2 * math.pi / spokes);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: bandRadius),
          angle,
          (math.pi / spokes),
          false,
          spokePaint,
        );
      }
    }

    // Outer border
    final borderPaint =
        Paint()
          ..color = strobeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _StrobeWheelPainter oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle ||
      oldDelegate.cents != cents ||
      oldDelegate.strobeColor != strobeColor;
}

// -------------------------------------------------------------
// CustomPainter: Audio Waveform harmonics
// -------------------------------------------------------------
class _AudioWaveformPainter extends CustomPainter {
  final double progress;
  final double vibrationIntensity;
  final Color waveColor;

  _AudioWaveformPainter({
    required this.progress,
    required this.vibrationIntensity,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final midY = size.height / 2;
    final baseAmplitude = 3.0 + (vibrationIntensity * 16.0);

    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 3) {
      final double normX = x / size.width;
      final double sin1 = math.sin(
        (normX * 4 * math.pi) + (progress * 2 * math.pi),
      );
      final double sin2 =
          math.sin((normX * 8 * math.pi) - (progress * 4 * math.pi)) * 0.4;
      final y = midY + (sin1 + sin2) * baseAmplitude;
      path.lineTo(x, y);
    }

    final wavePaint =
        Paint()
          ..color = waveColor.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _AudioWaveformPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.vibrationIntensity != vibrationIntensity ||
      oldDelegate.waveColor != waveColor;
}
