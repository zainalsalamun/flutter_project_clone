import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_clone/page_menu/glossy_shop/features/shop/domain/entities/product_entity.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/theme/glossy_theme.dart';
import '../state/shop_notifier.dart';
import '../widgets/brand_card.dart';
import '../widgets/product_card.dart';

class AiDashboardView extends StatefulWidget {
  final ShopNotifier notifier;
  final Function(ProductEntity) onProductSelected;
  final VoidCallback onAskAiTap;

  const AiDashboardView({
    super.key,
    required this.notifier,
    required this.onProductSelected,
    required this.onAskAiTap,
  });

  @override
  State<AiDashboardView> createState() => _AiDashboardViewState();
}

class _AiDashboardViewState extends State<AiDashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _searchPulseController;

  @override
  void initState() {
    super.initState();
    _searchPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // SAFE pre-load trigger in post-frame callback to prevent setState during build phase assertion!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.notifier.products.isEmpty) {
        widget.notifier.loadShopData();
      }
    });
  }

  @override
  void dispose() {
    _searchPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.notifier.isDarkMode;
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, _) {
        if (widget.notifier.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(GlossyTheme.neonMagenta),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Header / Greeting Section with Sun/Moon theme toggler
              _buildHeader(isDark),

              const SizedBox(height: 24),

              // AI explore banner
              _buildExploreBanner(isDark),

              const SizedBox(height: 18),

              // Search box
              _buildSearchBox(isDark),

              const SizedBox(height: 24),

              // Brand Grid Categories
              _buildCategories(),

              const SizedBox(height: 28),

              // Recommended Section
              _buildRecommendedSection(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hi, Olivia",
                    style: TextStyle(
                      color: GlossyTheme.getTextColor(isDark),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "👋",
                    style: TextStyle(
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.amber.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome back",
                style: TextStyle(
                  color: GlossyTheme.getSubtextColor(isDark),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Top Buttons (Theme Toggler + Bag + Profile)
          Row(
            children: [
              // SUN / MOON Theme Toggle Button
              GestureDetector(
                onTap: () => widget.notifier.toggleTheme(),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(isDark ? 0.06 : 0.4),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.12 : 0.6),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: GlossyTheme.getTextColor(isDark),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Bag Button
              _buildTopIconButton(
                icon: Icons.local_mall_outlined,
                badgeCount: widget.notifier.cartCount,
                isDark: isDark,
              ),
              const SizedBox(width: 12),

              // Profile
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(isDark ? 0.2 : 0.6),
                    width: 1.5,
                  ),
                  image: const DecorationImage(
                    image: CachedNetworkImageProvider(
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopIconButton({
    required IconData icon,
    int badgeCount = 0,
    required bool isDark,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(isDark ? 0.06 : 0.4),
        border: Border.all(
          color: Colors.white.withOpacity(isDark ? 0.12 : 0.6),
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: GlossyTheme.getTextColor(isDark), size: 20),
          if (badgeCount > 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrangeAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange,
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExploreBanner(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback:
                (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFFF9E80),
                    GlossyTheme.accentPink,
                    GlossyTheme.neonMagenta,
                  ],
                ).createShader(bounds),
            child: Text(
              "A new way of Shopping is here",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Explore with Ai",
            style: TextStyle(
              color: GlossyTheme.getTextColor(isDark),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              shadows:
                  isDark
                      ? [
                        const Shadow(
                          color: Colors.purpleAccent,
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: widget.onAskAiTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedBuilder(
          animation: _searchPulseController,
          builder: (context, child) {
            return GlassCard(
              borderRadius: 28,
              opacity: isDark ? 0.08 : 0.45,
              gradient: GlossyTheme.getCardGradient(isDark),
              border: GlossyTheme.getCardBorder(isDark),
              boxShadow: GlossyTheme.getCardShadow(isDark),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: GlossyTheme.getSubtextColor(isDark).withOpacity(0.6),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Search or ask AI...",
                      style: TextStyle(
                        color: GlossyTheme.getSubtextColor(
                          isDark,
                        ).withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // AI Orb/Microphone Trigger
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: GlossyTheme.purpleBlueGradient,
                      boxShadow: GlossyTheme.premiumGlowShadow(
                        GlossyTheme.neonMagenta,
                        radius: 8,
                      ),
                    ),
                    child: const Icon(
                      Icons.blur_on,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = widget.notifier.categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 105,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return BrandCard(category: categories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection(bool isDark) {
    final products = widget.notifier.products;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "✨",
                    style: TextStyle(
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.orangeAccent.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Recommended for you",
                    style: TextStyle(
                      color: GlossyTheme.getTextColor(isDark),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "See all",
                  style: TextStyle(
                    color: GlossyTheme.getSubtextColor(isDark),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Product Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                isDarkMode: isDark,
                onTap: () => widget.onProductSelected(product),
              );
            },
          ),
        ],
      ),
    );
  }
}
