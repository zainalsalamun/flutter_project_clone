import 'package:flutter/material.dart';

class TixIdCinemaPage extends StatelessWidget {
  const TixIdCinemaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> cinemas = [
      "AMBARRUKMO XXI",
      "AMBARRUKMO PREMIERE",
      "EMPIRE PREMIERE",
      "EMPIRE XXI",
      "JOGJA CITY PREMIERE",
      "JOGJA CITY XXI",
      "JWALK MALL CGV",
      "LIPPO PLAZA JOGJA CINEPOLIS",
    ];

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
