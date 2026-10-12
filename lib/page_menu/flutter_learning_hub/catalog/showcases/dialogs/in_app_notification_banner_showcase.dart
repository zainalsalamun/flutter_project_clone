import 'dart:async';
import 'package:flutter/material.dart';

class InAppNotificationBannerShowcase extends StatefulWidget {
  const InAppNotificationBannerShowcase({super.key});

  @override
  State<InAppNotificationBannerShowcase> createState() =>
      _InAppNotificationBannerShowcaseState();
}

class _InAppNotificationBannerShowcaseState
    extends State<InAppNotificationBannerShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  Timer? _countdownTimer;
  double _timerProgress = 1.0;
  bool _isVisible = false;
  int _activeNotificationIndex = 0;

  final List<Map<String, dynamic>> _notificationPresets = [
    {
      'title': 'Driver Sedang Menuju Lokasi ',
      'subtitle': 'Pak Budi (Honda Vario) berjarak 400m dari titik antar.',
      'time': 'Baru saja',
      'primaryColor': const Color(0xFF10B981),
      'icon': Icons.delivery_dining_rounded,
      'actionLabel': 'Lacak',
      'type': 'Pesanan Aktif',
    },
    {
      'title': 'Siti Rahma ',
      'subtitle': 'Halo mas, untuk bajunya mau dikirim warna hitam atau navy?',
      'time': '1 mnt lalu',
      'primaryColor': const Color(0xFF6366F1),
      'icon': Icons.chat_bubble_rounded,
      'actionLabel': 'Balas',
      'type': 'Pesan Masuk',
    },
    {
      'title': 'Flash Sale 9.9 Dimulai! ',
      'subtitle': 'Kupon diskon 90% sudah aktif untuk 100 pembeli pertama.',
      'time': 'Promo',
      'primaryColor': const Color(0xFFEF4444),
      'icon': Icons.local_fire_department_rounded,
      'actionLabel': 'Serbu',
      'type': 'Promo Spesial',
    },
    {
      'title': 'Login Perangkat Baru ',
      'subtitle': 'Aktivitas masuk terdeteksi dari Chrome MacOS di Jakarta.',
      'time': 'Keamanan',
      'primaryColor': const Color(0xFFF59E0B),
      'icon': Icons.security_rounded,
      'actionLabel': 'Cek',
      'type': 'Peringatan',
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    );

    // Auto-show first notification for showcase effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerNotification(0);
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  void _triggerNotification(int index) {
    _countdownTimer?.cancel();
    setState(() {
      _activeNotificationIndex = index;
      _timerProgress = 1.0;
      _isVisible = true;
    });

    _slideController.forward(from: 0.0);

    // 4-second auto dismiss timer with tick updates
    const totalDurationMs = 4000;
    const intervalMs = 50;
    int elapsed = 0;

    _countdownTimer = Timer.periodic(const Duration(milliseconds: intervalMs), (
      timer,
    ) {
      elapsed += intervalMs;
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _timerProgress = (1.0 - (elapsed / totalDurationMs)).clamp(0.0, 1.0);
        if (_timerProgress <= 0.0) {
          timer.cancel();
          _dismissNotification();
        }
      });
    });
  }

  void _dismissNotification() {
    _countdownTimer?.cancel();
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final active = _notificationPresets[_activeNotificationIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. SIMULATED APP TOP STAGE ----------------
        Container(
          height: 240,
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
                // Simulated App Background
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color:
                                    _isVisible
                                        ? const Color(0xFF10B981)
                                        : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isVisible
                                  ? 'Banner Aktif (Geser ke atas untuk tutup)'
                                  : 'Banner Disembunyikan',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pilih preset notifikasi di bawah untuk mensimulasikan top alert banner.',
                          style: TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------------- TOP SLIDING NOTIFICATION BANNER ----------------
                if (_isVisible)
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: GestureDetector(
                          onVerticalDragEnd: (details) {
                            if (details.primaryVelocity != null &&
                                details.primaryVelocity! < -100) {
                              _dismissNotification();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Icon badge
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: (active['primaryColor']
                                                  as Color)
                                              .withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          active['icon'] as IconData,
                                          color:
                                              active['primaryColor'] as Color,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                      // Content Text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    active['title'] as String,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  active['time'] as String,
                                                  style: TextStyle(
                                                    fontSize: 9.5,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              active['subtitle'] as String,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Quick Action Button
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          _dismissNotification();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Aksi "${active['actionLabel']}" dipilih!',
                                              ),
                                              backgroundColor:
                                                  active['primaryColor']
                                                      as Color,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (active['primaryColor']
                                                    as Color)
                                                .withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            active['actionLabel'] as String,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  active['primaryColor']
                                                      as Color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Auto-dismiss Progress Indicator Bar
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                  child: LinearProgressIndicator(
                                    value: _timerProgress,
                                    minHeight: 3,
                                    backgroundColor: Colors.grey.shade100,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      active['primaryColor'] as Color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. PRESET TRIGGER CONTROLS ----------------
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
                  Icon(
                    Icons.touch_app_rounded,
                    size: 16,
                    color: Color(0xFF6366F1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Simulasikan Event Notifikasi:',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 4 Trigger Buttons Grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_notificationPresets.length, (idx) {
                  final preset = _notificationPresets[idx];
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (preset['primaryColor'] as Color)
                          .withValues(alpha: 0.12),
                      foregroundColor: preset['primaryColor'] as Color,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => _triggerNotification(idx),
                    icon: Icon(preset['icon'] as IconData, size: 14),
                    label: Text(
                      preset['type'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
