import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/models/netflix_content.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/content_row.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/movie_detail_sheet.dart';

class NetflixDownloadsTab extends StatelessWidget {
  const NetflixDownloadsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Downloads',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast_rounded, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Smart Downloads Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.settings_suggest_rounded,
                      color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Smart Downloads',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: true,
                    onChanged: (val) {},
                    activeThumbColor: const Color(0xFFE50914),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12),

            // Downloaded list items
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Available Offline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _buildDownloadItem(
              context,
              title: 'Stranger Things (Season 4)',
              sizeText: '3.4 GB • 3 Episodes',
              thumbnail:
                  'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=300',
            ),
            _buildDownloadItem(
              context,
              title: 'Cyberpunk: Edgerunners',
              sizeText: '1.2 GB • 2 Episodes',
              thumbnail:
                  'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=300',
            ),

            const SizedBox(height: 16),

            // Storage Breakdown Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Device Storage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '4.6 GB of 128 GB Used',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.28,
                      backgroundColor: Colors.white12,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recommendation to download
            ContentRow(
              title: 'Find Something to Download',
              contents: NetflixContent.trendingNow,
              onContentTap: (content) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => MovieDetailSheet(content: content),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadItem(
    BuildContext context, {
    required String title,
    required String sizeText,
    required String thumbnail,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          thumbnail,
          width: 75,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 75,
            height: 48,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        sizeText,
        style: const TextStyle(color: Colors.white54, fontSize: 11),
      ),
      trailing: const Icon(
        Icons.check_circle_rounded,
        color: Color(0xFF0071EB),
        size: 22,
      ),
    );
  }
}
