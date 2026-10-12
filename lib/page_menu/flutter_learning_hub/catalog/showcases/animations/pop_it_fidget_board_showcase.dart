import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopItFidgetBoardShowcase extends StatefulWidget {
  const PopItFidgetBoardShowcase({super.key});

  @override
  State<PopItFidgetBoardShowcase> createState() =>
      _PopItFidgetBoardShowcaseState();
}

class _PopItFidgetBoardShowcaseState extends State<PopItFidgetBoardShowcase>
    with SingleTickerProviderStateMixin {
  static const int _rowCount = 6;
  static const int _colCount = 6;
  static const int _totalBubbles = _rowCount * _colCount;

  // Popped state for each bubble (indexed 0 to 35)
  late List<bool> _poppedStates;
  int _poppedCount = 0;

  // Board Flip Animation
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipping = false;

  // Color Themes
  int _selectedThemeIndex = 0;
  final List<String> _themeNames = [
    'Rainbow Pastel',
    'Cyber Neon',
    'Cotton Candy',
    'Ocean Deep',
  ];

  // Speed Run Timer
  bool _speedRunMode = false;
  Timer? _speedRunTimer;
  int _elapsedMilliseconds = 0;
  bool _timerRunning = false;
  int? _bestTimeMs;

  @override
  void initState() {
    super.initState();
    _poppedStates = List<bool>.filled(_totalBubbles, false);

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _speedRunTimer?.cancel();
    super.dispose();
  }

  void _onBubbleTap(int index) {
    if (_isFlipping) return;

    HapticFeedback.lightImpact();

    // Start timer on first pop if speed run mode is active
    if (_speedRunMode && !_timerRunning && _poppedCount == 0) {
      _startSpeedRunTimer();
    }

    setState(() {
      _poppedStates[index] = !_poppedStates[index];
      _poppedCount = _poppedStates.where((p) => p).length;

      // Check speed run completion
      if (_speedRunMode && _poppedCount == _totalBubbles && _timerRunning) {
        _stopSpeedRunTimer();
        if (_bestTimeMs == null || _elapsedMilliseconds < _bestTimeMs!) {
          _bestTimeMs = _elapsedMilliseconds;
        }
        _showSpeedRunSuccessDialog();
      }
    });
  }

  void _startSpeedRunTimer() {
    _speedRunTimer?.cancel();
    _elapsedMilliseconds = 0;
    _timerRunning = true;
    _speedRunTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _elapsedMilliseconds += 50;
        });
      }
    });
  }

  void _stopSpeedRunTimer() {
    _speedRunTimer?.cancel();
    _timerRunning = false;
  }

  void _resetBoard({bool flipAnimation = true}) {
    if (_isFlipping) return;

    if (flipAnimation) {
      setState(() {
        _isFlipping = true;
      });
      _flipController.forward(from: 0.0).then((_) {
        setState(() {
          _poppedStates = List<bool>.filled(_totalBubbles, false);
          _poppedCount = 0;
          _stopSpeedRunTimer();
          _elapsedMilliseconds = 0;
        });
      });
    } else {
      setState(() {
        _poppedStates = List<bool>.filled(_totalBubbles, false);
        _poppedCount = 0;
        _stopSpeedRunTimer();
        _elapsedMilliseconds = 0;
      });
    }
  }

  void _popAllBubbles() {
    setState(() {
      _poppedStates = List<bool>.filled(_totalBubbles, true);
      _poppedCount = _totalBubbles;
    });
  }

  void _showSpeedRunSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFF1E293B),
            title: const Row(
              children: [
                Text(' ', style: TextStyle(fontSize: 24)),
                Expanded(
                  child: Text(
                    'Speed Run Selesai!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktu Kamu: ${(_elapsedMilliseconds / 1000).toStringAsFixed(2)} detik',
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_bestTimeMs != null)
                  Text(
                    'Rekor Terbaik: ${(_bestTimeMs! / 1000).toStringAsFixed(2)} detik',
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 12),
                const Text(
                  'Semua 36 gelembung berhasil diletupkan dengan kecepatan kilat!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _resetBoard(flipAnimation: true);
                },
                child: const Text(
                  'Main Lagi',
                  style: TextStyle(color: Color(0xFF818CF8)),
                ),
              ),
            ],
          ),
    );
  }

  List<Color> _getRowColors() {
    switch (_selectedThemeIndex) {
      case 1: // Cyber Neon
        return const [
          Color(0xFFFF007F),
          Color(0xFFFF5500),
          Color(0xFFFFD700),
          Color(0xFF00FF88),
          Color(0xFF00E5FF),
          Color(0xFF9D00FF),
        ];
      case 2: // Cotton Candy
        return const [
          Color(0xFFFF9AA2),
          Color(0xFFFFB7B2),
          Color(0xFFFFDAC1),
          Color(0xFFE2F0CB),
          Color(0xFFB5EAD7),
          Color(0xFFC7CEEA),
        ];
      case 3: // Ocean Deep
        return const [
          Color(0xFF0284C7),
          Color(0xFF0EA5E9),
          Color(0xFF38BDF8),
          Color(0xFF2DD4BF),
          Color(0xFF14B8A6),
          Color(0xFF0D9488),
        ];
      case 0: // Rainbow Pastel
      default:
        return const [
          Color(0xFFF472B6), // Pink
          Color(0xFFFB923C), // Peach / Orange
          Color(0xFFFACC15), // Lemon
          Color(0xFF4ADE80), // Pastel Green
          Color(0xFF60A5FA), // Baby Blue
          Color(0xFFA78BFA), // Lavender
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final rowColors = _getRowColors();
    final progress = _poppedCount / _totalBubbles;

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF472B6).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF472B6).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bubble_chart_rounded,
                        color: Color(0xFFF472B6),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Silicone Pop-It Fidget Board',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Papan gelembung sensorik relaksasi anti-stres dengan fisika 3D dan haptic audio feel.',
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
                const SizedBox(height: 16),

                // PROGRESS BAR & STATS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Progres Meletup: $_poppedCount / $_totalBubbles (${(progress * 100).toInt()}%)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_speedRunMode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _timerRunning
                                  ? Colors.amber.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _timerRunning ? Colors.amber : Colors.grey,
                          ),
                        ),
                        child: Text(
                          '⏱ ${(_elapsedMilliseconds / 1000).toStringAsFixed(1)}s',
                          style: TextStyle(
                            color:
                                _timerRunning ? Colors.amber : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF472B6),
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // POP-IT BOARD CONTAINER
          Center(
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * math.pi;
                final isFront = _flipAnimation.value < 0.5;

                return Transform(
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateY(angle),
                  alignment: Alignment.center,
                  child:
                      isFront
                          ? _buildSiliconeBoard(rowColors)
                          : Transform(
                            transform: Matrix4.identity()..rotateY(math.pi),
                            alignment: Alignment.center,
                            child: _buildSiliconeBoard(rowColors),
                          ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // CONTROL ACTION BUTTONS
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _resetBoard(flipAnimation: true),
                icon: const Icon(Icons.flip_rounded, size: 18),
                label: const Text('Balik & Reset Papan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _popAllBubbles,
                icon: const Icon(Icons.done_all_rounded, size: 18),
                label: const Text('Letupkan Semua'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF38BDF8),
                  side: const BorderSide(color: Color(0xFF38BDF8)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // THEME & MODE SELECTOR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Tema Warna:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_themeNames.length, (idx) {
                    final isSelected = _selectedThemeIndex == idx;
                    return ChoiceChip(
                      label: Text(_themeNames[idx]),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          setState(() => _selectedThemeIndex = idx);
                        }
                      },
                      selectedColor: const Color(0xFFF472B6),
                      backgroundColor: const Color(0xFF334155),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }),
                ),
                const Divider(color: Colors.white12, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mode Speed Run Timer ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ukur seberapa cepat kamu bisa meletupkan semua gelembung.',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _speedRunMode,
                      activeThumbColor: const Color(0xFFF472B6),
                      onChanged: (val) {
                        setState(() {
                          _speedRunMode = val;
                          _resetBoard(flipAnimation: false);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BUILD SILICONE BOARD FRAME & GRID
  Widget _buildSiliconeBoard(List<Color> rowColors) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 6,
        ),
        boxShadow: [
          BoxShadow(
            color: rowColors[0].withValues(alpha: 0.2),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          const BoxShadow(
            color: Colors.black45,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _totalBubbles,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _colCount,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ _colCount;
            final bubbleColor = rowColors[row % rowColors.length];
            final isPopped = _poppedStates[index];

            return _PopItBubbleWidget(
              color: bubbleColor,
              isPopped: isPopped,
              onTap: () => _onBubbleTap(index),
            );
          },
        ),
      ),
    );
  }
}

class _PopItBubbleWidget extends StatefulWidget {
  final Color color;
  final bool isPopped;
  final VoidCallback onTap;

  const _PopItBubbleWidget({
    required this.color,
    required this.isPopped,
    required this.onTap,
  });

  @override
  State<_PopItBubbleWidget> createState() => _PopItBubbleWidgetState();
}

class _PopItBubbleWidgetState extends State<_PopItBubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.82), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pulseController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.all(4.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors:
                  widget.isPopped
                      ? [
                        widget.color.withValues(alpha: 0.5),
                        widget.color.withValues(alpha: 0.9),
                      ]
                      : [
                        HSLColor.fromColor(widget.color)
                            .withLightness(
                              (HSLColor.fromColor(widget.color).lightness +
                                      0.15)
                                  .clamp(0.0, 1.0),
                            )
                            .toColor(),
                        widget.color,
                      ],
              center:
                  widget.isPopped
                      ? const Alignment(0.2, 0.2)
                      : const Alignment(-0.35, -0.35),
              radius: 0.85,
            ),
            boxShadow:
                widget.isPopped
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 3,
                        spreadRadius: -1,
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 3),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.35),
                        offset: const Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: widget.isPopped ? 10 : 16,
              height: widget.isPopped ? 10 : 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    widget.isPopped
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.4),
              ),
              child:
                  widget.isPopped
                      ? Center(
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
