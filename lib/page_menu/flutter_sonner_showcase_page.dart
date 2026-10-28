import 'package:flutter/material.dart';
import 'package:flutter_sonner/flutter_sonner.dart';

class FlutterSonnerShowcasePage extends StatefulWidget {
  const FlutterSonnerShowcasePage({super.key});

  @override
  State<FlutterSonnerShowcasePage> createState() =>
      _FlutterSonnerShowcasePageState();
}

class _FlutterSonnerShowcasePageState extends State<FlutterSonnerShowcasePage> {
  SonnerPosition _position = SonnerPosition.topCenter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Sonner Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear All Toasts',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => Sonner.dismissAll(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Highlight Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.layers_rounded, color: Colors.white, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'flutter_sonner v0.1.0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plugin notifikasi modern dengan tumpukan kartu 3D, gesture swipe-to-dismiss, dan mode Dynamic Island.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Posisi Notifikasi
                const Text(
                  '1. Posisi Notifikasi di Layar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Top Center (Dynamic Island)'),
                      selected: _position == SonnerPosition.topCenter,
                      onSelected: (_) {
                        setState(() {
                          _position = SonnerPosition.topCenter;
                          Sonner.setPosition(SonnerPosition.topCenter);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Bottom Center (Default)'),
                      selected: _position == SonnerPosition.bottomCenter,
                      onSelected: (_) {
                        setState(() {
                          _position = SonnerPosition.bottomCenter;
                          Sonner.setPosition(SonnerPosition.bottomCenter);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Bottom Right (Web/Desktop)'),
                      selected: _position == SonnerPosition.bottomRight,
                      onSelected: (_) {
                        setState(() {
                          _position = SonnerPosition.bottomRight;
                          Sonner.setPosition(SonnerPosition.bottomRight);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Demo Tumpukan 3D
                const Text(
                  '2. Coba Efek Tumpukan 3D (Stacked Cards)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.burst_mode_rounded),
                  label: const Text('Tampilkan 3 Notifikasi Sekaligus!'),
                  onPressed: () {
                    Sonner.info(
                      'Langkah 1: Menyiapkan aset',
                      description: 'Mengunduh komponen tambahan...',
                    );
                    Future.delayed(const Duration(milliseconds: 180), () {
                      Sonner.warning(
                        'Langkah 2: Sinkronisasi database',
                        description: 'Memperbarui cache lokal...',
                      );
                    });
                    Future.delayed(const Duration(milliseconds: 360), () {
                      Sonner.success(
                        'Langkah 3: Selesai!',
                        description: 'Semua proses berjalan sukses.',
                      );
                    });
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  '*Tips: Ketuk atau arahkan kursor ke kartu yang bertumpuk untuk melihatnya mengembang.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 28),

                // Varian Toast
                const Text(
                  '3. Varian Notifikasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8,
                  children: [
                    _ToastButton(
                      label: 'Success Toast',
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFF10B981),
                      onTap: () {
                        Sonner.success(
                          'Pembayaran Berhasil!',
                          description: 'Struk transaksi telah dikirim ke email.',
                        );
                      },
                    ),
                    _ToastButton(
                      label: 'Error Toast',
                      icon: Icons.error_rounded,
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        Sonner.error(
                          'Gagal Mengunggah',
                          description: 'Koneksi internet tidak stabil (504).',
                        );
                      },
                    ),
                    _ToastButton(
                      label: 'Warning Toast',
                      icon: Icons.warning_rounded,
                      color: const Color(0xFFF59E0B),
                      onTap: () {
                        Sonner.warning(
                          'Kapasitas Memori Hampir Penuh',
                          description: 'Sisa ruang penyimpanan tersisa 5%.',
                        );
                      },
                    ),
                    _ToastButton(
                      label: 'Info Toast',
                      icon: Icons.info_rounded,
                      color: const Color(0xFF3B82F6),
                      onTap: () {
                        Sonner.info(
                          'Fitur Baru Tersedia',
                          description: 'Versi 0.1.0 siap dicoba.',
                        );
                      },
                    ),
                    _ToastButton(
                      label: 'Dengan Tombol Aksi',
                      icon: Icons.undo_rounded,
                      color: const Color(0xFF6366F1),
                      onTap: () {
                        Sonner.show(
                          'Pesan berhasil dihapus',
                          action: SonnerAction(
                            label: 'Undo',
                            onClick: () {
                              Sonner.dismissAll();
                              Sonner.success('Pesan dikembalikan!');
                            },
                          ),
                        );
                      },
                    ),
                    _ToastButton(
                      label: 'Loading Toast',
                      icon: Icons.hourglass_top_rounded,
                      color: Colors.purple,
                      onTap: () {
                        final id = Sonner.loading(
                          'Memproses data...',
                          description: 'Mohon tunggu beberapa detik.',
                        );
                        Future.delayed(const Duration(seconds: 3), () {
                          Sonner.dismiss(id);
                          Sonner.success('Proses selesai!');
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Async Promise
                const Text(
                  '4. Async / Future Promise Handler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mengubah status dari Loading ➔ Success secara otomatis dalam satu kartu tanpa rebuild UI manual:',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.bolt_rounded),
                        label: const Text('Simulasi Sukses'),
                        onPressed: () {
                          Sonner.promise(
                            Future.delayed(
                              const Duration(seconds: 2),
                              () => 'Zainal Salamun',
                            ),
                            loading: 'Menghubungkan ke server...',
                            success: (nama) => 'Berhasil login sebagai $nama!',
                            error: (err) => 'Gagal: $err',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.error_outline_rounded),
                        label: const Text('Simulasi Error'),
                        onPressed: () {
                          Sonner.promise(
                            Future.delayed(
                              const Duration(seconds: 2),
                              () => throw Exception('Koneksi terputus'),
                            ),
                            loading: 'Mengirim formulir...',
                            success: (_) => 'Terkirim!',
                            error: (err) => 'Error: $err',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ToastButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
