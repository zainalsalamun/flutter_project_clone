import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/pintu/menu/beranda_page.dart';

class PintuHomePage extends StatefulWidget {
  const PintuHomePage({super.key});

  @override
  State<PintuHomePage> createState() => _PintuHomePageState();
}

class _PintuHomePageState extends State<PintuHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BerandaPage(),
    const Center(child: Text('Market Page')),
    const Center(child: Text('Trade Page')),
    const Center(child: Text('Futures Page')),
    const Center(child: Text('Wallet Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Market",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: "Trade",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: "Futures",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Wallet",
            ),
          ],
        ),
      ),
    );
  }
}
