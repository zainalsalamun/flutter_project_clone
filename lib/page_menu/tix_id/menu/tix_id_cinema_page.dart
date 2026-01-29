import 'package:flutter/material.dart';

class TixIdCinemaPage extends StatelessWidget {
  final String cityName;
  const TixIdCinemaPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> cityCinemas = {
      "JAKARTA": [
        "PLAZA SENAYAN XXI",
        "GRAND INDONESIA CGV",
        "PONDOK INDAH 1 XXI",
        "GANDARIA CITY XXI",
        "KELAPA GADING IMAX",
        "KOTA KASABLANKA XXI",
      ],
      "YOGYAKARTA": [
        "AMBARRUKMO XXI",
        "AMBARRUKMO PREMIERE",
        "EMPIRE PREMIERE",
        "EMPIRE XXI",
        "JOGJA CITY PREMIERE",
        "JOGJA CITY XXI",
        "JWALK MALL CGV",
        "LIPPO PLAZA JOGJA CINEPOLIS",
      ],
      "BANDUNG": [
        "CIWALK XXI",
        "TSM XXI BANDUNG",
        "BEC CGV",
        "PARIS VAN JAVA CGV",
        "EMPIRE XXI BANDUNG",
      ],
      "SURABAYA": [
        "TUNJUNGAN 1 XXI",
        "TUNJUNGAN 3 XXI",
        "PAKUWON MALL CGV",
        "GALAXY MALL XXI",
        "CIPUTRA WORLD XXI",
      ],
      "MALANG": [
        "MALANG TOWN SQUARE 21",
        "MOG XXI",
        "MOVIMAX DINODYO",
        "CGV CYBER MALL",
        "ARAYA XXI",
      ],
      "SEMARANG": [
        "PARAGON XXI",
        "CITRA XXI",
        "DP MALL XXI",
        "TENTREM MALL XXI",
        "JAVA SUPERMALL CINEPOLIS",
      ],
      "BALI": [
        "BEACHWALK XXI",
        "GALERIA XXI",
        "LEVEL 21 XXI",
        "TRANS STUDIO BALI XXI",
        "LIPPO MALL KUTA CINEPOLIS",
      ],
      "MEDAN": [
        "CENTRE POINT XXI",
        "SUN PLAZA XXI",
        "DELIPARK XXI",
        "RINGROAD CITY WALKS XXI",
        "HERMES XXI",
      ],
      "MAKASSAR": [
        "PANAKKUKANG XXI",
        "TSM XXI MAKASSAR",
        "M'TOS XXI",
        "NIPAH PREMIERE",
        "NIPAH XXI",
      ],
    };

    final List<String> cinemas = cityCinemas[cityName] ?? [];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Banner Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2C50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Windows
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWindow(),
                            _buildWindow(),
                            _buildWindow(),
                          ],
                        ),
                        // Gold Stripe
                        Container(
                          width: 12,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC5A059),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: -6,
                    left: -6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.star_border,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tandai bioskop favoritmu!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A2C50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Bioskop favoritmu akan berada paling atas pada daftar ini dan pada jadwal film.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1A2C50)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text(
                        "MENGERTI",
                        style: TextStyle(
                          color: Color(0xFF1A2C50),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Cinema List match exact style in image: star icon left, text bold, arrow right
        ...cinemas.map((name) => _buildCinemaItem(name)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWindow() {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCinemaItem(String name) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: ListTile(
        leading: const Icon(Icons.star_border, color: Colors.grey),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2C50),
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
        onTap: () {},
      ),
    );
  }
}
