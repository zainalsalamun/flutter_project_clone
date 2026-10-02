import 'package:flutter/material.dart';

/// Passenger Tips Card with clean styling, subtle expandability, and checklist indicators.
class PassengerTipsCard extends StatefulWidget {
  const PassengerTipsCard({super.key});

  @override
  State<PassengerTipsCard> createState() => _PassengerTipsCardState();
}

class _PassengerTipsCardState extends State<PassengerTipsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FB), // Soft modern lavender-grey
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Lightbulb Icon & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Tips Mengisi Data Penumpang",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade500,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Description Text
          const Text(
            "Anda memiliki waktu 15 menit untuk proses pemilihan jadwal kereta dan pengisian data penumpang. Sambil menunggu antrean, pastikan Anda telah menyiapkan data penumpang yang akan berangkat.",
            style: TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),

          // Expandable Checklist
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                children: [
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 12),
                  _buildChecklistItem(
                    Icons.badge_outlined,
                    "Siapkan Nomor Induk Kependudukan (NIK) / No. Paspor",
                  ),
                  const SizedBox(height: 8),
                  _buildChecklistItem(
                    Icons.account_balance_wallet_outlined,
                    "Pastikan saldo E-Wallet / Mobile Banking aktif",
                  ),
                  const SizedBox(height: 8),
                  _buildChecklistItem(
                    Icons.wifi_rounded,
                    "Gunakan koneksi internet stabil & jangan tutup tab aplikasi",
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF2563EB),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
