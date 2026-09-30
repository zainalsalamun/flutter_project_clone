import 'package:flutter/material.dart';

class EmptyStateCardShowcase extends StatefulWidget {
  const EmptyStateCardShowcase({super.key});

  @override
  State<EmptyStateCardShowcase> createState() => _EmptyStateCardShowcaseState();
}

class _EmptyStateCardShowcaseState extends State<EmptyStateCardShowcase> {
  int _selectedPresetIndex = 0;

  final List<_EmptyStatePreset> _presets = [
    _EmptyStatePreset(
      type: 'Empty Cart',
      title: 'Keranjang Belanja Kosong',
      description:
          'Wah, belum ada barang impian yang dimasukkan ke keranjang. Yuk jelajahi promo spesial hari ini!',
      icon: Icons.shopping_bag_outlined,
      iconColor: const Color(0xFF6366F1),
      buttonLabel: 'Mulai Belanja',
      secondaryButtonLabel: 'Lihat Wishlist',
      accentColor: const Color(0xFF6366F1),
    ),
    _EmptyStatePreset(
      type: 'No Connection',
      title: 'Koneksi Internet Terputus',
      description:
          'Sepertinya perangkat Anda sedang offline. Silakan periksa jaringan Wi-Fi atau paket data seluler Anda.',
      icon: Icons.wifi_off_rounded,
      iconColor: const Color(0xFFEF4444),
      buttonLabel: 'Coba Lagi',
      secondaryButtonLabel: 'Buka Pengaturan',
      accentColor: const Color(0xFFEF4444),
    ),
    _EmptyStatePreset(
      type: 'Not Found',
      title: 'Pencarian Tidak Ditemukan',
      description:
          'Kami tidak dapat menemukan hasil untuk kata kunci tersebut. Coba periksa ejaan atau gunakan filter lain.',
      icon: Icons.search_off_rounded,
      iconColor: const Color(0xFFF59E0B),
      buttonLabel: 'Reset Pencarian',
      secondaryButtonLabel: 'Rekomendasi Populer',
      accentColor: const Color(0xFFF59E0B),
    ),
    _EmptyStatePreset(
      type: 'No Orders',
      title: 'Belum Ada Riwayat Pesanan',
      description:
          'Semua transaksi dan riwayat belanja Anda akan tercatat rapi di sini setelah pesanan pertama dibuat.',
      icon: Icons.receipt_long_rounded,
      iconColor: const Color(0xFF10B981),
      buttonLabel: 'Cari Produk Populer',
      secondaryButtonLabel: 'Pusat Bantuan',
      accentColor: const Color(0xFF10B981),
    ),
  ];

  void _onActionTap(String actionName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aksi "$actionName" berhasil dijalankan!'),
        backgroundColor: _presets[_selectedPresetIndex].accentColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preset = _presets[_selectedPresetIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Preset Type Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_presets.length, (index) {
              final p = _presets[index];
              final isSelected = _selectedPresetIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  avatar: Icon(
                    p.icon,
                    size: 14,
                    color: isSelected ? Colors.white : p.accentColor,
                  ),
                  label: Text(p.type),
                  selected: isSelected,
                  selectedColor: p.accentColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPresetIndex = index);
                    }
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),

        // Main Illustrative Empty State Card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder:
              (child, anim) => FadeTransition(opacity: anim, child: child),
          child: Container(
            key: ValueKey<int>(_selectedPresetIndex),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing Icon Aura Container
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: preset.accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: preset.accentColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: preset.accentColor.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      preset.icon,
                      size: 44,
                      color: preset.accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  preset.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    preset.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    if (preset.secondaryButtonLabel != null)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              () => _onActionTap(preset.secondaryButtonLabel!),
                          child: Text(
                            preset.secondaryButtonLabel!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (preset.secondaryButtonLabel != null)
                      const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: preset.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _onActionTap(preset.buttonLabel),
                        child: Text(
                          preset.buttonLabel,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyStatePreset {
  final String type;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String buttonLabel;
  final String? secondaryButtonLabel;
  final Color accentColor;

  _EmptyStatePreset({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.buttonLabel,
    this.secondaryButtonLabel,
    required this.accentColor,
  });
}
