import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhackAMoleArcadeShowcase extends StatefulWidget {
  const WhackAMoleArcadeShowcase({super.key});

  @override
  State<WhackAMoleArcadeShowcase> createState() =>
      _WhackAMoleArcadeShowcaseState();
}

enum _MoleType { regular, golden, bomb }

class _MoleState {
  bool isUp;
  _MoleType type;
  bool isHit;
  DateTime? popTime;

  _MoleState({
    this.isUp = false,
    this.type = _MoleType.regular,
    this.isHit = false,
    this.popTime,
  });
}

class _FloatingScore {
  final int holeIndex;
  final String text;
  final Color color;
  final double key;

  _FloatingScore({
    required this.holeIndex,
    required this.text,
    required this.color,
    required this.key,
  });
}

class _WhackAMoleArcadeShowcaseState extends State<WhackAMoleArcadeShowcase> {
  static const int _gridSize = 9;
  late List<_MoleState> _holes;
  final List<_FloatingScore> _floatingScores = [];

  // Game Stats
  bool _isPlaying = false;
  int _score = 0;
  int _highScore = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _totalHits = 0;
  int _totalClicks = 0;
  int _timeLeft = 30;

  Timer? _gameTimer;
  Timer? _moleSpawnerTimer;
  final math.Random _random = math.Random();

  // Hammer Smash Visual State
  int? _hammerHoleIndex;

