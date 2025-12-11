import 'package:flutter/material.dart';
import 'package:shoppe_clone/page_menu/bibit_home_page.dart';
import 'package:shoppe_clone/page_menu/gojek_home_page.dart';
import 'package:shoppe_clone/page_menu/livin_home_page.dart';
import 'package:shoppe_clone/page_menu/ovo_home_page.dart';
import 'package:shoppe_clone/page_menu/pintu_home_page.dart';
import 'package:shoppe_clone/page_menu/shopeepay_page.dart';

class AllPagesDemo extends StatelessWidget {
  const AllPagesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          "UI Demo Pages",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _menuCard(
            context,
            title: "Bibit Home Page",
            icon: Icons.wallet_travel,
            iconColor: Colors.green,
            page: const BibitHomePage(),
          ),
          _menuCard(
            context,
            title: "Gojek Home Page",
            icon: Icons.motorcycle,
            iconColor: Colors.green.shade700,
            page: const GojekHomePage(),
          ),
          _menuCard(
            context,
            title: "Livin Mandiri Home Page",
            icon: Icons.account_balance_wallet,
            iconColor: Colors.blue.shade700,
            page: const LivinHomePage(),
          ),
          _menuCard(
            context,
            title: "OVO Home Page",
            icon: Icons.account_balance,
            iconColor: Colors.purple,
            page: const OVOHomePage(),
          ),
          _menuCard(
            context,
            title: "ShopeePay Page",
            icon: Icons.shopping_bag,
            iconColor: Colors.orange,
            page: const ShopeePayPage(),
          ),
          _menuCard(
            context,
            title: "Pintu Page",
            icon: Icons.door_back_door,
            iconColor: Colors.lightBlue,
            page: const PintuHomePage(),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 26, color: iconColor),
            ),
            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
