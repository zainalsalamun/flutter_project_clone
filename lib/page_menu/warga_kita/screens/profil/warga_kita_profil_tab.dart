import 'package:flutter/material.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../widgets/warga_kita_network_image.dart';

class WargaKitaProfilTab extends StatelessWidget {
  const WargaKitaProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = WargaKitaData.defaultUser;

    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Profil Warga & KK',
          style: WargaKitaTheme.font(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: WargaKitaTheme.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: WargaKitaTheme.cardBorder),
              boxShadow: WargaKitaTheme.cardShadow,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: WargaKitaNetworkImage(
                    imageUrl: user.avatarUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.fullName,
                  style: WargaKitaTheme.font(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: WargaKitaTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.blockNumber} • ${user.rtRw}',
                  style: WargaKitaTheme.font(
                    fontSize: 13,
                    color: WargaKitaTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, color: Color(0xFF047857), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Warga Tetap Terverifikasi Dukcapil',
                        style: WargaKitaTheme.font(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Identitas Kependudukan Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WargaKitaTheme.cardBorder),
              boxShadow: WargaKitaTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identitas Kependudukan (KK)',
                  style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                _buildInfoRow('Nomor Kartu Keluarga (KK)', user.kkNumber),
                _buildInfoRow('Nomor Induk Kependudukan (NIK)', user.nik),
                _buildInfoRow('Nomor Handphone / WA', user.phone),
                _buildInfoRow('Kelurahan / Domisili', '${user.village}, RT 04 / RW 08'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Anggota Keluarga (KK)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WargaKitaTheme.cardBorder),
              boxShadow: WargaKitaTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anggota Keluarga Terdaftar (${user.familyMembers.length} Jiwa)',
                  style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                ...user.familyMembers.map((m) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'NIK: ${m.nik}',
                              style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textTertiary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E7FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            m.relation,
                            style: WargaKitaTheme.font(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Kontak Darurat Lingkungan
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WargaKitaTheme.cardBorder),
              boxShadow: WargaKitaTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kontak Darurat Siaga Lingkungan',
                  style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                _buildEmergencyContactRow(
                  'Pos Satpam Utama RT 04',
                  '0811-9988-7711 (24 Jam)',
                  Icons.local_police_rounded,
                  const Color(0xFF047857),
                ),
                _buildEmergencyContactRow(
                  'Puskesmas / Medis Sukamaju',
                  '021-8765432 / 119',
                  Icons.local_hospital_rounded,
                  const Color(0xFFDC2626),
                ),
                _buildEmergencyContactRow(
                  'Pemadam Kebakaran (Damkar)',
                  '113 / 021-8899001',
                  Icons.fire_truck_rounded,
                  const Color(0xFFD97706),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textTertiary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactRow(String title, String phone, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
                Text(phone, style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.phone_in_talk_rounded, size: 16, color: Color(0xFF047857)),
        ],
      ),
    );
  }
}
