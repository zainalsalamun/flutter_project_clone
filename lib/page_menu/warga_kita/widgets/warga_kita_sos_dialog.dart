import 'dart:async';
import 'package:flutter/material.dart';
import '../core/warga_kita_data.dart';
import '../core/warga_kita_theme.dart';

class WargaKitaSosDialog extends StatefulWidget {
  const WargaKitaSosDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WargaKitaSosDialog(),
    );
  }

  @override
  State<WargaKitaSosDialog> createState() => _WargaKitaSosDialogState();
}

class _EmergencyType {
  final String title;
  final IconData icon;
  final Color color;

  const _EmergencyType(this.title, this.icon, this.color);
}

class _WargaKitaSosDialogState extends State<WargaKitaSosDialog>
    with SingleTickerProviderStateMixin {
  int _secondsLeft = 5;
  Timer? _timer;
  String _selectedCategory = 'Keamanan / Kriminalitas';
  final TextEditingController _notesController = TextEditingController();
  bool _isSent = false;

  final List<_EmergencyType> _categories = const [
    _EmergencyType('Keamanan / Kriminalitas', Icons.security_rounded, Color(0xFFDC2626)),
    _EmergencyType('Kebakaran / Gas Bocor', Icons.local_fire_department_rounded, Color(0xFFEA580C)),
    _EmergencyType('Medis / Butuh Ambulans', Icons.medical_services_rounded, Color(0xFFEF4444)),
    _EmergencyType('Hewan Liar Berbahaya', Icons.warning_amber_rounded, Color(0xFFD97706)),
    _EmergencyType('Bencana / Pohon Tumbang', Icons.thunderstorm_rounded, Color(0xFF2563EB)),
  ];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        _confirmEmergency();
      }
    });
  }

  void _confirmEmergency() {
    _timer?.cancel();
    WargaKitaData().triggerEmergencyAlert(
      emergencyType: _selectedCategory,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : 'Panggilan darurat dari ${WargaKitaData.defaultUser.name} (${WargaKitaData.defaultUser.blockNumber})',
    );

    setState(() {
      _isSent = true;
    });
  }

  void _cancelAlert() {
    _timer?.cancel();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panggilan darurat dibatalkan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = WargaKitaData.defaultUser;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: !_isSent ? _buildCountdownState(user) : _buildSuccessState(user),
    );
  }

  Widget _buildCountdownState(dynamic user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Urgent Beacon Icon with Countdown Badge
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.emergency_rounded,
                color: Color(0xFFDC2626),
                size: 44,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF991B1B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$_secondsLeft',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Title & Location
        Text(
          'Mengirim Alarm Darurat RT 04',
          style: WargaKitaTheme.font(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF991B1B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pos Satpam & Tim Ronda akan menerima lokasi Anda dalam $_secondsLeft detik:',
          textAlign: TextAlign.center,
          style: WargaKitaTheme.font(
            fontSize: 13,
            color: WargaKitaTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDAE2FD)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 14,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(width: 5),
              Text(
                '${user.name} • ${user.blockNumber} • ${user.rtRw}',
                style: WargaKitaTheme.font(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: WargaKitaTheme.primaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Category Selector
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Pilih Jenis Keadaan Darurat:',
            style: WargaKitaTheme.font(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: WargaKitaTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WargaKitaTheme.cardBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              items: _categories.map((c) {
                return DropdownMenuItem<String>(
                  value: c.title,
                  child: Row(
                    children: [
                      Icon(c.icon, size: 18, color: c.color),
                      const SizedBox(width: 8),
                      Text(
                        c.title,
                        style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Catatan Opsional
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Keterangan singkat (cth: ada orang mencurigakan di gang)',
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

        // Actions: [ BATALKAN ] & [ KIRIM SEKARANG ]
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelAlert,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: WargaKitaTheme.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Batalkan ($_secondsLeft s)',
                  style: WargaKitaTheme.font(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: WargaKitaTheme.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmEmergency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF991B1B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: Text(
                  'KIRIM SEKARANG',
                  style: WargaKitaTheme.font(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessState(dynamic user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFD1FAE5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF047857),
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sinyal Darurat Terkirim!',
          style: WargaKitaTheme.font(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF047857),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pos Satpam Utama RT 04 dan 4 personil Siskamling telah merespons dan sedang menuju ke lokasi Anda (${user.blockNumber}).',
          textAlign: TextAlign.center,
          style: WargaKitaTheme.font(
            fontSize: 13,
            color: WargaKitaTheme.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_rounded, color: Color(0xFFD97706), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tetap berada di tempat yang aman. Sirine pos ronda utama diaktifkan.',
                  style: WargaKitaTheme.font(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: WargaKitaTheme.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
