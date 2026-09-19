import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';
import '../../data/models/coffee_order_model.dart';

class PaymentModalSheet extends StatefulWidget {
  final List<CoffeeOrderItem> items;
  final Function(CoffeeOrderModel order) onPaymentSuccess;

  const PaymentModalSheet({
    super.key,
    required this.items,
    required this.onPaymentSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required List<CoffeeOrderItem> items,
    required Function(CoffeeOrderModel order) onPaymentSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => PaymentModalSheet(
            items: items,
            onPaymentSuccess: onPaymentSuccess,
          ),
    );
  }

  @override
  State<PaymentModalSheet> createState() => _PaymentModalSheetState();
}

class _PaymentModalSheetState extends State<PaymentModalSheet>
    with TickerProviderStateMixin {
  PaymentType _selectedPayment = PaymentType.qris;
  final TextEditingController _promoController = TextEditingController();
  double _discount = 0.0;
  String? _appliedPromoCode;
  String? _promoMessage;
  bool _isPromoValid = false;

  bool _isProcessing = false;
  bool _isSuccess = false;

  // QRIS Countdown Timer
  int _qrisSecondsLeft = 899; // 14:59
  Timer? _countdownTimer;

  // Scanner Laser Animation for QRIS
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_laserController);
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_qrisSecondsLeft > 0) {
        setState(() {
          _qrisSecondsLeft--;
        });
      } else {
        _countdownTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _laserController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return widget.items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get _serviceFee => 1000.0;

  double get _totalPayment {
    final total = _subtotal - _discount + _serviceFee;
    return total > 0 ? total : 0.0;
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'BREWEZ50') {
      setState(() {
        _discount = (_subtotal * 0.5).clamp(0.0, 15000.0);
        _appliedPromoCode = code;
        _isPromoValid = true;
        _promoMessage =
            "${BrewezLocalization.tr('promo_applied')} -${BrewezCurrency.format(_discount)}";
      });
    } else if (code == 'DISKONKOPI') {
      setState(() {
        _discount = 10000.0;
        _appliedPromoCode = code;
        _isPromoValid = true;
        _promoMessage =
            "${BrewezLocalization.tr('promo_applied')} -${BrewezCurrency.format(_discount)}";
      });
    } else {
      setState(() {
        _discount = 0.0;
        _appliedPromoCode = null;
        _isPromoValid = false;
        _promoMessage = BrewezLocalization.tr('invalid_promo');
      });
    }
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate Network Payment Verification
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      HapticFeedback.heavyImpact();

      // Create Order Model
      final randomQueue =
          "A-${(math.Random().nextInt(80) + 10).toString().padLeft(2, '0')}";
      final randomOrderId = "#BRW-${math.Random().nextInt(9000) + 1000}";
      final randomRef =
          "REF${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

      final order = CoffeeOrderModel(
        orderId: randomOrderId,
        queueNumber: randomQueue,
        items: widget.items,
        subtotal: _subtotal,
        discount: _discount,
        serviceFee: _serviceFee,
        totalAmount: _totalPayment,
        paymentType: _selectedPayment,
        paymentReference: randomRef,
        orderTime: DateTime.now(),
        promoCode: _appliedPromoCode,
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pop(context); // Close Payment Sheet
        widget.onPaymentSuccess(order);
      });
    });
  }

  String _formatTimer(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: BrewezTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.payment_rounded,
                          color: BrewezTheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        BrewezLocalization.tr('checkout_title'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: BrewezTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade200, height: 1),

            // Scrollable Content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  // 1. Order Summary Section
                  _buildSectionHeader(
                    BrewezLocalization.tr('order_summary'),
                    Icons.receipt_long_rounded,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children:
                          widget.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.quantity}x  ${item.name}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: BrewezTheme.textDark,
                                          ),
                                        ),
                                        Text(
                                          "${item.size} • ${item.isHot ? 'Hot' : 'Iced'} • ${item.sweetness}% Sugar",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    BrewezCurrency.format(item.totalPrice),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: BrewezTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 2. Voucher / Promo Code Input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  _isPromoValid
                                      ? Colors.green
                                      : Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: _promoController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: BrewezLocalization.tr(
                                'promo_code_hint',
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                              icon: Icon(
                                Icons.local_offer_rounded,
                                size: 18,
                                color:
                                    _isPromoValid
                                        ? Colors.green
                                        : Colors.grey.shade400,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _applyPromo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BrewezTheme.espresso,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          BrewezLocalization.tr('apply_btn'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_promoMessage != null) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        _promoMessage!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color:
                              _isPromoValid
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  // 3. Payment Method Options
                  _buildSectionHeader(
                    BrewezLocalization.tr('payment_method'),
                    Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: 12),

                  // QRIS Selection Card
                  _buildPaymentCard(
                    type: PaymentType.qris,
                    title: 'QRIS (Instant Pay)',
                    subtitle: 'GoPay, OVO, BCA, DANA, ShopeePay',
                    icon: Icons.qr_code_scanner_rounded,
                    iconColor: const Color(0xFFE53935),
                  ),

                  // E-Wallets
                  const SizedBox(height: 8),
                  _buildPaymentCard(
                    type: PaymentType.gopay,
                    title: 'GoPay / GoPay Coins',
                    subtitle: 'Saldo: Rp 150.000 (Auto-connect)',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: const Color(0xFF00AED6),
                  ),

                  const SizedBox(height: 8),
                  _buildPaymentCard(
                    type: PaymentType.shopeepay,
                    title: 'ShopeePay',
                    subtitle: 'Cashback koin s.d. 30%',
                    icon: Icons.shopping_bag_rounded,
                    iconColor: const Color(0xFFEE4D2D),
                  ),

                  const SizedBox(height: 8),
                  _buildPaymentCard(
                    type: PaymentType.bcaVa,
                    title: 'BCA Virtual Account',
                    subtitle: 'Verifikasi instan 24 jam',
                    icon: Icons.account_balance_rounded,
                    iconColor: const Color(0xFF005BAA),
                  ),

                  const SizedBox(height: 8),
                  _buildPaymentCard(
                    type: PaymentType.cash,
                    title: 'Tunai di Kasir (Cash at Counter)',
                    subtitle: 'Bayar langsung saat pengambilan pesanan',
                    icon: Icons.storefront_rounded,
                    iconColor: const Color(0xFF4CAF50),
                  ),

                  const SizedBox(height: 20),

                  // Dynamic Payment Details Box (QRIS / VA / E-Wallet interactive simulation)
                  _buildInteractivePaymentDetails(),

                  const SizedBox(height: 20),

                  // Price Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: BrewezTheme.accentWarm.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        _priceRow(
                          BrewezLocalization.tr('subtotal_label'),
                          BrewezCurrency.format(_subtotal),
                        ),
                        if (_discount > 0) ...[
                          const SizedBox(height: 6),
                          _priceRow(
                            "${BrewezLocalization.tr('discount_label')} ($_appliedPromoCode)",
                            "- ${BrewezCurrency.format(_discount)}",
                            isGreen: true,
                          ),
                        ],
                        const SizedBox(height: 6),
                        _priceRow(
                          BrewezLocalization.tr('service_fee'),
                          BrewezCurrency.format(_serviceFee),
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              BrewezLocalization.tr('total_payment'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: BrewezTheme.textDark,
                              ),
                            ),
                            Text(
                              BrewezCurrency.format(_totalPayment),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: BrewezTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Bottom Pay Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      _isProcessing || _isSuccess ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSuccess
                            ? const Color(0xFF2E7D32)
                            : BrewezTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  child:
                      _isProcessing
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Memverifikasi Pembayaran...',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                          : _isSuccess
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Pembayaran Berhasil!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    BrewezLocalization.tr('pay_now_btn'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                BrewezCurrency.format(_totalPayment),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: BrewezTheme.milkFoam,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: BrewezTheme.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: BrewezTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard({
    required PaymentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedPayment == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? BrewezTheme.primary.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? BrewezTheme.primary : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: BrewezTheme.primary.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: BrewezTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? BrewezTheme.primary : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? BrewezTheme.primary : Colors.transparent,
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractivePaymentDetails() {
    switch (_selectedPayment) {
      case PaymentType.qris:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    BrewezLocalization.tr('qris_merchant'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: BrewezTheme.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${BrewezLocalization.tr('qris_expires_in')} ${_formatTimer(_qrisSecondsLeft)}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Animated Simulated QR Box with Scanning Laser
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black87, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Simulated QR grid pattern
                          Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 3,
                                    crossAxisSpacing: 3,
                                  ),
                              itemCount: 49,
                              itemBuilder: (context, index) {
                                final isBlack =
                                    index % 2 == 0 ||
                                    index == 0 ||
                                    index == 6 ||
                                    index == 42 ||
                                    index == 48 ||
                                    index == 24;
                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isBlack ? Colors.black87 : Colors.white,
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Laser Scanning Line
                    AnimatedBuilder(
                      animation: _laserAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: 10 + (_laserAnimation.value * 150),
                          child: Container(
                            width: 160,
                            height: 2.5,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.8),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Simulation Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _isProcessing || _isSuccess ? null : _processPayment,
                  icon: const Icon(Icons.flash_on_rounded, size: 16),
                  label: Text(
                    BrewezLocalization.tr('scan_qris_sim'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BrewezTheme.primary,
                    side: const BorderSide(color: BrewezTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        );

      case PaymentType.bcaVa:
        const vaNumber = "88092 0812 3456 7890";
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF005BAA).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance_rounded,
                    color: Color(0xFF005BAA),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Nomor BCA Virtual Account',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005BAA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    vaNumber,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: vaNumber));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(BrewezLocalization.tr('va_copied')),
                          duration: const Duration(milliseconds: 1000),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        BrewezLocalization.tr('copy_va'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: BrewezTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _isProcessing || _isSuccess ? null : _processPayment,
                  icon: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 16,
                  ),
                  label: Text(
                    BrewezLocalization.tr('transfer_va_sim'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF005BAA),
                    side: const BorderSide(color: Color(0xFF005BAA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case PaymentType.gopay:
      case PaymentType.shopeepay:
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.phone_android_rounded,
                    size: 18,
                    color: BrewezTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nomor Akun: 0812-****-8899',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _isProcessing || _isSuccess ? null : _processPayment,
                  icon: const Icon(Icons.bolt_rounded, size: 16),
                  label: Text(
                    BrewezLocalization.tr('pay_ewallet_sim'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BrewezTheme.primary,
                    side: const BorderSide(color: BrewezTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case PaymentType.cash:
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Bayar saat pesanan selesai diseduh dan diambil di kasir.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _priceRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isGreen ? Colors.green.shade700 : Colors.grey.shade600,
            fontWeight: isGreen ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isGreen ? Colors.green.shade700 : BrewezTheme.textDark,
          ),
        ),
      ],
    );
  }
}
