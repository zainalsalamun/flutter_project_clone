import 'package:flutter/material.dart';
import '../../core/warga_kita_currency.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';

class WargaKitaBayarIuranScreen extends StatefulWidget {
  const WargaKitaBayarIuranScreen({super.key});

  @override
  State<WargaKitaBayarIuranScreen> createState() => _WargaKitaBayarIuranScreenState();
}

class _WargaKitaBayarIuranScreenState extends State<WargaKitaBayarIuranScreen> {
  void _processPayment(IuranPeriod period) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Konfirmasi Bayar Iuran',
                style: WargaKitaTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: WargaKitaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Periode: ${period.month} ${period.year} • Blok C2 No. 14',
                style: WargaKitaTheme.font(
                  fontSize: 13,
                  color: WargaKitaTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Breakdown Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WargaKitaTheme.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildRow('Iuran Kas RT 04', formatWargaRupiah(period.amountKasRT)),
                    const SizedBox(height: 8),
                    _buildRow('Iuran Petugas Satpam', formatWargaRupiah(period.amountSatpam)),
                    const SizedBox(height: 8),
                    _buildRow('Iuran Kebersihan & Sampah', formatWargaRupiah(period.amountKebersihan)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: WargaKitaTheme.cardBorder),
                    ),
                    _buildRow(
                      'Total Pembayaran',
                      formatWargaRupiah(period.totalAmount),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Method Selector
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WargaKitaTheme.mintTint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: WargaKitaTheme.mintBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded, color: WargaKitaTheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'QRIS Realtime RT 04',
                            style: WargaKitaTheme.font(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: WargaKitaTheme.primaryContainer,
                            ),
                          ),
                          Text(
                            'Otomatis terverifikasi tanpa perlu unggah struk',
                            style: WargaKitaTheme.font(
                              fontSize: 11,
                              color: WargaKitaTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: WargaKitaTheme.primary, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pay Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    WargaKitaData().payIuran(period.id, 'QRIS RT 04');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pembayaran Iuran ${period.month} ${period.year} Berhasil! Status: LUNAS'),
                        backgroundColor: WargaKitaTheme.primaryContainer,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WargaKitaTheme.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Bayar Sekarang (${formatWargaRupiah(period.totalAmount)})',
                    style: WargaKitaTheme.font(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String val, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: WargaKitaTheme.font(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? WargaKitaTheme.textPrimary : WargaKitaTheme.textSecondary,
          ),
        ),
        Text(
          val,
          style: WargaKitaTheme.font(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            color: isTotal ? WargaKitaTheme.primaryContainer : WargaKitaTheme.textPrimary,
          ),
        ),
      ],
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
          'Iuran Warga RT 04',
          style: WargaKitaTheme.font(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: WargaKitaTheme.textPrimary,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<IuranPeriod>>(
        valueListenable: WargaKitaData().iuranNotifier,
        builder: (context, iuranList, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Resident Summary Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WargaKitaTheme.cardBorder),
                  boxShadow: WargaKitaTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: WargaKitaTheme.mintTint,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.house_rounded, color: WargaKitaTheme.primaryContainer, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budi Santoso',
                            style: WargaKitaTheme.font(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: WargaKitaTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Blok C2 No. 14 • RT 04 / RW 08',
                            style: WargaKitaTheme.font(
                              fontSize: 12,
                              color: WargaKitaTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title Header
              Text(
                'Tagihan & Riwayat Iuran',
                style: WargaKitaTheme.font(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: WargaKitaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Periods List
              ...iuranList.map((period) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: period.isPaid ? WargaKitaTheme.cardBorder : const Color(0xFFFDE68A),
                      width: period.isPaid ? 1 : 1.5,
                    ),
                    boxShadow: WargaKitaTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${period.month} ${period.year}',
                                style: WargaKitaTheme.font(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: WargaKitaTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: period.isPaid
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  period.isPaid ? 'LUNAS' : 'BELUM DIBAYAR',
                                  style: WargaKitaTheme.font(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: period.isPaid
                                        ? const Color(0xFF047857)
                                        : const Color(0xFFB45309),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            formatWargaRupiah(period.totalAmount),
                            style: WargaKitaTheme.font(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: period.isPaid
                                  ? WargaKitaTheme.textPrimary
                                  : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kas: ${formatWargaRupiahClean(period.amountKasRT)} • Satpam: ${formatWargaRupiahClean(period.amountSatpam)} • Sampah: ${formatWargaRupiahClean(period.amountKebersihan)}',
                            style: WargaKitaTheme.font(
                              fontSize: 11,
                              color: WargaKitaTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (!period.isPaid) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () => _processPayment(period),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WargaKitaTheme.primaryContainer,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Bayar Iuran Bulan Ini',
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Dibayar pada ${period.paidAt ?? '-'} via ${period.paymentMethod ?? 'Online'}',
                            style: WargaKitaTheme.font(
                              fontSize: 11,
                              color: WargaKitaTheme.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
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
