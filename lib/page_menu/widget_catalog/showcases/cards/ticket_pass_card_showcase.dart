import 'package:flutter/material.dart';

class TicketPassCardShowcase extends StatelessWidget {
  const TicketPassCardShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: TicketPassCard(
          headerColor: const Color(0xFF0F172A),
          airline: 'FLUTTER AIR',
          flightNumber: 'FL-902',
          fromCode: 'CGK',
          fromCity: 'Jakarta',
          toCode: 'NRT',
          toCity: 'Tokyo',
          passenger: 'Zainal S.',
          gate: 'B4',
          seat: '12A',
          time: '08:30 AM',
          date: '28 Oct 2026',
        ),
      ),
    );
  }
}

class TicketPassCard extends StatelessWidget {
  final Color headerColor;
  final String airline;
  final String flightNumber;
  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final String passenger;
  final String gate;
  final String seat;
  final String time;
  final String date;

  const TicketPassCard({
    super.key,
    required this.headerColor,
    required this.airline,
    required this.flightNumber,
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    required this.passenger,
    required this.gate,
    required this.seat,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.flight_takeoff_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      airline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  flightNumber,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Flight Route
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      fromCity,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.more_horiz_rounded, color: Colors.grey),
                    Icon(
                      Icons.flight_rounded,
                      color: Color(0xFF6366F1),
                      size: 22,
                    ),
                    Icon(Icons.more_horiz_rounded, color: Colors.grey),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      toCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      toCity,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notch and dashed separator
          Row(
            children: [
              Container(
                width: 14,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(14),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final count = (constraints.maxWidth / 8).floor();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        count,
                        (_) => Container(
                          width: 4,
                          height: 1.5,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 14,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
              ),
            ],
          ),

          // Ticket Info Grid
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoCell('PASSENGER', passenger),
                    _infoCell('DATE', date),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoCell('GATE', gate),
                    _infoCell('SEAT', seat),
                    _infoCell('TIME', time),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
