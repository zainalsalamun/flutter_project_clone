import 'package:flutter/material.dart';
import '../../../core/theme/travel_theme.dart';
import '../../../core/utils/travel_currency.dart';
import '../../../core/utils/travel_page_routes.dart';
import '../../../data/models/travel_item_model.dart';
import '../../../data/repositories/travel_cart_manager.dart';
import '../../../data/repositories/travel_repository.dart';
import '../booking_flow_screen.dart';
import '../../widgets/ticket_pass_painter.dart';
import '../e_ticket_success_screen.dart';

class OrdersTabView extends StatefulWidget {
  final VoidCallback onExploreTapped;
  final ValueChanged<TravelCategory>? onCategoryExploreTapped;

  const OrdersTabView({
    super.key,
    required this.onExploreTapped,
    this.onCategoryExploreTapped,
  });

  @override
  State<OrdersTabView> createState() => _OrdersTabViewState();
}

class _OrdersTabViewState extends State<OrdersTabView> {
  // Main sub-tabs: 0 = Keranjang (Cart), 1 = Tiket Aktif, 2 = Riwayat Selesai
  int _selectedMainTab = 0;

  // Category filter: null = Semua, or specific TravelCategory
  TravelCategory? _selectedCategory;

  final TravelCartManager _cartManager = TravelCartManager();

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartManager.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  List<BookingOrder> _getActiveOrders() {
    final repo = TravelRepository();
    final flights = repo.getFlightTickets();
    final trains = repo.getTrainTickets();
    final destinations = repo.getFeaturedDestinations();
    final experiences = repo.getExperiences();

    final allOrders = [
      BookingOrder(
        orderId: 'ORD-98231',
        bookingCode: 'WND-7482',
        flight: flights[0], // Garuda
        category: TravelCategory.flight,
        travelDate: DateTime.now().add(const Duration(days: 3)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: '14A (Jendela)',
        ),
        basePrice: flights[0].price,
        taxAndService: flights[0].price * 0.1,
        status: 'Confirmed / Siap Boarding',
      ),
      BookingOrder(
        orderId: 'ORD-65412',
        bookingCode: 'WND-9912',
        train: trains[0], // Whoosh
        category: TravelCategory.train,
        travelDate: DateTime.now().add(const Duration(days: 8)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: 'Gerbong VIP 1 - 8A',
        ),
        basePrice: trains[0].price,
        taxAndService: trains[0].price * 0.1,
        status: 'Issued / Terbit',
      ),
      BookingOrder(
        orderId: 'ORD-32145',
        bookingCode: 'WND-3341',
        destination: destinations[0], // The Kayon Jungle
        category: TravelCategory.hotel,
        travelDate: DateTime.now().add(const Duration(days: 14)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: 'Deluxe Jungle Villa',
        ),
        basePrice: destinations[0].pricePerNight,
        taxAndService: destinations[0].pricePerNight * 0.1,
        status: 'Confirmed / Siap Check-In',
      ),
      BookingOrder(
        orderId: 'ORD-77123',
        bookingCode: 'WND-5519',
        experience: experiences[0], // Ubud ATV
        category: TravelCategory.experience,
        travelDate: DateTime.now().add(const Duration(days: 18)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: 'Sesi Pagi (08:30 WIB)',
        ),
        basePrice: experiences[0].price,
        taxAndService: experiences[0].price * 0.1,
        status: 'Confirmed / Voucher Aktif',
      ),
    ];

    if (_selectedCategory == null) return allOrders;
    return allOrders.where((order) => order.category == _selectedCategory).toList();
  }

