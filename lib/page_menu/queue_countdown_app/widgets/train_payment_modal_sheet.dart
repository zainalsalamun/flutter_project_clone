import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Modal bottom sheet for Train Ticket Payment Simulation (QRIS, VA, E-Wallet, Retail).
class TrainPaymentModalSheet extends StatefulWidget {
  final int basePrice;
  final int insurancePrice;
  final int serviceFee;
  final ValueChanged<Map<String, dynamic>> onPaymentSuccess;

  const TrainPaymentModalSheet({
    super.key,
    required this.basePrice,
    required this.insurancePrice,
    required this.serviceFee,
    required this.onPaymentSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required int basePrice,
    required int insurancePrice,
    required int serviceFee,
    required ValueChanged<Map<String, dynamic>> onPaymentSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TrainPaymentModalSheet(
        basePrice: basePrice,
        insurancePrice: insurancePrice,
        serviceFee: serviceFee,
        onPaymentSuccess: onPaymentSuccess,
      ),
    );
  }

  @override
  State<TrainPaymentModalSheet> createState() => _TrainPaymentModalSheetState();
}

class _TrainPaymentModalSheetState extends State<TrainPaymentModalSheet>
    with SingleTickerProviderStateMixin {
  String _selectedMethod = 'qris'; // 'qris', 'bca_va', 'gopay', 'shopeepay'

  // Promo Code State
  final TextEditingController _voucherController = TextEditingController();
  int _discountAmount = 0;
  String? _appliedVoucherCode;
  String? _voucherError;

  // Processing Animation
  bool _isProcessing = false;

  // Laser scanner animation controller for QRIS
  late AnimationController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  int get _totalPayment =>
      widget.basePrice +
      widget.insurancePrice +
      widget.serviceFee -
      _discountAmount;

  String get _qrisPayloadString {
    final amount = _totalPayment.toString();
    return "00020101021226680016ID.CO.KAI.WWW01189360091100203040500215ID10203040508820303UMI51440014ID.LINKAJA.WWW0215ID1020304050882520441115303360540${amount.length.toString().padLeft(2, '0')}${amount}5802ID5925PT KERETA API INDONESIA6007JAKARTA61051011062280724KAI-TICKET-2026-9842106304A8F2";
  }

  void _applyVoucher() {
    final code = _voucherController.text.trim().toUpperCase();
    if (code == 'KAIHEMAT' || code == 'KERETA10' || code == 'DISKON15') {
      setState(() {
        _discountAmount = 15000;
        _appliedVoucherCode = code;
        _voucherError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Voucher $code berhasil digunakan! Diskon Rp 15.000"),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(milliseconds: 1400),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _voucherError = "Kode voucher tidak valid. Coba: KAIHEMAT";
      });
    }
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
      Navigator.pop(context); // Close bottom sheet

      final methodName = _selectedMethod == 'qris'
          ? 'QRIS Dinamis'
          : _selectedMethod == 'bca_va'
              ? 'BCA Virtual Account'
              : _selectedMethod == 'gopay'
                  ? 'GoPay'
                  : 'ShopeePay';

      widget.onPaymentSuccess({
        'paymentMethod': methodName,
        'totalAmount': _totalPayment,
        'paidAt': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        child: _isProcessing
            ? _buildProcessingView()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 42,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pembayaran Tiket",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.grey, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Scrollable Content (Methods, QRIS / VA view, Promo, Breakdown)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Total Amount Header Pill
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color:
                                      const Color(0xFF2563EB).withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Tagihan",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B)),
                                    ),
                                    Text(
                                      "Argo Parahyangan (1 Penumpang)",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0F172A)),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Rp ${_formatNumber(_totalPayment)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 1. Payment Methods Selector
                          const Text(
                            "Pilih Metode Pembayaran",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildMethodTab("qris", "QRIS", Icons.qr_code_scanner_rounded),
                              const SizedBox(width: 8),
                              _buildMethodTab("bca_va", "BCA VA", Icons.account_balance_rounded),
                              const SizedBox(width: 8),
                              _buildMethodTab("gopay", "GoPay", Icons.account_balance_wallet_rounded),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // 2. Method Specific Interactive Body
                          if (_selectedMethod == 'qris') _buildQrisSection(),
                          if (_selectedMethod == 'bca_va') _buildBcaVaSection(),
                          if (_selectedMethod == 'gopay') _buildEwalletSection(),
                          const SizedBox(height: 20),

                          // 3. Voucher Promo Code Input
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.confirmation_number_outlined,
                                        size: 18, color: Color(0xFF2563EB)),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Punya Kode Promo?",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (_appliedVoucherCode != null)
                                      const Text(
                                        "TERPASANG",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF10B981)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _voucherController,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Ketik promo (Coba: KAIHEMAT)",
                                          hintStyle: TextStyle(
                                              fontSize: 12.5,
                                              color: Colors.grey.shade400),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: _applyVoucher,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2563EB),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                      ),
                                      child: const Text("Pakai",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                    ),
                                  ],
                                ),
                                if (_voucherError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      _voucherError!,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.red.shade700),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4. Breakdown Summary
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                _buildPriceRow("Tarif Tiket Kereta",
                                    widget.basePrice),
                                const SizedBox(height: 6),
                                _buildPriceRow("Asuransi Perjalanan",
                                    widget.insurancePrice),
                                const SizedBox(height: 6),
                                _buildPriceRow("Biaya Layanan",
                                    widget.serviceFee),
                                if (_discountAmount > 0) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Diskon Promo ($_appliedVoucherCode)",
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color: Color(0xFF10B981)),
                                      ),
                                      Text(
                                        "- Rp ${_formatNumber(_discountAmount)}",
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF10B981)),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Pay Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Bayar Sekarang (Rp ${_formatNumber(_totalPayment)})",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMethodTab(String key, String label, IconData icon) {
    final isSelected = _selectedMethod == key;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = key;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrisSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.qr_code_2_rounded,
                      color: Color(0xFF2563EB), size: 22),
                  SizedBox(width: 8),
                  Text(
                    "QRIS KAI ACCESS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 12, color: Colors.amber.shade900),
                    const SizedBox(width: 4),
                    Text(
                      "14:59",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Animated QR Box with Laser Scan Effect & Real QR Generator
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 178,
                height: 178,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: QrImageView(
                    data: _qrisPayloadString,
                    version: QrVersions.auto,
                    size: 160,
                    padding: const EdgeInsets.all(4),
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF0F172A),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
              // Animated Laser Beam
              AnimatedBuilder(
                animation: _scannerController,
                builder: (context, child) {
                  return Positioned(
                    top: 12 + (_scannerController.value * 148),
                    child: Container(
                      width: 154,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "NMID: ID1020304050 • PT KERETA API INDONESIA",
            style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildBcaVaSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.account_balance_rounded,
                  color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 8),
              Text(
                "BCA Virtual Account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text("Nomor Virtual Account:",
              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "8801 2345 6789 0001",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text("Nomor BCA VA berhasil disalin!"),
                      backgroundColor: const Color(0xFF2563EB),
                      duration: const Duration(milliseconds: 1000),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Salin",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEwalletSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: const [
          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Akun GoPay Terhubung",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0F172A)),
                ),
                Text(
                  "Saldo: Rp 450.000 (Cukup untuk pembayaran)",
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
        Text("Rp ${_formatNumber(amount)}",
            style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Memverifikasi Pembayaran...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Mohon tunggu, kami sedang menerbitkan tiket Anda",
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

