import 'package:flutter/material.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';
import '../../widgets/warga_kita_agenda_card.dart';
import '../../widgets/warga_kita_header.dart';
import '../../widgets/warga_kita_kas_card.dart';
import '../../widgets/warga_kita_service_tile.dart';
import '../../widgets/warga_kita_sos_card.dart';
import '../../widgets/warga_kita_sos_dialog.dart';
import '../agenda/warga_kita_agenda_list_screen.dart';
import '../fasilitas/warga_kita_fasilitas_screen.dart';
import '../iuran/warga_kita_bayar_iuran_screen.dart';
import '../jimpitan/warga_kita_jimpitan_screen.dart';
import '../kas/warga_kita_buku_kas_screen.dart';
import '../lapor/warga_kita_lapor_masalah_screen.dart';
import '../pasar/warga_kita_pasar_screen.dart';
import '../ronda/warga_kita_ronda_screen.dart';
import '../surat/warga_kita_surat_pengantar_screen.dart';

class WargaKitaHomeTab extends StatelessWidget {
  final VoidCallback onNavigateToPesan;
  final VoidCallback onNavigateToProfil;

  const WargaKitaHomeTab({
    super.key,
    required this.onNavigateToPesan,
    required this.onNavigateToProfil,
  });

  @override
  Widget build(BuildContext context) {
    final user = WargaKitaData.defaultUser;

    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Bar
              WargaKitaHeader(
                onNotificationTap: onNavigateToPesan,
                onProfileTap: onNavigateToProfil,
              ),
              const SizedBox(height: 12),

              // Greeting & Resident Status Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Greeting Headline
                    Row(
                      children: [
                        Text(
                          'Selamat Pagi, ${user.name}',
                          style: WargaKitaTheme.font(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: WargaKitaTheme.textPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.waving_hand_rounded,
                          color: Color(0xFFF59E0B),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Subtitle Details with Checkmark
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 14,
                          color: Color(0xFF047857),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${user.role}  •  ${user.blockNumber}  •  ${user.rtRw}',
                          style: WargaKitaTheme.font(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: WargaKitaTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Status Iuran Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6CF8BB).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.5),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: Color(0xFF005D42),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Status Iuran: ${user.duesStatus}',
                            style: WargaKitaTheme.font(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF005D42),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Total Kas Lingkungan RT 04 Card
              WargaKitaKasCard(
                onOpenLedger: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WargaKitaBukuKasScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Tombol Darurat (SOS) Card
              WargaKitaSosCard(
                onTriggerSos: () => WargaKitaSosDialog.show(context),
                onPosRondaTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pos Ronda RT 04: Aktif & Siaga 24 Jam (Petugas: Bpk. Hendra & Bpk. Budi)'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Layanan Warga Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Layanan Warga RT 04',
                      style: WargaKitaTheme.font(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WargaKitaTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      '8 Layanan Aktif',
                      style: WargaKitaTheme.font(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: WargaKitaTheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Layanan Warga 4x2 Grid (8 Services)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.72,
                  children: [
                    // 1. Bayar Iuran
                    WargaKitaServiceTile(
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: const Color(0xFF005D42),
                      iconBgColor: const Color(0xFFE6F8F0),
                      title: 'Bayar Iuran',
                      subtitle: 'Iuran Warga',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaBayarIuranScreen(),
                          ),
                        );
                      },
                    ),

                    // 2. Surat RT
                    WargaKitaServiceTile(
                      icon: Icons.mark_email_read_rounded,
                      iconColor: const Color(0xFF006C5B),
                      iconBgColor: const Color(0xFFE6F6F6),
                      title: 'Surat RT',
                      subtitle: 'KTP & Domisili',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaSuratPengantarScreen(),
                          ),
                        );
                      },
                    ),

                    // 3. Lapor Warga
                    WargaKitaServiceTile(
                      icon: Icons.campaign_rounded,
                      iconColor: const Color(0xFFE11D48),
                      iconBgColor: const Color(0xFFFFF1F2),
                      title: 'Lapor Warga',
                      subtitle: 'Aduan Masalah',
                      badgeText: 'Cepat',
                      badgeBgColor: const Color(0xFFD1FAE5),
                      badgeTextColor: const Color(0xFF047857),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaLaporMasalahScreen(),
                          ),
                        );
                      },
                    ),

                    // 4. Pengumuman
                    WargaKitaServiceTile(
                      icon: Icons.feed_rounded,
                      iconColor: const Color(0xFF4338CA),
                      iconBgColor: const Color(0xFFEEF2FF),
                      title: 'Pengumuman',
                      subtitle: 'Edaran Resmi',
                      onTap: onNavigateToPesan,
                    ),

                    // 5. Scan Jimpitan
                    WargaKitaServiceTile(
                      icon: Icons.qr_code_scanner_rounded,
                      iconColor: const Color(0xFFB45309),
                      iconBgColor: const Color(0xFFFFFBEB),
                      title: 'Scan Jimpitan',
                      subtitle: 'Uang & Beras',
                      badgeText: 'Ronda',
                      badgeBgColor: const Color(0xFFD1FAE5),
                      badgeTextColor: const Color(0xFF047857),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaJimpitanScreen(),
                          ),
                        );
                      },
                    ),

                    // 6. Jadwal Ronda
                    WargaKitaServiceTile(
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFF0369A1),
                      iconBgColor: const Color(0xFFF0F7FF),
                      title: 'Jadwal Ronda',
                      subtitle: 'Siskamling',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaRondaScreen(),
                          ),
                        );
                      },
                    ),

                    // 7. Pinjam Fasilitas
                    WargaKitaServiceTile(
                      icon: Icons.holiday_village_rounded,
                      iconColor: const Color(0xFF6D28D9),
                      iconBgColor: const Color(0xFFF5F3FF),
                      title: 'Pinjam Fasili...',
                      subtitle: 'Balai & Tenda',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaFasilitasScreen(),
                          ),
                        );
                      },
                    ),

                    // 8. Pasar Warga
                    WargaKitaServiceTile(
                      icon: Icons.storefront_rounded,
                      iconColor: const Color(0xFF047857),
                      iconBgColor: const Color(0xFFE6F8F0),
                      title: 'Pasar Warga',
                      subtitle: 'UMKM RT',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaPasarScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kabar & Agenda Lingkungan Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 20,
                          color: WargaKitaTheme.primaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kabar & Agenda Lingkungan',
                          style: WargaKitaTheme.font(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: WargaKitaTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaAgendaListScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Semua',
                        style: WargaKitaTheme.font(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: WargaKitaTheme.primaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Agenda Cards List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ValueListenableBuilder<List<AgendaItem>>(
                  valueListenable: WargaKitaData().agendaNotifier,
                  builder: (context, agendas, _) {
                    return Column(
                      children: agendas.map((agenda) {
                        return WargaKitaAgendaCard(
                          agenda: agenda,
                          onActionTap: () {
                            if (agenda.isSiskamling) {
                              WargaKitaData().swapShift(agenda.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permohonan Tukar Jadwal Ronda Terkirim ke Regu Garuda'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              WargaKitaData().toggleAgendaRsvp(agenda.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    agenda.isConfirmed
                                        ? 'Terima kasih telah konfirmasi hadir di kerja bakti!'
                                        : 'Konfirmasi kehadiran dibatalkan.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
