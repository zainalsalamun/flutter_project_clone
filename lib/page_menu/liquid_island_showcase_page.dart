import 'package:flutter/material.dart';
import 'package:liquid_island/liquid_island.dart';

class LiquidIslandShowcasePage extends StatefulWidget {
  const LiquidIslandShowcasePage({super.key});

  @override
  State<LiquidIslandShowcasePage> createState() =>
      _LiquidIslandShowcasePageState();
}

class _LiquidIslandShowcasePageState extends State<LiquidIslandShowcasePage> {
  double _trackingProgress = 0.5;
  ThemeMode _currentThemeMode = ThemeMode.dark;
  IslandPosition _currentPosition = IslandPosition.notch;

  @override
  Widget build(BuildContext context) {
    final isDark = _currentThemeMode == ThemeMode.dark;

    final bgColor = isDark ? const Color(0xFF0C0C0E) : const Color(0xFFF2F2F7);
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final subtextColor = isDark ? Colors.white60 : const Color(0xFF6E6E73);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            'Liquid Island',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          actions: [
            // Notch Mode vs Floating HUD Toggle Button
            IconButton(
              tooltip: _currentPosition == IslandPosition.notch
                  ? 'Ganti ke Floating HUD (Melayang)'
                  : 'Ganti ke Notch Mode (Poni Apple)',
              icon: Icon(
                _currentPosition == IslandPosition.notch
                    ? Icons.phone_iphone_rounded
                    : Icons.layers_outlined,
                color: textColor.withOpacity(0.8),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _currentPosition = _currentPosition == IslandPosition.notch
                      ? IslandPosition.floating
                      : IslandPosition.notch;
                  LiquidIslandController.instance.setTheme(
                    IslandTheme(
                      themeMode: _currentThemeMode,
                      position: _currentPosition,
                    ),
                  );
                });
              },
            ),
            // Dark / Light Mode Toggle Button
            IconButton(
              tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: textColor.withOpacity(0.8),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _currentThemeMode =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                  LiquidIslandController.instance.setTheme(
                    IslandTheme(
                      themeMode: _currentThemeMode,
                      position: _currentPosition,
                    ),
                  );
                });
              },
            ),
            IconButton(
              tooltip: 'Tutup Island',
              icon: Icon(Icons.close_rounded,
                  color: textColor.withOpacity(0.7), size: 20),
              onPressed: () => LiquidIsland.dismiss(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Minimal header intro
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Live Activities',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            // Theme Pill Indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white12
                                    : Colors.black.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${isDark ? 'Dark' : 'Light'} • ${_currentPosition == IslandPosition.notch ? 'Notch Mode' : 'Floating HUD'}',
                                style: TextStyle(
                                  color: subtextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pilih aktivitas untuk memicu Dynamic Island di bagian atas layar. Sentuh dan tarik ke bawah untuk membuka tampilan detail.',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grouped list of activities
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        _ActivityTile(
                          icon: Icons.music_note_rounded,
                          iconColor: const Color(0xFF34C759),
                          title: 'Music Player',
                          subtitle: 'Piringan lagu & visualizer gelombang suara',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            LiquidIsland.music(
                              trackTitle: 'Die With A Smile',
                              artistName: 'Lady Gaga & Bruno Mars',
                              isPlaying: true,
                            );
                          },
                        ),
                        _divider(borderColor),
                        _ActivityTile(
                          icon: Icons.two_wheeler_rounded,
                          iconColor: const Color(0xFF007AFF),
                          title: 'Delivery & Ride Tracking',
                          subtitle:
                              'Pergerakan kurir motor dan estimasi waktu tiba',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            setState(() => _trackingProgress = 0.5);
                            LiquidIsland.tracking(
                              driverName: 'Pak Supri',
                              vehicleInfo: 'Honda Vario • B 4920 KLS',
                              eta: '6 min',
                              progress: _trackingProgress,
                              statusMessage: 'Kurir sedang dalam perjalanan',
                            );
                          },
                        ),
                        _divider(borderColor),
                        _ActivityTile(
                          icon: Icons.timer_rounded,
                          iconColor: const Color(0xFFFF9500),
                          title: 'Timer & Stopwatch',
                          subtitle: 'Hitung mundur dengan cincin progres',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            LiquidIsland.timer(
                              duration: const Duration(minutes: 5),
                              label: 'Rebus Telur',
                            );
                          },
                        ),
                        _divider(borderColor),
                        _ActivityTile(
                          icon: Icons.face_rounded,
                          iconColor: isDark ? Colors.white : Colors.black87,
                          title: 'Face ID Verification',
                          subtitle: 'Simulasi pemindaian biometrik',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            LiquidIsland.biometric(
                              prompt: 'Verifikasi Pembayaran',
                            );
                          },
                        ),
                        _divider(borderColor),
                        _ActivityTile(
                          icon: Icons.bolt_rounded,
                          iconColor: const Color(0xFF34C759),
                          title: 'Pengisian Daya Baterai',
                          subtitle: 'Status baterai 88%',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            LiquidIsland.battery(
                              percentage: 88,
                              isCharging: true,
                            );
                          },
                        ),
                        _divider(borderColor),
                        _ActivityTile(
                          icon: Icons.phone_in_talk_rounded,
                          iconColor: const Color(0xFF34C759),
                          title: 'Panggilan Masuk',
                          subtitle:
                              'Banner interaktif dengan tombol jawab dan tolak',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            LiquidIsland.alert(
                              title: 'Panggilan Masuk',
                              subtitle: 'Kantor Operasional',
                              icon: const Icon(Icons.phone_rounded,
                                  color: Color(0xFF34C759), size: 18),
                              secondaryActionLabel: 'Tolak',
                              primaryActionLabel: 'Jawab',
                              onPrimaryAction: () {
                                LiquidIsland.alert(
                                  title: 'Terhubung',
                                  subtitle: '00:01 • Panggilan Suara',
                                );
                              },
                            );
                          },
                        ),
                        _divider(borderColor),
                        _ActivityTile(
                          icon: Icons.splitscreen_rounded,
                          iconColor: const Color(0xFFAF52DE),
                          title: '⚡ Dual Activities (Split Island)',
                          subtitle:
                              'Pill Musik di kiri + Droplet Timer di kanan',
                          textColor: textColor,
                          subtextColor: subtextColor,
                          onTap: () {
                            LiquidIsland.split(
                              primary: IslandActivity.music(
                                trackTitle: 'Die With A Smile',
                                artistName: 'Lady Gaga & Bruno Mars',
                                isPlaying: true,
                              ),
                              secondary: IslandActivity.timer(
                                duration: const Duration(minutes: 5),
                                label: 'Rebus Telur',
                                isRunning: true,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tracking progress slider
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Simulasi Progres Kurir',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Geser slider untuk mengubah posisi kurir di Dynamic Island.',
                          style: TextStyle(color: subtextColor, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            activeTrackColor: const Color(0xFF007AFF),
                            inactiveTrackColor: isDark
                                ? Colors.white12
                                : Colors.black.withOpacity(0.08),
                            thumbColor:
                                isDark ? Colors.white : const Color(0xFF007AFF),
                          ),
                          child: Slider(
                            value: _trackingProgress,
                            onChanged: (val) {
                              setState(() => _trackingProgress = val);
                              LiquidIsland.tracking(
                                driverName: 'Pak Supri',
                                vehicleInfo: 'Honda Vario • B 4920 KLS',
                                eta: '${((1.0 - val) * 12).ceil()} min',
                                progress: val,
                                statusMessage: val >= 0.95
                                    ? 'Kurir telah tiba di alamat'
                                    : 'Kurir sedang dalam perjalanan (${(val * 100).toInt()}%)',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider(Color borderColor) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 52,
      color: borderColor,
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subtextColor;
  final VoidCallback onTap;

  const _ActivityTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.subtextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: subtextColor.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
