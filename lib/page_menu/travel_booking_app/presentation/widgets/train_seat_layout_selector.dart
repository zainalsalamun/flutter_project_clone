import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../data/models/travel_item_model.dart';

class _TrainWagon {
  final String name;
  final String code;
  final String type;
  final String badge;
  final int capacity;
  final int totalRows;
  final List<String> leftColumns;
  final List<String> rightColumns;
  final String formationText;
  final String reclineText;
  final String revolvingText;
  final String legroomText;
  final String exampleTrains;
  final String characteristics;
  final Set<String> occupiedSeats;
  final Set<String> validSeatCodes;

  const _TrainWagon({
    required this.name,
    required this.code,
    required this.type,
    required this.badge,
    required this.capacity,
    required this.totalRows,
    required this.leftColumns,
    required this.rightColumns,
    required this.formationText,
    required this.reclineText,
    required this.revolvingText,
    required this.legroomText,
    required this.exampleTrains,
    required this.characteristics,
    required this.occupiedSeats,
    required this.validSeatCodes,
  });

  int get availableSeats => capacity - occupiedSeats.length;
}

class TrainSeatLayoutSelector extends StatefulWidget {
  final TrainTicket? train;
  final String selectedWagon;
  final String selectedSeat;
  final void Function(String wagon, String seat) onSeatSelected;

  const TrainSeatLayoutSelector({
    super.key,
    this.train,
    required this.selectedWagon,
    required this.selectedSeat,
    required this.onSeatSelected,
  });

  @override
  State<TrainSeatLayoutSelector> createState() => _TrainSeatLayoutSelectorState();
}

class _TrainSeatLayoutSelectorState extends State<TrainSeatLayoutSelector> {
  late String _currentWagon;
  late String _currentSeat;

