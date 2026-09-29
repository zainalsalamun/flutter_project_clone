import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class BouncingNotificationBellShowcase extends StatefulWidget {
  const BouncingNotificationBellShowcase({super.key});

  @override
  State<BouncingNotificationBellShowcase> createState() =>
      _BouncingNotificationBellShowcaseState();
}

class _BouncingNotificationBellShowcaseState
    extends State<BouncingNotificationBellShowcase>
    with TickerProviderStateMixin {
  int _unreadCount = 3;
  bool _isAutoSimulating = false;
  Timer? _simulationTimer;

  late AnimationController _shakeController;
  late AnimationController _badgeBounceController;
  late Animation<double> _badgeScaleAnimation;

  final List<_NotificationItem> _recentNotifications = [
    _NotificationItem(
      title: 'Pesanan Telah Dikirim! ',
      time: '2 menit lalu',
      icon: Icons.local_shipping_rounded,
      color: const Color(0xFF10B981),
    ),
    _NotificationItem(
      title: 'Flash Sale Diskon 80% Dimulai ',
      time: '15 menit lalu',
      icon: Icons.local_fire_department_rounded,
      color: const Color(0xFFEF4444),
    ),
    _NotificationItem(
      title: 'Poin Reward +500 Berhasil Ditambah ',
      time: '1 jam lalu',
      icon: Icons.stars_rounded,
      color: const Color(0xFFF59E0B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _badgeBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _badgeScaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _badgeBounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _shakeController.dispose();
    _badgeBounceController.dispose();
    super.dispose();
  }

  void _addNotification({int amount = 1, String? customTitle}) {
    setState(() {
      _unreadCount += amount;
      _recentNotifications.insert(
        0,
        _NotificationItem(
          title: customTitle ?? 'Pemberitahuan Baru Masuk #$_unreadCount ',
          time: 'Baru saja',
          icon: Icons.notifications_active_rounded,
          color: const Color(0xFF6366F1),
        ),
      );
      if (_recentNotifications.length > 5) {
        _recentNotifications.removeLast();
      }
    });

    _triggerBellAlert();
  }

  void _triggerBellAlert() {
    _shakeController.forward(from: 0.0);
    _badgeBounceController.forward(from: 0.0).then((_) {
      _badgeBounceController.reverse();
    });
  }

  void _decrementNotification() {
    if (_unreadCount > 0) {
      setState(() => _unreadCount--);
    }
  }

  void _clearNotifications() {
    setState(() {
      _unreadCount = 0;
      _isAutoSimulating = false;
      _simulationTimer?.cancel();
    });
  }

  void _toggleAutoSimulation() {
    setState(() {
      _isAutoSimulating = !_isAutoSimulating;
      if (_isAutoSimulating) {
        _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
          _addNotification(
            amount: 1,
            customTitle: 'Notifikasi Otomatis [Live Sync] ',
          );
        });
      } else {
        _simulationTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top App Bar Preview Card with Bouncing Bell
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF6366F1),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Zainal! ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Naltech Workspace',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              // Bouncing Notification Bell Icon
              GestureDetector(
                onTap: _triggerBellAlert,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Ringing Bell Icon
                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          final angle =
                              math.sin(_shakeController.value * math.pi * 6) *
                              0.25;
                          return Transform.rotate(
                            angle: angle,
                            child: const Icon(
                              Icons.notifications_rounded,
                              size: 26,
                              color: Color(0xFF1E293B),
                            ),
                          );
                        },
                      ),

                      // Bouncing Badge Pill
                      if (_unreadCount > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: ScaleTransition(
                            scale: _badgeScaleAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                _unreadCount > 99 ? '99+' : '$_unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                ),
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
        const SizedBox(height: 14),

        // Interactive Simulation Controls
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Simulasi Notifikasi Masuk:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isAutoSimulating
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      _isAutoSimulating
                          ? Icons.pause_rounded
                          : Icons.stream_rounded,
                      size: 14,
                    ),
                    label: Text(
                      _isAutoSimulating ? 'Stop Stream' : 'Auto Stream',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _toggleAutoSimulation,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Action Buttons Row
              Row(
                children: [
                  _buildControlBtn(
                    label: '+1 Baru',
                    icon: Icons.add_rounded,
                    color: const Color(0xFF6366F1),
                    onTap: () => _addNotification(amount: 1),
                  ),
                  const SizedBox(width: 6),
                  _buildControlBtn(
                    label: '+5 Massal',
                    icon: Icons.add_circle_outline_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () => _addNotification(amount: 5),
                  ),
                  const SizedBox(width: 6),
                  _buildControlBtn(
                    label: '-1 Baca',
                    icon: Icons.remove_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: _decrementNotification,
                  ),
                  const SizedBox(width: 6),
                  _buildControlBtn(
                    label: 'Bersihkan',
                    icon: Icons.done_all_rounded,
                    color: const Color(0xFF64748B),
                    onTap: _clearNotifications,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Recent Notifications Feed Preview
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aktivitas Notifikasi Terbaru',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),

              if (_recentNotifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Tidak ada notifikasi aktif.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                )
              else
                ..._recentNotifications.map((notif) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: notif.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(notif.icon, size: 14, color: notif.color),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            notif.title,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                        Text(
                          notif.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  _NotificationItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}