  List<BookingOrder> _getHistoryOrders() {
    final repo = TravelRepository();
    final flights = repo.getFlightTickets();
    final trains = repo.getTrainTickets();
    final destinations = repo.getFeaturedDestinations();
    final experiences = repo.getExperiences();

    final history = [
      BookingOrder(
        orderId: 'ORD-HIST-01',
        bookingCode: 'WND-1049',
        flight: flights[1], // Pelita Air
        category: TravelCategory.flight,
        travelDate: DateTime.now().subtract(const Duration(days: 30)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: '12F (Jendela)',
        ),
        basePrice: flights[1].price,
        taxAndService: flights[1].price * 0.1,
        status: 'Selesai / Perjalanan Usai',
      ),
      BookingOrder(
        orderId: 'ORD-HIST-02',
        bookingCode: 'WND-8842',
        train: trains[1], // KA Argo Dwipangga Luxury
        category: TravelCategory.train,
        travelDate: DateTime.now().subtract(const Duration(days: 52)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: 'Sleeper 1 - 2A',
        ),
        basePrice: trains[1].price,
        taxAndService: trains[1].price * 0.1,
        status: 'Selesai / Perjalanan Usai',
      ),
      BookingOrder(
        orderId: 'ORD-HIST-03',
        bookingCode: 'WND-4412',
        destination: destinations[1], // Plataran Bromo
        category: TravelCategory.hotel,
        travelDate: DateTime.now().subtract(const Duration(days: 85)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: 'Premier Mountain Room (2 Malam)',
        ),
        basePrice: destinations[1].pricePerNight * 2,
        taxAndService: destinations[1].pricePerNight * 0.2,
        status: 'Selesai / Check-Out',
      ),
      BookingOrder(
        orderId: 'ORD-HIST-04',
        bookingCode: 'WND-2299',
        experience: experiences[1], // Bromo Sunrise Jeep
        category: TravelCategory.experience,
        travelDate: DateTime.now().subtract(const Duration(days: 120)),
        passenger: const PassengerInfo(
          fullName: 'Zainal Salamun',
          selectedSeat: 'Private Jeep 4x4',
        ),
        basePrice: experiences[1].price,
        taxAndService: experiences[1].price * 0.1,
        status: 'Selesai / Tur Selesai',
      ),
    ];

    if (_selectedCategory == null) return history;
    return history.where((order) => order.category == _selectedCategory).toList();
  }

  List<TravelCartItem> _getFilteredCartItems() {
    final all = _cartManager.items;
    if (_selectedCategory == null) return all;
    return all.where((item) => item.category == _selectedCategory).toList();
  }

