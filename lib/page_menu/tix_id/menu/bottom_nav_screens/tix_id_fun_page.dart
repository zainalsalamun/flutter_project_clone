import 'package:flutter/material.dart';

class TixIdFunPage extends StatelessWidget {
  const TixIdFunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Custom Header Background
          Container(
            height: 350,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0A1D37), // Dark blue background
              image: DecorationImage(
                image: NetworkImage(
                  "https://picsum.photos/600/600?blur=2",
                ), // Placeholder for night sky/fireworks abstract
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Bar: Location & Search
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "JAKARTA",
                                style: TextStyle(
                                  color: Color(0xFF1A2C50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        // Search Button
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Color(0xFF1A2C50),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TIX FUN Logo Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "TIX",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "FUN",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.greenAccent[400],
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tagline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "Mari manfaatkan pengalaman ini sebaik-baiknya dan ciptakan kenangan indah!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Scrollable Content Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 24),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Categories Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildCategoryItem("Zoo", Icons.pets, Colors.orange),
                          _buildCategoryItem(
                            "Arcade",
                            Icons.videogame_asset,
                            Colors.purple,
                          ),
                          _buildCategoryItem(
                            "Amusement",
                            Icons.attractions,
                            Colors.red,
                          ),
                          _buildCategoryItem(
                            "Waterpark",
                            Icons.pool,
                            Colors.cyan,
                          ),
                          _buildCategoryItem(
                            "Museum",
                            Icons.account_balance,
                            Colors.blueGrey,
                          ),
                          _buildCategoryItem(
                            "Activity",
                            Icons.sports_handball,
                            Colors.brown,
                          ),
                          _buildCategoryItem(
                            "Entertainment",
                            Icons.theater_comedy,
                            Colors.pink,
                          ),
                          _buildCategoryItem(
                            "Sport",
                            Icons.sports_soccer,
                            Colors.green,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Divider(height: 1, color: Colors.grey[200]),
                      const SizedBox(height: 24),

                      // Recommendations Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Recommendations",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2C50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Lihat rekomendasi terbaik kami! Jangan ragu, coba sekarang juga!",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Horizontal Recommendation List
                      SizedBox(
                        height: 240,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildRecommendationCard(
                              "Ancol Entrance Gate",
                              "Rp25.000",
                              "https://picsum.photos/300/200?random=10",
                            ),
                            const SizedBox(width: 16),
                            _buildRecommendationCard(
                              "Skorz FX Sudirman",
                              null,
                              "https://picsum.photos/300/200?random=11",
                            ),
                            const SizedBox(width: 16),
                            _buildRecommendationCard(
                              "Dufan Annual Pass",
                              "Rp350.000",
                              "https://picsum.photos/300/200?random=12",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80), // Bottom padding
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1A2C50),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    String title,
    String? price,
    String imageUrl,
  ) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A2C50),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (price != null) ...[
                  Text(
                    "Mulai dari",
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A2C50),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
