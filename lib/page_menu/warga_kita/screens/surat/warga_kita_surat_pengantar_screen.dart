import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';

class WargaKitaSuratPengantarScreen extends StatefulWidget {
  const WargaKitaSuratPengantarScreen({super.key});

  @override
  State<WargaKitaSuratPengantarScreen> createState() => _WargaKitaSuratPengantarScreenState();
}

class _WargaKitaSuratPengantarScreenState extends State<WargaKitaSuratPengantarScreen> {
  void _openRequestModal() {
    String selectedType = 'Surat Pengantar Pembuatan KTP';
    final purposeController = TextEditingController();

    final letterTypes = [
      'Surat Pengantar Pembuatan KTP',
      'Surat Pengantar Kartu Keluarga (KK)',
      'Surat Keterangan Domisili Tinggal',
      'Surat Pengantar Catatan Kepolisian (SKCK)',
      'Surat Keterangan Domisili Usaha',
      'Surat Pengantar Pernikahan (N1-N4)',
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
                    'Buat Surat Pengantar Online',
                    style: WargaKitaTheme.font(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: WargaKitaTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Surat otomatis diterbitkan dengan TTD QR Digital Ketua RT 04',
                    style: WargaKitaTheme.font(
                      fontSize: 12,
                      color: WargaKitaTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Letter Type
                  Text('Jenis Surat Pengantar', style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
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
                        value: selectedType,
                        isExpanded: true,
                        items: letterTypes.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(t, style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setModalState(() => selectedType = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Keperluan
                  Text('Keperluan / Keterangan', style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: purposeController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Cth: Persyaratan perpanjangan KTP di Kelurahan',
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
                        if (purposeController.text.trim().isEmpty) return;
                        final newRequest = SuratPengantarRequest(
                          id: 'srt_${DateTime.now().millisecondsSinceEpoch}',
                          requestNumber: 'SP/RT04/2025/${100 + DateTime.now().millisecond}',
                          letterType: selectedType,
                          purpose: purposeController.text.trim(),
                          applicantName: WargaKitaData.defaultUser.fullName,
                          applicantNik: WargaKitaData.defaultUser.nik,
                          blockNumber: WargaKitaData.defaultUser.blockNumber,
                          status: SuratStatus.disetujui,
                          qrCodeHash: 'WK-VALID-RT04-${DateTime.now().millisecondsSinceEpoch}',
                          createdDate: 'Hari Ini, Realtime',
                          signedByRt: 'H. Rahmat (Ketua RT 04)',
                        );

                        WargaKitaData().addSuratRequest(newRequest);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Surat Pengantar Berhasil Diterbitkan!'),
                            backgroundColor: WargaKitaTheme.primaryContainer,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WargaKitaTheme.primaryContainer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Terbitkan Surat Pengantar', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showQrPreview(SuratPengantarRequest surat) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TTD Digital Terverifikasi',
                  style: WargaKitaTheme.font(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  surat.requestNumber,
                  style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.primaryContainer, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WargaKitaTheme.cardBorder),
                  ),
                  child: QrImageView(
                    data: surat.qrCodeHash,
                    version: QrVersions.auto,
                    size: 160.0,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ditandatangani secara elektronik oleh:',
                  style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textSecondary),
                ),
                Text(
                  surat.signedByRt,
                  style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WargaKitaTheme.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
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
          'Surat Pengantar RT Online',
          style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRequestModal,
        backgroundColor: WargaKitaTheme.primaryContainer,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Buat Surat', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: ValueListenableBuilder<List<SuratPengantarRequest>>(
        valueListenable: WargaKitaData().suratRequestsNotifier,
        builder: (context, requests, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFDAE2FD)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_2_rounded, color: WargaKitaTheme.primaryContainer, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Layanan Surat Cepat RT 04',
                            style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: WargaKitaTheme.primaryContainer),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Surat ber-QR Code resmi sah digunakan untuk pengurusan berkas di Kelurahan & Dukcapil.',
                            style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Daftar Surat Saya', style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              ...requests.map((surat) {
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
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'TERVERIFIKASI',
                              style: WargaKitaTheme.font(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF047857)),
                            ),
                          ),
                          Text(
                            surat.createdDate,
                            style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        surat.letterType,
                        style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Nomor: ${surat.requestNumber}',
                        style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: WargaKitaTheme.primaryContainer),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keperluan: ${surat.purpose}',
                        style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TTD: ${surat.signedByRt}',
                            style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textTertiary, fontWeight: FontWeight.w500),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _showQrPreview(surat),
                            icon: const Icon(Icons.qr_code_rounded, size: 16),
                            label: const Text('Lihat QR TTD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: WargaKitaTheme.primaryContainer,
                              side: const BorderSide(color: WargaKitaTheme.primaryContainer),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                          ),
                        ],
                      ),
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
