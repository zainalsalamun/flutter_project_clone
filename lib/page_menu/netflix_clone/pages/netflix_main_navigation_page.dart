import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/netflix_clone/pages/netflix_downloads_tab.dart';
import 'package:project_clone/page_menu/netflix_clone/pages/netflix_home_tab.dart';
import 'package:project_clone/page_menu/netflix_clone/pages/netflix_hot_tab.dart';
import 'package:project_clone/page_menu/netflix_clone/pages/netflix_search_tab.dart';
import 'package:project_clone/page_menu/netflix_clone/widgets/netflix_intro_splash.dart';

class NetflixMainNavigationPage extends StatefulWidget {
  final bool startWithSplash;

  const NetflixMainNavigationPage({
    super.key,
    this.startWithSplash = true,
  });

  @override
  State<NetflixMainNavigationPage> createState() =>
      _NetflixMainNavigationPageState();
}

class _NetflixMainNavigationPageState extends State<NetflixMainNavigationPage> {
  late bool _showSplash;
  int _currentIndex = 0;
  String _currentProfileName = 'Alex';

  @override
  void initState() {
    super.initState();
    _showSplash = widget.startWithSplash;
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Who\'s Watching?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileAvatar(
                    name: 'Alex',
                    color: const Color(0xFF0071EB),
                    icon: Icons.sentiment_satisfied_alt_rounded,
                    isSelected: _currentProfileName == 'Alex',
                  ),
                  _buildProfileAvatar(
                    name: 'Family',
                    color: const Color(0xFFE50914),
                    icon: Icons.family_restroom_rounded,
                    isSelected: _currentProfileName == 'Family',
                  ),
                  _buildProfileAvatar(
                    name: 'Kids',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.child_care_rounded,
                    isSelected: _currentProfileName == 'Kids',
                  ),
                  _buildProfileAvatar(
                    name: 'Add',
                    color: const Color(0xFF374151),
                    icon: Icons.add_rounded,
                    isSelected: false,
                    isAdd: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white12),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.movie_creation_outlined,
                    color: Color(0xFFE50914)),
                title: const Text('Replay "Ta-Dum" Intro Animation',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                trailing:
                    const Icon(Icons.replay_rounded, color: Colors.white54),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _showSplash = true;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.white70),
                title: const Text('App Settings & Playback Quality',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white54, size: 14),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar({
    required String name,
    required Color color,
    required IconData icon,
    required bool isSelected,
    bool isAdd = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isAdd) {
          setState(() {
            _currentProfileName = name;
          });
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2.5)
                  : null,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return NetflixIntroSplash(
        onAnimationComplete: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    final List<Widget> tabs = [
      NetflixHomeTab(
        onSearchTap: () => setState(() => _currentIndex = 2),
        onProfileTap: _showProfileModal,
      ),
      const NetflixHotTab(),
      const NetflixSearchTab(),
      const NetflixDownloadsTab(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF121212),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white10, width: 0.5),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (idx) => setState(() => _currentIndex = idx),
            backgroundColor: const Color(0xFF121212),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38,
            selectedFontSize: 9.5,
            unselectedFontSize: 9.5,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.home_filled),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.video_library_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.video_library_rounded),
                ),
                label: 'New & Hot',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.search_rounded),
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.file_download_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.download_for_offline_rounded),
                ),
                label: 'Downloads',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
