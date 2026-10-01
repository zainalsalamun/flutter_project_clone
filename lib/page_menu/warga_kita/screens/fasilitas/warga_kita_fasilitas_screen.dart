import 'package:flutter/material.dart';
import '../../core/warga_kita_theme.dart';

class WargaKitaFasilitasScreen extends StatefulWidget {
  const WargaKitaFasilitasScreen({super.key});

  @override
  State<WargaKitaFasilitasScreen> createState() => _WargaKitaFasilitasScreenState();
}

class _WargaKitaFasilitasScreenState extends State<WargaKitaFasilitasScreen> {
  final List<Map<String, dynamic>> _facilities = [
    {
      'name': 'Balai Warga Serbaguna RT 04',
      'category': 'Ruang Pertemuan',
      'capacity': 'Kapasitas 80 Orang',
      'status': 'Tersedia',
      'isAvailable': true,
      'price': 'Gratis (Warga RT 04)',
      'icon': Icons.meeting_room_rounded,
      'color': Color(0xFF6D28D9),
      'desc': 'Dilengkapi AC, sound system, toilet, dan proyektor untuk rapat / acara keluarga.',
    },
    {
      'name': 'Tenda Pesta & Kanopi (4 x 6 m)',
      'category': 'Perlengkapan Outdoor',
      'capacity': 'Tersedia 3 Unit',
      'status': 'Tersedia 2 Unit',
      'isAvailable': true,
      'price': 'Uang Kebersihan Rp 50.000',
      'icon': Icons.roofing_rounded,
      'color': Color(0xFF0284C7),
      'desc': 'Termasuk tiang besi & terpal waterproof untuk hajatan / pengajian.',
    },
    {
      'name': 'Kursi Lipat Futura Stainless',
      'category': 'Furnitur',
      'capacity': 'Tersedia 150 Buah',
      'status': 'Tersedia',
      'isAvailable': true,
      'price': 'Gratis',
      'icon': Icons.chair_rounded,
      'color': Color(0xFF047857),
      'desc': 'Kursi lipat empuk bersih untuk acara di balai maupun rumah warga.',
    },
    {
      'name': 'Sound System Portable + 2 Mic',
      'category': 'Elektronik Audio',
      'capacity': 'Tersedia 2 Set',
      'status': 'Dipinjam Blok C1 (sd 2 Okt)',
      'isAvailable': false,
      'price': 'Gratis',
      'icon': Icons.speaker_group_rounded,
      'color': Color(0xFFB45309),
      'desc': 'Speaker portable bluetooth dengan mic wireless jangkauan 30 meter.',
    },
    {
      'name': 'Meja Prasmanan Lipat (Panjang 2m)',
      'category': 'Furnitur',
      'capacity': 'Tersedia 8 Unit',
      'status': 'Tersedia',
      'isAvailable': true,
      'price': 'Gratis',
      'icon': Icons.table_restaurant_rounded,
      'color': Color(0xFFD97706),
      'desc': 'Meja kokoh dapat dilipat praktis untuk hidangan prasmanan.',
    },
  ];

  void _openBookingForm(Map<String, dynamic> item) {
    final purposeCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '05 Oktober 2026');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Form Pinjam Fasilitas RT',
                style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                item['name'],
                style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6D28D9)),
              ),
              const SizedBox(height: 16),
              Text(
                'Tanggal Pemakaian:',
                style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: dateCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF6D28D9)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: WargaKitaTheme.cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Keperluan / Acara:',
                style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: purposeCtrl,
                decoration: InputDecoration(
                  hintText: 'Cth: Syukuran ulang tahun / Pengajian keluarga',
                  hintStyle: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textTertiary),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: WargaKitaTheme.cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Permohonan pinjam ${item['name']} telah diajukan ke pengurus RT!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D28D9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Ajukan Peminjaman',
                    style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
          'Pinjam Fasilitas & Inventaris',
          style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Announcement Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFDDD6FE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF6D28D9), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Fasilitas & inventaris RT 04 dapat dipinjam oleh seluruh warga tetap. Harap menjaga kebersihan dan mengembalikan tepat waktu.',
                    style: WargaKitaTheme.font(fontSize: 11.5, color: const Color(0xFF4C1D95), height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Items List
          ..._facilities.map((f) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: WargaKitaTheme.cardBorder),
                boxShadow: WargaKitaTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (f['color'] as Color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(f['icon'] as IconData, color: f['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f['name'],
                              style: WargaKitaTheme.font(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: WargaKitaTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${f['category']} • ${f['capacity']}',
                              style: WargaKitaTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: f['color'] as Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: f['isAvailable'] == true ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          f['status'],
                          style: WargaKitaTheme.font(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: f['isAvailable'] == true ? const Color(0xFF047857) : const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    f['desc'],
                    style: WargaKitaTheme.font(fontSize: 11.5, color: WargaKitaTheme.textSecondary, height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        f['price'],
                        style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF047857)),
                      ),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: f['isAvailable'] == true ? () => _openBookingForm(f) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6D28D9),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: Text(
                            f['isAvailable'] == true ? 'Pinjam Sekarang' : 'Sedang Dipakai',
                            style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
