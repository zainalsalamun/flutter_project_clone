import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/theme/glossy_theme.dart';
import '../../../shop/domain/entities/product_entity.dart';
import '../../../shop/domain/repositories/shop_repository.dart';
import '../../../shop/data/datasources/shop_mock_datasource.dart';
import '../../../shop/data/repositories/shop_repository_impl.dart';
import '../../../shop/presentation/state/shop_notifier.dart';
import '../../../shop/presentation/views/ai_dashboard_view.dart';
import '../../../shop/presentation/views/ai_chat_view.dart';
import '../../../shop/presentation/views/product_detail_view.dart';

class GlossyShopPage extends StatefulWidget {
  const GlossyShopPage({super.key});

  @override
  State<GlossyShopPage> createState() => _GlossyShopPageState();
}

class _GlossyShopPageState extends State<GlossyShopPage> with TickerProviderStateMixin {
  int _currentTab = 0; // 0: Dashboard, 1: AI Chat
  ProductEntity? _selectedProduct;

  // Clean dependency injection instances
  late final ShopMockDatasource _datasource;
  late final ShopRepository _repository;
  late final ShopNotifier _notifier;
  
  // Animation controllers for background glowing blobs
  late AnimationController _blob1Controller;
  late AnimationController _blob2Controller;
  late AnimationController _blob3Controller;
  
  late Animation<Offset> _blob1Animation;
  late Animation<Offset> _blob2Animation;
  late Animation<Offset> _blob3Animation;

  @override
  void initState() {
    super.initState();

    // Clean Architecture Injection
    _datasource = ShopMockDatasource();
    _repository = ShopRepositoryImpl(_datasource);
    _notifier = ShopNotifier(_repository);
    
    // SAFE Pre-load trigger: Fetch data asynchronously outside build execution loops!
    _notifier.loadShopData();
    
    // Setup background floating blobs animations
    _blob1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _blob2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _blob3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);

    // Floating paths
    _blob1Animation = Tween<Offset>(
      begin: const Offset(-0.3, -0.2),
      end: const Offset(0.4, 0.5),
    ).animate(CurvedAnimation(parent: _blob1Controller, curve: Curves.easeInOutSine));

    _blob2Animation = Tween<Offset>(
      begin: const Offset(0.5, 0.6),
      end: const Offset(-0.4, -0.3),
    ).animate(CurvedAnimation(parent: _blob2Controller, curve: Curves.easeInOutQuad));