  static final List<_TrainWagon> _wagons = [
    // 1. Eksekutif New Generation (50 Kursi)
    _TrainWagon(
      name: 'Gerbong 1',
      code: 'EKS-1',
      type: 'Eksekutif New Generation',
      badge: '50 Kursi • Stainless Steel',
      capacity: 50,
      totalRows: 13,
      leftColumns: const ['A', 'B'],
      rightColumns: const ['C', 'D'],
      formationText: 'Formasi 2 - 2 (Searah Jalan)',
      reclineText: 'Recline Elektrik / Tuas Mulus',
      revolvingText: 'Bisa Diputar 180°',
      legroomText: 'Pijakan Kaki + Ruang Sangat Luas',
      exampleTrains: 'KA Argo Dwipangga, KA Argo Lawu, KA Taksaka New Gen',
      characteristics: 'Kursi kulit sintetis modern, lampu baca individual, USB charger & stop kontak, pintu geser elektrik kedap suara.',
      occupiedSeats: const {'1B', '2A', '3C', '5D', '7A', '10B', '12C'},
      validSeatCodes: _generateValidSeats(13, const ['A', 'B'], const ['C', 'D'], 50),
    ),

    // 2. Eksekutif Reguler (50 Kursi)
    _TrainWagon(
      name: 'Gerbong 2',
      code: 'EKS-2',
      type: 'Eksekutif Reguler',
      badge: '50 Kursi • Reclining & Footrest',
      capacity: 50,
      totalRows: 13,
      leftColumns: const ['A', 'B'],
      rightColumns: const ['C', 'D'],
      formationText: 'Formasi 2 - 2 (Sisi A-B dan C-D)',
      reclineText: 'Reclining Sudut Fleksibel',
      revolvingText: 'Bisa Diputar 180° (Revolving)',
      legroomText: 'Footrest Pijakan Kaki + Meja Lipat',
      exampleTrains: 'KA Argo Bromo Anggrek, KA Gajayana, KA Bima, KA Taksaka',
      characteristics: 'Kursi ergonomis dan sangat empuk, legroom lega, meja lipat di sandaran tangan, dan pijakan kaki.',
      occupiedSeats: const {'1A', '2D', '4B', '6C', '8A', '9D', '11B', '13A'},
      validSeatCodes: _generateValidSeats(13, const ['A', 'B'], const ['C', 'D'], 50),
    ),

    // 3. Ekonomi New Generation (72 Kursi)
    _TrainWagon(
      name: 'Gerbong 3',
      code: 'EKO-1',
      type: 'Ekonomi New Generation',
      badge: '72 Kursi • Captain Seat',
      capacity: 72,
      totalRows: 18,
      leftColumns: const ['A', 'B'],
      rightColumns: const ['C', 'D'],
      formationText: 'Formasi 2 - 2 (Searah Jalan)',
      reclineText: 'Reclining Seat (Bisa Rebah)',
      revolvingText: 'Bisa Diputar (Revolving Seat)',
      legroomText: 'Ruang Kaki Jauh Lebih Luas',
      exampleTrains: 'KA Majapahit, KA Logawa, KA Jaka Tingkir, KA Gumarang',
      characteristics: 'Tipe captain seat individual yang mewah, bisa diputar mengikuti arah laju kereta sehingga tidak duduk mundur.',
      occupiedSeats: const {'1B', '2C', '4A', '5D', '7B', '9C', '11A', '14D', '16B', '18C'},
      validSeatCodes: _generateValidSeats(18, const ['A', 'B'], const ['C', 'D'], 72),
    ),

    // 4. Ekonomi New Image / Premium (80 Kursi)
    _TrainWagon(
      name: 'Gerbong 4',
      code: 'EKO-2',
      type: 'Ekonomi New Image / Premium',
      badge: '80 Kursi • Formasi 2-2',
      capacity: 80,
      totalRows: 20,
      leftColumns: const ['A', 'B'],
      rightColumns: const ['C', 'D'],
      formationText: 'Formasi 2 - 2 (1/2 Berhadapan di Tengah)',
      reclineText: 'Reclining Seat (Sedikit Rebah)',
      revolvingText: 'Posisi Tetap (1/2 Maju, 1/2 Mundur)',
      legroomText: 'Cukup Luas & Kursi Empuk',
      exampleTrains: 'KA Jayakarta, KA Kertajaya, KA Kutojaya Utara',
      characteristics: 'Desain kursi lebih empuk dengan fitur recline. Separuh gerbong menghadap depan & separuh menghadap belakang (bertemu di tengah).',
      occupiedSeats: const {'1A', '2D', '3B', '5C', '8A', '10D', '11B', '13C', '15A', '17D', '19B', '20C'},
      validSeatCodes: _generateValidSeats(20, const ['A', 'B'], const ['C', 'D'], 80),
    ),

    // 5. Ekonomi Standar / K3 Tipe Lawas (106 Kursi)
    _TrainWagon(
      name: 'Gerbong 5',
      code: 'EKO-3',
      type: 'Ekonomi Standar / K3 (Tipe Lawas)',
      badge: '106 Kursi • Formasi 3-2',
      capacity: 106,
      totalRows: 22,
      leftColumns: const ['A', 'B', 'C'],
      rightColumns: const ['D', 'E'],
      formationText: 'Formasi 3 - 2 (Saling Berhadapan)',
      reclineText: 'Tegak 90° (Non-Reclining)',
      revolvingText: 'Posisi Duduk Tetap Berhadapan',
      legroomText: 'Terbatas (Standard PSO)',
      exampleTrains: 'KA Kahuripan, KA Bengawan, KA Sri Tanjung, KA Airlangga',
      characteristics: 'Kursi tegak 90 derajat saling berhadapan tanpa recline dengan kapasitas maksimal 106 kursi per gerbong.',
      occupiedSeats: const {'1B', '2D', '3A', '4C', '5E', '7B', '9D', '11A', '13C', '15E', '17B', '19D', '21A'},
      validSeatCodes: _generateValidSeats(22, const ['A', 'B', 'C'], const ['D', 'E'], 106),
    ),
  ];

  static Set<String> _generateValidSeats(
      int totalRows, List<String> leftCols, List<String> rightCols, int limit) {
    final Set<String> seats = {};
    final allCols = [...leftCols, ...rightCols];
    for (int r = 1; r <= totalRows; r++) {
      for (final c in allCols) {
        if (seats.length < limit) {
          seats.add('$r$c');
        }
      }
    }
    return seats;
  }

  @override
  void initState() {
    super.initState();
    _currentWagon = widget.selectedWagon;
    _currentSeat = _sanitizeSeatCode(widget.selectedSeat);

    // If train model passed, ensure default wagon aligns with train class
    if (widget.train != null) {
      final trainClass = widget.train!.trainClass.toLowerCase();
      if (trainClass.contains('ekonomi')) {
        if (!_currentWagon.contains('Gerbong 3') &&
            !_currentWagon.contains('Gerbong 4') &&
            !_currentWagon.contains('Gerbong 5')) {
          _currentWagon = 'Gerbong 3';
        }
      } else if (trainClass.contains('eksekutif') || trainClass.contains('luxury')) {
        if (!_currentWagon.contains('Gerbong 1') && !_currentWagon.contains('Gerbong 2')) {
          _currentWagon = 'Gerbong 1';
        }
      }
    }
  }

