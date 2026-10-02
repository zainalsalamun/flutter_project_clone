import 'dart:async';
import 'package:flutter/material.dart';
import 'pages/passenger_booking_preview_page.dart';
import 'widgets/flip_countdown_timer.dart';
import 'widgets/passenger_tips_card.dart';
import 'widgets/railroad_crossing_visualizer.dart';

/// Main Queue Countdown Screen matching the reference UI perfectly.
/// Features:
/// 1. Top warning notice banner with auto-refresh notification
/// 2. Vector Railroad Crossing & Station Animated Illustration (flashing lights, moving train, barrier)
/// 3. Card-styled Flip Countdown Timer (Jam : Menit)
/// 4. Informative Queue status copy
/// 5. Passenger Data preparation Tips Card
/// 6. Live ticking "Terakhir diperbarui" timestamp
/// 7. Interactive simulation controls (Fast-forward, auto-refresh, finish queue)
class QueueCountdownPage extends StatefulWidget {
  const QueueCountdownPage({super.key});

  @override
  State<QueueCountdownPage> createState() => _QueueCountdownPageState();
}

class _QueueCountdownPageState extends State<QueueCountdownPage>
    with SingleTickerProviderStateMixin {
  // Timer State
  int _secondsRemaining = 120; // 2 minutes initial countdown
  int _initialSeconds = 120;
  Timer? _countdownTimer;
  Timer? _clockTimer;

  // Real-time Clock String
  String _currentTimeString = '';

  // Auto-refresh simulation state
  bool _isRefreshing = false;
  int _queuePosition = 142;

  // Animation controller for pulse banner
  late AnimationController _bannerPulseController;

  @override
  void initState() {
    super.initState();
    _updateCurrentTime();

    // 1. Clock ticker (every second)
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCurrentTime();
    });

    // 2. Countdown ticker
    _startCountdown();

    // 3. Subtle banner pulse
    _bannerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  void _updateCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    final sec = now.second.toString().padLeft(2, '0');
    if (mounted) {
      setState(() {
        _currentTimeString = "$hour:$min:$sec";
      });
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 12 == 0 && _queuePosition > 5) {
            _queuePosition -= 8;
          }
        });
      } else {
        timer.cancel();
        _onQueueComplete();
      }
    });
  }

  void _onQueueComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Giliran Anda Tiba!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masa antrean selesai. Anda sekarang dapat melanjutkan proses pemilihan jadwal dan pengisian data penumpang.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PassengerBookingPreviewPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Mulai Pemesanan Tiket",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _manualRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    _updateCurrentTime();
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() {
        _isRefreshing = false;
        if (_queuePosition > 10) _queuePosition -= 15;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text("Status antrean berhasil diperbarui!"),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2563EB),
          duration: const Duration(milliseconds: 1400),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _clockTimer?.cancel();
    _bannerPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top App Bar: Close Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF2563EB), // Sleek Royal Blue
                          size: 26,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      // Demo Interactive Controls Button
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF2563EB),
                            size: 18,
                          ),
                        ),
                        tooltip: "Pengaturan Simulasi Demo",
                        onPressed: _showDemoControlsModal,
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _manualRefresh,
                    color: const Color(0xFF2563EB),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 6),

                          // 1. Warning Notice Banner
                          _buildWarningNoticeBanner(),
                          const SizedBox(height: 28),

                          // 2. Animated Railroad Crossing Visualizer
                          const RailroadCrossingVisualizer(),
                          const SizedBox(height: 32),

                          // 3. Countdown Box (Menit : Detik Live Ticking)
                          FlipCountdownTimer(
                            totalSeconds: _secondsRemaining,
                          ),
                          const SizedBox(height: 28),

                          // 4. Queue Heading & Description
                          const Text(
                            "Anda Sedang Memasuki Masa Antrian",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Saat ini pemesanan sedang ramai. Untuk memastikan kenyamanan semua pengguna, kami membatasi jumlah pemesanan yang diproses secara bersamaan.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.45,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Live Queue Progress Pill
                          _buildQueuePositionPill(),
                          const SizedBox(height: 24),

                          // 5. Passenger Tips Card
                          const PassengerTipsCard(),
                          const SizedBox(height: 32),

                          // 6. Last Updated Time
                          _buildLastUpdatedFooter(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Subtle Loading Overlay on manual refresh
            if (_isRefreshing)
              Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2563EB)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Memperbarui antrean...",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningNoticeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Warm light orange
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFB923C), // Orange border
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFEA580C), // Solid orange circle
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Halaman ini akan refresh secara otomatis! mohon untuk tidak meninggalkan halaman ini.",
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFFC2410C), // Deep burnt orange text
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueuePositionPill() {
    final progress =
        1.0 - (_secondsRemaining / (_initialSeconds > 0 ? _initialSeconds : 1));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981), // Live Green indicator
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Nomor Antrean Anda: #$_queuePosition",
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "• ${(progress * 100).clamp(0, 100).toInt()}% Selesai",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedFooter() {
    return GestureDetector(
      onTap: _manualRefresh,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Terakhir diperbarui : ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            _currentTimeString,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB), // Vivid Blue
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.sync_rounded,
            size: 15,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  void _showDemoControlsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Panel Kontrol Demo Antrean",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Uji coba interaksi countdown dan alur transisi antrean",
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // Button: Selesaikan Antrean Sekarang (Fast-forward)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.flash_on_rounded,
                        color: Color(0xFF10B981)),
                  ),
                  title: const Text("Simulasi Selesai Antre Sekarang",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Langsung membuka dialog pemesanan"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _secondsRemaining = 0;
                    });
                    _onQueueComplete();
                  },
                ),

                // Button: Set Timer ke 10 Detik
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.timer_10_rounded,
                        color: Color(0xFF2563EB)),
                  ),
                  title: const Text("Set Countdown ke 10 Detik",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Melihat animasi detik-detik akhir"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _secondsRemaining = 10;
                    });
                    _startCountdown();
                  },
                ),

                // Button: Reset ke 2 Menit
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.restart_alt_rounded,
                        color: Color(0xFF64748B)),
                  ),
                  title: const Text("Reset Countdown (2 Menit)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Mulai ulang simulasi hitung mundur aktif"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _initialSeconds = 120;
                      _secondsRemaining = 120;
                      _queuePosition = 142;
                    });
                    _startCountdown();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
