import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/theme/glossy_theme.dart';
import '../../domain/entities/product_entity.dart';
import '../state/shop_notifier.dart';

class ProductDetailView extends StatefulWidget {
  final ProductEntity product;
  final ShopNotifier notifier;
  final VoidCallback onBack;

  const ProductDetailView({
    super.key,
    required this.product,
    required this.notifier,
    required this.onBack,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedSize = "";
  Color _selectedColor = Colors.transparent;
  
  // Animation for cart bottom sheet
  late AnimationController _cartSheetController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes[0];
    }
    
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors[0];
    }

    _cartSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _cartSheetController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _cartSheetController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _openCartSheet() {
    widget.notifier.addToCart(widget.product.id, _quantity);
    _cartSheetController.forward();
  }

  void _closeCartSheet() {
    _cartSheetController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.notifier.isDarkMode;
    final colors = widget.product.colors;
    final sizes = widget.product.sizes;
    final double basePrice = widget.product.price;
    final double totalPrice = basePrice * _quantity;

    return Stack(
      children: [
        // Main detail scroll view
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              
              // Top navigation header
              _buildTopNav(isDark),
              
              const SizedBox(height: 12),
              
              // Hero Product Image
              _buildProductHero(isDark),
              
              const SizedBox(height: 20),
              
              // Product details container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.category,
                          style: TextStyle(
                            color: GlossyTheme.getSubtextColor(isDark),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        
                        // Rating star indicator
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.product.rating}",
                              style: TextStyle(
                                color: GlossyTheme.getTextColor(isDark),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Product Title
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        color: GlossyTheme.getTextColor(isDark),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Price Row & Quantity Controller
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          GlossyTheme.formatRupiah(basePrice),
                          style: TextStyle(
                            color: GlossyTheme.getTextColor(isDark),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        
                        // Quantity Controller
                        _buildQuantityController(isDark),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Colors Selector
                    if (colors.isNotEmpty) ...[
                      Text(
                        "Pilih Warna",
                        style: TextStyle(
                          color: GlossyTheme.getTextColor(isDark).withOpacity(0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: colors.map((color) => _buildColorChip(color)).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Size Selector
                    if (sizes.isNotEmpty) ...[
                      Text(
                        "Pilih Ukuran",
                        style: TextStyle(
                          color: GlossyTheme.getTextColor(isDark).withOpacity(0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: sizes.map((size) => _buildSizeChip(size, isDark)).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Description text
                    Text(
                      "Deskripsi",
                      style: TextStyle(
                        color: GlossyTheme.getTextColor(isDark).withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        color: GlossyTheme.getSubtextColor(isDark).withOpacity(0.85),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Sticky Glassmorphic Bottom action panel
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildBottomActionBar(totalPrice, isDark),
        ),
        
        // Animated Sliding Cart bottom sheet
        AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            final screenHeight = MediaQuery.of(context).size.height;
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: screenHeight * 0.35 + (_slideAnimation.value * screenHeight * 0.65),
              child: child!,
            );
          },
          child: _buildCartSheet(basePrice, totalPrice, isDark),
        ),
      ],
    );
  }

  Widget _buildTopNav(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(isDark ? 0.06 : 0.4),
                border: Border.all(color: Colors.white.withOpacity(isDark ? 0.12 : 0.6), width: 1.2),
              ),
              child: Icon(Icons.arrow_back, color: GlossyTheme.getTextColor(isDark), size: 20),
            ),
          ),
          
          Text(
            "Detail Produk",
            style: TextStyle(
              color: GlossyTheme.getTextColor(isDark),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          
          // Favorite button
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(isDark ? 0.06 : 0.4),
              border: Border.all(color: Colors.white.withOpacity(isDark ? 0.12 : 0.6), width: 1.2),
            ),
            child: Icon(Icons.favorite_border, color: GlossyTheme.getTextColor(isDark), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHero(bool isDark) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 28,
        opacity: isDark ? 0.04 : 0.35,
        gradient: GlossyTheme.getCardGradient(isDark),
        border: GlossyTheme.getCardBorder(isDark),
        boxShadow: GlossyTheme.getCardShadow(isDark),
        child: Hero(
          tag: "product_hero_${widget.product.id}",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityController(bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: 24,
      opacity: isDark ? 0.08 : 0.45,
      gradient: GlossyTheme.getCardGradient(isDark),
      border: GlossyTheme.getCardBorder(isDark),
      boxShadow: GlossyTheme.getCardShadow(isDark),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus
          GestureDetector(
            onTap: _decrement,
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: Icon(Icons.remove, color: GlossyTheme.getTextColor(isDark), size: 16),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _quantity.toString().padLeft(2, '0'),
              style: TextStyle(
                color: GlossyTheme.getTextColor(isDark),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Plus
          GestureDetector(
            onTap: _increment,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: GlossyTheme.orangeRedGradient,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildSizeChip(String size, bool isDark) {
    final isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 44,
        height: 44,
        child: GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 12,
          opacity: isSelected ? (isDark ? 0.25 : 0.65) : (isDark ? 0.05 : 0.35),
          gradient: isSelected ? null : GlossyTheme.getCardGradient(isDark),
          color: isSelected ? GlossyTheme.accentPink.withOpacity(0.18) : null,
          border: Border.all(
            color: isSelected ? GlossyTheme.accentPink : (isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08)),
            width: 1.5,
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? GlossyTheme.accentPink : GlossyTheme.getTextColor(isDark),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(double totalPrice, bool isDark) {
    return Container(
      width: double.infinity,
      height: 95,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total display
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Harga",
                style: TextStyle(
                  color: GlossyTheme.getSubtextColor(isDark),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                GlossyTheme.formatRupiah(totalPrice),
                style: TextStyle(
                  color: GlossyTheme.getTextColor(isDark),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Glowing Add to Cart button
          GestureDetector(
            onTap: _openCartSheet,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: GlossyTheme.primaryAiGradient,
                boxShadow: GlossyTheme.premiumGlowShadow(GlossyTheme.neonMagenta, radius: 15),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Masukkan Keranjang",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSheet(double basePrice, double totalPrice, bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.78) : Colors.white.withOpacity(0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.white.withOpacity(0.18) : Colors.black.withOpacity(0.08),
                width: 1.5,
              ),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag bar indicator & close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Keranjang Belanja",
                    style: TextStyle(
                      color: GlossyTheme.getTextColor(isDark),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: _closeCartSheet,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      ),
                      child: Icon(Icons.close, color: GlossyTheme.getTextColor(isDark), size: 16),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Product item inside cart
              GlassCard(
                padding: const EdgeInsets.all(12),
                borderRadius: 20,
                opacity: isDark ? 0.06 : 0.45,
                gradient: GlossyTheme.getCardGradient(isDark),
                border: GlossyTheme.getCardBorder(isDark),
                boxShadow: GlossyTheme.getCardShadow(isDark),
                child: Row(
                  children: [
                    // Small Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageUrl,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle(
                              color: GlossyTheme.getTextColor(isDark),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ukuran: $_selectedSize  •  Jumlah: $_quantity",
                            style: TextStyle(
                              color: GlossyTheme.getSubtextColor(isDark),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${GlossyTheme.formatRupiah(basePrice)} per item",
                            style: TextStyle(
                              color: GlossyTheme.getTextColor(isDark).withOpacity(0.65),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Final price for this item
                    Text(
                      GlossyTheme.formatRupiah(totalPrice),
                      style: TextStyle(
                        color: GlossyTheme.getTextColor(isDark),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Pricing breakdown
              Column(
                children: [
                  _buildPriceBreakdownRow("Subtotal", GlossyTheme.formatRupiah(totalPrice), isDark),
                  const SizedBox(height: 10),
                  _buildPriceBreakdownRow("Ongkos Kirim", GlossyTheme.formatRupiah(20000.0), isDark),
                  const SizedBox(height: 12),
                  Divider(color: isDark ? Colors.white24 : Colors.black12, height: 1),
                  const SizedBox(height: 12),
                  _buildPriceBreakdownRow(
                    "Total Pembayaran",
                    GlossyTheme.formatRupiah(totalPrice + 20000.0),
                    isDark,
                    isBold: true,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Slide/Press to checkout button
              GestureDetector(
                onTap: () {
                  _closeCartSheet();
                  widget.notifier.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: GlassCard(
                        borderRadius: 16,
                        opacity: 0.25,
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                            SizedBox(width: 12),
                            Text(
                              "Pesanan berhasil dibuat!",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: GlossyTheme.checkoutGradient,
                    boxShadow: GlossyTheme.premiumGlowShadow(GlossyTheme.accentPink, radius: 15),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Geser untuk Checkout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? GlossyTheme.getTextColor(isDark) : GlossyTheme.getSubtextColor(isDark),
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: GlossyTheme.getTextColor(isDark),
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
