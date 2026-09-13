import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../data/models/travel_item_model.dart';

class _CabinZone {
  final String title;
  final String subtitle;
  final int startRow;
  final int endRow;

  const _CabinZone({
    required this.title,
    required this.subtitle,
    required this.startRow,
    required this.endRow,
  });
}

class AirplaneSeatLayoutSelector extends StatefulWidget {
  final FlightTicket? flight;
  final String selectedSeat;
  final void Function(String seatCode, String seatFullDescription) onSeatSelected;

  const AirplaneSeatLayoutSelector({
    super.key,
    this.flight,
    required this.selectedSeat,
    required this.onSeatSelected,
  });

  @override
  State<AirplaneSeatLayoutSelector> createState() => _AirplaneSeatLayoutSelectorState();
}

class _AirplaneSeatLayoutSelectorState extends State<AirplaneSeatLayoutSelector> {
  late String _currentSeatCode;
  int _selectedZoneIndex = 0; // 0: Baris 1-6 (Depan), 1: Baris 7-14 (Sayap/Exit), 2: Baris 15-22 (Belakang)

  final List<_CabinZone> _zones = const [
    _CabinZone(
      title: 'Zona Depan',
      subtitle: 'Baris 1 - 6 (Cepat Keluar)',
      startRow: 1,
      endRow: 6,
    ),
    _CabinZone(
      title: 'Zona Sayap',
      subtitle: 'Baris 7 - 14 (Exit Row)',
      startRow: 7,
      endRow: 14,
    ),
    _CabinZone(
      title: 'Zona Belakang',
      subtitle: 'Baris 15 - 22 (Dekat Galley)',
      startRow: 15,
      endRow: 22,
    ),
  ];

  // Mock occupied / booked seats by other passengers
  final Set<String> _occupiedSeats = {
    '1A', '1B', '2E', '2F', '3C', '3D',
    '7B', '8A', '8F', '10C', '11D', '12B',
    '15A', '16E', '17F', '18C', '20B', '21E',
  };

  // Emergency Exit row numbers (Extra legroom)
  final Set<int> _exitRows = {1, 12};

  @override
  void initState() {
    super.initState();
    _currentSeatCode = _extractSeatCode(widget.selectedSeat);
  }

  String _extractSeatCode(String rawSeat) {
    // Extracts "14A" from "Kursi 14A (Jendela)" or returns raw if short
    final match = RegExp(r'(\d+[A-F])').firstMatch(rawSeat);
    if (match != null) {
      return match.group(1)!;
    }
    return rawSeat.isNotEmpty ? rawSeat : '14A';
  }

