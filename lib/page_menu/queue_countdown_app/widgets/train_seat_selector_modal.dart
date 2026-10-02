import 'package:flutter/material.dart';

/// Modal bottom sheet for interactive Train Carriage & Seat Selection.
class TrainSeatSelectorModal extends StatefulWidget {
  final String selectedCarriage;
  final String selectedSeat;
  final ValueChanged<Map<String, String>> onSeatSelected;

  const TrainSeatSelectorModal({
    super.key,
    required this.selectedCarriage,
    required this.selectedSeat,
    required this.onSeatSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String selectedCarriage,
    required String selectedSeat,
    required ValueChanged<Map<String, String>> onSeatSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TrainSeatSelectorModal(
        selectedCarriage: selectedCarriage,
        selectedSeat: selectedSeat,
        onSeatSelected: onSeatSelected,
      ),
    );
  }

  @override
  State<TrainSeatSelectorModal> createState() => _TrainSeatSelectorModalState();
}

class _TrainSeatSelectorModalState extends State<TrainSeatSelectorModal> {
  late String _currentCarriage;
  late String _currentSeat;

  final List<String> _carriages = [
    "Eksekutif 1",
    "Eksekutif 2",
    "Eksekutif 3",
    "Eksekutif 4",
  ];

  // Occupied seats simulation
  final Set<String> _occupiedSeats = {
    "1A", "1B", "2C", "2D", "3A", "4B", "5C", "5D", "6A", "7B", "8C", "9D", "10A"
  };

  @override
  void initState() {
    super.initState();
    _currentCarriage = widget.selectedCarriage;
    _currentSeat = widget.selectedSeat;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        child: Column(
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 42,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header Title & Carriage Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Kursi Kereta",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      "Argo Parahyangan • Eksekutif (2x2)",
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Kursi: $_currentSeat",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Carriage Switcher Tabs
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _carriages.length,
                itemBuilder: (context, index) {
                  final carriage = _carriages[index];
                  final isSelected = _currentCarriage == carriage;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCarriage = carriage;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        carriage,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Seat Legend (Tersedia, Terisi, Dipilih)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                    const Color(0xFFF8FAFC), Colors.grey.shade300, "Tersedia"),
                const SizedBox(width: 16),
                _buildLegendItem(
                    const Color(0xFFE2E8F0), Colors.transparent, "Terisi"),
                const SizedBox(width: 16),
                _buildLegendItem(const Color(0xFF2563EB),
                    const Color(0xFF2563EB), "Dipilih",
                    textColor: Colors.white),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE2E8F0), height: 1),
            const SizedBox(height: 10),

            // Carriage Front Direction
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_upward_rounded,
                      size: 14, color: Color(0xFF64748B)),
                  SizedBox(width: 4),
                  Text(
                    "Arah Lokomotif / Pintu Depan",
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Carriage Grid (Rows 1 to 10 with 2x2 layout: A B [Lorong] C D)
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10, // 10 rows
                  itemBuilder: (context, index) {
                    final rowNumber = index + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Window Seats (A, B)
                          Row(
                            children: [
                              _buildSeatButton("${rowNumber}A"),
                              const SizedBox(width: 8),
                              _buildSeatButton("${rowNumber}B"),
                            ],
                          ),

                          // Aisle / Row Number Indicator
                          Container(
                            width: 28,
                            alignment: Alignment.center,
                            child: Text(
                              "$rowNumber",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),

                          // Right Window Seats (C, D)
                          Row(
                            children: [
                              _buildSeatButton("${rowNumber}C"),
                              const SizedBox(width: 8),
                              _buildSeatButton("${rowNumber}D"),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Confirm Selection Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSeatSelected({
                    'carriage': _currentCarriage,
                    'seat': _currentSeat,
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Konfirmasi Kursi ($_currentCarriage - $_currentSeat)",
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatButton(String seatCode) {
    final isOccupied = _occupiedSeats.contains(seatCode);
    final isSelected = _currentSeat == seatCode;

    return GestureDetector(
      onTap: () {
        if (isOccupied) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Kursi $seatCode sudah terisi oleh penumpang lain."),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(milliseconds: 1000),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }
        setState(() {
          _currentSeat = seatCode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB)
              : isOccupied
                  ? const Color(0xFFCBD5E1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : isOccupied
                    ? Colors.transparent
                    : Colors.grey.shade300,
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOccupied ? Icons.person_rounded : Icons.chair_rounded,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : isOccupied
                      ? const Color(0xFF64748B)
                      : const Color(0xFF2563EB),
            ),
            const SizedBox(height: 2),
            Text(
              seatCode,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : isOccupied
                        ? const Color(0xFF64748B)
                        : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, Color borderColor, String label,
      {Color? textColor}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
