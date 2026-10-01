import 'package:flutter/material.dart';
import '../../core/warga_kita_theme.dart';

class WargaKitaRondaScreen extends StatefulWidget {
  const WargaKitaRondaScreen({super.key});

  @override
  State<WargaKitaRondaScreen> createState() => _WargaKitaRondaScreenState();
}

class _WargaKitaRondaScreenState extends State<WargaKitaRondaScreen> {
  String _selectedDay = 'Kamis';

  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  final Map<String, Map<String, dynamic>> _schedule = {
    'Senin': {
      'coordinator': 'Bpk. Ahmad Fauzi (Blok C1/02)',
      'team': ['Bpk. Joko', 'Bpk. Rusli', 'Bpk. Teguh', 'Bpk. Wahyu'],
      'time': '22:00 – 04:30 WIB',
      'post': 'Pos Ronda Utama (Depan Gerbang Blok C1)',
      'status': 'Selesai',
    },
    'Selasa': {
      'coordinator': 'Bpk. Bambang (Blok C2/05)',
      'team': ['Bpk. Deni', 'Bpk. Iwan', 'Bpk. Gunawan', 'Bpk. Rudi'],
      'time': '22:00 – 04:30 WIB',
      'post': 'Pos Ronda Utama (Depan Gerbang Blok C1)',
      'status': 'Selesai',
    },
    'Rabu': {
      'coordinator': 'Bpk. Supriadi (Blok C3/11)',
      'team': ['Bpk. Yanto', 'Bpk. Surya', 'Bpk. Fajar', 'Bpk. Tono'],
      'time': '22:00 – 04:30 WIB',
      'post': 'Pos Ronda Utama (Depan Gerbang Blok C1)',
      'status': 'Selesai',
    },
    'Kamis': {
      'coordinator': 'Bpk. Hendra Pratama (Anda - Blok C2/14)',
      'team': ['Bpk. Budi Santoso', 'Bpk. Aris', 'Bpk. Rizal', 'Bpk. Dedi'],
      'time': '22:00 – 04:30 WIB',
      'post': 'Pos Ronda Utama (Depan Gerbang Blok C1)',
      'status': 'Malam Ini (Siaga)',
      'isTonight': true,
    },
    'Jumat': {
      'coordinator': 'Bpk. Wisnu (Blok C4/01)',
      'team': ['Bpk. Farhan', 'Bpk. Agus', 'Bpk. Lukman', 'Bpk. Dani'],
      'time': '22:00 – 04:30 WIB',
      'post': 'Pos Ronda Utama (Depan Gerbang Blok C1)',
      'status': 'Mendatang',
    },
    'Sabtu': {
      'coordinator': 'Bpk. Herman (Blok C1/14)',
      'team': ['Bpk. Toni', 'Bpk. Bayu', 'Bpk. Arif', 'Bpk. Radit', 'Bpk. Eko'],
      'time': '22:00 – 05:00 WIB',
      'post': 'Pos Ronda Utama + Pos 2 Taman',
      'status': 'Mendatang (Piket Ramai)',
    },
    'Minggu': {
      'coordinator': 'Bpk. Sutarman (Blok C3/04)',
      'team': ['Bpk. Hendro', 'Bpk. Dimas', 'Bpk. Tri', 'Bpk. Anwar'],
      'time': '22:00 – 04:30 WIB',
      'post': 'Pos Ronda Utama (Depan Gerbang Blok C1)',
      'status': 'Mendatang',
    },
  };

  void _showSwapModal() {
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
                'Permohonan Tukar Jadwal Ronda',
                style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'Jadwal Anda saat ini: Malam Ini (Kamis, 22:00 WIB)',
                style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Rekan Pengganti:',
                style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WargaKitaTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, color: Color(0xFF0369A1), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Bpk. Agus Salim (Jumat - Blok C4/02)',
                        style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Alasan penukaran (cth: ada dinas luar kota)',
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
                      const SnackBar(
                        content: Text('Permintaan tukar jadwal telah diteruskan ke Koordinator Ronda.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0369A1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Kirim Permintaan Tukar',
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
    final current = _schedule[_selectedDay]!;

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
          'Jadwal Ronda Siskamling',
          style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Day Chips Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _days.map((day) {
                final isSelected = day == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      day == 'Kamis' ? '$day (Malam Ini)' : day,
                      style: WargaKitaTheme.font(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : WargaKitaTheme.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0369A1),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF0369A1) : WargaKitaTheme.cardBorder,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (val) {
                      if (val) setState(() => _selectedDay = day);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Selected Shift Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: current['isTonight'] == true ? const Color(0xFF0369A1) : WargaKitaTheme.cardBorder,
                width: current['isTonight'] == true ? 1.5 : 1,
              ),
              boxShadow: WargaKitaTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Piket Hari $_selectedDay',
                        style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF0369A1)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: current['isTonight'] == true ? const Color(0xFFD1FAE5) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        current['status'],
                        style: WargaKitaTheme.font(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: current['isTonight'] == true ? const Color(0xFF047857) : WargaKitaTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Text(
                  'Koordinator Regu: ${current['coordinator']}',
                  style: WargaKitaTheme.font(fontSize: 14, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF0369A1)),
                    const SizedBox(width: 6),
                    Text(
                      current['time'],
                      style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: WargaKitaTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFEF4444)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        current['post'],
                        style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(color: WargaKitaTheme.cardBorder),
                ),

                Text(
                  'Anggota Regu Jaga (${(current['team'] as List).length} Personil):',
                  style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (current['team'] as List<String>).map((member) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: WargaKitaTheme.cardBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_outline_rounded, size: 14, color: Color(0xFF0369A1)),
                          const SizedBox(width: 6),
                          Text(
                            member,
                            style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: WargaKitaTheme.textPrimary),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showSwapModal,
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: Color(0xFF0369A1)),
                  label: Text(
                    'Tukar Jadwal',
                    style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0369A1)),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF0369A1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kehadiran ronda malam ini terkonfirmasi ✓'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.white),
                  label: Text(
                    'Siap Hadir',
                    style: WargaKitaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
