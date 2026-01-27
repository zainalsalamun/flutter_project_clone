import 'package:flutter/material.dart';
import 'tix_id_shared_widgets.dart';
import '../tix_id_movie_detail_page.dart';
import '../tix_id_rent_list_page.dart';
import '../tix_id_now_showing_list_page.dart';

class TixIdNowShowingSection extends StatelessWidget {
  const TixIdNowShowingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TixIdSectionHeader(
          icon: Icons.movie,
          title: "Sedang Tayang",
          onAllPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TixIdNowShowingListPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const TixIdFilterChip(label: "Semua Film", isSelected: true),
              const TixIdFilterChip(label: "XXI"),
              const TixIdFilterChip(label: "CGV"),
              const TixIdFilterChip(label: "Cinépolis"),
              const TixIdFilterChip(label: "❤️ Watchlist Saya"),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Movie List
        SizedBox(
          height: 380,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return TixIdNowShowingCard(index: index);
            },
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TixIdNowShowingListPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A2C50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF1A2C50)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            label: const Text("Semua"),
          ),
        ),
      ],
    );
  }
}

class TixIdNowShowingCard extends StatelessWidget {
  final int index;

  const TixIdNowShowingCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["DAYS", "MERCY", "TWILIGHT"];
    // Safety check for index
    String title = titles[index % titles.length];
    String imageUrl = "https://picsum.photos/300/400?random=$index";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    TixIdMovieDetailPage(title: title, imageUrl: imageUrl),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            // Top Left Badge
            if (index == 0)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "24",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            // Number Badge
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2C50),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            minimumSize: const Size(0, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Beli Tiket",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TixIdRentSection extends StatelessWidget {
  const TixIdRentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TixIdSectionHeader(
          icon: Icons.play_circle_fill,
          title: "Sewa Film Online",
          subtitle: "Sewa dan tonton film menarik kapanpun!",
          onAllPressed: () {},
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              List<String> titles = [
                "28 YEARS LATER",
                "28 DAYS LATER",
                "ANABELLE",
              ];
              // Safety
              String title = titles[index % titles.length];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TixIdMovieDetailPage(
                            title: title,
                            imageUrl:
                                "https://picsum.photos/300/450?random=${index + 10}",
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                index % 2 == 0
                                    ? Colors.red[900]
                                    : Colors.grey[800],
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://picsum.photos/300/450?random=${index + 10}",
                              ),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Floating 'Semua' Button - strictly speaking this was outside the list in original code
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TixIdRentListPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A2C50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF1A2C50)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            label: const Text("Semua"),
          ),
        ),
      ],
    );
  }
}

class TixIdComingSoonSection extends StatelessWidget {
  const TixIdComingSoonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TixIdSectionHeader(
          icon: Icons.hourglass_empty,
          title: "Akan Tayang",
          subtitle: "Film-film seru yang segera tayang di bioskop",
          onAllPressed: () {},
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              List<Map<String, dynamic>> movies = [
                {
                  "title": "ESOK TANPA IBU",
                  "date": "Tanggal rilis: 22 Jan",
                  "tags": ["XXI", "CGV", "CINEPOLIS"],
                },
                {
                  "title": "SEBELUM DIJEMPUT NENEK",
                  "date": "Tanggal rilis: 22 Jan",
                  "tags": ["XXI", "CGV", "CINEPOLIS"],
                },
                {
                  "title": "SENTUHAN SATU MALAM",
                  "date": "Tanggal rilis: 22 Jan",
                  "tags": ["XXI"],
                },
              ];
              var movie = movies[index % movies.length];

              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              index % 2 == 0
                                  ? Colors.blue[900]
                                  : Colors.purple[900],
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://picsum.photos/300/450?random=${index + 100}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1A2C50),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children:
                          (movie["tags"] as List<String>)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        tag == "XXI"
                                            ? Colors.amber
                                            : (tag == "CGV"
                                                ? Colors.red
                                                : Colors.blue[900]),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie["date"],
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