  void _handleSeatTap(int row, String col) {
    final seatCode = '$row$col';

    if (_occupiedSeats.contains(seatCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kursi $seatCode sudah terisi oleh penumpang lain 🚫'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    String positionName;
    if (col == 'A' || col == 'F') {
      positionName = 'Jendela (Window)';
    } else if (col == 'C' || col == 'D') {
      positionName = 'Lorong (Aisle)';
    } else {
      positionName = 'Tengah (Middle)';
    }

    final isExtraLegroom = _exitRows.contains(row);
    final fullDesc = isExtraLegroom
        ? 'Kursi $seatCode • $positionName (Extra Legroom)'
        : 'Kursi $seatCode • $positionName';

    setState(() {
      _currentSeatCode = seatCode;
    });

    widget.onSeatSelected(seatCode, fullDesc);
  }

  @override
  Widget build(BuildContext context) {
    final currentZone = _zones[_selectedZoneIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TravelTheme.border),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Pesawat & Konfigurasi Kabin
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TravelTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flight_takeoff_rounded, color: TravelTheme.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flight?.planeModel ?? 'Boeing 737 / Airbus A320',
                      style: const TextStyle(
                        color: TravelTheme.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Formasi Kabin 3 - 3 (A B C • D E F)',
                      style: TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 2. Zone Selector Tabs (Depan, Sayap, Belakang)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: TravelTheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: List.generate(_zones.length, (index) {
                final zone = _zones[index];
                final isSelected = _selectedZoneIndex == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedZoneIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: TravelTheme.dark.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            zone.title,
                            style: TextStyle(
                              color: isSelected ? TravelTheme.primary : TravelTheme.darkMuted,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Baris ${zone.startRow}-${zone.endRow}',
                            style: TextStyle(
                              color: isSelected ? TravelTheme.darkMuted : TravelTheme.muted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Cabin Shell (Visual Fuselage & Seat Matrix)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TravelTheme.border),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              children: [
                // Cockpit Nose Cone & Direction
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: TravelTheme.border),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.navigation_rounded, size: 13, color: TravelTheme.primary),
                          SizedBox(width: 5),
                          Text(
                            'DEPAN (KOKPIT)',
                            style: TextStyle(
                              color: TravelTheme.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Column Headers (A B C • AISLE • D E F)
                Row(
                  children: [
                    // Left 3 seats header (A, B, C)
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildColumnLabel('A', 'Jendela'),
                          _buildColumnLabel('B', 'Tengah'),
                          _buildColumnLabel('C', 'Lorong'),
                        ],
                      ),
                    ),

                    // Aisle center spacer
                    const SizedBox(
                      width: 38,
                      child: Center(
                        child: Text(
                          'LORONG',
                          style: TextStyle(
                            color: TravelTheme.muted,
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    // Right 3 seats header (D, E, F)
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildColumnLabel('D', 'Lorong'),
                          _buildColumnLabel('E', 'Tengah'),
                          _buildColumnLabel('F', 'Jendela'),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                const Divider(height: 1, color: TravelTheme.border),
                const SizedBox(height: 10),

                // Seat Matrix Rows
                ...List.generate(
                  currentZone.endRow - currentZone.startRow + 1,
                  (index) {
                    final rowNumber = currentZone.startRow + index;
                    final isExitRow = _exitRows.contains(rowNumber);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          // Left 3 seats (A, B, C)
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSeatWidget(rowNumber, 'A', isExitRow),
                                _buildSeatWidget(rowNumber, 'B', isExitRow),
                                _buildSeatWidget(rowNumber, 'C', isExitRow),
                              ],
                            ),
                          ),

                          // Row Number in Aisle Center
                          SizedBox(
                            width: 38,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isExitRow
                                      ? const Color(0xFFFEF3C7)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isExitRow ? const Color(0xFFF59E0B) : TravelTheme.border,
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  '$rowNumber',
                                  style: TextStyle(
                                    color: isExitRow ? const Color(0xFFB45309) : TravelTheme.darkMuted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Right 3 seats (D, E, F)
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSeatWidget(rowNumber, 'D', isExitRow),
                                _buildSeatWidget(rowNumber, 'E', isExitRow),
                                _buildSeatWidget(rowNumber, 'F', isExitRow),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 4. Seat Legend (Keterangan Warna)
          Wrap(
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem(color: Colors.white, borderColor: TravelTheme.border, label: 'Tersedia'),
              _buildLegendItem(color: TravelTheme.primary, borderColor: TravelTheme.primary, label: 'Pilihan Anda'),
              _buildLegendItem(color: const Color(0xFFE2E8F0), borderColor: const Color(0xFFCBD5E1), label: 'Terisi'),
              _buildLegendItem(color: const Color(0xFFFEF3C7), borderColor: const Color(0xFFF59E0B), label: 'Extra Legroom'),
            ],
          ),

          const SizedBox(height: 14),

          // 5. Selected Seat Summary Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TravelTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: TravelTheme.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: TravelTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KURSI TERPILIH',
                        style: TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Kursi $_currentSeatCode • ${_getSeatPositionDescription(_currentSeatCode)}',
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TravelTheme.emerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Gratis Pilih',
                    style: TextStyle(
                      color: TravelTheme.emerald,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
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

  Widget _buildColumnLabel(String col, String desc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          col,
          style: const TextStyle(
            color: TravelTheme.dark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          desc,
          style: const TextStyle(
            color: TravelTheme.muted,
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatWidget(int row, String col, bool isExitRow) {
    final seatCode = '$row$col';
    final isSelected = _currentSeatCode == seatCode;
    final isOccupied = _occupiedSeats.contains(seatCode);

    Color bgColor;
    Color borderColor;
    Color iconColor;

    if (isSelected) {
      bgColor = TravelTheme.primary;
      borderColor = TravelTheme.primary;
      iconColor = Colors.white;
    } else if (isOccupied) {
      bgColor = const Color(0xFFE2E8F0);
      borderColor = const Color(0xFFCBD5E1);
      iconColor = const Color(0xFF94A3B8);
    } else if (isExitRow) {
      bgColor = const Color(0xFFFEF3C7);
      borderColor = const Color(0xFFF59E0B);
      iconColor = const Color(0xFFD97706);
    } else {
      bgColor = Colors.white;
      borderColor = TravelTheme.border;
      iconColor = TravelTheme.darkMuted;
    }

    return GestureDetector(
      onTap: () => _handleSeatTap(row, col),
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: TravelTheme.primary.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : isOccupied
                    ? const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 14)
                    : isExitRow
                        ? const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 14)
                        : Text(
                            col,
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.5),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: TravelTheme.darkMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getSeatPositionDescription(String seatCode) {
    if (seatCode.isEmpty) return 'Standar';
    final col = seatCode[seatCode.length - 1];
    final rowNum = int.tryParse(seatCode.substring(0, seatCode.length - 1)) ?? 14;

    String type;
    if (col == 'A' || col == 'F') {
      type = 'Jendela (Window)';
    } else if (col == 'C' || col == 'D') {
      type = 'Lorong (Aisle)';
    } else {
      type = 'Tengah (Middle)';
    }

    if (_exitRows.contains(rowNum)) {
      type += ' • Extra Legroom';
    }
    return type;
  }
}