  void _handleCheckout() {
    final selected = _cartManager.getSelectedItems();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan pilih setidaknya 1 tiket untuk checkout'),
          backgroundColor: TravelTheme.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final firstItem = selected.first;
    Navigator.push(
      context,
      TravelPageRoute(
        page: BookingFlowScreen(
          flight: firstItem.flight,
          train: firstItem.train,
          destination: firstItem.destination,
          experience: firstItem.experience,
          initialPrice: firstItem.basePrice * firstItem.quantity,
          selectedRoomType: firstItem.selectedDetail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pesanan & Tiket Saya',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (_selectedMainTab == 0 && _cartManager.itemCount > 0)
            TextButton.icon(
              onPressed: () => _cartManager.selectAll(!_cartManager.isAllSelected),
              icon: Icon(
                _cartManager.isAllSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                size: 18,
                color: TravelTheme.primary,
              ),
              label: Text(
                _cartManager.isAllSelected ? 'Batal Semua' : 'Pilih Semua',
                style: const TextStyle(color: TravelTheme.primary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. Sub-Tabs (Keranjang, Tiket Aktif, Riwayat)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                _buildMainTabPill(
                  title: 'Keranjang',
                  badgeCount: _cartManager.itemCount,
                  tabIndex: 0,
                  icon: Icons.shopping_cart_outlined,
                ),
                const SizedBox(width: 8),
                _buildMainTabPill(
                  title: 'Tiket Aktif',
                  badgeCount: 4,
                  tabIndex: 1,
                  icon: Icons.airplane_ticket_outlined,
                ),
                const SizedBox(width: 8),
                _buildMainTabPill(
                  title: 'Riwayat',
                  badgeCount: 4,
                  tabIndex: 2,
                  icon: Icons.history_rounded,
                ),
              ],
            ),
          ),

          // 2. Category Filter Chips (Pesawat, Kereta, Hotel, Wisata, Semua)
          _buildCategoryFilterRow(),

          // 3. Body View based on _selectedMainTab
          Expanded(
            child: _selectedMainTab == 0
                ? _buildCartSection()
                : _selectedMainTab == 1
                    ? _buildActiveTicketsSection()
                    : _buildHistorySection(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTabPill({
    required String title,
    required int badgeCount,
    required int tabIndex,
    required IconData icon,
  }) {
    final isSelected = _selectedMainTab == tabIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMainTab = tabIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? TravelTheme.primary : TravelTheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: TravelTheme.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : TravelTheme.darkMuted,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white : TravelTheme.darkMuted,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected ? TravelTheme.accent : TravelTheme.muted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: isSelected ? Colors.white : TravelTheme.dark,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterRow() {
    final categories = [
      (label: 'Semua Tiket', category: null, icon: Icons.apps_rounded),
      (label: 'Pesawat', category: TravelCategory.flight, icon: Icons.flight_takeoff_rounded),
      (label: 'Kereta', category: TravelCategory.train, icon: Icons.directions_railway_rounded),
      (label: 'Hotel', category: TravelCategory.hotel, icon: Icons.hotel_rounded),
      (label: 'Wisata', category: TravelCategory.experience, icon: Icons.explore_rounded),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((item) {
            final isSelected = _selectedCategory == item.category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = item.category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? TravelTheme.dark : TravelTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? TravelTheme.dark : TravelTheme.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 14,
                        color: isSelected ? TravelTheme.primaryLight : TravelTheme.muted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : TravelTheme.darkMuted,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: KERANJANG TIKET (CART)
  // ==========================================
  Widget _buildCartSection() {
    final cartItems = _getFilteredCartItems();

    if (cartItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.remove_shopping_cart_rounded,
        title: _selectedCategory == null
            ? 'Keranjang Tiket Masih Kosong'
            : 'Tidak ada tiket ${_getCategoryName(_selectedCategory!)} di keranjang',
        subtitle: 'Pilih tiket penerbangan, kereta, hotel, atau tur wisata favorit Anda di menu Eksplor.',
        actionLabel: 'Cari & Tambah Tiket',
        onAction: widget.onExploreTapped,
      );
    }

    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartItemCard(item);
            },
          ),
        ),

        // Bottom Sticky Checkout Bar
        _buildCartBottomBar(),
      ],
    );
  }

  Widget _buildCartItemCard(TravelCartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected ? item.categoryColor.withValues(alpha: 0.5) : TravelTheme.border,
          width: item.isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Top Item Row (Checkbox, Badge, Category, Delete)
            Row(
              children: [
                // Selection Checkbox
                GestureDetector(
                  onTap: () => _cartManager.toggleItemSelection(item.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: item.isSelected ? item.categoryColor : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: item.isSelected ? item.categoryColor : TravelTheme.muted.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: item.isSelected
                        ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),

                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, size: 12, color: item.categoryColor),
                      const SizedBox(width: 4),
                      Text(
                        item.categoryName,
                        style: TextStyle(
                          color: item.categoryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Delete Item
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: TravelTheme.muted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _cartManager.removeItem(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.title} dihapus dari keranjang'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Item Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: TravelTheme.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.event_seat_rounded, size: 12, color: TravelTheme.darkMuted),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.selectedDetail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: TravelTheme.darkMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: TravelTheme.surface, height: 1),
            const SizedBox(height: 10),

            // Price & Quantity Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Harga', style: TextStyle(color: TravelTheme.muted, fontSize: 10)),
                    Text(
                      formatTravelCurrency(item.totalPrice),
                      style: TextStyle(
                        color: item.categoryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                // Qty Stepper
                Container(
                  decoration: BoxDecoration(
                    color: TravelTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TravelTheme.border),
                  ),
                  child: Row(
                    children: [
                      _buildStepperBtn(
                        icon: Icons.remove,
                        onTap: () => _cartManager.updateQuantity(item.id, item.quantity - 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _buildStepperBtn(
                        icon: Icons.add,
                        onTap: () => _cartManager.updateQuantity(item.id, item.quantity + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 14, color: TravelTheme.dark),
      ),
    );
  }

  Widget _buildCartBottomBar() {
    final selectedTotal = _cartManager.selectedTotalPrice;
    final selectedCount = _cartManager.selectedCount;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total ($selectedCount item)',
                style: const TextStyle(color: TravelTheme.muted, fontSize: 11, fontWeight: FontWeight.w600),
              ),
              Text(
                formatTravelCurrency(selectedTotal),
                style: const TextStyle(
                  color: TravelTheme.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: selectedCount > 0 ? _handleCheckout : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: TravelTheme.primary,
              disabledBackgroundColor: TravelTheme.muted.withValues(alpha: 0.3),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Checkout ($selectedCount)',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: TIKET AKTIF (ACTIVE ORDERS)
  // ==========================================
  Widget _buildActiveTicketsSection() {
    final orders = _getActiveOrders();

    if (orders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.airplane_ticket_outlined,
        title: 'Tidak ada tiket aktif ${_getCategoryName(_selectedCategory)}',
        subtitle: 'Tiket penerbangan atau voucher perjalanan yang baru saja dibeli akan muncul di sini.',
        actionLabel: 'Pesan Tiket Sekarang',
        onAction: widget.onExploreTapped,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildActiveTicketCard(order);
      },
    );
  }

  Widget _buildActiveTicketCard(BookingOrder order) {
    final flight = order.flight;
    final train = order.train;
    final dest = order.destination;
    final exp = order.experience;

    String title = flight?.airlineName ?? train?.trainName ?? dest?.title ?? exp?.title ?? 'Tiket Perjalanan';
    String subtitle = flight?.flightNumber ?? train?.trainNumber ?? dest?.tag ?? exp?.categoryTag ?? '';

    IconData icon = flight != null
        ? Icons.flight_rounded
        : train != null
            ? Icons.train_rounded
            : exp != null
                ? Icons.explore_rounded
                : Icons.hotel_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: TicketPassCard(
        cutoutRadius: 14,
        cutoutPositionFactor: 0.68,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: TravelTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: TravelTheme.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: TravelTheme.muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TravelTheme.emerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: const TextStyle(
                        color: TravelTheme.emerald,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Route details for Flight & Train
              if (flight != null || train != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flight?.originCode ?? train!.originCode,
                          style: const TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          flight?.departureTime ?? train!.departureTime,
                          style: const TextStyle(
                            color: TravelTheme.darkMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          flight != null ? Icons.flight_takeoff_rounded : Icons.directions_railway_rounded,
                          color: TravelTheme.primaryLight,
                          size: 18,
                        ),
                        Text(
                          formatTravelDate(order.travelDate),
                          style: const TextStyle(color: TravelTheme.muted, fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          flight?.destinationCode ?? train!.destinationCode,
                          style: const TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          flight?.arrivalTime ?? train!.arrivalTime,
                          style: const TextStyle(
                            color: TravelTheme.darkMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                // Hotel & Experience detail row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dest != null ? 'Check-In Date' : 'Jadwal Aktivitas',
                          style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                        ),
                        Text(
                          formatTravelDate(order.travelDate),
                          style: const TextStyle(color: TravelTheme.dark, fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        order.passenger.selectedSeat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: TravelTheme.primary, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 38), // Perforation line spacing

              // Bottom Actions & QR Preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KODE BOOKING',
                        style: TextStyle(color: TravelTheme.muted, fontSize: 9, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        order.bookingCode,
                        style: const TextStyle(
                          color: TravelTheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        TravelPageRoute(page: ETicketSuccessScreen(order: order)),
                      );
                    },
                    icon: const Icon(Icons.qr_code_rounded, size: 16),
                    label: const Text('Buka E-Ticket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TravelTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 3: RIWAYAT SELESAI (HISTORY)
  // ==========================================
  Widget _buildHistorySection() {
    final historyOrders = _getHistoryOrders();

    if (historyOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_toggle_off_rounded,
        title: 'Tidak ada riwayat tiket ${_getCategoryName(_selectedCategory)}',
        subtitle: 'Perjalanan yang telah selesai akan tercatat rapi di sini.',
        actionLabel: 'Mulai Petualangan Baru',
        onAction: widget.onExploreTapped,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: historyOrders.length,
      itemBuilder: (context, index) {
        final order = historyOrders[index];
        return _buildHistoryTicketCard(order);
      },
    );
  }

  Widget _buildHistoryTicketCard(BookingOrder order) {
    final flight = order.flight;
    final train = order.train;
    final dest = order.destination;
    final exp = order.experience;

    String title = flight?.airlineName ?? train?.trainName ?? dest?.title ?? exp?.title ?? 'Tiket Perjalanan';
    String route = flight != null
        ? '${flight.originCity} (${flight.originCode}) ➔ ${flight.destinationCity} (${flight.destinationCode})'
        : train != null
            ? '${train.originCity} ➔ ${train.destinationCity}'
            : dest != null
                ? '${dest.location} • ${dest.country}'
                : '${exp!.location} • ${exp.duration}';

    IconData icon = flight != null
        ? Icons.flight_takeoff_rounded
        : train != null
            ? Icons.directions_railway_rounded
            : exp != null
                ? Icons.explore_rounded
                : Icons.hotel_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TravelTheme.border),
        boxShadow: [
          BoxShadow(
            color: TravelTheme.dark.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TravelTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: TravelTheme.darkMuted, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        route,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      color: TravelTheme.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: TravelTheme.surface, height: 1),
            const SizedBox(height: 10),

            // Date & Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tanggal Perjalanan', style: TextStyle(color: TravelTheme.muted, fontSize: 10)),
                    Text(
                      formatTravelDate(order.travelDate),
                      style: const TextStyle(color: TravelTheme.dark, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Total Biaya', style: TextStyle(color: TravelTheme.muted, fontSize: 10)),
                    Text(
                      formatTravelCurrency(order.totalPrice),
                      style: const TextStyle(color: TravelTheme.dark, fontSize: 13, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action Buttons (Pesan Lagi & Beri Ulasan)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Terima kasih! Formulir ulasan bintang telah dibuka.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                    label: const Text('Beri Ulasan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TravelTheme.dark,
                      side: const BorderSide(color: TravelTheme.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _cartManager.addItem(
                        category: order.category,
                        flight: order.flight,
                        train: order.train,
                        destination: order.destination,
                        experience: order.experience,
                        basePrice: order.basePrice,
                      );
                      setState(() => _selectedMainTab = 0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tiket $title telah ditambahkan ke Keranjang'),
                          backgroundColor: TravelTheme.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.repeat_rounded, size: 16),
                    label: const Text('Pesan Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TravelTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: TravelTheme.muted),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: TravelTheme.dark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: TravelTheme.muted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: TravelTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(actionLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(TravelCategory? cat) {
    if (cat == null) return '';
    switch (cat) {
      case TravelCategory.flight:
        return 'Pesawat';
      case TravelCategory.train:
        return 'Kereta';
      case TravelCategory.hotel:
        return 'Hotel';
      case TravelCategory.experience:
        return 'Wisata';
    }
  }
}
