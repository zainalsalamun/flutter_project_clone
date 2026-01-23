import 'package:flutter/material.dart';
import 'tix_id_shared_widgets.dart';

class TixIdEventsSection extends StatelessWidget {
  const TixIdEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TixIdSectionHeader(
          icon: Icons.star,
          title: "TIX Events",
          subtitle: "Rasakan serunya, nikmati pengalamannya!",
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
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color: Colors.red[400],
                        // image: DecorationImage(...) // Add real image here
                      ),
                      child: Center(
                        child: Text(
                          "Event Image $index",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Art Jakarta Papers 2026",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1A2C50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "City Hall, Pondok Indah Ma...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Mulai dari ",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                "Rp150.000",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1A2C50),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

class TixIdFoodSection extends StatelessWidget {
  const TixIdFoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TixIdSectionHeader(
          icon: Icons.fastfood,
          title: "TIX Food",
          subtitle:
              "Nonton lebih asik bareng camilan favoritmu. Pesannya\nlebih mudah pake TIX Food!",
        ),
        const SizedBox(height: 16),
        // Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFFFCC00),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 100,
                top: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "BELI CEMILAN NONTON",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2C50),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      color: const Color(0xFF1A2C50),
                      child: const Text(
                        "TANPA ANTRE!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2C50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 24),
                      ),
                      child: const Text(
                        "BELI SEKARANG",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Cup Image Placeholder (Left)
              Positioned(
                left: 10,
                bottom: 10,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    width: 60,
                    height: 80,
                    color: Colors.green[800],
                    child: const Center(
                      child: Icon(Icons.coffee, color: Colors.white),
                    ),
                  ),
                ),
              ),
              // Popcorn Image Placeholder (Right)
              Positioned(
                right: 10,
                bottom: 0,
                child: Container(
                  width: 70,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.fastfood, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TixIdVideoSection extends StatelessWidget {
  const TixIdVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TixIdSectionHeader(
          icon: Icons.video_library,
          title: "Video",
          subtitle: "Trailer, wawancara, di balik layar, dan banyak lagi!",
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              List<String> titles = [
                "EPiC: Elvis Presley in Concert | Official Main Tr...",
                "Scream 7 | Legacy Movie - Neve Campbell",
              ];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://picsum.photos/400/250?random=${index + 50}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Play Button Overlay
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        // Likes Badge
                        if (index == 0)
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A2C50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    size: 10,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "2",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      titles[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A2C50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${36 + index * 6}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "|  20 Jan 2026",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
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

class TixIdSpotlightSection extends StatelessWidget {
  const TixIdSpotlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TixIdSectionHeader(
          icon: Icons.flashlight_on,
          title: "Spotlight",
          subtitle: "Berita hiburan terhangat untuk Anda!",
        ),
        const SizedBox(height: 16),
        // Spotlight Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Card 1
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF1A2C50),
                      ),
                      child: Stack(
                        children: [
                          // Images
                          Row(
                            children: [
                              Expanded(
                                child: Image.network(
                                  "https://picsum.photos/200/200?random=1",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Image.network(
                                  "https://picsum.photos/200/200?random=2",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Image.network(
                                  "https://picsum.photos/200/200?random=3",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Image.network(
                                  "https://picsum.photos/200/200?random=4",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          // Overlay Text
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    const Color(0xFF1A2C50),
                                    const Color(0xFF1A2C50).withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "10",
                                    style: TextStyle(
                                      fontSize: 60,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "TIX ID | Weekly Box Office",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          "FILM TERLARIS DI BIOSKOP INDONESIA",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "12 - 18 Januari 2026",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "TIX ID Box Office (12-18 Januari)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2C50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "8.516",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.thumb_up, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          "17",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Semua", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class TixIdNewsSection extends StatelessWidget {
  const TixIdNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TixIdSectionHeader(
            icon: Icons.newspaper,
            title: "TIX Now",
            subtitle: "Update berita terbaru seputar dunia film",
            onAllPressed: () {},
          ),
          const SizedBox(height: 16),
          // News Items
          const TixIdNewsItem(
            title: "Dodit Mulyanto dan Angga Yunanda Jadi Saudara Kembar?",
            time: "20 jam yang lalu",
            viewCount: "210",
            likeCount: "2",
          ),
          const TixIdNewsItem(
            title: "Ketika Dongeng Timun Mas Menjadi Teror Mencekam!",
            time: "2 hari lalu",
            viewCount: "311",
            likeCount: "2",
          ),
          const TixIdNewsItem(
            title:
                "Sebelum Nonton, Cek Dulu Sinopsis Penerbangan Terakhir Sekarang!",
            time: "5 hari lalu",
            viewCount: "3K",
            likeCount: "11",
          ),
          const TixIdNewsItem(
            title: "Apa Jadinya Kalo Ibu Kamu Jadi AI?",
            time: "6 hari lalu",
            viewCount: "2K",
            likeCount: "20",
          ),
          const TixIdNewsItem(
            title: "Lebih Besar dan Seru, Greenland: Migration Tayang!",
            time: "7 hari lalu",
            viewCount: "1.5K",
            likeCount: "15",
          ),
        ],
      ),
    );
  }
}

class TixIdNewsItem extends StatelessWidget {
  final String title;
  final String time;
  final String viewCount;
  final String likeCount;

  const TixIdNewsItem({
    super.key,
    required this.title,
    required this.time,
    required this.viewCount,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://picsum.photos/100/100?random=${title.length}",
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A2C50),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        "News",
                        style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      viewCount,
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.thumb_up, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      likeCount,
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
