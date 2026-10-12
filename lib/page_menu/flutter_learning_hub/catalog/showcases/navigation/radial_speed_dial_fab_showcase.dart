import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadialSpeedDialFabShowcase extends StatefulWidget {
  const RadialSpeedDialFabShowcase({super.key});

  @override
  State<RadialSpeedDialFabShowcase> createState() =>
      _RadialSpeedDialFabShowcaseState();
}

class _RadialSpeedDialFabShowcaseState extends State<RadialSpeedDialFabShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  bool _isOpen = false;
  String _lastActionClicked = 'Belum ada aksi diklik';

  final List<Map<String, dynamic>> _dialActions = [
    {
      'label': 'Kamera',
      'icon': Icons.camera_alt_rounded,
      'color': const Color(0xFF6366F1),
    },
    {
      'label': 'Dokumen',
      'icon': Icons.description_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'label': 'Lokasi',
      'icon': Icons.location_on_rounded,
      'color': const Color(0xFFF43F5E),
    },
    {
      'label': 'Audio',
      'icon': Icons.mic_rounded,
      'color': const Color(0xFFF59E0B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 260),
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: math.pi / 4).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDial() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onActionTap(String label) {
    setState(() {
      _lastActionClicked = 'Aksi "$label" berhasil dipicu!';
    });
    _toggleDial();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.touch_app_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Menu Radial: $label dipilih!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6366F1),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. SIMULATED SCREEN STAGE ----------------
        Container(
          height: 310,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Background Stage Content (Dummy App Header & Content)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.hub_rounded,
                              color: Color(0xFF818CF8),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Radial Menu Stage',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tekan FAB di sudut kanan bawah',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Status Info Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isOpen
                                  ? Icons.lock_open_rounded
                                  : Icons.info_outline_rounded,
                              color:
                                  _isOpen
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF818CF8),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _isOpen
                                    ? 'Menu terbuka! Pilih salah satu aksi.'
                                    : _lastActionClicked,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Backdrop Tap Barrier when open
                if (_isOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleDial,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
                    ),
                  ),

                // ---------------- RADIAL SPEED DIAL BUTTONS ----------------
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      clipBehavior: Clip.none,
                      children: [
                        // Radial Sub-Action Items fanning out from 180° to 270° (top-left quarter arc)
                        ...List.generate(_dialActions.length, (index) {
                          return AnimatedBuilder(
                            animation: _expandAnimation,
                            builder: (context, child) {
                              // Distribute 4 items evenly across arc (math.pi / 2)
                              // Angle from math.pi (Left) to math.pi * 1.5 (Top)
                              const totalAngleSpan = math.pi / 2;
                              final angleStep =
                                  totalAngleSpan / (_dialActions.length - 1);
                              final itemAngle = math.pi + (index * angleStep);

                              const radius = 110.0;
                              final progress = _expandAnimation.value;

                              final dx =
                                  math.cos(itemAngle) * radius * progress;
                              final dy =
                                  math.sin(itemAngle) * radius * progress;

                              final action = _dialActions[index];

                              return Transform.translate(
                                offset: Offset(dx, dy),
                                child: Transform.scale(
                                  scale: progress.clamp(0.0, 1.0),
                                  child: Opacity(
                                    opacity: progress.clamp(0.0, 1.0),
                                    child: _buildRadialActionItem(
                                      label: action['label'] as String,
                                      icon: action['icon'] as IconData,
                                      color: action['color'] as Color,
                                      onTap:
                                          () => _onActionTap(
                                            action['label'] as String,
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),

                        // Primary Radial FAB Toggle
                        GestureDetector(
                          onTap: _toggleDial,
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _rotateAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotateAnimation.value,
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  );
                                },
                              ),
                            ),
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
        const SizedBox(height: 14),

        // ---------------- 2. CONTROLS & SHORTCUTS ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Radial Arc Configuration',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Busur 90° Kuadran Kiri-Atas (R: 110px)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: _toggleDial,
                icon: Icon(
                  _isOpen
                      ? Icons.close_rounded
                      : Icons.expand_circle_down_rounded,
                  size: 16,
                ),
                label: Text(
                  _isOpen ? 'Tutup' : 'Buka Menu',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadialActionItem({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
