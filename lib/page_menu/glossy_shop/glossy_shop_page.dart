import 'dart:ui';
import 'package:flutter/material.dart';
import 'views/ai_dashboard_view.dart';
import 'views/ai_chat_view.dart';
import 'views/product_detail_view.dart';
import 'widgets/glass_card.dart';

class GlossyShopPage extends StatefulWidget {
  const GlossyShopPage({super.key});

  @override
  State<GlossyShopPage> createState() => _GlossyShopPageState();
}

class _GlossyShopPageState extends State<GlossyShopPage> with TickerProviderStateMixin {
  int _currentTab = 0; // 0: Dashboard, 1: AI Chat
  Map<String, dynamic>? _selectedProduct;
  
  // Animation controllers for the background glowing blobs
  late AnimationController _blob1Controller;
  late AnimationController _blob2Controller;
  late AnimationController _blob3Controller;
  
  late Animation<Offset> _blob1Animation;
  late Animation<Offset> _blob2Animation;
  late Animation<Offset> _blob3Animation;

  @override
  void initState() {
    super.initState();
    
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

    // Floating paths (using different curves for organic motion)
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0714), // Deep premium dark background
      body: Stack(
        children: [
          // 1. Floating Glow Blobs Background
          _buildBackgroundBlobs(),
          
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
              child: _buildActiveScreen(),
            ),
          ),
          
          // 4. Floating Premium Navigation Bar (only visible when not in details page)
          if (_selectedProduct == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildFloatingNavbar(),
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlobs() {
    final size = MediaQuery.of(context).size;
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
                  const Color(0xFFE040FB).withOpacity(0.55),
                  const Color(0xFFE040FB).withOpacity(0.0),
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
                  const Color(0xFF00E5FF).withOpacity(0.35),
                  const Color(0xFF00E5FF).withOpacity(0.0),
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
                  const Color(0xFFFF5252).withOpacity(0.28),
                  const Color(0xFFFF5252).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveScreen() {
    if (_selectedProduct != null) {
      return ProductDetailView(
        key: const ValueKey("details_screen"),
        product: _selectedProduct!,
        onBack: () => setState(() => _selectedProduct = null),
      );
    }
    
    if (_currentTab == 1) {
      return AiChatView(
        key: const ValueKey("ai_chat_screen"),
        onStopListening: () => setState(() => _currentTab = 0),
      );
    }
    
    return AiDashboardView(
      key: const ValueKey("dashboard_screen"),
      onProductSelected: (product) {
        setState(() => _selectedProduct = product);
      },
      onAskAiTap: () {
        setState(() => _currentTab = 1);
      },
    );
  }

  Widget _buildFloatingNavbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: GlassCard(
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        opacity: 0.12,
        border: Border.all(color: Colors.white.withOpacity(0.14), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dashboard Menu Tab
            _buildNavButton(
              index: 0,
              icon: Icons.dashboard_rounded,
              label: "Explore",
            ),
            
            // Center AI Spark Orb
            _buildCenterAiButton(),
            
            // Favorites tab or direct view detail mock
            _buildNavButton(
              index: 2,
              icon: Icons.shopping_bag_outlined,
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({required int index, required IconData icon, required String label}) {
    // Treat index 2 as setting a mock product directly for demo ease, or switching
    final isSelected = (index == 2 && _selectedProduct != null) || (index == _currentTab && _selectedProduct == null);
    
    return GestureDetector(
      onTap: () {
        if (index == 2) {
          // Open product details directly for classic edge hoodie to showcase the third view!
          setState(() {
            _selectedProduct = {
              "id": "1",
              "name": "Edge runner-Black",
              "category": "Premium Hoodie",
              "price": 23.65,
              "rating": 4.5,
              "image": "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500&auto=format&fit=crop&q=80",
              "isNew": true,
              "description": "Premium ultra-cotton heavyweight hoodie designed for modern street comfort. Features drop shoulder sleeves, high-density edge graphic embroidery, and double-lined cozy hood.",
              "colors": [Colors.black, Colors.deepPurple, Colors.indigo],
              "sizes": ["S", "M", "L", "XL"],
            };
          });
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
          color: isSelected ? Colors.white.withOpacity(0.08) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
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
          gradient: const LinearGradient(
            colors: [Color(0xFFE040FB), Color(0xFF651FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE040FB).withOpacity(isAiActive ? 0.5 : 0.2),
              blurRadius: isAiActive ? 14 : 8,
              spreadRadius: isAiActive ? 2 : 0,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.blur_on, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              isAiActive ? "AI Active" : "+ AI",
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
