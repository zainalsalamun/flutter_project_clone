import 'package:flutter/material.dart';

class TixIdTicketPage extends StatefulWidget {
  const TixIdTicketPage({super.key});

  @override
  State<TixIdTicketPage> createState() => _TixIdTicketPageState();
}

class _TixIdTicketPageState extends State<TixIdTicketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilterIndex = 0; // 0: Film, 1: Makanan, 2: Event, 3: Atraksi

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1A2C50),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            indicatorColor: const Color(0xFF001A4C), // Dark blue indicator
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "TIKET AKTIF"),
              Tab(text: "DAFTAR TRANSAKSI"),
            ],
          ),
        ),

        // Filter Chips
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(0, "Film"),
                const SizedBox(width: 12),
                _buildFilterChip(1, "Makanan"),
                const SizedBox(width: 12),
                _buildFilterChip(2, "Event"),
                const SizedBox(width: 12),
                _buildFilterChip(3, "Atraksi"),
              ],
            ),
          ),
        ),

        // Main Content (Empty State)
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty State Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  "Nonton Film Yuk!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2C50),
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  "Dapatkan tiket nonton seru di\nbioskop favoritmu.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                // CTA Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to movies or handle action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A2C50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Lihat Film",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 100), // Offsetting center visually
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final bool isSelected = _selectedFilterIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : const Color(0xFF1A2C50),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
