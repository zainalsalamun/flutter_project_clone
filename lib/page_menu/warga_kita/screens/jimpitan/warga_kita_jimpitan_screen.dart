import 'package:flutter/material.dart';
import '../../core/warga_kita_currency.dart';
import '../../core/warga_kita_theme.dart';

class WargaKitaJimpitanScreen extends StatefulWidget {
  const WargaKitaJimpitanScreen({super.key});

  @override
  State<WargaKitaJimpitanScreen> createState() => _WargaKitaJimpitanScreenState();
}

class _WargaKitaJimpitanScreenState extends State<WargaKitaJimpitanScreen> {
  int _totalUang = 1240000;
  final int _totalBerasKg = 45;
  int _collectedHousesToday = 28;
  final int _totalHouses = 42;

  final List<Map<String, dynamic>> _history = [
    {
      'house': 'Blok C2 No. 14 (Rumah Anda)',
      'time': 'Tadi malam, 23:15 WIB',
      'type': 'Uang Koin Rp 2.000 + Beras 100gr',
      'officer': 'Regu Bpk. Hendra',
      'status': 'Terverifikasi',
    },
    {
      'house': 'Blok C2 No. 12',
      'time': 'Tadi malam, 23:18 WIB',
      'type': 'Uang Koin Rp 1.000',
      'officer': 'Regu Bpk. Hendra',
      'status': 'Terverifikasi',
    },
    {
      'house': 'Blok C2 No. 10',
      'time': 'Tadi malam, 23:22 WIB',
      'type': 'Uang Koin Rp 2.000 + Beras 100gr',
      'officer': 'Regu Bpk. Hendra',
      'status': 'Terverifikasi',
    },
    {
      'house': 'Blok C1 No. 08',
      'time': 'Tadi malam, 23:35 WIB',
      'type': 'Uang Koin Rp 1.000',
      'officer': 'Regu Bpk. Hendra',
      'status': 'Terverifikasi',
    },
  ];

  void _simulateScan() {
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
                'Scan QR Kotak Jimpitan',
                style: WargaKitaTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: WargaKitaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Arahkan kamera ke QR Code di depan pagar/kotak jimpitan warga.',
                textAlign: TextAlign.center,
                style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 80,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _collectedHousesToday++;
                      _totalUang += 2000;
                      _history.insert(0, {
                        'house': 'Blok C3 No. 05 (Baru Di-scan)',
                        'time': 'Baru saja',
                        'type': 'Uang Koin Rp 2.000 + Beras 100gr',
                        'officer': 'Petugas Ronda',
                        'status': 'Terverifikasi',
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Jimpitan Blok C3 No. 05 berhasil dicatat! (+Rp 2.000)'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                  label: Text(
                    'Simulasi Sukses Scan QR Jimpitan',
                    style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          'Scan Jimpitan Warga',
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
          // Hero Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF78350F),
                  Color(0xFF92400E),
                  Color(0xFFB45309),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB45309).withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tradisi Gotong Royong RT 04',
                          style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6CF8BB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Ronda Aktif',
                        style: WargaKitaTheme.font(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF005D42)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Jimpitan Terkumpul Bulan Ini',
                  style: WargaKitaTheme.font(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatWargaRupiah(_totalUang),
                      style: WargaKitaTheme.font(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_totalBerasKg kg Beras',
                        style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Piket Ronda Semalam: $_collectedHousesToday/$_totalHouses Rumah',
                          style: WargaKitaTheme.font(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        Text(
                          '${((_collectedHousesToday / _totalHouses) * 100).toInt()}%',
                          style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _collectedHousesToday / _totalHouses,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6CF8BB)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scan Action Button
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _simulateScan,
              icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
              label: Text(
                'Scan QR Kotak Jimpitan Ronda',
                style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF047857),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 1,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section Title
          Text(
            'Riwayat Pengambilan Jimpitan',
            style: WargaKitaTheme.font(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: WargaKitaTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // History List
          ..._history.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WargaKitaTheme.cardBorder),
                boxShadow: WargaKitaTheme.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.grain_rounded, color: Color(0xFFB45309), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['house'],
                          style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['type'],
                          style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF047857)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item['time']} • ${item['officer']}',
                          style: WargaKitaTheme.font(fontSize: 10, color: WargaKitaTheme.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: Color(0xFF047857), size: 14),
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
