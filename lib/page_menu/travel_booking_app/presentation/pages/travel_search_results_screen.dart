import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../core/utils/travel_page_routes.dart';
import '../../data/models/travel_item_model.dart';
import '../../data/repositories/travel_cart_manager.dart';
import '../../data/repositories/travel_repository.dart';
import '../widgets/animated_flight_card.dart';
import '../widgets/animated_train_card.dart';
import '../widgets/flying_plane_animator.dart';
import 'booking_flow_screen.dart';
import 'tabs/orders_tab_view.dart';

class TravelSearchResultsScreen extends StatefulWidget {
  final TravelCategory category;
  final String origin;
  final String destination;
  final DateTime date;
  final int passengerCount;
  final String selectedClass;

  const TravelSearchResultsScreen({
    super.key,
    required this.category,
    required this.origin,
    required this.destination,
    required this.date,
    this.passengerCount = 1,
    this.selectedClass = 'Semua Kelas',
  });

  @override
  State<TravelSearchResultsScreen> createState() =>
      _TravelSearchResultsScreenState();
}

class _TravelSearchResultsScreenState extends State<TravelSearchResultsScreen>
    with SingleTickerProviderStateMixin {
  final TravelRepository _repository = TravelRepository();
  final TravelCartManager _cartManager = TravelCartManager();
  final GlobalKey _cartKey = GlobalKey();

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;
  bool _isFlying = false;

  late String _currentOrigin;
  late String _currentDestination;
  late DateTime _currentDate;
  String _selectedSort = 'Semua';

  @override
  void initState() {
    super.initState();
    _currentOrigin = widget.origin;
    _currentDestination = widget.destination;
    _currentDate = widget.date;

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.35).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.35, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleFlightSelection(GlobalKey sourceKey, FlightTicket flight) async {
    if (_isFlying) return;
    setState(() => _isFlying = true);

    await FlyingPlaneAnimator.flyAirplane(
      context: context,
      sourceKey: sourceKey,
      targetKey: _cartKey,
      duration: const Duration(milliseconds: 750),
      onArrival: () {
        if (!mounted) return;
        _cartManager.addItem(
          category: TravelCategory.flight,
          flight: flight,
          selectedDetail: 'Kursi 14A (${flight.cabinClass})',
          basePrice: flight.price,
        );
        _bounceController.forward(from: 0.0);
      },
    );

    if (!mounted) return;
    setState(() => _isFlying = false);

    Navigator.push(
      context,
      TravelPageRoute(page: BookingFlowScreen(flight: flight)),
    );
  }

  void _handleTrainSelection(GlobalKey sourceKey, TrainTicket train) async {
    if (_isFlying) return;
    setState(() => _isFlying = true);

    await FlyingPlaneAnimator.flyTrain(
      context: context,
      sourceKey: sourceKey,
      targetKey: _cartKey,
      duration: const Duration(milliseconds: 750),
      onArrival: () {
        if (!mounted) return;
        _cartManager.addItem(
          category: TravelCategory.train,
          train: train,
          selectedDetail: 'Gerbong 1 - 4A',
          basePrice: train.price,
        );
        _bounceController.forward(from: 0.0);
      },
    );

    if (!mounted) return;
    setState(() => _isFlying = false);

    Navigator.push(
      context,
      TravelPageRoute(page: BookingFlowScreen(train: train)),
    );
  }

  List<FlightTicket> get _filteredFlights {
    final all = _repository.getFlightTickets();
    var list = all.where((f) {
      final matchOrigin = _currentOrigin == 'Semua Asal' ||
          f.originCity.toLowerCase().contains(_currentOrigin.toLowerCase()) ||
          _currentOrigin.toLowerCase().contains(f.originCity.toLowerCase()) ||
          f.originCode.toLowerCase().contains(_currentOrigin.toLowerCase());
      final matchDest = _currentDestination == 'Semua Tujuan' ||
          f.destinationCity.toLowerCase().contains(_currentDestination.toLowerCase()) ||
          _currentDestination.toLowerCase().contains(f.destinationCity.toLowerCase()) ||
          f.destinationCode.toLowerCase().contains(_currentDestination.toLowerCase());
      return matchOrigin && matchDest;
    }).toList();

    if (_selectedSort == 'Harga Termurah') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Waktu Terpagi') {
      list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    } else if (_selectedSort == 'Waktu Termalam') {
      list.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    }
    return list;
  }

  List<TrainTicket> get _filteredTrains {
    final all = _repository.getTrainTickets();
    var list = all.where((t) {
      final originQ = _currentOrigin.toLowerCase();
      final matchOrigin = _currentOrigin == 'Semua Asal' ||
          t.originCity.toLowerCase().contains(originQ) ||
          originQ.contains(t.originCity.toLowerCase()) ||
          t.originCode.toLowerCase().contains(originQ) ||
          t.originStation.toLowerCase().contains(originQ) ||
          t.transitStops.any((s) => s.toLowerCase().contains(originQ));

      final destQ = _currentDestination.toLowerCase();
      final matchDest = _currentDestination == 'Semua Tujuan' ||
          t.destinationCity.toLowerCase().contains(destQ) ||
          destQ.contains(t.destinationCity.toLowerCase()) ||
          t.destinationCode.toLowerCase().contains(destQ) ||
          t.destinationStation.toLowerCase().contains(destQ) ||
          t.transitStops.any((s) => s.toLowerCase().contains(destQ));

      return matchOrigin && matchDest;
    }).toList();

    if (_selectedSort == 'Harga Termurah') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Waktu Terpagi') {
      list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    } else if (_selectedSort == 'Waktu Termalam') {
      list.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    }
    return list;
  }

  void _showChangeRouteBottomSheet() {
    final isFlight = widget.category == TravelCategory.flight;
    final origins = isFlight
        ? ['Semua Asal', 'Jakarta', 'Bali (Denpasar)', 'Surabaya', 'Medan (Kualanamu)']
        : ['Semua Asal', 'Jakarta', 'Bandung', 'Surabaya', 'Medan', 'Palembang'];
    final destinations = isFlight
        ? [
            'Semua Tujuan',
            'Bali (Denpasar)',
            'Yogyakarta',
            'Surabaya',
            'Medan (Kualanamu)',
            'Lombok (Praya)',
            'Labuan Bajo',
            'Tambolaka (Sumba)',
            'Pangkal Pinang',
          ]
        : [
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String tempOrigin = _currentOrigin;
        String tempDest = _currentDestination;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: TravelTheme.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isFlight ? 'Ubah Rute Penerbangan' : 'Ubah Rute Kereta Api',
                    style: const TextStyle(
                      color: TravelTheme.dark,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Origin
                  _buildBottomSheetDropdown(
                    label: isFlight ? 'DARI (BANDARA ASAL)' : 'STASIUN ASAL',
                    value: tempOrigin,
                    items: origins,
                    icon: isFlight ? Icons.flight_takeoff_rounded : Icons.trip_origin_rounded,
                    onChanged: (v) {
                      if (v != null) setModalState(() => tempOrigin = v);
                    },
                  ),
                  const SizedBox(height: 10),
                  // Swap Row
                  Center(
                    child: IconButton(
                      onPressed: () {
                        setModalState(() {
                          final t = tempOrigin;
                          tempOrigin = tempDest == 'Semua Tujuan' ? 'Semua Asal' : tempDest;
                          tempDest = t == 'Semua Asal' ? 'Semua Tujuan' : t;
                        });
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: TravelTheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: TravelTheme.border),
                        ),
                        child: const Icon(Icons.swap_vert_rounded, color: TravelTheme.primary, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Destination
                  _buildBottomSheetDropdown(
                    label: isFlight ? 'KE (BANDARA TUJUAN)' : 'STASIUN TUJUAN',
                    value: tempDest,
                    items: destinations,
                    icon: isFlight ? Icons.flight_land_rounded : Icons.location_on_rounded,
                    onChanged: (v) {
                      if (v != null) setModalState(() => tempDest = v);
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentOrigin = tempOrigin;
                          _currentDestination = tempDest;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TravelTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Terapkan Perubahan', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSheetDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    final validVal = items.contains(value) ? value : items.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              Icon(icon, size: 14, color: TravelTheme.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: TravelTheme.muted, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: validVal,
              isExpanded: true,
              style: const TextStyle(color: TravelTheme.dark, fontSize: 14, fontWeight: FontWeight.w800),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFlight = widget.category == TravelCategory.flight;
    final int resultCount = isFlight ? _filteredFlights.length : _filteredTrains.length;

    return Scaffold(
      backgroundColor: TravelTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: TravelTheme.dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    '$_currentOrigin ➔ $_currentDestination',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: TravelTheme.dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isFlight ? Icons.flight_rounded : Icons.train_rounded,
                  color: TravelTheme.primary,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${formatTravelDate(_currentDate)} • ${widget.passengerCount} Penumpang',
              style: const TextStyle(
                color: TravelTheme.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Ubah Rute',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: TravelTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune_rounded, color: TravelTheme.primary, size: 18),
            ),
            onPressed: _showChangeRouteBottomSheet,
          ),
          // Animated Cart / Order Icon
          ListenableBuilder(
            listenable: _cartManager,
            builder: (context, _) {
              final count = _cartManager.items.length;
              return ScaleTransition(
                scale: _bounceAnim,
                child: IconButton(
                  key: _cartKey,
                  tooltip: 'Pesanan Saya ($count)',
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: count > 0 ? TravelTheme.accent.withValues(alpha: 0.15) : TravelTheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: count > 0 ? TravelTheme.accent : TravelTheme.border,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: count > 0 ? TravelTheme.accent : TravelTheme.dark,
                          size: 18,
                        ),
                      ),
                      if (count > 0)
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: TravelTheme.accent,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$count',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: const BoxDecoration(
                          color: TravelTheme.surface,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: OrdersTabView(
                          onExploreTapped: () => Navigator.pop(ctx),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Date Strip / Quick Date Slider (Traveloka style)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    final d = DateTime.now().add(Duration(days: index + 1));
                    final isSelected = d.day == _currentDate.day &&
                        d.month == _currentDate.month &&
                        d.year == _currentDate.year;

                    return GestureDetector(
                      onTap: () => setState(() => _currentDate = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? TravelTheme.primary : TravelTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? TravelTheme.primary : TravelTheme.border,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getDayName(d.weekday),
                              style: TextStyle(
                                color: isSelected ? Colors.white70 : TravelTheme.muted,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${d.day} ${_getMonthName(d.month)}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : TravelTheme.dark,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // 2. Filter & Sort Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Semua',
                          'Harga Termurah',
                          'Waktu Terpagi',
                          'Waktu Termalam',
                        ].map((sort) {
                          final isSelected = _selectedSort == sort;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(sort),
                              selected: isSelected,
                              selectedColor: TravelTheme.primary.withValues(alpha: 0.12),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? TravelTheme.primary : TravelTheme.darkMuted,
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: isSelected ? TravelTheme.primary : TravelTheme.border,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (_) => setState(() => _selectedSort = sort),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Result Banner Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Menampilkan $resultCount jadwal ${isFlight ? "penerbangan" : "kereta api"}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showChangeRouteBottomSheet,
                    child: const Text(
                      'Ganti Rute',
                      style: TextStyle(
                        color: TravelTheme.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Ticket List
          if (isFlight) ...[
            if (_filteredFlights.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyResult(
                  isFlight: true,
                  onReset: () => setState(() {
                    _currentOrigin = 'Semua Asal';
                    _currentDestination = 'Semua Tujuan';
                  }),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final flight = _filteredFlights[index];
                      return AnimatedFlightCard(
                        flight: flight,
                        onTapWithKey: (cardKey) {
                          _handleFlightSelection(cardKey, flight);
                        },
                      );
                    },
                    childCount: _filteredFlights.length,
                  ),
                ),
              ),
          ] else ...[
            if (_filteredTrains.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyResult(
                  isFlight: false,
                  onReset: () => setState(() {
                    _currentOrigin = 'Semua Asal';
                    _currentDestination = 'Semua Tujuan';
                  }),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final train = _filteredTrains[index];
                      return AnimatedTrainCard(
                        train: train,
                        onTapWithKey: (cardKey) {
                          _handleTrainSelection(cardKey, train);
                        },
                      );
                    },
                    childCount: _filteredTrains.length,
                  ),
                ),
              ),
          ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResult({required bool isFlight, required VoidCallback onReset}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TravelTheme.border),
      ),
      child: Column(
        children: [
          Icon(
            isFlight ? Icons.flight_takeoff_rounded : Icons.train_rounded,
            size: 56,
            color: TravelTheme.muted,
          ),
          const SizedBox(height: 14),
          Text(
            'Tidak ada jadwal ${isFlight ? "penerbangan" : "kereta api"}',
            style: const TextStyle(
              color: TravelTheme.dark,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tidak ditemukan jadwal untuk rute $_currentOrigin ➔ $_currentDestination pada tanggal ${formatTravelDate(_currentDate)}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TravelTheme.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Tampilkan Semua Rute', style: TextStyle(fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(
              backgroundColor: TravelTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}
