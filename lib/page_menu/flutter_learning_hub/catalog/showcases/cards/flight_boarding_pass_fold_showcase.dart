import 'package:flutter/material.dart';

class FlightBoardingPassFoldShowcase extends StatefulWidget {
  const FlightBoardingPassFoldShowcase({super.key});

  @override
  State<FlightBoardingPassFoldShowcase> createState() =>
      _FlightBoardingPassFoldShowcaseState();
}

class _FlightBoardingPassFoldShowcaseState
    extends State<FlightBoardingPassFoldShowcase>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _foldController;
  late Animation<double> _heightFactorAnimation;

  // Selected Class
  int _selectedClassIndex = 0; // 0: First Class, 1: Business, 2: Economy
  final List<String> _classNames = ['First Class', 'Business', 'Economy'];
  final List<Color> _classColors = [
    const Color(0xFFEAB308), // Gold
    const Color(0xFF38BDF8), // Sky Cyan
    const Color(0xFF10B981), // Emerald
  ];

  @override
  void initState() {
    super.initState();
    _foldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _heightFactorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _foldController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _foldController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _foldController.forward();
      } else {
        _foldController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _classColors[_selectedClassIndex];

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
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
              border: Border.all(color: themeColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.airplane_ticket_rounded,
                    color: themeColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Digital Boarding Pass',
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
                        'Tiket penerbangan digital lipat 3D dengan rute penerbangan, barcode, dan detail bagasi.',
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

          // CLASS PICKER CHIPS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_classNames.length, (idx) {
              final isSelected = _selectedClassIndex == idx;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(_classNames[idx]),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedClassIndex = idx);
                  },
                  selectedColor: _classColors[idx],
                  backgroundColor: const Color(0xFF1E293B),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // MAIN BOARDING PASS CARD CONTAINER
          Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.white12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    // 1. TOP AIRLINE HEADER
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeColor.withValues(alpha: 0.25),
                            const Color(0xFF1E293B),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flight_rounded,
                                color: themeColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'NALTECH AIRWAYS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: themeColor),
                            ),
                            child: Text(
                              _classNames[_selectedClassIndex].toUpperCase(),
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2. FLIGHT ROUTE (ORIGIN -> DESTINATION)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CGK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'Jakarta (Soetta)',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '08:30 WIB',
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                '7h 15m (Direct)',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 1.5,
                                    color: Colors.white24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Icon(
                                      Icons.flight_takeoff_rounded,
                                      color: themeColor,
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 1.5,
                                    color: Colors.white24,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'GA-874',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'HND',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'Tokyo (Haneda)',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '17:45 JST',
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 3. PASSENGER & FLIGHT SPECS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('PENUMPANG', 'ALEXANDER W.'),
                          _buildInfoColumn('GATE', 'G12'),
                          _buildInfoColumn(
                            'KURSI',
                            _selectedClassIndex == 0 ? '02A' : '14K',
                          ),
                          _buildInfoColumn('BOARDING', '07:50'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 4. PERFORATED CUTOUT DIVIDER
                    _buildPerforatedDivider(context),

                    // 5. EXPANDABLE / FOLDABLE ITINERARY DETAILS
                    AnimatedBuilder(
                      animation: _heightFactorAnimation,
                      builder: (context, child) {
                        return ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: _heightFactorAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF182234),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fasilitas & Informasi Tambahan:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              Icons.luggage_rounded,
                              'Bagasi Terdaftar',
                              '35 kg + 7 kg Kabin',
                            ),
                            _buildDetailRow(
                              Icons.restaurant_rounded,
                              'Makanan & Minuman',
                              'Japanese Kaiseki Bento (Halal)',
                            ),
                            _buildDetailRow(
                              Icons.wifi_rounded,
                              'Wi-Fi Onboard',
                              'Gratis Sepanjang Penerbangan',
                            ),
                            _buildDetailRow(
                              Icons.airplanemode_active_rounded,
                              'Tipe Pesawat',
                              'Boeing 777-300ER (Wide Body)',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 6. TOGGLE EXPAND BUTTON
                    InkWell(
                      onTap: _toggleExpand,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFF141E2E),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isExpanded
                                  ? 'Tutup Detail'
                                  : 'Lihat Fasilitas & Detail Lengkap',
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: themeColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 7. BOTTOM BARCODE & PASS ACTION
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // BARCODE PAINTER
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: CustomPaint(
                              painter: _BarcodePainter(
                                barColor: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '9842 1084 7294 0019',
                            style: TextStyle(
                              color: Colors.white54,
                              fontFamily: 'monospace',
                              fontSize: 12,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF10B981),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.wallet_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Boarding pass berhasil disimpan ke Apple/Google Wallet!',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.wallet_rounded, size: 18),
                            label: const Text(
                              'Simpan ke Wallet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF334155),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerforatedDivider(BuildContext context) {
    return Row(
      children: [
        // Left notch cutout
        Container(
          width: 14,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
          ),
        ),
        // Dashed line
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final dashCount = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  dashCount,
                  (_) =>
                      Container(width: 5, height: 1.5, color: Colors.white24),
                ),
              );
            },
          ),
        ),
        // Right notch cutout
        Container(
          width: 14,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

class _BarcodePainter extends CustomPainter {
  final Color barColor;

  _BarcodePainter({required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = barColor;
    final widths = [
      2.0,
      4.0,
      1.5,
      3.0,
      5.0,
      1.5,
      2.5,
      4.0,
      2.0,
      3.5,
      1.0,
      4.5,
      2.0,
      3.0,
      1.5,
      5.0,
      2.0,
      3.0,
    ];

    double currentX = 10.0;
    int index = 0;

    while (currentX < size.width - 20) {
      final barWidth = widths[index % widths.length];
      final isSpace = (index % 3 == 0);

      if (!isSpace) {
        canvas.drawRect(
          Rect.fromLTWH(currentX, 0, barWidth, size.height),
          paint,
        );
      }
      currentX += barWidth + 3.0;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