  @override
  void initState() {
    super.initState();
    _holes = List.generate(_gridSize, (_) => _MoleState());
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _moleSpawnerTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _gameTimer?.cancel();
    _moleSpawnerTimer?.cancel();

    setState(() {
      _isPlaying = true;
      _score = 0;
      _combo = 0;
      _maxCombo = 0;
      _totalHits = 0;
      _totalClicks = 0;
      _timeLeft = 30;
      _floatingScores.clear();
      _holes = List.generate(_gridSize, (_) => _MoleState());
    });

    // Countdown Timer (1 second interval)
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });

    // Mole Spawner Loop (every 500ms)
    _moleSpawnerTimer = Timer.periodic(const Duration(milliseconds: 550), (
      timer,
    ) {
      if (!mounted || !_isPlaying) return;
      _spawnRandomMole();
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _moleSpawnerTimer?.cancel();

    setState(() {
      _isPlaying = false;
      for (var hole in _holes) {
        hole.isUp = false;
        hole.isHit = false;
      }
      if (_score > _highScore) {
        _highScore = _score;
      }
    });

    _showGameOverDialog();
  }

  void _spawnRandomMole() {
    // Pick 1 or 2 available holes
    final availableIndices = <int>[];
    for (int i = 0; i < _holes.length; i++) {
      if (!_holes[i].isUp) {
        availableIndices.add(i);
      }
    }

    if (availableIndices.isEmpty) return;

    final pickHole = availableIndices[_random.nextInt(availableIndices.length)];
    final roll = _random.nextDouble();

    _MoleType type = _MoleType.regular;
    if (roll < 0.18) {
      type = _MoleType.golden; // 18% chance Golden Mole
    } else if (roll < 0.32) {
      type = _MoleType.bomb; // 14% chance Bomb Trap
    }

    setState(() {
      _holes[pickHole].isUp = true;
      _holes[pickHole].type = type;
      _holes[pickHole].isHit = false;
      _holes[pickHole].popTime = DateTime.now();
    });

    // Auto retreat mole after duration (800ms to 1200ms)
    final stayDuration = type == _MoleType.golden ? 750 : 1100;
    Future.delayed(Duration(milliseconds: stayDuration), () {
      if (mounted &&
          _isPlaying &&
          _holes[pickHole].isUp &&
          !_holes[pickHole].isHit) {
        setState(() {
          _holes[pickHole].isUp = false;
        });
      }
    });
  }

  void _onHoleTapped(int index) {
    if (!_isPlaying) return;

    _totalClicks++;
    final hole = _holes[index];

    // Trigger Hammer visual over this hole
    setState(() {
      _hammerHoleIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) {
        setState(() {
          _hammerHoleIndex = null;
        });
      }
    });

    if (hole.isUp && !hole.isHit) {
      _totalHits++;
      hole.isHit = true;
      HapticFeedback.heavyImpact();

      int points = 0;
      String text = '';
      Color color = Colors.greenAccent;

      if (hole.type == _MoleType.golden) {
        _combo++;
        points = 300 + (_combo * 20);
        text = '+$points ';
        color = const Color(0xFFFACC15);
      } else if (hole.type == _MoleType.bomb) {
        _combo = 0; // Combo broken
        points = -150;
        text = '$points ';
        color = const Color(0xFFEF4444);
        HapticFeedback.vibrate();
      } else {
        _combo++;
        points = 100 + (_combo * 10);
        text = '+$points';
        color = const Color(0xFF4ADE80);
      }

      if (_combo > _maxCombo) _maxCombo = _combo;
      _score = math.max(0, _score + points);

      // Add Floating Score Effect
      final scoreKey = _random.nextDouble();
      setState(() {
        _floatingScores.add(
          _FloatingScore(
            holeIndex: index,
            text: text,
            color: color,
            key: scoreKey,
          ),
        );
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _floatingScores.removeWhere((s) => s.key == scoreKey);
            hole.isUp = false;
          });
        }
      });
    } else {
      // Missed click
      _combo = 0;
      HapticFeedback.lightImpact();
    }
  }

  void _showGameOverDialog() {
    final accuracy =
        _totalClicks > 0 ? ((_totalHits / _totalClicks) * 100).toInt() : 0;

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
                    'Waktu Habis! Game Selesai',
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
                  'Skor Akhir: $_score PTS',
                  style: const TextStyle(
                    color: Color(0xFFFACC15),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildStatRow(' High Score', '$_highScore PTS'),
                _buildStatRow(' Max Combo', '$_maxCombo x Streak'),
                _buildStatRow(
                  ' Akurasi Pukulan',
                  '$accuracy% ($_totalHits / $_totalClicks)',
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _startGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Main Lagi!'),
              ),
            ],
          ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SCOREBOARD BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF78350F), Color(0xFF451A03)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SKOR',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$_score PTS',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _timeLeft <= 5
                                ? Colors.red.withValues(alpha: 0.4)
                                : Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _timeLeft <= 5 ? Colors.red : Colors.amber,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_rounded,
                            color:
                                _timeLeft <= 5
                                    ? Colors.redAccent
                                    : Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_timeLeft}s',
                            style: TextStyle(
                              color:
                                  _timeLeft <= 5
                                      ? Colors.redAccent
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'COMBO STREAK',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_combo}x ',
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3x3 MOLE HOLE PLAYFIELD
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155), width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _gridSize,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final hole = _holes[index];
                  final isHammered = _hammerHoleIndex == index;
                  final floatingScore =
                      _floatingScores
                          .where((s) => s.holeIndex == index)
                          .firstOrNull;

                  return GestureDetector(
                    onTapDown: (_) => _onHoleTapped(index),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // DIRT HOLE BACKGROUND
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                            ),
                            border: Border.all(
                              color: const Color(0xFF475569),
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black87,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 48,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        // POPPING MOLE ANIMATION
                        if (hole.isUp)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: AnimatedScale(
                                scale: hole.isHit ? 0.75 : 1.0,
                                duration: const Duration(milliseconds: 150),
                                child: _buildMoleAvatar(hole),
                              ),
                            ),
                          ),

                        // HAMMER STRIKE VISUAL
                        if (isHammered)
                          Positioned(
                            top: -12,
                            right: -8,
                            child: Transform.rotate(
                              angle: -0.4,
                              child: const Text(
                                '',
                                style: TextStyle(fontSize: 34),
                              ),
                            ),
                          ),

                        // FLOATING SCORE TEXT
                        if (floatingScore != null)
                          Positioned(
                            top: 4,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  floatingScore.text,
                                  style: TextStyle(
                                    color: floatingScore.color,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 18),

          // START / PLAY BUTTON
          ElevatedButton.icon(
            onPressed: _isPlaying ? null : _startGame,
            icon: Icon(
              _isPlaying
                  ? Icons.sports_kabaddi_rounded
                  : Icons.play_arrow_rounded,
              size: 24,
            ),
            label: Text(
              _isPlaying ? 'Game Berlangsung...' : 'Mulai Game (30s Round)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
            ),
          ),

          const SizedBox(height: 14),

          // LEGEND CARD
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  ' Biasa: +100',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                Text(
                  ' Emas: +300',
                  style: TextStyle(
                    color: Color(0xFFFACC15),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' Bom: -150',
                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoleAvatar(_MoleState mole) {
    if (mole.isHit) {
      return const Text('', style: TextStyle(fontSize: 42));
    }

    switch (mole.type) {
      case _MoleType.golden:
        return const Text('', style: TextStyle(fontSize: 38));
      case _MoleType.bomb:
        return const Text('', style: TextStyle(fontSize: 40));
      case _MoleType.regular:
      default:
        return const Text('', style: TextStyle(fontSize: 42));
    }
  }
}