  _TrainWagon get _activeWagon {
    return _wagons.firstWhere(
      (w) => w.name == _currentWagon || _currentWagon.contains(w.name),
      orElse: () => _wagons.first,
    );
  }

  String _sanitizeSeatCode(String rawSeat) {
    final match = RegExp(r'(\d+[A-E])').firstMatch(rawSeat);
    if (match != null) {
      return match.group(1)!;
    }
    return rawSeat.isNotEmpty ? rawSeat : '1A';
  }

  void _switchWagon(_TrainWagon wagon) {
    String newSeat = _currentSeat;

    // Check if the currently selected seat exists in the new wagon and is not occupied
    if (!wagon.validSeatCodes.contains(_currentSeat) ||
        wagon.occupiedSeats.contains(_currentSeat)) {
      // Find the first available valid seat
      for (int r = 1; r <= wagon.totalRows; r++) {
        final allCols = [...wagon.leftColumns, ...wagon.rightColumns];
        for (final c in allCols) {
          final candidate = '$r$c';
          if (wagon.validSeatCodes.contains(candidate) &&
              !wagon.occupiedSeats.contains(candidate)) {
            newSeat = candidate;
            break;
          }
        }
        if (newSeat != _currentSeat && wagon.validSeatCodes.contains(newSeat)) break;
      }
    }

    setState(() {
      _currentWagon = wagon.name;
      _currentSeat = newSeat;
    });

    _notifySeatSelected(wagon.name, newSeat, wagon);
  }

