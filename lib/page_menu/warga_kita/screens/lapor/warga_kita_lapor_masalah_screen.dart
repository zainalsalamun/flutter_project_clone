import 'package:flutter/material.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';

class WargaKitaLaporMasalahScreen extends StatefulWidget {
  const WargaKitaLaporMasalahScreen({super.key});

  @override
  State<WargaKitaLaporMasalahScreen> createState() => _WargaKitaLaporMasalahScreenState();
}

class _WargaKitaLaporMasalahScreenState extends State<WargaKitaLaporMasalahScreen> {
  void _openReportModal() {
    String selectedCat = 'Lampu Jalan Padam';
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final locCtrl = TextEditingController(text: 'Dekat Blok C2 No. 14');

    final categories = [
      {'name': 'Lampu Jalan Padam', 'icon': Icons.lightbulb_outline_rounded},
      {'name': 'Saluran Air / Selokan', 'icon': Icons.water_damage_outlined},
      {'name': 'Sampah & Kebersihan', 'icon': Icons.delete_outline_rounded},
      {'name': 'Kamtibmas & Keamanan', 'icon': Icons.security_rounded},
      {'name': 'Jalan Rusak / Fasum', 'icon': Icons.construction_rounded},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
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
                      'Lapor Masalah Lingkungan',
                      style: WargaKitaTheme.font(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WargaKitaTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Laporan Anda diteruskan langsung ke Pengurus RT & Sie Terkait',
                      style: WargaKitaTheme.font(
                        fontSize: 12,
                        color: WargaKitaTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Category
                    Text('Kategori Masalah', style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: WargaKitaTheme.cardBorder),
                        color: const Color(0xFFF8FAFC),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCat,
                          isExpanded: true,
                          items: categories.map((c) {
                            return DropdownMenuItem(
                              value: c['name'] as String,
                              child: Row(
                                children: [
                                  Icon(c['icon'] as IconData, size: 18, color: WargaKitaTheme.primary),
                                  const SizedBox(width: 8),
                                  Text(c['name'] as String, style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setModalState(() => selectedCat = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Judul Laporan
                    Text('Judul Laporan', style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        hintText: 'Cth: Lampu Tiang Gang C2 Padam',
                        hintStyle: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textTertiary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: WargaKitaTheme.cardBorder),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Detail Masalah
                    Text('Deskripsi Masalah', style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Jelaskan kondisi secara detail agar pengurus mudah menindaklanjuti...',
                        hintStyle: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textTertiary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: WargaKitaTheme.cardBorder),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lokasi
                    Text('Lokasi / Patokan', style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: locCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_rounded, color: Color(0xFFEF4444), size: 20),
                        hintText: 'Alamat / Patokan lokasi',
                        hintStyle: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textTertiary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: WargaKitaTheme.cardBorder),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) return;

                          final newComplaint = ComplaintReport(
                            id: 'cmp_${DateTime.now().millisecondsSinceEpoch}',
                            ticketNumber: 'LAPOR-2025-${100 + DateTime.now().millisecond}',
                            category: selectedCat,
                            categoryIcon: Icons.warning_amber_rounded,
                            title: titleCtrl.text.trim(),
                            description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'Laporan fasilitas warga.',
                            locationAddress: locCtrl.text.trim(),
                            status: ComplaintStatus.diajukan,
                            reportedDate: 'Hari Ini, Realtime',
                            rtNotes: 'Laporan telah diterima sistem dan menunggu penugasan seksi terkait.',
                          );

                          WargaKitaData().addComplaint(newComplaint);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Laporan Berhasil Dikirim! Tim RT segera menindaklanjuti.'),
                              backgroundColor: WargaKitaTheme.primaryContainer,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WargaKitaTheme.primaryContainer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Kirim Laporan', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
          'Lapor Masalah RT 04',
          style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openReportModal,
        backgroundColor: const Color(0xFFEF4444),
        icon: const Icon(Icons.add_alert_rounded, color: Colors.white),
        label: const Text('Buat Laporan', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: ValueListenableBuilder<List<ComplaintReport>>(
        valueListenable: WargaKitaData().complaintsNotifier,
        builder: (context, complaints, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.help_outline_rounded, color: Color(0xFFD97706), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lapor Cepat Fasilitas Lingkungan',
                            style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF92400E)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Laporkan lampu mati, sampah menumpuk, atau gangguan ketertiban untuk respon cepat pengurus.',
                            style: WargaKitaTheme.font(fontSize: 11, color: const Color(0xFF78350F)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Daftar Laporan Warga', style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              ...complaints.map((report) {
                final isDone = report.status == ComplaintStatus.selesai;
                final isProgress = report.status == ComplaintStatus.diproses;

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFFD1FAE5)
                                  : isProgress
                                      ? const Color(0xFFE0F2FE)
                                      : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isDone ? 'SELESAI' : isProgress ? 'SEDANG DIPROSES' : 'DIAJUKAN',
                              style: WargaKitaTheme.font(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: isDone
                                    ? const Color(0xFF047857)
                                    : isProgress
                                        ? const Color(0xFF0284C7)
                                        : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                          Text(
                            report.reportedDate,
                            style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        report.title,
                        style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kategori: ${report.category} • Tiket: ${report.ticketNumber}',
                        style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: WargaKitaTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        report.description,
                        style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Color(0xFFEF4444), size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              report.locationAddress,
                              style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textSecondary, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      if (report.rtNotes != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: WargaKitaTheme.cardBorder),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.reply_rounded, color: WargaKitaTheme.primaryContainer, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tindak Lanjut RT: ${report.rtNotes}',
                                  style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.primaryContainer, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
