import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../core/utils/travel_page_routes.dart';
import '../../data/models/travel_item_model.dart';
import '../../data/repositories/travel_cart_manager.dart';
import '../../data/repositories/travel_repository.dart';
import '../widgets/animated_experience_card.dart';
import '../widgets/animated_travel_card.dart';
import '../widgets/flying_plane_animator.dart';
import '../widgets/travel_bottom_nav.dart';
import '../widgets/travel_category_bar.dart';
import 'booking_flow_screen.dart';
import 'tabs/favorites_tab_view.dart';
import 'tabs/orders_tab_view.dart';
import 'tabs/profile_tab_view.dart';
import 'travel_detail_screen.dart';
import 'travel_search_results_screen.dart';

class TravelHomeScreen extends StatefulWidget {
  const TravelHomeScreen({super.key});

  @override
  State<TravelHomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<TravelHomeScreen>
    with SingleTickerProviderStateMixin {
  final TravelRepository _repository = TravelRepository();
  final TravelCartManager _cartManager = TravelCartManager();
  final ScrollController _scrollController = ScrollController();
  final Set<String> _favoriteIds = {'dest_1'};

  final GlobalKey _orderNavKey = GlobalKey();

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  TravelCategory _selectedCategory = TravelCategory.hotel;
  int _currentNavIndex = 0;
  double _scrollOffset = 0.0;
  bool _isFlying = false;

  // Train Search Filter State
  String _trainOrigin = 'Jakarta';
  String _trainDestination = 'Yogyakarta';
  DateTime _trainDate = DateTime.now().add(const Duration(days: 3));

  // Flight Search Filter State
  String _flightOrigin = 'Jakarta';
  String _flightDestination = 'Bali (Denpasar)';
  DateTime _flightDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_onCartUpdated);
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.45, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  void _onCartUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cartManager.removeListener(_onCartUpdated);
    _scrollController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  void _handleExperienceSelection(
    GlobalKey sourceKey,
    ExperienceItem experience,
  ) async {
    if (_isFlying) return;
    setState(() => _isFlying = true);

    await FlyingPlaneAnimator.flyExperience(
      context: context,
      sourceKey: sourceKey,
      targetKey: _orderNavKey,
      duration: const Duration(milliseconds: 750),
      onArrival: () {
        if (!mounted) return;
        _cartManager.addItem(
          category: TravelCategory.experience,
          experience: experience,
          selectedDetail: 'Sesi Pagi (08:30 WIB)',
          basePrice: experience.price,
        );
        _bounceController.forward(from: 0.0);
      },
    );

    if (!mounted) return;
    setState(() => _isFlying = false);

    Navigator.push(
      context,
      TravelPageRoute(page: BookingFlowScreen(experience: experience)),
    );
  }

