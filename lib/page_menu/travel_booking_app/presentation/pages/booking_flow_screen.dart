import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../core/utils/travel_page_routes.dart';
import '../../data/models/travel_item_model.dart';
import '../widgets/animated_booking_button.dart';
import '../widgets/animated_price_text.dart';
import '../widgets/booking_step_progress.dart';
import '../widgets/train_seat_layout_selector.dart';
import '../widgets/airplane_seat_layout_selector.dart';
import 'e_ticket_success_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final DestinationItem? destination;
  final FlightTicket? flight;
  final TrainTicket? train;
  final ExperienceItem? experience;
  final double? initialPrice;
  final String? selectedRoomType;

  const BookingFlowScreen({
    super.key,
    this.destination,
    this.flight,
    this.train,
    this.experience,
    this.initialPrice,
    this.selectedRoomType,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Form State
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 5));
  String _selectedSeat = '14A';
  String _selectedTrainWagon = 'Gerbong 1';
  bool _includeInsurance = true;
  bool _includeExtraBaggage = false;
  bool _includeSpecialMeal = false;

  final TextEditingController _nameController =
      TextEditingController(text: 'Zainal Salamun');
  final TextEditingController _idController =
      TextEditingController(text: '3171012345678901');
  final TextEditingController _emailController =
      TextEditingController(text: 'zainal.dev@example.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+62 812-3456-7890');
  final TextEditingController _promoController = TextEditingController();

  double _discountAmount = 0;
  String? _promoMessage;
  String _selectedPaymentMethod = 'QRIS Instant (GoPay, OVO, DANA, BCA)';
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    if (widget.train != null) {
      _selectedTrainWagon = 'Gerbong 1';
      _selectedSeat = 'Gerbong 1 - Kursi 4A (Jendela)';
    } else if (widget.flight != null) {
      _selectedSeat = 'Kursi 14A • Jendela (Window)';
    } else if (widget.experience != null) {
      _selectedSeat = 'Sesi Pagi (08:00 WIB)';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  double get _basePrice {
    if (widget.initialPrice != null) return widget.initialPrice!;
    if (widget.flight != null) return widget.flight!.price;
    if (widget.train != null) return widget.train!.price;
    if (widget.experience != null) return widget.experience!.price;
    if (widget.destination != null) return widget.destination!.pricePerNight;
    return 1500000;
  }

  double get _addonsPrice {
    double total = 0;
    if (_includeInsurance) total += 75000;
    if (_includeExtraBaggage) total += 150000;
    if (_includeSpecialMeal) total += 65000;
    return total;
  }

  double get _taxAndService => _basePrice * 0.1;

  double get _totalPrice => (_basePrice + _taxAndService + _addonsPrice) - _discountAmount;

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

  void _applyPromo([String? code]) {
    final promoCode = (code ?? _promoController.text).trim().toUpperCase();
    _promoController.text = promoCode;

    setState(() {
      if (promoCode == 'WANDER50') {
        _discountAmount = 50000;
        _promoMessage = 'Voucher WANDER50 Diskon Rp 50.000 berhasil diterapkan! 🎉';
      } else if (promoCode == 'KAIHEMAT50') {
        _discountAmount = 50000;
        _promoMessage = 'Voucher KAIHEMAT50 Diskon Rp 50.000 Spesial Kereta Api! 🚅';
      } else if (promoCode == 'FLIGHT100') {
        _discountAmount = 100000;
        _promoMessage = 'Voucher FLIGHT100 Diskon Rp 100.000 Terbang Hemat! ✈️';
      } else if (promoCode == 'DISKONMEMBER20') {
        final calc = _basePrice * 0.20;
        _discountAmount = calc > 100000 ? 100000 : calc;
        _promoMessage = 'Voucher Member 20% (-${formatTravelCurrency(_discountAmount)}) aktif! 🌟';
      } else if (promoCode.isEmpty) {
        _discountAmount = 0;
        _promoMessage = null;
      } else {
        _discountAmount = 0;
        _promoMessage = 'Kode "$promoCode" tidak valid. Silakan pilih promo di bawah.';
      }
    });
  }

  void _completePayment() async {
    setState(() => _isProcessingPayment = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final passenger = PassengerInfo(
      fullName: _nameController.text,
      idCardOrPassport: _idController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      selectedSeat: _selectedSeat,
      selectedMeal: _includeSpecialMeal ? 'Signature Gourmet Meal' : 'Standard',
      extraBaggage: _includeExtraBaggage ? 10 : 0,
    );

    final TravelCategory category = widget.flight != null
        ? TravelCategory.flight
        : widget.train != null
            ? TravelCategory.train
            : widget.experience != null
                ? TravelCategory.experience
                : TravelCategory.hotel;

    final order = BookingOrder(
      orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      bookingCode: 'WND-${(1000 + DateTime.now().millisecond).toString()}',
      destination: widget.destination,
      flight: widget.flight,
      train: widget.train,
      experience: widget.experience,
      category: category,
      travelDate: _selectedDate,
      passenger: passenger,
      basePrice: _basePrice,
      taxAndService: _taxAndService,
      discountAmount: _discountAmount,
      extraAddonsPrice: _addonsPrice,
      paymentMethod: _selectedPaymentMethod,
    );

    setState(() => _isProcessingPayment = false);

    Navigator.pushReplacement(
      context,
      TravelPageRoute(
        page: ETicketSuccessScreen(order: order),
      ),
    );
  }

  String get _appBarTitle {
    if (widget.flight != null) return 'Pemesanan Tiket Pesawat';
    if (widget.train != null) return 'Pemesanan Tiket Kereta';
    if (widget.experience != null) return 'Pemesanan Paket Wisata';
    return 'Pemesanan Kamar Hotel';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: TravelTheme.dark),
          onPressed: () {
            if (_currentStep > 0) {
              _goToStep(_currentStep - 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _appBarTitle,
          style: const TextStyle(
            color: TravelTheme.dark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: BookingStepProgress(
              currentStep: _currentStep,
              onStepTapped: (step) => _goToStep(step),
            ),
          ),

          // Multi-Step Content (PageView)
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep0ScheduleAndSeat(),
                _buildStep1PassengerAndAddons(),
                _buildStep2PaymentAndSummary(),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AnimatedPriceText(
                      price: _totalPrice,
                      style: const TextStyle(
                        color: TravelTheme.accent,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AnimatedBookingButton(
                    text: _currentStep == 2 ? 'Bayar Sekarang' : 'Lanjut',
                    icon: _currentStep == 2 ? Icons.lock_outline_rounded : Icons.arrow_forward_rounded,
                    isLoading: _isProcessingPayment,
                    onPressed: () {
                      if (_currentStep < 2) {
                        _goToStep(_currentStep + 1);
                      } else {
                        _completePayment();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP 0: Pilih Jadwal & Kursi / Kamar / Sesi
  Widget _buildStep0ScheduleAndSeat() {
    String title = 'Pilihan Terbaik';
    String subtitle = 'Detail Pemesanan';
    IconData itemIcon = Icons.airplane_ticket_rounded;

    if (widget.flight != null) {
      title = widget.flight!.airlineName;
      subtitle = '${widget.flight!.originCode} ➔ ${widget.flight!.destinationCode} • ${widget.flight!.cabinClass}';
      itemIcon = Icons.flight_rounded;
    } else if (widget.train != null) {
      title = widget.train!.trainName;
      subtitle = '${widget.train!.originCode} ➔ ${widget.train!.destinationCode} • ${widget.train!.trainClass}';
      itemIcon = Icons.train_rounded;
    } else if (widget.experience != null) {
      title = widget.experience!.title;
      subtitle = '${widget.experience!.location} • ${widget.experience!.duration}';
      itemIcon = Icons.explore_rounded;
    } else if (widget.destination != null) {
      title = widget.destination!.title;
      subtitle = '${widget.destination!.location} • ${widget.selectedRoomType ?? "Deluxe Suite"}';
      itemIcon = Icons.hotel_rounded;
    }

    final List<String> seatOptions = widget.train != null
        ? ['Gerbong 1 - 8A', 'Gerbong 1 - 8B', 'Gerbong 2 - 12A (Window)', 'Gerbong 2 - 12B']
        : widget.experience != null
            ? ['Sesi Pagi (08:00 WIB)', 'Sesi Siang (13:00 WIB)', 'Sesi Sunset (16:30 WIB)']
            : widget.flight != null
                ? ['12A', '12B', '14A (Jendela)', '14C (Lorong)', '15A', '16F']
                : ['Lantai Atas (High Floor)', 'King Bed Non-Smoking', 'Valley View', 'Dekat Lift'];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TravelTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: TravelTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(itemIcon, color: TravelTheme.primary, size: 26),
              ),
              const SizedBox(width: 14),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Date Picker Section
        const Text(
          '1. Pilih Tanggal Perjalanan / Aktivitas',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TravelTheme.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: TravelTheme.primary, size: 22),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal Terpilih',
                        style: TextStyle(color: TravelTheme.muted, fontSize: 11),
                      ),
                      Text(
                        formatTravelDate(_selectedDate),
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TravelTheme.surface,
                  foregroundColor: TravelTheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ganti', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // If Train: Render Interactive Wagon & PT KAI Seat Map Selector
        if (widget.train != null) ...[
          TrainSeatLayoutSelector(
            train: widget.train,
            selectedWagon: _selectedTrainWagon,
            selectedSeat: _selectedSeat.contains('Kursi ')
                ? _selectedSeat.split('Kursi ')[1].split(' ')[0]
                : '4A',
            onSeatSelected: (wagon, seatFullName) {
              setState(() {
                _selectedTrainWagon = wagon;
                _selectedSeat = seatFullName;
              });
            },
          ),
        ] else if (widget.flight != null) ...[
          // Interactive 3-3 Commercial Airplane Cabin Seat Map
          AirplaneSeatLayoutSelector(
            flight: widget.flight,
            selectedSeat: _selectedSeat,
            onSeatSelected: (seatCode, seatFullDescription) {
              setState(() {
                _selectedSeat = seatFullDescription;
              });
            },
          ),
        ] else ...[
          // For Experiences, Hotels
          Text(
            widget.experience != null
                ? '2. Pilih Sesi Waktu Aktivitas'
                : '2. Pilihan Preferensi Kamar',
            style: const TextStyle(
              color: TravelTheme.dark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: seatOptions.map((seat) {
              final isSelected = _selectedSeat == seat;
              return GestureDetector(
                onTap: () => setState(() => _selectedSeat = seat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? TravelTheme.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? TravelTheme.primary : TravelTheme.border,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: TravelTheme.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.experience != null
                            ? Icons.access_time_rounded
                            : Icons.hotel_class_rounded,
                        color: isSelected ? Colors.white : TravelTheme.darkMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        seat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : TravelTheme.dark,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // STEP 1: Data Penumpang & Add-ons
  Widget _buildStep1PassengerAndAddons() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Informasi Penumpang / Pemesan Utama',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        // Passenger Form Fields
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TravelTheme.border),
          ),
          child: Column(
            children: [
              _buildInputField(
                controller: _nameController,
                label: 'Nama Lengkap (Sesuai KTP/Paspor)',
                icon: Icons.person_rounded,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                controller: _idController,
                label: 'Nomor Identitas (NIK/Paspor)',
                icon: Icons.badge_rounded,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                controller: _emailController,
                label: 'Alamat Email (Untuk E-Ticket)',
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                controller: _phoneController,
                label: 'Nomor WhatsApp / HP',
                icon: Icons.phone_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // Add-ons Section
        const Text(
          'Layanan Tambahan (Add-ons)',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        _buildAddonTile(
          title: 'Asuransi Perjalanan Komprehensif',
          subtitle: 'Perlindungan bagasi hilang, keterlambatan & medis',
          price: 75000,
          value: _includeInsurance,
          onChanged: (val) => setState(() => _includeInsurance = val),
        ),
        _buildAddonTile(
          title: 'Fasilitas Layanan Ekstra',
          subtitle: 'Prioritas check-in / Bagasi tambahan',
          price: 150000,
          value: _includeExtraBaggage,
          onChanged: (val) => setState(() => _includeExtraBaggage = val),
        ),
        _buildAddonTile(
          title: 'Kuliner & Snack Spesial',
          subtitle: 'Paket makanan & minuman premium selama perjalanan',
          price: 65000,
          value: _includeSpecialMeal,
          onChanged: (val) => setState(() => _includeSpecialMeal = val),
        ),
      ],
    );
  }

  // STEP 2: Pembayaran & Ringkasan
  Widget _buildStep2PaymentAndSummary() {
    final paymentMethods = [
      ('QRIS Instant (GoPay, OVO, DANA, BCA)', Icons.qr_code_scanner_rounded, 'Scan via Semua E-Wallet & Mobile Banking'),
      ('BCA Virtual Account', Icons.account_balance_rounded, 'Otomatis Terverifikasi 24 Jam'),
      ('Mandiri Virtual Account', Icons.account_balance_rounded, 'Otomatis Terverifikasi 24 Jam'),
      ('Kartu Kredit / Debit', Icons.credit_card_rounded, 'Visa / Mastercard / JCB'),
    ];

    final vouchers = [
      ('WANDER50', 'Diskon Rp 50rb (Semua)', Icons.card_giftcard_rounded),
      if (widget.train != null)
        ('KAIHEMAT50', 'Diskon Rp 50rb Tiket KA', Icons.train_rounded),
      if (widget.flight != null)
        ('FLIGHT100', 'Diskon Rp 100rb Tiket Pesawat', Icons.flight_rounded),
      ('DISKONMEMBER20', 'Diskon 20% Member Wanderlust', Icons.stars_rounded),
    ];

    final isQris = _selectedPaymentMethod.startsWith('QRIS');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Promo Code Card with Quick Chips
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TravelTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.discount_rounded, color: TravelTheme.accent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Voucher & Promo',
                        style: TextStyle(
                          color: TravelTheme.dark,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (_discountAmount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TravelTheme.emerald.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Hemat ${formatTravelCurrency(_discountAmount)}',
                        style: const TextStyle(
                          color: TravelTheme.emerald,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Ketik atau pilih voucher...',
                        hintStyle: const TextStyle(color: TravelTheme.muted, fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: TravelTheme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: TravelTheme.border),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _applyPromo(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TravelTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Pakai', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              if (_promoMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _promoMessage!,
                  style: TextStyle(
                    color: _discountAmount > 0 ? TravelTheme.emerald : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Text(
                'Rekomendasi Voucher Untukmu:',
                style: TextStyle(color: TravelTheme.muted, fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: vouchers.map((v) {
                  final isApplied = _promoController.text.toUpperCase() == v.$1 && _discountAmount > 0;
                  return GestureDetector(
                    onTap: () => _applyPromo(v.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isApplied ? TravelTheme.primary.withValues(alpha: 0.1) : TravelTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isApplied ? TravelTheme.primary : TravelTheme.border,
                          width: isApplied ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(v.$3, size: 14, color: isApplied ? TravelTheme.primary : TravelTheme.muted),
                          const SizedBox(width: 6),
                          Text(
                            v.$1,
                            style: TextStyle(
                              color: isApplied ? TravelTheme.primary : TravelTheme.dark,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '• ${v.$2}',
                            style: TextStyle(
                              color: isApplied ? TravelTheme.primary : TravelTheme.darkMuted,
                              fontSize: 10,
                              fontWeight: isApplied ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Payment Method Selector
        const Text(
          'Metode Pembayaran',
          style: TextStyle(
            color: TravelTheme.dark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...paymentMethods.map((method) {
          final isSelected = _selectedPaymentMethod == method.$1;

          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = method.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? TravelTheme.primary.withValues(alpha: 0.05) : Colors.white,
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
                  Icon(method.$2, color: isSelected ? TravelTheme.primary : TravelTheme.darkMuted, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method.$1,
                          style: TextStyle(
                            color: TravelTheme.dark,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          method.$3,
                          style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        // Interactive QRIS Simulator Card
        if (isQris) ...[
          const SizedBox(height: 8),
          _buildQrisSimulatorCard(),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 8),

        // Price Breakdown Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TravelTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rincian Biaya',
                style: TextStyle(
                  color: TravelTheme.dark,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 14),
              _buildPriceRow('Harga Pokok', _basePrice),
              const SizedBox(height: 8),
              _buildPriceRow('Pajak & Layanan (10%)', _taxAndService),
              if (_addonsPrice > 0) ...[
                const SizedBox(height: 8),
                _buildPriceRow('Layanan Tambahan', _addonsPrice),
              ],
              if (_discountAmount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Diskon Voucher',
                      style: TextStyle(color: TravelTheme.emerald, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '- ${formatTravelCurrency(_discountAmount)}',
                      style: const TextStyle(color: TravelTheme.emerald, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: TravelTheme.border, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Tagihan',
                    style: TextStyle(color: TravelTheme.dark, fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  AnimatedPriceText(
                    price: _totalPrice,
                    style: const TextStyle(
                      color: TravelTheme.accent,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Interactive Official QRIS Simulator Card
  Widget _buildQrisSimulatorCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // QRIS Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'QRIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TravelTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TravelTheme.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 12, color: TravelTheme.accent),
                    SizedBox(width: 4),
                    Text(
                      'Berlaku: 14:59',
                      style: TextStyle(
                        color: TravelTheme.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Merchant Info
          const Text(
            'PT WANDERLUST TIKET INDONESIA',
            style: TextStyle(
              color: TravelTheme.dark,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
          const Text(
            'NMID: ID102003928192301 • KAI & AIRLINES AGENT',
            style: TextStyle(
              color: TravelTheme.muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          // QR Code Graphic Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TravelTheme.border, width: 2),
            ),
            child: Column(
              children: [
                // Simulated QR Pattern Visual
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          11,
                          (rowIndex) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              11,
                              (colIndex) {
                                final isCorner = (rowIndex < 3 && colIndex < 3) ||
                                    (rowIndex < 3 && colIndex > 7) ||
                                    (rowIndex > 7 && colIndex < 3);
                                final isRandomDot = (rowIndex + colIndex) % 2 == 0 || (rowIndex * colIndex) % 3 == 0;

                                return Container(
                                  width: 11,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: isCorner
                                        ? const Color(0xFF1E293B)
                                        : isRandomDot
                                            ? const Color(0xFF1E293B)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(isCorner ? 2 : 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Center QRIS Logo
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFD32F2F), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        'QRIS',
                        style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Tagihan: ${formatTravelCurrency(_totalPrice)}',
                  style: const TextStyle(
                    color: TravelTheme.dark,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Supported E-Wallets
          const Text(
            'Mendukung Pembayaran Dari:',
            style: TextStyle(color: TravelTheme.muted, fontSize: 10, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              'GoPay',
              'OVO',
              'DANA',
              'ShopeePay',
              'BCA Mobile',
              'Livin Mandiri',
              'BRImo',
            ].map((app) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: TravelTheme.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: TravelTheme.border),
                ),
                child: Text(
                  app,
                  style: const TextStyle(
                    color: TravelTheme.darkMuted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Instant Simulate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isProcessingPayment ? null : _completePayment,
              icon: _isProcessingPayment
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.flash_on_rounded, size: 18),
              label: Text(
                _isProcessingPayment ? 'Memproses Transaksi...' : '⚡ Simulasi Bayar QRIS Sekarang',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: TravelTheme.darkMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: TravelTheme.primary, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: TravelTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: TravelTheme.border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddonTile({
    required String title,
    required String subtitle,
    required double price,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? TravelTheme.primary : TravelTheme.border,
          width: value ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: TravelTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (v) => onChanged(v ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: TravelTheme.dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '+${formatTravelCurrency(price)}',
            style: const TextStyle(
              color: TravelTheme.darkMuted,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: TravelTheme.darkMuted, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          formatTravelCurrency(amount),
          style: const TextStyle(color: TravelTheme.dark, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
