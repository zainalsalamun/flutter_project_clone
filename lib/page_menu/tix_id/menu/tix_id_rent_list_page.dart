import 'package:flutter/material.dart';
import 'tix_id_movie_detail_page.dart';

class TixIdRentListPage extends StatelessWidget {
  const TixIdRentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2C50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sewa Film Online",
          style: TextStyle(
            color: Color(0xFF1A2C50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          List<String> titles = [
            "28 YEARS LATER",
            "28 DAYS LATER",
            "ANABELLE",
            "INSIDIOUS",
            "THE CONJURING",
            "SAW X",
            "EXORCIST",
            "THE NUN",
            "IT",
            "HALLOWEEN",
          ];
          String title = titles[index % titles.length];
          String imageUrl =
              "https://picsum.photos/300/450?random=${index + 50}";

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TixIdMovieDetailPage(
                        title: title,
                        imageUrl: imageUrl,
                      ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A2C50),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp 25.000",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
