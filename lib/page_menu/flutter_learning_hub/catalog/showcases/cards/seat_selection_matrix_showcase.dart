import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeatSelectionMatrixShowcase extends StatefulWidget {
  const SeatSelectionMatrixShowcase({super.key});

  @override
  State<SeatSelectionMatrixShowcase> createState() =>
      _SeatSelectionMatrixShowcaseState();
}

class _SeatSelectionMatrixShowcaseState
    extends State<SeatSelectionMatrixShowcase> {
  final Set<String> _selectedSeatIds = {};

  // 6 Rows (A - F), 8 Columns (1 - 8)
  final List<String> _rows = ['A', 'B', 'C', 'D', 'E', 'F'];

  // Occupied seats
  final Set<String> _occupiedSeats = {
    'A4',
    'A5',
    'C2',
    'C3',
    'D7',
    'E1',
    'E2',
    'F5',
    'F6',
  };

  // Prices
  static const int _regularPrice = 50000;
  static const int _vipPrice = 75000;

  void _onSeatTap(String seatId, bool isVip, bool isOccupied) {
    if (isOccupied) return;

    HapticFeedback.selectionClick();

    setState(() {
      if (_selectedSeatIds.contains(seatId)) {
        _selectedSeatIds.remove(seatId);
      } else {
        _selectedSeatIds.add(seatId);
      }
    });
  }

  int _calculateTotalPrice() {
    int total = 0;
    for (var id in _selectedSeatIds) {
      final isVip = id.startsWith('A') || id.startsWith('B');
      total += isVip ? _vipPrice : _regularPrice;
    }
    return total;
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showCheckoutDialog() {
    if (_selectedSeatIds.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFF1E293B),
            title: const Row(
              children: [
                Text(' ', style: TextStyle(fontSize: 24)),
                Expanded(
                  child: Text(
                    'Konfirmasi Kursi Bioskop',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kursi Terpilih: ${_selectedSeatIds.toList()..sort()}',
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jumlah Tiket: ${_selectedSeatIds.length} Kursi',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Bayar: ${_formatCurrency(_calculateTotalPrice())}',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Studio 1 Premiere • Inception (IMAX Laser)',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Berhasil memesan ${_selectedSeatIds.length} kursi!',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  setState(() {
                    _occupiedSeats.addAll(_selectedSeatIds);
                    _selectedSeatIds.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Bayar Sekarang'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotalPrice();

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.airline_seat_recline_extra_rounded,
                    color: Color(0xFF38BDF8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interactive Cinema Seat Matrix',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Pilih kursi bioskop/pesawat dengan status ketersediaan, kelas VIP/Reguler, dan kalkulator harga real-time.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CINEMA SCREEN PROJECTOR CURVE
          Center(
            child: Column(
              children: [
                CustomPaint(
                  size: const Size(260, 24),
                  painter: _CinemaScreenPainter(),
                ),
                const SizedBox(height: 6),
                const Text(
                  'LAYAR BIOSKOP UTAMA',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SEAT GRID MATRIX
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children:
                      _rows.map((row) {
                        final isVip = (row == 'A' || row == 'B');

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Row Letter Label (Left)
                              SizedBox(
                                width: 16,
                                child: Text(
                                  row,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isVip
                                            ? const Color(0xFFEAB308)
                                            : Colors.white60,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),

                              // Left Seats (1 - 4)
                              ...List.generate(4, (colIdx) {
                                final colNum = colIdx + 1;
                                final seatId = '$row$colNum';
                                final isOccupied = _occupiedSeats.contains(
                                  seatId,
                                );
                                final isSelected = _selectedSeatIds.contains(
                                  seatId,
                                );

                                return _buildSeatWidget(
                                  seatId,
                                  isVip,
                                  isOccupied,
                                  isSelected,
                                );
                              }),

                              // Center Aisle Walkway Gap
                              const SizedBox(width: 12),

                              // Right Seats (5 - 8)
                              ...List.generate(4, (colIdx) {
                                final colNum = colIdx + 5;
                                final seatId = '$row$colNum';
                                final isOccupied = _occupiedSeats.contains(
                                  seatId,
                                );
                                final isSelected = _selectedSeatIds.contains(
                                  seatId,
                                );

                                return _buildSeatWidget(
                                  seatId,
                                  isVip,
                                  isOccupied,
                                  isSelected,
                                );
                              }),

                              const SizedBox(width: 4),
                              // Row Letter Label (Right)
                              SizedBox(
                                width: 16,
                                child: Text(
                                  row,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isVip
                                            ? const Color(0xFFEAB308)
                                            : Colors.white60,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // LEGEND CHIPS
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem(
                const Color(0xFF334155),
                Colors.white70,
                'Tersedia (50k)',
              ),
              _buildLegendItem(
                const Color(0xFF1E293B),
                const Color(0xFFEAB308),
                'VIP (75k)',
                isBorderOnly: true,
              ),
              _buildLegendItem(
                const Color(0xFF10B981),
                Colors.white,
                'Dipilih',
              ),
              _buildLegendItem(
                const Color(0xFF0F172A),
                Colors.white24,
                'Terisi',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // BOTTOM CHECKOUT SUMMARY CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kursi Terpilih',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedSeatIds.isEmpty
                                ? 'Belum ada kursi dipilih'
                                : (_selectedSeatIds.toList()..sort()).join(
                                  ', ',
                                ),
                            style: TextStyle(
                              color:
                                  _selectedSeatIds.isEmpty
                                      ? Colors.white38
                                      : const Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Harga',
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatCurrency(totalPrice),
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        _selectedSeatIds.isEmpty ? null : _showCheckoutDialog,
                    icon: const Icon(Icons.confirmation_number_rounded),
                    label: Text(
                      _selectedSeatIds.isEmpty
                          ? 'Pilih Kursi Terlebih Dahulu'
                          : 'Lanjut Pembayaran (${_selectedSeatIds.length} Kursi)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatWidget(
    String seatId,
    bool isVip,
    bool isOccupied,
    bool isSelected,
  ) {
    Color bgColor = const Color(0xFF334155);
    Color borderColor = isVip ? const Color(0xFFEAB308) : Colors.transparent;

    if (isSelected) {
      bgColor = const Color(0xFF10B981);
      borderColor = Colors.white;
    } else if (isOccupied) {
      bgColor = const Color(0xFF0F172A);
      borderColor = Colors.white10;
    }

    return GestureDetector(
      onTap: () => _onSeatTap(seatId, isVip, isOccupied),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 26,
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: isVip ? 1.5 : 1.0),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.6),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child:
              isSelected
                  ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  )
                  : isOccupied
                  ? const Icon(
                    Icons.close_rounded,
                    color: Colors.white24,
                    size: 12,
                  )
                  : isVip
                  ? const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFEAB308),
                    size: 11,
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    Color bg,
    Color textColor,
    String label, {
    bool isBorderOnly = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isBorderOnly ? Colors.transparent : bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: textColor, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _CinemaScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path =
        Path()
          ..moveTo(0, size.height)
          ..quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    final glowPaint =
        Paint()
          ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6)
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final screenPaint =
        Paint()
          ..color = const Color(0xFF38BDF8)
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, screenPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
