import 'package:flutter/material.dart';
import '../../../core/theme/travel_theme.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          'Akun Profil Saya',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: TravelTheme.dark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: TravelTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: TravelTheme.dark.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: TravelTheme.primaryLight, width: 2.5),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Zainal Salamun',
                          style: TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'zainal.dev@example.com',
                          style: TextStyle(
                            color: TravelTheme.muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TravelTheme.accentGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded, color: TravelTheme.accentGold, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'GOLD ELITE MEMBER',
                                style: TextStyle(
                                  color: Color(0xFFB45309),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // WanderMiles Points Card (Loyalty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: TravelTheme.primaryGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: TravelTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: TravelTheme.accentGold, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'WanderMiles Poin',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '14.250 pts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: TravelTheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Tukar Hadiah', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats Quick Row
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: TravelTheme.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('8', 'Perjalanan'),
                  Container(width: 1, height: 28, color: TravelTheme.border),
                  _buildStatItem('14', 'Ulasan'),
                  Container(width: 1, height: 28, color: TravelTheme.border),
                  _buildStatItem('3', 'Voucher Aktif'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Settings Menu List
            _buildMenuGroup(
              title: 'Pengaturan & Dokumen',
              items: [
                _MenuItem(icon: Icons.credit_card_rounded, title: 'Metode Pembayaran Tersimpan', subtitle: 'BCA VA, Visa, GoPay'),
                _MenuItem(icon: Icons.badge_outlined, title: 'Data Identitas & Paspor', subtitle: 'NIK & Nomor Paspor Utama'),
                _MenuItem(icon: Icons.local_offer_outlined, title: 'Voucher & Promo Saya', subtitle: '3 kupon diskon tersedia'),
              ],
            ),

            const SizedBox(height: 16),

            _buildMenuGroup(
              title: 'Preferensi & Keamanan',
              items: [
                _MenuItem(icon: Icons.notifications_none_rounded, title: 'Notifikasi Tiket & Pengingat', subtitle: 'Aktif'),
                _MenuItem(icon: Icons.language_rounded, title: 'Bahasa & Wilayah', subtitle: 'Bahasa Indonesia (IDR)'),
                _MenuItem(icon: Icons.fingerprint_rounded, title: 'Keamanan & Biometrik Face ID', subtitle: 'Telah Diamankan'),
              ],
            ),

            const SizedBox(height: 16),

            _buildMenuGroup(
              title: 'Pusat Bantuan & Lainnya',
              items: [
                _MenuItem(icon: Icons.support_agent_rounded, title: 'Customer Support 24/7', subtitle: 'Chat dengan Tim Wanderlust'),
                _MenuItem(icon: Icons.description_outlined, title: 'Syarat & Ketentuan Layanan', subtitle: 'Kebijakan Privasi'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: TravelTheme.dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: TravelTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup({required String title, required List<_MenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: TravelTheme.darkMuted,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TravelTheme.border),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TravelTheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: TravelTheme.primary, size: 20),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: TravelTheme.dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 11,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: TravelTheme.muted,
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  if (index < items.length - 1)
                    const Divider(color: TravelTheme.surface, height: 1, indent: 60),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