  void _selectSeat(String seatCode) {
    final wagon = _activeWagon;
    if (wagon.occupiedSeats.contains(seatCode)) {
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

    setState(() {
      _currentSeat = seatCode;
    });

    _notifySeatSelected(_currentWagon, seatCode, wagon);
  }

  void _notifySeatSelected(String wagonName, String seatCode, _TrainWagon wagon) {
    final col = seatCode.replaceAll(RegExp(r'[0-9]'), '');
    final isWindow = (wagon.leftColumns.isNotEmpty && col == wagon.leftColumns.first) ||
        (wagon.rightColumns.isNotEmpty && col == wagon.rightColumns.last);
    final seatType = isWindow ? 'Jendela (Window)' : 'Lorong (Aisle)';
    final fullSeatName = '$wagonName (${wagon.code}) - Kursi $seatCode ($seatType)';

    widget.onSeatSelected(wagonName, fullSeatName);
  }

  @override
  Widget build(BuildContext context) {
    final wagon = _activeWagon;

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
          // 1. Header: Pilih Gerbong Kereta (PT KAI Standard)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.directions_transit_filled_rounded, color: Color(0xFF0284C7), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Pilih Gerbong Kereta (PT KAI)',
                    style: TextStyle(
                      color: TravelTheme.dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_wagons.length} Tipe Gerbong',
                  style: const TextStyle(
                    color: Color(0xFF0284C7),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Wagon Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _wagons.map((w) {
                final isSelected = _currentWagon == w.name || _currentWagon.contains(w.name);

                return GestureDetector(
                  onTap: () => _switchWagon(w),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0284C7) : TravelTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0284C7) : TravelTheme.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.train_rounded,
                              color: isSelected ? Colors.white : const Color(0xFF0284C7),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${w.name} (${w.code})',
                              style: TextStyle(
                                color: isSelected ? Colors.white : TravelTheme.dark,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          w.type,
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : TravelTheme.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : TravelTheme.border,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '${w.capacity} Kursi • ${w.leftColumns.length}-${w.rightColumns.length}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : TravelTheme.darkMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // Wagon Feature & Specification Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: TravelTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${wagon.type} (${wagon.code})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF0284C7),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        wagon.badge,
                        style: const TextStyle(
                          color: Color(0xFF0284C7),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  wagon.characteristics,
                  style: const TextStyle(
                    color: TravelTheme.dark,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildSpecChip(Icons.airline_seat_recline_extra_rounded, wagon.formationText),
                    _buildSpecChip(Icons.replay_rounded, 'Putar: ${wagon.revolvingText}'),
                    _buildSpecChip(Icons.airline_seat_legroom_extra_rounded, wagon.legroomText),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Contoh Kereta: ${wagon.exampleTrains}',
                  style: const TextStyle(
                    color: TravelTheme.muted,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: TravelTheme.border, height: 1),
          const SizedBox(height: 14),

          // 2. Denah Kursi Kereta Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Denah Kursi ${wagon.formationText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TravelTheme.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Total ${wagon.totalRows} Baris • ${wagon.availableSeats} dari ${wagon.capacity} Kursi Tersedia',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Arah Laju ➔',
                      style: TextStyle(
                        color: Color(0xFF0284C7),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Seat Legend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegend(
                color: Colors.white,
                borderColor: TravelTheme.border,
                label: 'Tersedia',
              ),
              _buildLegend(
                color: const Color(0xFF0284C7),
                borderColor: const Color(0xFF0284C7),
                label: 'Pilihan Anda',
              ),
              _buildLegend(
                color: const Color(0xFFE2E8F0),
                borderColor: const Color(0xFFCBD5E1),
                label: 'Terisi',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dynamic Grid of Seats
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey<String>(wagon.name),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              decoration: BoxDecoration(
                color: TravelTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: TravelTheme.border),
              ),
              child: Column(
                children: [
                  // Column Header Labels (e.g. A B C | LORONG | D E)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // Left Columns
                        Expanded(
                          flex: wagon.leftColumns.length,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: wagon.leftColumns.map((col) {
                              final isWindow = col == wagon.leftColumns.first;
                              return _buildColumnHeader(col, isWindow ? 'Jendela' : 'Lorong');
                            }).toList(),
                          ),
                        ),

                        // Center Aisle Header
                        const SizedBox(
                          width: 32,
                          child: Center(
                            child: Text(
                              'LORONG',
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.w800,
                                color: TravelTheme.muted,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        // Right Columns
                        Expanded(
                          flex: wagon.rightColumns.length,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: wagon.rightColumns.map((col) {
                              final isWindow = col == wagon.rightColumns.last;
                              return _buildColumnHeader(col, isWindow ? 'Jendela' : 'Lorong');
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: TravelTheme.border),
                  const SizedBox(height: 8),

                  // Dynamic Seat Rows
                  ...List.generate(wagon.totalRows, (rowIdx) {
                    final rowNum = rowIdx + 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.5),
                      child: Row(
                        children: [
                          // Left Columns
                          Expanded(
                            flex: wagon.leftColumns.length,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: wagon.leftColumns.map((col) {
                                final seatCode = '$rowNum$col';
                                if (!wagon.validSeatCodes.contains(seatCode)) {
                                  return const SizedBox(width: 34, height: 34);
                                }
                                return _buildSeatBox(seatCode, wagon);
                              }).toList(),
                            ),
                          ),

                          // Center Row Number
                          SizedBox(
                            width: 32,
                            child: Center(
                              child: Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$rowNum',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: TravelTheme.darkMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Right Columns
                          Expanded(
                            flex: wagon.rightColumns.length,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: wagon.rightColumns.map((col) {
                                final seatCode = '$rowNum$col';
                                if (!wagon.validSeatCodes.contains(seatCode)) {
                                  return const SizedBox(width: 34, height: 34);
                                }
                                return _buildSeatBox(seatCode, wagon);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Selected Seat Summary Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF0284C7), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pilihan: ${wagon.name} (${wagon.code}) • Kursi $_currentSeat (${_getSeatPositionSummary(_currentSeat, wagon)})',
                    style: const TextStyle(
                      color: Color(0xFF0284C7),
                      fontSize: 12,
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

  Widget _buildColumnHeader(String col, String desc) {
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

  Widget _buildSpecChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: TravelTheme.border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: const Color(0xFF0284C7)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: TravelTheme.darkMuted,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeatPositionSummary(String seatCode, _TrainWagon wagon) {
    if (seatCode.isEmpty) return 'Standar';
    final col = seatCode.replaceAll(RegExp(r'[0-9]'), '');
    final isWindow = (wagon.leftColumns.isNotEmpty && col == wagon.leftColumns.first) ||
        (wagon.rightColumns.isNotEmpty && col == wagon.rightColumns.last);
    return isWindow ? 'Dekat Jendela 🏞️' : 'Dekat Lorong 🚶';
  }

  Widget _buildSeatBox(String seatCode, _TrainWagon wagon) {
    final isOccupied = wagon.occupiedSeats.contains(seatCode);
    final isSelected = _currentSeat == seatCode;

    return GestureDetector(
      onTap: () => _selectSeat(seatCode),
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0284C7)
                : isOccupied
                    ? const Color(0xFFE2E8F0)
                    : Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0284C7)
                  : isOccupied
                      ? const Color(0xFFCBD5E1)
                      : TravelTheme.border,
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isOccupied
                ? const Icon(Icons.close_rounded, size: 13, color: TravelTheme.muted)
                : isSelected
                    ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                    : Text(
                        seatCode,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: TravelTheme.dark,
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend({
    required Color color,
    required Color borderColor,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.5),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: TravelTheme.darkMuted,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

