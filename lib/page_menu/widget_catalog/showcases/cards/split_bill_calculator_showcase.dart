import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitBillCalculatorShowcase extends StatefulWidget {
  const SplitBillCalculatorShowcase({super.key});

  @override
  State<SplitBillCalculatorShowcase> createState() =>
      _SplitBillCalculatorShowcaseState();
}

class _SplitBillCalculatorShowcaseState
    extends State<SplitBillCalculatorShowcase> {
  int _billAmount = 350000;
  int _tipPercentage = 10; // 0, 5, 10, 15, 20
  int _peopleCount = 4; // 1 to 10
  final bool _includeTax = true; // 10%

  final List<int> _tipOptions = [0, 5, 10, 15, 20];

  final List<Color> _avatarColors = const [
    Color(0xFF6366F1),
    Color(0xFF10B981),
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
    Color(0xFF06B6D4),
    Color(0xFF8B5CF6),
    Color(0xFFF43F5E),
    Color(0xFF14B8A6),
    Color(0xFF64748B),
    Color(0xFFE11D48),
  ];

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  void _shareBreakdown(
    int tipAmount,
    int taxAmount,
    int grandTotal,
    int perPerson,
  ) {
    final text = '''
 *RINCIAN PATUNGAN TAGIHAN*
• Total Makanan: ${_formatRupiah(_billAmount)}
• Tip ($_tipPercentage%): ${_formatRupiah(tipAmount)}
• Pajak PB1 (10%): ${_formatRupiah(taxAmount)}
• *Grand Total*: ${_formatRupiah(grandTotal)}
 Dibagi $_peopleCount Orang:
-> *${_formatRupiah(perPerson)} / orang*
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Rincian patungan berhasil disalin ke clipboard!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tipAmount = (_billAmount * _tipPercentage / 100).round();
    final taxAmount = _includeTax ? (_billAmount * 0.10).round() : 0;
    final grandTotal = _billAmount + tipAmount + taxAmount;
    final perPersonAmount = (grandTotal / _peopleCount).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. CALCULATOR INPUT CARD ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 18,
                    color: Color(0xFF6366F1),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Kalkulator Patungan Tagihan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Total Bill Amount Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nominal Tagihan:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Text(
                    _formatRupiah(_billAmount),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Quick bill presets
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [150000, 250000, 350000, 500000, 750000].map((amt) {
                        final isSel = _billAmount == amt;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(_formatRupiah(amt)),
                            selected: isSel,
                            selectedColor: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.15),
                            labelStyle: TextStyle(
                              fontSize: 10.5,
                              fontWeight:
                                  isSel ? FontWeight.bold : FontWeight.w500,
                              color:
                                  isSel
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF334155),
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _billAmount = amt);
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
              const Divider(height: 22),

              // Tip Selector Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Persentase Tip:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Text(
                    '+${_formatRupiah(tipAmount)} ($_tipPercentage%)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children:
                    _tipOptions.map((tip) {
                      final isSel = _tipPercentage == tip;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => setState(() => _tipPercentage = tip),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    isSel
                                        ? const Color(0xFF6366F1)
                                        : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$tip%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSel
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const Divider(height: 22),

              // Number of People Stepper & Avatars
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jumlah Teman Patungan:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Avatar Stack matching people count
                      SizedBox(
                        height: 24,
                        child: Row(
                          children: List.generate(_peopleCount, (i) {
                            return Transform.translate(
                              offset: Offset(i * -6.0, 0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    _avatarColors[i % _avatarColors.length],
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),

                  // Stepper controls
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, size: 16),
                          visualDensity: VisualDensity.compact,
                          onPressed:
                              _peopleCount > 1
                                  ? () => setState(() => _peopleCount--)
                                  : null,
                        ),
                        Text(
                          '$_peopleCount',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 16),
                          visualDensity: VisualDensity.compact,
                          onPressed:
                              _peopleCount < 10
                                  ? () => setState(() => _peopleCount++)
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. SPLIT BREAKDOWN RESULT BANNER ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BAYAR PER ORANG:',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatRupiah(perPersonAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed:
                        () => _shareBreakdown(
                          tipAmount,
                          taxAmount,
                          grandTotal,
                          perPersonAmount,
                        ),
                    icon: const Icon(Icons.share_rounded, size: 15),
                    label: const Text(
                      'Bagikan',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 20),

              // Detailed summary breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tagihan: ${_formatRupiah(_billAmount)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                  Text(
                    'Tip: ${_formatRupiah(tipAmount)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                  Text(
                    'Pajak 10%: ${_formatRupiah(taxAmount)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
