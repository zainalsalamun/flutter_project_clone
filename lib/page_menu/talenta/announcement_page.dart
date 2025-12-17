import 'package:flutter/material.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: _appBar(),
      body: Column(
        children: [
          _searchBar(),
          _infoText(),
          Expanded(child: _announcementList()),
        ],
      ),
      floatingActionButton: _scrollToTopButton(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: const Color(0xFFB31212),
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: const Text(
        'Announcement',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.filter_alt_outlined, color: Colors.white),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      color: const Color(0xFFB31212),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _infoText() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'You have 100 new announcements',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ),
    );
  }

  Widget _announcementList() {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: dummyAnnouncements.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = dummyAnnouncements[index];
        return _announcementTile(item);
      },
    );
  }

  Widget _announcementTile(AnnouncementItem item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 22, backgroundImage: AssetImage(item.avatar)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      item.date,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'By ${item.author}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  item.preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8),
                _tagChip(item.tag),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A4A4A),
        ),
      ),
    );
  }

  Widget _scrollToTopButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF0D47A1),
      onPressed: () {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      },
      child: const Icon(Icons.keyboard_arrow_up),
    );
  }
}

class AnnouncementItem {
  final String title;
  final String author;
  final String preview;
  final String date;
  final String tag;
  final String avatar;

  AnnouncementItem({
    required this.title,
    required this.author,
    required this.preview,
    required this.date,
    required this.tag,
    required this.avatar,
  });
}

final dummyAnnouncements = [
  AnnouncementItem(
    title: 'Respectful Workplace Policy',
    author: 'Mochamad Ihza Yudhakesuma',
    preview: 'Hai Yokke Squad,',
    date: '19 Nov',
    tag: 'Yokke Culture',
    avatar: 'assets/avatar_1.png',
  ),
  AnnouncementItem(
    title: 'Survey Budaya Perusahaan',
    author: 'Mochamad Ihza Yudhakesuma',
    preview: 'Semangat Pagi Yokke Squad!',
    date: '14 Nov',
    tag: 'Yokke Culture',
    avatar: 'assets/avatar_1.png',
  ),
  AnnouncementItem(
    title: 'Komitmen Kebijakan Mutu',
    author: 'Mochamad Ihza Yudhakesuma',
    preview: 'Mutu dan keamanan informasi...',
    date: '14 Nov',
    tag: 'Yokke Spotlight',
    avatar: 'assets/avatar_1.png',
  ),
  AnnouncementItem(
    title: 'Yokke Buzz Vol.08',
    author: 'Mochamad Ihza Yudhakesuma',
    preview: 'Halo Yokke Squad!',
    date: '10 Nov',
    tag: 'Yokke Buzz',
    avatar: 'assets/avatar_1.png',
  ),
];