  String get _sectionTitle {
    switch (_selectedCategory) {
      case TravelCategory.flight:
        return 'Tiket Penerbangan Populer ✈️';
      case TravelCategory.train:
        return 'Kereta Cepat & Scenic Train 🚅';
      case TravelCategory.experience:
        return 'Paket Wisata & Petualangan 🧭';
      case TravelCategory.hotel:
        return 'Destinasi & Hotel Favorit 🏨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _repository.getFeaturedDestinations();
    final flights = _repository.getFlightTickets();
    final trains = _repository.getTrainTickets();
    final experiences = _repository.getExperiences();

    return Scaffold(
      backgroundColor: TravelTheme.surface,
      body: Stack(
        children: [
          // IndexedStack for the 4 Bottom Nav Screens
          IndexedStack(
            index: _currentNavIndex,
            children: [
              // Tab 0: Eksplor (Explore Dashboard)
              _buildExploreTab(destinations, flights, trains, experiences),

              // Tab 1: Pesanan (Orders / Active Tickets)
              OrdersTabView(
                onExploreTapped: () => setState(() => _currentNavIndex = 0),
              ),

              // Tab 2: Favorit (Wishlist)
              FavoritesTabView(
                onExploreTapped: () => setState(() => _currentNavIndex = 0),
              ),

              // Tab 3: Akun (User Profile)
              const ProfileTabView(),
            ],
          ),

          // Floating Bottom Navigation (Always on top)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TravelBottomNav(
              currentIndex: _currentNavIndex,
              orderKey: _orderNavKey,
              orderCount: _cartManager.itemCount,
              bounceAnimation: _bounceAnimation,
              onIndexChanged: (index) {
                setState(() => _currentNavIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // TAB 0: Explore Content
  Widget _buildExploreTab(
    List<DestinationItem> destinations,
    List<FlightTicket> flights,
    List<TrainTicket> trains,
    List<ExperienceItem> experiences,
  ) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Top App Bar & Greeting
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap:
                                  () => setState(
                                    () => _currentNavIndex = 3,
                                  ), // Navigate to Akun
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: TravelTheme.primaryLight,
                                    width: 2,
                                  ),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, Traveler! ✈️',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: TravelTheme.muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Zainal Salamun',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: TravelTheme.dark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: TravelTheme.border),
                          boxShadow: [
                            BoxShadow(
                              color: TravelTheme.dark.withValues(alpha: 0.04),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              color: TravelTheme.dark,
                              size: 22,
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: TravelTheme.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title Headline
                  const Text(
                    'Jelajahi Dunia &\nTemukan Liburan Impian',
                    style: TextStyle(
                      color: TravelTheme.dark,
                      fontSize: 26,
                      height: 1.2,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search Bar Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: TravelTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: TravelTheme.dark.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: TravelTheme.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Cari hotel, pesawat, kereta, wisata...',
                            style: TextStyle(
                              color: TravelTheme.muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: TravelTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: TravelTheme.primary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Category Tabs (Hotel, Pesawat, Kereta, Wisata)
                  TravelCategoryBar(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) {
                      setState(() => _selectedCategory = cat);
                    },
                  ),

                  const SizedBox(height: 18),

                  // Interactive Route Search Filter for Trains
                  if (_selectedCategory == TravelCategory.train) ...[
                    _buildTrainRouteSearchBox(),
                    const SizedBox(height: 24),
                    _buildTrainHomeHighlights(),
                  ],

                  // Interactive Route Search Filter for Flights
                  if (_selectedCategory == TravelCategory.flight) ...[
                    _buildFlightRouteSearchBox(),
                    const SizedBox(height: 24),
                    _buildFlightHomeHighlights(),
                  ],

                  if (_selectedCategory == TravelCategory.hotel ||
                      _selectedCategory == TravelCategory.experience) ...[
                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _sectionTitle,
                          style: const TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: TravelTheme.primaryLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ),

          // 1. Experience / Tour Category List
          if (_selectedCategory == TravelCategory.experience)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final exp = experiences[index];
                  final itemOffset = index * 330.0;
                  final difference = _scrollOffset - itemOffset;
                  final parallax = (difference * 0.08).clamp(-30.0, 30.0);

                  return AnimatedExperienceCard(
                    experience: exp,
                    parallaxOffset: parallax,
                    onTapWithKey: (cardKey) {
                      _handleExperienceSelection(cardKey, exp);
                    },
                  );
                }, childCount: experiences.length),
              ),
            )
          // 2. Hotel & Destination Category List
          else if (_selectedCategory == TravelCategory.hotel)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final dest = destinations[index];
                  final itemOffset = index * 320.0;
                  final difference = _scrollOffset - itemOffset;
                  final parallax = (difference * 0.08).clamp(-30.0, 30.0);

                  return AnimatedTravelCard(
                    destination: dest,
                    parallaxOffset: parallax,
                    isFavorite: _favoriteIds.contains(dest.id),
                    onFavoriteToggle: () => _toggleFavorite(dest.id),
                    onTap: () {
                      Navigator.push(
                        context,
                        TravelPageRoute(
                          page: TravelDetailScreen(destination: dest),
                        ),
                      );
                    },
                  );
                }, childCount: destinations.length),
              ),
            ),

          // Bottom Spacing for Floating Nav
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // Interactive Train Route Search Box Card
  Widget _buildTrainRouteSearchBox() {
    final origins = [
      'Semua Asal',
      'Jakarta',
      'Bandung',
      'Surabaya',
      'Medan',
      'Palembang',
    ];
    final destinations = [
      'Semua Tujuan',
      'Yogyakarta',
      'Bandung',
      'Solo',
      'Surabaya',
      'Malang',
      'Banyuwangi',
      'Madiun',
      'Rantau Prapat',
      'Lubuklinggau',
    ];

    final quickRoutes = [
      ('Semua Rute', 'Semua Asal', 'Semua Tujuan'),
      ('Jakarta ➔ Yogyakarta', 'Jakarta', 'Yogyakarta'),
      ('Jakarta ➔ Bandung (Whoosh)', 'Jakarta', 'Bandung'),
      ('Jakarta ➔ Solo', 'Jakarta', 'Solo'),
      ('Jakarta ➔ Surabaya', 'Jakarta', 'Surabaya'),
      ('Bandung ➔ Yogyakarta', 'Bandung', 'Yogyakarta'),
      ('Jakarta ➔ Banyuwangi', 'Jakarta', 'Banyuwangi'),
      ('Medan ➔ Rantau Prapat', 'Medan', 'Rantau Prapat'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TravelTheme.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.train_rounded, color: TravelTheme.primary, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pencarian Tiket Kereta Api',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TravelTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PT KAI Official',
                  style: TextStyle(
                    color: TravelTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Origin and Destination Selectors with Swap Button
          Row(
            children: [
              Expanded(
                child: _buildRouteDropdownField(
                  label: 'STASIUN ASAL',
                  value: _trainOrigin,
                  items: origins,
                  icon: Icons.trip_origin_rounded,
                  onChanged: (val) {
                    if (val != null) setState(() => _trainOrigin = val);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      final temp = _trainOrigin;
                      _trainOrigin =
                          _trainDestination == 'Semua Tujuan'
                              ? 'Semua Asal'
                              : _trainDestination;
                      _trainDestination =
                          temp == 'Semua Asal' ? 'Semua Tujuan' : temp;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: TravelTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: TravelTheme.border),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: TravelTheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildRouteDropdownField(
                  label: 'STASIUN TUJUAN',
                  value: _trainDestination,
                  items: destinations,
                  icon: Icons.location_on_rounded,
                  onChanged: (val) {
                    if (val != null) setState(() => _trainDestination = val);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date and Passenger Info Row
          Row(
            children: [
              // Date Picker
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _trainDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 120)),
                    );
                    if (picked != null) setState(() => _trainDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: TravelTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: TravelTheme.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 16, color: TravelTheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TANGGAL PERJALANAN',
                                style: TextStyle(
                                  color: TravelTheme.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                formatTravelDate(_trainDate).split(', ')[1],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Passengers & Class
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: TravelTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: TravelTheme.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.person_rounded, size: 16, color: TravelTheme.primary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PENUMPANG & KELAS',
                              style: TextStyle(
                                color: TravelTheme.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '1 Dewasa • Semua Kelas',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: TravelTheme.dark,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Quick Route Filter Chips
          const Text(
            'Rute Populer KAI:',
            style: TextStyle(
              color: TravelTheme.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  quickRoutes.map((route) {
                    final isSelected =
                        _trainOrigin == route.$2 &&
                        _trainDestination == route.$3;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _trainOrigin = route.$2;
                            _trainDestination = route.$3;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? TravelTheme.primary
                                    : TravelTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? TravelTheme.primary
                                      : TravelTheme.border,
                            ),
                          ),
                          child: Text(
                            route.$1,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : TravelTheme.dark,
                              fontSize: 11,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Big Prominent "Cari Tiket Kereta Api" Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  TravelPageRoute(
                    page: TravelSearchResultsScreen(
                      category: TravelCategory.train,
                      origin: _trainOrigin,
                      destination: _trainDestination,
                      date: _trainDate,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search_rounded, size: 20),
              label: const Text(
                'Cari Tiket Kereta Api 🚅',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TravelTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Flight Route Search Box Card
  Widget _buildFlightRouteSearchBox() {
    final origins = [
      'Semua Asal',
      'Jakarta',
      'Bali (Denpasar)',
      'Surabaya',
      'Medan (Kualanamu)',
    ];
    final destinations = [
      'Semua Tujuan',
      'Bali (Denpasar)',
      'Yogyakarta',
      'Surabaya',
      'Medan (Kualanamu)',
      'Lombok (Praya)',
      'Labuan Bajo',
      'Tambolaka (Sumba)',
      'Pangkal Pinang',
    ];

    final quickRoutes = [
      ('Semua Rute', 'Semua Asal', 'Semua Tujuan'),
      ('Jakarta ➔ Bali', 'Jakarta', 'Bali (Denpasar)'),
      ('Jakarta ➔ Yogyakarta', 'Jakarta', 'Yogyakarta'),
      ('Jakarta ➔ Surabaya', 'Jakarta', 'Surabaya'),
      ('Jakarta ➔ Medan', 'Jakarta', 'Medan (Kualanamu)'),
      ('Bali ➔ Labuan Bajo', 'Bali (Denpasar)', 'Labuan Bajo'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TravelTheme.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.flight_takeoff_rounded,
                      color: TravelTheme.primary,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pencarian Tiket Penerbangan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TravelTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Best Flight Deals',
                  style: TextStyle(
                    color: TravelTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Origin and Destination Selectors with Swap Button
          Row(
            children: [
              Expanded(
                child: _buildRouteDropdownField(
                  label: 'DARI (BANDARA ASAL)',
                  value: _flightOrigin,
                  items: origins,
                  icon: Icons.flight_takeoff_rounded,
                  onChanged: (val) {
                    if (val != null) setState(() => _flightOrigin = val);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      final temp = _flightOrigin;
                      _flightOrigin =
                          _flightDestination == 'Semua Tujuan'
                              ? 'Semua Asal'
                              : _flightDestination;
                      _flightDestination =
                          temp == 'Semua Asal' ? 'Semua Tujuan' : temp;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: TravelTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: TravelTheme.border),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: TravelTheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildRouteDropdownField(
                  label: 'KE (BANDARA TUJUAN)',
                  value: _flightDestination,
                  items: destinations,
                  icon: Icons.flight_land_rounded,
                  onChanged: (val) {
                    if (val != null) setState(() => _flightDestination = val);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date and Passenger Info Row
          Row(
            children: [
              // Date Picker
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _flightDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _flightDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: TravelTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: TravelTheme.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 16, color: TravelTheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TANGGAL BERANGKAT',
                                style: TextStyle(
                                  color: TravelTheme.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                formatTravelDate(_flightDate).split(', ')[1],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Passengers & Class
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: TravelTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: TravelTheme.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.airline_seat_recline_normal_rounded, size: 16, color: TravelTheme.primary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PENUMPANG & KELAS',
                              style: TextStyle(
                                color: TravelTheme.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '1 Penumpang • Ekonomi',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: TravelTheme.dark,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Quick Route Filter Chips
          const Text(
            'Rute Populer Maskapai:',
            style: TextStyle(
              color: TravelTheme.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  quickRoutes.map((route) {
                    final isSelected =
                        _flightOrigin == route.$2 &&
                        _flightDestination == route.$3;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _flightOrigin = route.$2;
                            _flightDestination = route.$3;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? TravelTheme.primary
                                    : TravelTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? TravelTheme.primary
                                      : TravelTheme.border,
                            ),
                          ),
                          child: Text(
                            route.$1,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : TravelTheme.dark,
                              fontSize: 11,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Big Prominent "Cari Tiket Pesawat" Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  TravelPageRoute(
                    page: TravelSearchResultsScreen(
                      category: TravelCategory.flight,
                      origin: _flightOrigin,
                      destination: _flightDestination,
                      date: _flightDate,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search_rounded, size: 20),
              label: const Text(
                'Cari Tiket Pesawat ✈️',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TravelTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Highlights on Train Home Screen
  Widget _buildTrainHomeHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Info & Promo PT Kereta Api 🚆',
              style: TextStyle(
                color: TravelTheme.dark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Detail',
              style: TextStyle(
                color: TravelTheme.primaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [TravelTheme.primary, TravelTheme.primary.withValues(alpha: 0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: TravelTheme.primary.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KAI New Generation Telah Hadir!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Nikmati kenyamanan kursi Captain Seat (2-2), port USB type-C di setiap kursi, dan pintu geser otomatis.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Highlights on Flight Home Screen
  Widget _buildFlightHomeHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Promo Maskapai & Rute Wisata ✈️',
              style: TextStyle(
                color: TravelTheme.dark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Lihat Promo',
              style: TextStyle(
                color: TravelTheme.primaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flight_rounded, color: Colors.lightBlueAccent, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diskon Liburan Hingga Rp 100.000',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Gunakan voucher FLIGHT100 untuk penerbangan rute Bali, Labuan Bajo, Medan, dan Yogyakarta!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Reusable Route Dropdown Field
  Widget _buildRouteDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    final currentValue = items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: TravelTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TravelTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: TravelTheme.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TravelTheme.muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: TravelTheme.darkMuted,
                size: 18,
              ),
              style: const TextStyle(
                color: TravelTheme.dark,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              items:
                  items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
