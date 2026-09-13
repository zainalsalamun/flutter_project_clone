import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../core/utils/travel_page_routes.dart';
import '../../data/models/travel_item_model.dart';
import '../../data/repositories/travel_cart_manager.dart';
import '../widgets/animated_booking_button.dart';
import '../widgets/animated_price_text.dart';
import '../widgets/flying_plane_animator.dart';
import 'booking_flow_screen.dart';

class TravelDetailScreen extends StatefulWidget {
  final DestinationItem destination;
  final String? heroTag;

  const TravelDetailScreen({
    super.key,
    required this.destination,
    this.heroTag,
  });

  @override
  State<TravelDetailScreen> createState() => _TravelDetailScreenState();
}

class _TravelDetailScreenState extends State<TravelDetailScreen> {
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _btnKey = GlobalKey();
  int _selectedGalleryIndex = 0;
  bool _isFavorite = true;
  String _selectedRoomType = 'Deluxe Suite';
  bool _isBooking = false;

  final List<(String name, double priceMultiplier, String desc)> _roomOptions = [
    ('Deluxe Suite', 1.0, 'King Bed • Jungle View • 48 m²'),
    ('Panoramic Villa', 1.35, 'Private Plunge Pool • Valley View • 75 m²'),
    ('Royal Penthouse', 1.8, '2 King Beds • 360° View • Jacuzzi • 120 m²'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoom = _roomOptions.firstWhere((r) => r.$1 == _selectedRoomType);
    final calculatedPrice = widget.destination.pricePerNight * currentRoom.$2;
    final currentImage = widget.destination.galleryUrls.isNotEmpty &&
            _selectedGalleryIndex < widget.destination.galleryUrls.length
        ? widget.destination.galleryUrls[_selectedGalleryIndex]
        : widget.destination.imageUrl;

    final heroTag = widget.heroTag ?? widget.destination.heroTag;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Header Image & Gallery
                Stack(
                  children: [
                    // Main Hero Image
                    Hero(
                      tag: heroTag,
                      child: SizedBox(
                        key: _imageKey,
                        height: 380,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: currentImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: TravelTheme.border,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: TravelTheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top Gradient Shadow for App Bar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Top Action Bar
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: TravelTheme.dark,
                                  size: 22,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.share_rounded,
                                    color: TravelTheme.dark,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: _isFavorite ? TravelTheme.accent : TravelTheme.dark,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Gallery Thumbnails (Floating at bottom of header)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            widget.destination.galleryUrls.length,
                            (idx) => GestureDetector(
                              onTap: () => setState(() => _selectedGalleryIndex = idx),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedGalleryIndex == idx
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(widget.destination.galleryUrls[idx]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Main Info Container
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location & Category Tag
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: TravelTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.destination.tag,
                              style: const TextStyle(
                                color: TravelTheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: TravelTheme.accent,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.destination.location}, ${widget.destination.country}',
                                style: const TextStyle(
                                  color: TravelTheme.darkMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        widget.destination.title,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Rating & Reviews Stats Row
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: TravelTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TravelTheme.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: TravelTheme.accentGold, size: 22),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.destination.rating} / 5.0',
                                      style: const TextStyle(
                                        color: TravelTheme.dark,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '${widget.destination.reviewCount} Ulasan',
                                      style: const TextStyle(
                                        color: TravelTheme.muted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(width: 1, height: 30, color: TravelTheme.border),
                            const Row(
                              children: [
                                Icon(Icons.verified_user_rounded, color: TravelTheme.emerald, size: 20),
                                SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Terverifikasi',
                                      style: TextStyle(
                                        color: TravelTheme.dark,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Garansi Higienis',
                                      style: TextStyle(
                                        color: TravelTheme.muted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Tentang Akomodasi',
                        style: TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.destination.description,
                        style: const TextStyle(
                          color: TravelTheme.darkMuted,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Room Type Selector
                      const Text(
                        'Pilihan Tipe Kamar',
                        style: TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._roomOptions.map((room) {
                        final isSelected = _selectedRoomType == room.$1;
                        final price = widget.destination.pricePerNight * room.$2;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedRoomType = room.$1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TravelTheme.primary.withValues(alpha: 0.05)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? TravelTheme.primary : TravelTheme.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                  color: isSelected ? TravelTheme.primary : TravelTheme.muted,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room.$1,
                                        style: TextStyle(
                                          color: TravelTheme.dark,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        room.$3,
                                        style: const TextStyle(
                                          color: TravelTheme.muted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatTravelCurrency(price),
                                  style: TextStyle(
                                    color: isSelected ? TravelTheme.primary : TravelTheme.darkMuted,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      // Amenities List
                      const Text(
                        'Fasilitas Populer',
                        style: TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.destination.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: TravelTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: TravelTheme.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: TravelTheme.emerald, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  amenity,
                                  style: const TextStyle(
                                    color: TravelTheme.dark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: TravelTheme.dark.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AnimatedPriceText(
                        price: calculatedPrice,
                        style: const TextStyle(
                          color: TravelTheme.accent,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'Termasuk Pajak & Biaya',
                        style: TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Add to Cart Button
                  InkWell(
                    onTap: () {
                      TravelCartManager().addItem(
                        category: widget.destination.category,
                        destination: widget.destination,
                        selectedDetail: '$_selectedRoomType • 1 Malam',
                        basePrice: calculatedPrice,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.destination.title} dimasukkan ke Keranjang Tiket'),
                          backgroundColor: TravelTheme.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: TravelTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: TravelTheme.primary.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: TravelTheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      key: _btnKey,
                      child: AnimatedBookingButton(
                        text: 'Pesan',
                        icon: Icons.flash_on_rounded,
                        isLoading: _isBooking,
                        onPressed: () async {
                          if (_isBooking) return;
                          setState(() => _isBooking = true);

                          await FlyingPlaneAnimator.flyAirplane(
                            context: context,
                            sourceKey: _imageKey,
                            targetKey: _btnKey,
                            duration: const Duration(milliseconds: 650),
                          );

                          if (!mounted) return;
                          setState(() => _isBooking = false);

                          Navigator.push(
                            context,
                            TravelPageRoute(
                              page: BookingFlowScreen(
                                destination: widget.destination,
                                initialPrice: calculatedPrice,
                                selectedRoomType: _selectedRoomType,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
