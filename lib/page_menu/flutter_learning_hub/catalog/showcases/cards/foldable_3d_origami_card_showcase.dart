import 'dart:math' as math;
import 'package:flutter/material.dart';

class Foldable3dOrigamiCardShowcase extends StatefulWidget {
  const Foldable3dOrigamiCardShowcase({super.key});

  @override
  State<Foldable3dOrigamiCardShowcase> createState() =>
      _Foldable3dOrigamiCardShowcaseState();
}

class _Foldable3dOrigamiCardShowcaseState
    extends State<Foldable3dOrigamiCardShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _foldController;
  late Animation<double> _foldAnimation;
  double _manualProgress = 1.0; // 0.0 (fully folded) to 1.0 (fully open)
  bool _isAnimating = false;

  static const double _topFlapHeight = 85.0;
  static const double _middleTierHeight = 110.0;
  static const double _bottomFlapHeight = 75.0;
  static const double _cardWidth = 300.0;

  @override
  void initState() {
    super.initState();
    _foldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      value: 1.0, // Start fully open
    );

    _foldAnimation = CurvedAnimation(
      parent: _foldController,
      curve: Curves.easeInOutCubic,
    )..addListener(() {
      if (_isAnimating) {
        setState(() {
          _manualProgress = _foldAnimation.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _foldController.dispose();
    super.dispose();
  }

  void _toggleFold() {
    _isAnimating = true;
    if (_manualProgress > 0.5) {
      _foldController.animateTo(0.0).then((_) {
        if (mounted) setState(() => _isAnimating = false);
      });
    } else {
      _foldController.animateTo(1.0).then((_) {
        if (mounted) setState(() => _isAnimating = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final foldRatio = _manualProgress.clamp(0.0, 1.0);
    final isFullyClosed = foldRatio < 0.05;

    // Folding angles
    // Bottom flap folds first from 0 to pi (when foldRatio goes from 1.0 to 0.0)
    final bottomAngle = (1.0 - foldRatio) * math.pi;

    // Top flap folds down over the bottom flap
    final topAngle = (1.0 - foldRatio) * math.pi;

    // Effective container height based on fold progress
    final totalCardHeight =
        _middleTierHeight +
        (_topFlapHeight * math.cos(topAngle / 2).abs() * foldRatio) +
        (_bottomFlapHeight * math.cos(bottomAngle / 2).abs() * foldRatio);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. 3D ORIGAMI CARD CANVAS CONTAINER ----------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              width: _cardWidth,
              height: totalCardHeight.clamp(
                _middleTierHeight,
                _topFlapHeight + _middleTierHeight + _bottomFlapHeight,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // LAYER 1: MIDDLE TIER BASE CARD (PASSENGER & QR INFO)
                  Positioned(
                    top: _topFlapHeight * foldRatio,
                    child: _buildMiddleTierCard(),
                  ),

                  // LAYER 2: BOTTOM FLAP (Folds upwards onto middle tier)
                  Positioned(
                    top: (_topFlapHeight * foldRatio) + _middleTierHeight,
                    child: Transform(
                      alignment: Alignment.topCenter,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.002) // Perspective depth
                            ..rotateX(-bottomAngle),
                      child:
                          bottomAngle > (math.pi / 2)
                              // BACK SIDE OF BOTTOM FLAP (When folded up)
                              ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateX(math.pi),
                                child: _buildBottomFlapBack(),
                              )
                              // FRONT SIDE OF BOTTOM FLAP (When open)
                              : _buildBottomFlapFront(foldRatio),
                    ),
                  ),

                  // LAYER 3: TOP FLAP (Folds downwards over middle & bottom flap)
                  Positioned(
                    top: 0,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.002) // Perspective depth
                            ..rotateX(topAngle),
                      child:
                          topAngle > (math.pi / 2)
                              // BACK SIDE OF TOP FLAP (When folded down: Elegant Gold Wax Seal)
                              ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateX(math.pi),
                                child: _buildTopFlapBack(),
                              )
                              // FRONT SIDE OF TOP FLAP (When open: VIP Pass Header)
                              : _buildTopFlapFront(foldRatio),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ---------------- 2. SLIDER & TOGGLE CONTROLS ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Derajat Bukaan 3D:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(foldRatio * 100).toInt()}% ${isFullyClosed ? '(Terlipat Rapi )' : '(Terbuka )'}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF6366F1),
                        thumbColor: const Color(0xFF6366F1),
                        inactiveTrackColor: Colors.grey.shade200,
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: foldRatio,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (val) {
                          setState(() {
                            _isAnimating = false;
                            _manualProgress = val;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      visualDensity: VisualDensity.compact,
                      elevation: 0,
                    ),
                    onPressed: _toggleFold,
                    child: Text(
                      foldRatio > 0.5 ? 'Lipat' : 'Buka',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- WIDGET HELPERS ----------------

  // TOP FLAP: FRONT FACE (OPEN)
  Widget _buildTopFlapFront(double foldRatio) {
    return Container(
      width: _cardWidth,
      height: _topFlapHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (1.0 - foldRatio) * 0.4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Color(0xFFFACC15),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VIP INVITATION PASS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFFACC15),
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Flutter Summit 2026',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Crease shadow when partially folded
          if (foldRatio < 0.95)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: ((1.0 - foldRatio) * 0.4).clamp(0.0, 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // TOP FLAP: BACK FACE (FOLDED / CLOSED ENVELOPE COVER)
  Widget _buildTopFlapBack() {
    return Container(
      width: _cardWidth,
      height: _topFlapHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFACC15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mail_lock_rounded,
                color: Color(0xFF312E81),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VIP INVITATION SEALED',
                  style: TextStyle(
                    color: Color(0xFFFACC15),
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Geser slider / tap Buka',
                  style: TextStyle(color: Colors.white70, fontSize: 9.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // MIDDLE TIER: BASE PASS (NAME & QR CODE)
  Widget _buildMiddleTierCard() {
    return Container(
      width: _cardWidth,
      height: _middleTierHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'GUEST NAME:',
                  style: TextStyle(
                    fontSize: 8.5,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Zainal Salamun',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildMetaTag('SEAT', 'Platinum A1'),
                    const SizedBox(width: 12),
                    _buildMetaTag('DATE', '28 Oct 2026'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // QR Code Mockup
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              size: 48,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM FLAP: FRONT FACE (OPEN)
  Widget _buildBottomFlapFront(double foldRatio) {
    return Container(
      width: _cardWidth,
      height: _bottomFlapHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Stack(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '[v] Akses Workshop & Swag Bag',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '[v] After Party & Dinner Pass',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'RSVP VIP Pass berhasil dikonfirmasi!',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  'RSVP Now',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (foldRatio < 0.95)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: ((1.0 - foldRatio) * 0.4).clamp(0.0, 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // BOTTOM FLAP: BACK FACE (FOLDED / CLOSED POCKET COVER)
  Widget _buildBottomFlapBack() {
    return Container(
      width: _cardWidth,
      height: _bottomFlapHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border.all(color: Colors.white12),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, color: Colors.white60, size: 16),
            SizedBox(width: 6),
            Text(
              'Official Pass • Flutter Summit 2026',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaTag(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8.5,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
