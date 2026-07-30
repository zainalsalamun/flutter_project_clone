import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/recipe_app/pages/splash_page.dart';
import 'package:project_clone/page_menu/bibit_home_page.dart';
import 'package:project_clone/page_menu/gojek_home_page.dart';
import 'package:project_clone/page_menu/talenta/hr_home_page.dart';
import 'package:project_clone/page_menu/livin_home_page.dart';
import 'package:project_clone/page_menu/ovo_home_page.dart';
import 'package:project_clone/page_menu/pintu/pintu_home_page.dart';
import 'package:project_clone/page_menu/shopeepay_page.dart';
import 'package:project_clone/page_menu/traveloka_home_page.dart';
import 'package:project_clone/page_menu/shark_fit/menu/shark_fit_home_page.dart';
import 'package:project_clone/page_menu/tix_id/menu/tix_id_menu_page.dart';
import 'package:project_clone/page_menu/glossy_shop/features/main_wrapper/presentation/views/glossy_shop_page.dart';
import 'package:project_clone/page_menu/glossy_music/features/main_wrapper/presentation/views/glossy_music_page.dart';
import 'package:project_clone/page_menu/notification_center/notification_menu_page.dart';
import 'package:project_clone/page_menu/nova_ai/nova_ai_home_page.dart';
import 'package:project_clone/page_menu/lumina_home/lumina_home_page.dart';
import 'package:project_clone/page_menu/aura_wallet/aura_wallet_page.dart';
import 'package:project_clone/page_menu/zenith_task/zenith_task_page.dart';
import 'package:project_clone/page_menu/brewez_coffee/brewez_coffee_page.dart';
import 'package:project_clone/page_menu/task_manager/task_manager_page.dart';
import 'package:project_clone/page_menu/habit_tracker/habit_tracker_page.dart';
import 'package:project_clone/page_menu/inventory_app/inventory_home_page.dart';
import 'package:project_clone/page_menu/weather_app/weather_home_page.dart';
import 'package:project_clone/page_menu/movie_app/movie_app.dart';
import 'package:project_clone/page_menu/e_commerce_app/e_commerce_app.dart';
import 'package:project_clone/page_menu/food_delivery_app/food_delivery_app.dart';
import 'package:project_clone/page_menu/pos_app/pos_app.dart';
import 'package:project_clone/page_menu/hospital_reservation_app/hospital_app.dart';
import 'package:project_clone/page_menu/rs_medika_app/rs_medika_app.dart';

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
            title: "Recipe App (Full App)",
            icon: Icons.restaurant_menu,
            iconColor: const Color(0xFFF96163),
            page: const SplashPage(),
          ),
          _menuCard(
            context,
            title: "Weather App (Aesthetic UI)",
            icon: Icons.cloud,
            iconColor: Colors.lightBlueAccent,
            page: const WeatherHomePage(),
          ),
          _menuCard(
            context,
            title: "Inventory App (Sederhana)",
            icon: Icons.inventory_2_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const InventoryHomePage(),
          ),
          _menuCard(
            context,
            title: "Coffee Order App",
            icon: Icons.coffee,
            iconColor: const Color(0xFFC67C4E),
            page: const BrewezCoffeePage(),
          ),
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
          _menuCard(
            context,
            title: "Traveloka Home Page",
            icon: Icons.flight,
            iconColor: Colors.lightBlue,
            page: const TravelokaHomePage(),
          ),
          _menuCard(
            context,
            title: "HR Home Page",
            icon: Icons.groups_2_outlined,
            iconColor: Colors.red.shade700,
            page: const HrHomePage(),
          ),
          _menuCard(
            context,
            title: "Shark Fit Home Page",
            icon: Icons.monitor_heart_outlined,
            iconColor: Colors.blue.shade700,
            page: const SharkFitHomePage(),
          ),
          _menuCard(
            context,
            title: "Tix ID Home Page",
            icon: Icons.movie_outlined,
            iconColor: const Color(0xFF1A2C50),
            page: const TixIdMenuPage(),
          ),
          _menuCard(
            context,
            title: "Halaman Belanja Glossy AI",
            icon: Icons.blur_on_rounded,
            iconColor: Colors.purpleAccent,
            page: const GlossyShopPage(),
          ),
          _menuCard(
            context,
            title: "Halaman Musik Glossy AI",
            icon: Icons.graphic_eq_rounded,
            iconColor: Colors.cyan,
            page: const GlossyMusicPage(),
          ),
          _menuCard(
            context,
            title: "Notification Center",
            icon: Icons.notifications_active,
            iconColor: Colors.redAccent,
            page: const NotificationMenuPage(),
          ),
          _menuCard(
            context,
            title: "Nova AI Dashboard",
            icon: Icons.auto_awesome,
            iconColor: const Color(0xFF6366F1), // Indigo
            page: const NovaAiHomePage(),
          ),
          _menuCard(
            context,
            title: "Lumina Smart Home",
            icon: Icons.home_filled,
            iconColor: const Color(0xFFF59E0B), // Amber
            page: const LuminaHomePage(),
          ),
          _menuCard(
            context,
            title: "Aura Crypto Wallet (BLoC)",
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF6366F1), // Indigo
            page: const AuraWalletPage(),
          ),
          _menuCard(
            context,
            title: "Zenith Task (Neo-Brutalism)",
            icon: Icons.check_box,
            iconColor: const Color(0xFFF472B6), // Pink
            page: const ZenithTaskPage(),
          ),
          _menuCard(
            context,
            title: "Task Manager Pro (Local Storage)",
            icon: Icons.task_alt,
            iconColor: const Color(0xFF10B981), // Emerald
            page: const TaskManagerPage(),
          ),
          _menuCard(
            context,
            title: "Habit Tracker (BLoC)",
            icon: Icons.local_fire_department,
            iconColor: const Color(0xFFF59E0B), // Amber
            page: const HabitTrackerPage(),
          ),
          _menuCard(
            context,
            title: "Movie App (TMDB & BLoC)",
            icon: Icons.movie_filter,
            iconColor: Colors.red,
            page: const MovieApp(),
          ),
          _menuCard(
            context,
            title: "E-Commerce App (Roadmap)",
            icon: Icons.shopping_cart,
            iconColor: Colors.blueAccent,
            page: const ECommerceApp(),
          ),
          _menuCard(
            context,
            title: "Food Delivery (Roadmap)",
            icon: Icons.fastfood,
            iconColor: Colors.green,
            page: const FoodDeliveryApp(),
          ),
          _menuCard(
            context,
            title: "POS App (Kasir Modern)",
            icon: Icons.point_of_sale,
            iconColor: Colors.deepPurple,
            page: const PosApp(),
          ),
          _menuCard(
            context,
            title: "Hospital App (Enterprise)",
            icon: Icons.local_hospital,
            iconColor: Colors.teal,
            page: const HospitalApp(),
          ),
          _menuCard(
            context,
            title: "RS Medika Utama (Reservasi)",
            icon: Icons.health_and_safety,
            iconColor: Colors.green,
            page: const RsMedikaApp(),
          ),
          const SizedBox(height: 16),
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
