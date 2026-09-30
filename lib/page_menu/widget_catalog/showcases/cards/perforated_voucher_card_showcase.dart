import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerforatedVoucherCardShowcase extends StatefulWidget {
  const PerforatedVoucherCardShowcase({super.key});

  @override
  State<PerforatedVoucherCardShowcase> createState() =>
      _PerforatedVoucherCardShowcaseState();
}

class _PerforatedVoucherCardShowcaseState
    extends State<PerforatedVoucherCardShowcase> {
  int _selectedVoucherIndex = 0;

  final List<Map<String, dynamic>> _vouchers = [
    {
      'code': 'DISKON50K',
      'title': 'Diskon Spesial Gajian',
      'discount': '50%',
      'maxDiscount': 'Maks. Rp 50.000',
      'minSpend': 'Min. Belanja Rp 100rb',
      'expiry': 'Berakhir dlm 3 jam',
      'category': 'Semua Kategori',
      'primaryColor': const Color(0xFFEF4444),
      'secondaryColor': const Color(0xFFF97316),
      'icon': Icons.local_fire_department_rounded,
      'isClaimed': false,
      'isUsed': false,
    },
    {
      'code': 'FREESHIP',
      'title': 'Gratis Ongkir Se-Indonesia',
      'discount': 'FREE',
      'maxDiscount': 'Potongan Ongkir Rp 25.000',
      'minSpend': 'Min. Belanja Rp 30rb',
      'expiry': 'Berakhir 2 hari lagi',
      'category': 'Pengiriman Reguler',
      'primaryColor': const Color(0xFF06B6D4),
      'secondaryColor': const Color(0xFF3B82F6),
      'icon': Icons.local_shipping_rounded,
      'isClaimed': true,
      'isUsed': false,
    },
    {
      'code': 'CBCOIN100',
      'title': 'Cashback Koin Ekstra',
      'discount': '10%',
      'maxDiscount': 'Hingga 50.000 Koin',
      'minSpend': 'Min. Belanja Rp 150rb',
      'expiry': 'Berakhir 7 hari lagi',
      'category': 'Official Store',
      'primaryColor': const Color(0xFF8B5CF6),
      'secondaryColor': const Color(0xFFD946EF),
      'icon': Icons.monetization_on_rounded,
      'isClaimed': false,
      'isUsed': false,
    },
  ];

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Kode voucher "$code" berhasil disalin!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _claimVoucher(int index) {
    setState(() {
      _vouchers[index]['isClaimed'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.card_giftcard_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Voucher "${_vouchers[index]['code']}" berhasil diklaim!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6366F1),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeVoucher = _vouchers[_selectedVoucherIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. VOUCHER TYPE SELECTOR ----------------
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_vouchers.length, (idx) {
              final v = _vouchers[idx];
              final isSelected = _selectedVoucherIndex == idx;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        v['icon'] as IconData,
                        size: 14,
                        color:
                            isSelected
                                ? Colors.white
                                : (v['primaryColor'] as Color),
                      ),
                      const SizedBox(width: 6),
                      Text(v['code'] as String),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: v['primaryColor'] as Color,
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedVoucherIndex = idx);
                    }
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // ---------------- 2. PERFORATED VOUCHER CARD ----------------
        CustomPaint(
          painter: _PerforatedShadowPainter(
            notchRadius: 12,
            notchPositionRatio: 0.32,
          ),
          child: ClipPath(
            clipper: _PerforatedTicketClipper(
              notchRadius: 12,
              notchPositionRatio: 0.32,
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main Voucher Body (Left: Badge, Right: Info)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left: Discount Badge Column
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                activeVoucher['primaryColor'] as Color,
                                activeVoucher['secondaryColor'] as Color,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                activeVoucher['icon'] as IconData,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                activeVoucher['discount'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Text(
                                'DISKON',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center Perforated Dashed Divider
                        CustomPaint(
                          size: const Size(1, double.infinity),
                          painter: _DashedLinePainter(
                            color: Colors.grey.shade300,
                            dashHeight: 5,
                            dashGap: 4,
                          ),
                        ),

                        // Right: Voucher Details & CTA
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category Pill & Expiry
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (activeVoucher['primaryColor']
                                                as Color)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        activeVoucher['category'] as String,
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              activeVoucher['primaryColor']
                                                  as Color,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      activeVoucher['expiry'] as String,
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Title & Conditions
                                Text(
                                  activeVoucher['title'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${activeVoucher['maxDiscount']} • ${activeVoucher['minSpend']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Promo Code Bar & Action Button
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        onTap:
                                            () => _copyCode(
                                              activeVoucher['code'] as String,
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  activeVoucher['code']
                                                      as String,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    fontFamily: 'monospace',
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.copy_rounded,
                                                size: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Claim / Use Button
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            activeVoucher['isClaimed'] == true
                                                ? const Color(0xFF10B981)
                                                : activeVoucher['primaryColor']
                                                    as Color,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 7,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        if (activeVoucher['isClaimed'] ==
                                            false) {
                                          _claimVoucher(_selectedVoucherIndex);
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Menerapkan "${activeVoucher['code']}" ke pesanan...',
                                              ),
                                              backgroundColor: const Color(
                                                0xFF10B981,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        activeVoucher['isClaimed'] == true
                                            ? 'Gunakan'
                                            : 'Klaim',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Barcode Strip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'S&K Berlaku',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        _buildMiniBarcode(),
                        const SizedBox(width: 6),
                        Text(
                          '#${activeVoucher['code']}',
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'monospace',
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 3. VOUCHER CAROUSEL / MINI TILES ----------------
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.confirmation_number_outlined,
                  color: Color(0xFFFACC15),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Koleksi Voucher Tersedia',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '3 kupon siap diklaim untuk pesanan ini',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() {
                    for (var v in _vouchers) {
                      v['isClaimed'] = true;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua voucher berhasil diklaim! '),
                      backgroundColor: Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  'Klaim Semua',
                  style: TextStyle(
                    color: Color(0xFFFACC15),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniBarcode() {
    final barHeights = [
      12.0,
      8.0,
      14.0,
      10.0,
      14.0,
      6.0,
      12.0,
      14.0,
      9.0,
      14.0,
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(barHeights.length, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: i % 3 == 0 ? 2 : 1.2,
          height: barHeights[i],
          color: Colors.grey.shade800,
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// PERFORATED TICKET CLIPPER WITH LEFT & RIGHT NOTCHES
// ---------------------------------------------------------------------------
class _PerforatedTicketClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchPositionRatio; // 0.0 to 1.0 from top

  _PerforatedTicketClipper({
    required this.notchRadius,
    required this.notchPositionRatio,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    const cornerRadius = 16.0;
    final notchCenterY = size.height * notchPositionRatio;

    // Top-left corner
    path.moveTo(cornerRadius, 0);

    // Top edge
    path.lineTo(size.width - cornerRadius, 0);
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );

    // Right edge with semicircular cutout
    path.lineTo(size.width, notchCenterY - notchRadius);
    path.arcToPoint(
      Offset(size.width, notchCenterY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false, // Inverted into ticket
    );
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: const Radius.circular(cornerRadius),
    );

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );

    // Left edge with semicircular cutout
    path.lineTo(0, notchCenterY + notchRadius);
    path.arcToPoint(
      Offset(0, notchCenterY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false, // Inverted into ticket
    );
    path.lineTo(0, cornerRadius);

    // Top-left corner arc
    path.arcToPoint(
      const Offset(cornerRadius, 0),
      radius: const Radius.circular(cornerRadius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _PerforatedTicketClipper oldClipper) =>
      oldClipper.notchRadius != notchRadius ||
      oldClipper.notchPositionRatio != notchPositionRatio;
}

// ---------------------------------------------------------------------------
// PERFORATED SHADOW PAINTER
// ---------------------------------------------------------------------------
class _PerforatedShadowPainter extends CustomPainter {
  final double notchRadius;
  final double notchPositionRatio;

  _PerforatedShadowPainter({
    required this.notchRadius,
    required this.notchPositionRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _PerforatedTicketClipper(
      notchRadius: notchRadius,
      notchPositionRatio: notchPositionRatio,
    ).getClip(size);

    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _PerforatedShadowPainter oldDelegate) =>
      oldDelegate.notchRadius != notchRadius ||
      oldDelegate.notchPositionRatio != notchPositionRatio;
}

// ---------------------------------------------------------------------------
// DASHED LINE PAINTER
// ---------------------------------------------------------------------------
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashGap;

  _DashedLinePainter({
    required this.color,
    required this.dashHeight,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = size.width
          ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashHeight != dashHeight ||
      oldDelegate.dashGap != dashGap;
}
