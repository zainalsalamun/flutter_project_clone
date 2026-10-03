import 'package:flutter/material.dart';
import '../../core/botanica_theme.dart';
import '../../widgets/botanica_cart_sheet.dart';

class BotanicaProfileTab extends StatelessWidget {
  const BotanicaProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BotanicaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profil Cantik Saya',
          style: BotanicaTheme.font(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: BotanicaTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: BotanicaTheme.textPrimary, size: 22),
            onPressed: () => BotanicaCartSheet.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Profile Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BotanicaTheme.cardBorderLight),
                boxShadow: BotanicaTheme.cardShadow,
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: BotanicaTheme.primaryTint,
                      border: Border.all(color: BotanicaTheme.primary, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.person_rounded, size: 34, color: BotanicaTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info & Tier Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clara Salsabila',
                          style: BotanicaTheme.font(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: BotanicaTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'clara.salsabila@email.com',
                          style: BotanicaTheme.font(
                            fontSize: 12,
                            color: BotanicaTheme.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: BotanicaTheme.primaryTint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, size: 14, color: BotanicaTheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                'BOTANICA Emerald • 1.450 Poin',
                                style: BotanicaTheme.font(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: BotanicaTheme.primary,
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

            // Skin Profile Assessment Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3E33), Color(0xFF1B5E4F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: BotanicaTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Skin Profile & Diagnostics',
                            style: BotanicaTheme.font(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Kombinasi',
                          style: BotanicaTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fokus Perawatan: Skin Barrier Repair, Hidrasi Intensif, & Pencerah Alami.',
                    style: BotanicaTheme.font(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Skin test diagnostic akan diperbarui.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        'Konsultasi Rekomendasi Rutinitas',
                        style: BotanicaTheme.font(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Status Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BotanicaTheme.cardBorderLight),
                boxShadow: BotanicaTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Pesanan',
                    style: BotanicaTheme.font(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: BotanicaTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOrderStatusItem(Icons.payment_rounded, 'Belum Bayar', '0'),
                      _buildOrderStatusItem(Icons.inventory_2_outlined, 'Dikemas', '1'),
                      _buildOrderStatusItem(Icons.local_shipping_outlined, 'Dikirim', '2'),
                      _buildOrderStatusItem(Icons.rate_review_outlined, 'Beri Nilai', '0'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BotanicaTheme.cardBorderLight),
                boxShadow: BotanicaTheme.cardShadow,
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Daftar Alamat Pengiriman',
                    subtitle: '2 alamat tersimpan',
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildMenuItem(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Voucher & Promo Saya',
                    subtitle: 'Kode BOTANICAGLOW aktif',
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildMenuItem(
                    icon: Icons.support_agent_rounded,
                    title: 'Bantuan & Live Consultation',
                    subtitle: 'Hubungi Beauty Advisor kami',
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang BOTANICA Clean Beauty',
                    subtitle: '100% Produk Terdaftar BPOM',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem(IconData icon, String label, String badge) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: BotanicaTheme.textPrimary),
            ),
            if (badge != '0')
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: BotanicaTheme.accentRose,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Center(
                    child: Text(
                      badge,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: BotanicaTheme.font(
            fontSize: 11,
            color: BotanicaTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: BotanicaTheme.primaryTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: BotanicaTheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: BotanicaTheme.font(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: BotanicaTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: BotanicaTheme.font(
          fontSize: 11,
          color: BotanicaTheme.textTertiary,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: BotanicaTheme.textTertiary),
      onTap: onTap,
    );
  }
}
