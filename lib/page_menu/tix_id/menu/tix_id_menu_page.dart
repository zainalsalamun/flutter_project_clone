import 'package:flutter/material.dart';
import 'widgets/tix_id_header_widgets.dart';
import 'tix_id_home_content.dart';
import 'tix_id_cinema_page.dart';
import 'tix_id_fun_page.dart';
import 'tix_id_ticket_page.dart';

class TixIdMenuPage extends StatefulWidget {
  const TixIdMenuPage({super.key});

  @override
  State<TixIdMenuPage> createState() => _TixIdMenuPageState();
}

class _TixIdMenuPageState extends State<TixIdMenuPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TixIdHomeContent(),
    const TixIdCinemaPage(),
    const TixIdFunPage(),
    const TixIdTicketPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TixIdAppBar(),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: const Color(0xFF1A2C50),
        unselectedItemColor: const Color(0xFFBDBDBD),
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.home_filled),
            ),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.apartment),
            ),
            label: 'Bioskop',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.attractions),
                ),
                Positioned(
                  right: -12,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5252), // Reddish color for badge
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "BARU",
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            label: 'TIX Fun',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.confirmation_number),
            ),
            label: 'Tiket',
          ),
        ],
      ),
    );
  }
}
