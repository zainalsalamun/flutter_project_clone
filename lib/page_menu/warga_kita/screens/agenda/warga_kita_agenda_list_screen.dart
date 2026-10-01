import 'package:flutter/material.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';
import '../../widgets/warga_kita_agenda_card.dart';

class WargaKitaAgendaListScreen extends StatelessWidget {
  const WargaKitaAgendaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: WargaKitaTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kabar & Agenda RT 04',
          style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
        ),
      ),
      body: ValueListenableBuilder<List<AgendaItem>>(
        valueListenable: WargaKitaData().agendaNotifier,
        builder: (context, agendas, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header announcement box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFDAE2FD)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_available_rounded, color: WargaKitaTheme.primaryContainer, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agenda Kegiatan & Ronda Bersama',
                            style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: WargaKitaTheme.primaryContainer),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pastikan konfirmasi kehadiran pada kegiatan gotong royong dan piket siskamling lingkungan.',
                            style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Semua Kegiatan & Agenda', style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              ...agendas.map((agenda) {
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
                          content: Text(agenda.isConfirmed ? 'Terima kasih atas konfirmasi kehadiran Anda!' : 'Konfirmasi kehadiran dibatalkan.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
