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
import 'package:project_clone/page_menu/food_delivery_promo/food_delivery_promo_page.dart';
import 'package:project_clone/page_menu/pos_app/pos_app.dart';
import 'package:project_clone/page_menu/hospital_reservation_app/hospital_app.dart';
import 'package:project_clone/page_menu/rs_medika_app/rs_medika_app.dart';
import 'package:project_clone/page_menu/abc_mobile_app/pages/m_abc_page.dart';
import 'package:project_clone/page_menu/bank_jnal_app/bank_jnal_main.dart';
import 'package:project_clone/page_menu/infinite_scroll_image_app/infinite_scroll_image_app.dart';
import 'package:project_clone/page_menu/iphone_duo_app/pages/iphone_duo_home_page.dart';
import 'package:project_clone/page_menu/netflix_clone/pages/netflix_main_navigation_page.dart';
import 'package:project_clone/page_menu/smart_cctv_app/pages/smart_home_main_wrapper.dart';
import 'package:project_clone/page_menu/travel_booking_app/travel_booking_page.dart';
import 'package:project_clone/page_menu/music_player_app/music_player_app.dart';
import 'package:project_clone/page_menu/meditation_sleep_app/meditation_sleep_app.dart';
import 'package:project_clone/page_menu/mood_reaction_app/mood_reaction_app.dart';
import 'package:project_clone/page_menu/fixly_service_app/fixly_service_app.dart';
import 'package:project_clone/page_menu/flutter_learning_hub/flutter_learning_hub_page.dart';
import 'package:project_clone/page_menu/flutter_learning_hub/catalog/pages/widget_catalog_home_page.dart';
import 'package:project_clone/page_menu/flutter_learning_hub/basics/pages/flutter_basics_home_page.dart';
import 'package:project_clone/page_menu/flutter_learning_hub/fundamentals/pages/fundamentals_home_page.dart';
import 'package:project_clone/page_menu/device_diagnostics/device_diagnostics_page.dart';
import 'package:project_clone/page_menu/merchant_fuzzy_search/merchant_fuzzy_search_page.dart';
import 'package:project_clone/page_menu/queue_countdown_app/queue_countdown_page.dart';
import 'package:project_clone/page_menu/ai_cloud_dashboard/ai_cloud_dashboard_page.dart';
import 'package:project_clone/page_menu/smart_logistics_fleet/smart_logistics_fleet_page.dart';
import 'package:project_clone/page_menu/issue_tracker/issue_tracker_page.dart';
import 'package:project_clone/page_menu/the_travel_nest/the_travel_nest_page.dart';
import 'package:project_clone/page_menu/fresh_grocery_app/fresh_grocery_page.dart';
import 'package:project_clone/page_menu/taskly_app/taskly_page.dart';
import 'package:project_clone/page_menu/warga_kita/warga_kita_page.dart';
import 'package:project_clone/page_menu/botanica_beauty_app/botanica_beauty_page.dart';
import 'package:project_clone/page_menu/nusanvara_travel_app/nusanvara_travel_page.dart';
import 'package:project_clone/page_menu/velox_rental_app/velox_rental_page.dart';
import 'package:project_clone/page_menu/aura_habit_app/aura_habit_page.dart';
import 'package:project_clone/page_menu/flutter_sonner_showcase_page.dart';
import 'package:project_clone/page_menu/liquid_island_showcase_page.dart';

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
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
        padding: const EdgeInsets.all(16),
        children: [
          _menuCard(
            context,
            title: "AURA HABIT (Habit & Wellness Companion)",
            icon: Icons.bubble_chart_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const AuraHabitPage(),
          ),
          _menuCard(
            context,
            title: "🌊 LIQUID ISLAND (Fluid Dynamic Island)",
            icon: Icons.bubble_chart_rounded,
            iconColor: const Color(0xFF38BDF8),
            page: const LiquidIslandShowcasePage(),
          ),
          _menuCard(
            context,
            title: "🔥 FLUTTER SONNER (Plugin Showcase)",
            icon: Icons.layers_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const FlutterSonnerShowcasePage(),
          ),
          _menuCard(
            context,
            title: "VELOX Mobility & Car Rental (10 Screens)",
            icon: Icons.directions_car_filled_rounded,
            iconColor: const Color(0xFF1E40AF),
            page: const VeloxRentalPage(),
          ),
          _menuCard(
            context,
            title: "NUSANVARA Travel & Beyond",
            icon: Icons.explore_rounded,
            iconColor: const Color(0xFFE05338),
            page: const NusanvaraTravelPage(),
          ),
          _menuCard(
            context,
            title: "BOTANICA Beauty & Care",
            icon: Icons.spa_rounded,
            iconColor: const Color(0xFF0F3E33),
            page: const BotanicaBeautyPage(),
          ),
          _menuCard(
            context,
            title: "WargaKita Civic System (RT/RW)",
            icon: Icons.holiday_village_rounded,
            iconColor: const Color(0xFF005D42),
            page: const WargaKitaPage(),
          ),
          _menuCard(
            context,
            title: "Taskly Project & Task (10 Screens)",
            icon: Icons.checklist_rounded,
            iconColor: const Color(0xFF4F46E5),
            page: const TasklyPage(),
          ),
          _menuCard(
            context,
            title: "Fresh Food & Groceries (10 Screens)",
            icon: Icons.eco_rounded,
            iconColor: const Color(0xFF16A34A),
            page: const FreshGroceryPage(),
          ),
          _menuCard(
            context,
            title: "TheTravelNest (All 10 Screens)",
            icon: Icons.travel_explore_rounded,
            iconColor: const Color(0xFF1E5AFF),
            page: const TheTravelNestPage(),
          ),
          _menuCard(
            context,
            title: "QA Issue Tracker (SQLite DB)",
            icon: Icons.bug_report_rounded,
            iconColor: const Color(0xFFEF4444),
            page: const IssueTrackerPage(),
          ),
          _menuCard(
            context,
            title: "Fleet Command Center (Logistics)",
            icon: Icons.local_shipping_rounded,
            iconColor: const Color(0xFFF59E0B),
            page: const SmartLogisticsFleetPage(),
          ),
          _menuCard(
            context,
            title: "AI Cloud SaaS Dashboard (Web)",
            icon: Icons.cloud_done_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const AiCloudDashboardPage(),
          ),
          _menuCard(
            context,
            title: "Antrean Tiket (Countdown)",
            icon: Icons.train_rounded,
            iconColor: const Color(0xFF2563EB),
            page: const QueueCountdownPage(),
          ),
          _menuCard(
            context,
            title: "Fuzzy Search Merchant",
            icon: Icons.manage_search_rounded,
            iconColor: const Color(0xFF4F46E5),
            page: const MerchantFuzzySearchPage(),
          ),
          _menuCard(
            context,
            title: "Flutter Learning Hub (Master)",
            icon: Icons.school_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const FlutterLearningHubPage(),
          ),
          _menuCard(
            context,
            title: "Materi Dasar Flutter",
            icon: Icons.auto_stories_rounded,
            iconColor: const Color(0xFF4F46E5),
            page: const FundamentalsHomePage(),
          ),
          _menuCard(
            context,
            title: "Flutter Basic Widgets",
            icon: Icons.flutter_dash,
            iconColor: const Color(0xFF0284C7),
            page: const FlutterBasicsHomePage(),
          ),
          _menuCard(
            context,
            title: "Widget Catalog (Pro Lab)",
            icon: Icons.widgets_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const WidgetCatalogHomePage(),
          ),
          _menuCard(
            context,
            title: "Device Diagnostics & ID",
            icon: Icons.fingerprint_rounded,
            iconColor: const Color(0xFF0284C7),
            page: const DeviceDiagnosticsPage(),
          ),
          _menuCard(
            context,
            title: "Wanderlust (Travel & Booking)",
            icon: Icons.flight_takeoff_rounded,
            iconColor: const Color(0xFF0F4C81),
            page: const TravelBookingPage(),
          ),
          _menuCard(
            context,
            title: "Rumah Pintar & CCTV",
            icon: Icons.home_rounded,
            iconColor: const Color(0xFF0EA5E9),
            page: const SmartHomeMainWrapper(),
          ),
          _menuCard(
            context,
            title: "Netflix Clone (Animated UI)",
            icon: Icons.movie_filter_rounded,
            iconColor: const Color(0xFFE50914),
            page: const NetflixMainNavigationPage(),
          ),
          _menuCard(
            context,
            title: "Music Player App",
            icon: Icons.album_rounded,
            iconColor: const Color(0xFF15D2B8),
            page: const MusicPlayerApp(),
          ),
          _menuCard(
            context,
            title: "Meditation Sleep App",
            icon: Icons.spa_rounded,
            iconColor: const Color(0xFF77E4C8),
            page: const MeditationSleepApp(),
          ),
          _menuCard(
            context,
            title: "Mood Reaction App",
            icon: Icons.sentiment_satisfied_alt_rounded,
            iconColor: const Color(0xFFFF1D16),
            page: const MoodReactionApp(),
          ),
          _menuCard(
            context,
            title: "Fixly Service App",
            icon: Icons.home_repair_service_rounded,
            iconColor: const Color(0xFF2F6BFF),
            page: const FixlyServiceApp(),
          ),
          _menuCard(
            context,
            title: "iPhone Duo (Savings UI)",
            icon: Icons.devices_fold_rounded,
            iconColor: const Color(0xFF28A0F6),
            page: const IPhoneDuoHomePage(),
          ),
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
            title: "Interactive Food Ordering",
            icon: Icons.delivery_dining_rounded,
            iconColor: const Color(0xFFFF7A1A),
            page: const FoodDeliveryPromoPage(),
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
          _menuCard(
            context,
            title: "myABC Clone",
            icon: Icons.account_balance_wallet,
            iconColor: const Color(0xFF005AA9),
            page: const MAbcPageWrapper(),
          ),
          _menuCard(
            context,
            title: "Bank J-NAL",
            icon: Icons.account_balance,
            iconColor: const Color(0xFF0057FF),
            page: const BankJnalApp(),
          ),
          _menuCard(
            context,
            title: "Infinite Scroll Gallery (BLoC)",
            icon: Icons.all_inclusive_rounded,
            iconColor: const Color(0xFF6366F1),
            page: const InfiniteScrollImageApp(),
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