    _blob3Animation = Tween<Offset>(
      begin: const Offset(-0.5, 0.4),
      end: const Offset(0.3, -0.5),
    ).animate(CurvedAnimation(parent: _blob3Controller, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _blob1Controller.dispose();
    _blob2Controller.dispose();
    _blob3Controller.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final isDark = _notifier.isDarkMode;
        return Scaffold(
          backgroundColor: GlossyTheme.getBackgroundColor(isDark),
          body: Stack(
            children: [
              // 1. Floating Glow Blobs Background (Adjusted intensity for light vs dark mode)
              _buildBackgroundBlobs(isDark),
              
              // 2. Heavy blur filter over blobs to turn them into glowing gas clouds
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 85.0, sigmaY: 85.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
              
              // 3. Screen Content
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildActiveScreen(isDark),
                ),
              ),
              
              // 4. Floating Premium Navigation Bar (only visible when not in details page)
              if (_selectedProduct == null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFloatingNavbar(isDark),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackgroundBlobs(bool isDark) {
    final size = MediaQuery.of(context).size;
    
    // Light mode features softer pastel halos; dark mode features vibrant neon glowing blobs
    final opacity1 = isDark ? 0.55 : 0.22;
    final opacity2 = isDark ? 0.35 : 0.25;
    final opacity3 = isDark ? 0.28 : 0.16;

    return Stack(
      children: [
        // Blob 1 - Purple/Pink
        AnimatedBuilder(
          animation: _blob1Animation,
          builder: (context, child) {
            return Positioned(
              left: (size.width / 2) + (_blob1Animation.value.dx * size.width) - 130,
              top: (size.height / 2) + (_blob1Animation.value.dy * size.height) - 130,
              child: child!,
            );
          },
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  GlossyTheme.neonMagenta.withOpacity(opacity1),
                  GlossyTheme.neonMagenta.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        
        // Blob 2 - Cyan/Blue
        AnimatedBuilder(
          animation: _blob2Animation,
          builder: (context, child) {
            return Positioned(
              left: (size.width / 2) + (_blob2Animation.value.dx * size.width) - 150,
              top: (size.height / 2) + (_blob2Animation.value.dy * size.height) - 150,
              child: child!,
            );
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  GlossyTheme.accentCyan.withOpacity(opacity2),
                  GlossyTheme.accentCyan.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        
        // Blob 3 - Red/Orange
        AnimatedBuilder(
          animation: _blob3Animation,
          builder: (context, child) {
            return Positioned(
              left: (size.width / 2) + (_blob3Animation.value.dx * size.width) - 120,
              top: (size.height / 2) + (_blob3Animation.value.dy * size.height) - 120,
              child: child!,
            );
          },
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  GlossyTheme.accentRed.withOpacity(opacity3),
                  GlossyTheme.accentRed.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveScreen(bool isDark) {
    if (_selectedProduct != null) {
      return ProductDetailView(
        key: const ValueKey("details_screen"),
        product: _selectedProduct!,
        notifier: _notifier,
        onBack: () => setState(() => _selectedProduct = null),
      );
    }
    
    if (_currentTab == 1) {
      return AiChatView(
        key: const ValueKey("ai_chat_screen"),
        isDarkMode: isDark,
        onStopListening: () => setState(() => _currentTab = 0),
      );
    }
    
    return AiDashboardView(
      key: const ValueKey("dashboard_screen"),
      notifier: _notifier,
      onProductSelected: (product) {
        setState(() => _selectedProduct = product);
      },
      onAskAiTap: () {
        setState(() => _currentTab = 1);
      },
    );
  }

  Widget _buildFloatingNavbar(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: GlassCard(
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        opacity: isDark ? 0.12 : 0.65,
        gradient: GlossyTheme.getCardGradient(isDark),
        border: GlossyTheme.getCardBorder(isDark),
        boxShadow: GlossyTheme.getCardShadow(isDark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dashboard Menu Tab
            _buildNavButton(
              index: 0,
              icon: Icons.dashboard_rounded,
              label: "Jelajahi",
              isDark: isDark,
            ),
            
            // Center AI Spark Orb
            _buildCenterAiButton(),
            
            // Cart shortcut tab
            _buildNavButton(
              index: 2,
              icon: Icons.shopping_bag_outlined,
              label: "Keranjang",
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({required int index, required IconData icon, required String label, required bool isDark}) {
    final isSelected = (index == 2 && _selectedProduct != null) || (index == _currentTab && _selectedProduct == null);
    
    return GestureDetector(
      onTap: () {
        if (index == 2) {
          // Open product details directly to showcase the third view!
          if (_notifier.products.isNotEmpty) {
            setState(() {
              _selectedProduct = _notifier.products[0];
            });
          }
        } else {
          setState(() {
            _selectedProduct = null;
            _currentTab = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? GlossyTheme.getTextColor(isDark) : GlossyTheme.getTextColor(isDark).withOpacity(0.4),
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: GlossyTheme.getTextColor(isDark),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAiButton() {
    final isAiActive = _currentTab == 1 && _selectedProduct == null;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProduct = null;
          _currentTab = 1;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: GlossyTheme.purpleBlueGradient,
          boxShadow: GlossyTheme.premiumGlowShadow(GlossyTheme.neonMagenta, radius: isAiActive ? 14 : 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.blur_on, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              isAiActive ? "AI Aktif" : "+ AI",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
