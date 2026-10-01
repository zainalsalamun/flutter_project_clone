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
import '../iuran/warga_kita_bayar_iuran_screen.dart';
import '../kas/warga_kita_buku_kas_screen.dart';
import '../lapor/warga_kita_lapor_masalah_screen.dart';
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
                      'Layanan Warga',
                      style: WargaKitaTheme.font(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WargaKitaTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Terintegrasi RT 04',
                      style: WargaKitaTheme.font(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: WargaKitaTheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Layanan Warga 2x2 Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    // 1. Bayar Iuran
                    WargaKitaServiceTile(
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: Colors.white,
                      iconBgColor: WargaKitaTheme.primaryContainer,
                      title: 'Bayar Iuran',
                      subtitle: 'Sampah, Satpam & Kas',
                      badgeText: 'Iuran Juni',
                      badgeBgColor: const Color(0xFF6CF8BB),
                      badgeTextColor: const Color(0xFF005D42),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaBayarIuranScreen(),
                          ),
                        );
                      },
                    ),

                    // 2. Pengumuman
                    WargaKitaServiceTile(
                      icon: Icons.campaign_rounded,
                      iconColor: const Color(0xFF005D42),
                      iconBgColor: const Color(0xFF6CF8BB),
                      title: 'Pengumuman',
                      subtitle: 'Surat Edaran Pengurus',
                      badgeText: '2 Baru',
                      badgeBgColor: const Color(0xFFFFDAD6),
                      badgeTextColor: const Color(0xFF93000A),
                      onTap: onNavigateToPesan,
                    ),

                    // 3. Surat Pengantar
                    WargaKitaServiceTile(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFF0284C7),
                      iconBgColor: const Color(0xFFE0F2FE),
                      title: 'Surat Pengantar',
                      subtitle: 'KTP, KK, Domisili, dll',
                      badgeText: 'Cepat • TTD QR',
                      badgeBgColor: const Color(0xFFE2E7FF),
                      badgeTextColor: const Color(0xFF1E293B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaSuratPengantarScreen(),
                          ),
                        );
                      },
                    ),

                    // 4. Lapor Masalah
                    WargaKitaServiceTile(
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFF005D42),
                      iconBgColor: const Color(0xFFE2E7FF),
                      title: 'Lapor Masalah',
                      subtitle: 'Lampu, Selokan, Kamtib',
                      badgeText: '• Aktif',
                      badgeBgColor: const Color(0xFFE0F2FE),
                      badgeTextColor: const Color(0xFF0284C7),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WargaKitaLaporMasalahScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kabar & Agenda RT Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.feed_outlined,
                          size: 18,
                          color: WargaKitaTheme.primaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Kabar & Agenda RT',
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
                          fontSize: 12,
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
