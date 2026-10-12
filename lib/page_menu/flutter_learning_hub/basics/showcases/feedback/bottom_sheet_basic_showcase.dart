import 'package:flutter/material.dart';

class BottomSheetBasicShowcase extends StatefulWidget {
  const BottomSheetBasicShowcase({super.key});

  @override
  State<BottomSheetBasicShowcase> createState() =>
      _BottomSheetBasicShowcaseState();
}

class _BottomSheetBasicShowcaseState extends State<BottomSheetBasicShowcase> {
  String _selectedOption = 'Belum ada opsi dipilih dari BottomSheet';

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF3B82F6),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'E-Wallet (GoPay, OVO, ShopeePay)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Instan tanpa biaya admin'),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(
                        () => _selectedOption = 'Metode: E-Wallet Terpilih',
                      );
                    },
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF10B981),
                      child: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Kartu Debit / Kredit (Visa & Master)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Mendukung cicilan 0%'),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(
                        () =>
                            _selectedOption =
                                'Metode: Kartu Kredit/Debit Terpilih',
                      );
                    },
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFF59E0B),
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'QRIS Instant Pay',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Scan langsung dari semua bank'),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _selectedOption = 'Metode: QRIS Terpilih');
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _openBottomSheet,
                icon: const Icon(Icons.vertical_align_top_rounded, size: 18),
                label: const Text('Buka Modal BottomSheet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedOption,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
