import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/train_payment_modal_sheet.dart';
import '../widgets/train_seat_selector_modal.dart';
import 'train_boarding_pass_receipt_page.dart';

/// Screen displayed when the Queue ends and the user is allowed to proceed with Passenger Data & Ticket Booking.
class PassengerBookingPreviewPage extends StatefulWidget {
  const PassengerBookingPreviewPage({super.key});

  @override
  State<PassengerBookingPreviewPage> createState() =>
      _PassengerBookingPreviewPageState();
}

class _PassengerBookingPreviewPageState
    extends State<PassengerBookingPreviewPage> {
  int _secondsRemaining = 15 * 60; // 15 minutes session timer
  Timer? _sessionTimer;

  // Passenger Form Controllers
  final TextEditingController _nameController =
      TextEditingController(text: "Zainal Salamun");
  final TextEditingController _nikController =
      TextEditingController(text: "3201234567890001");
  final TextEditingController _phoneController =
      TextEditingController(text: "081234567890");

  // Selected Seat State
  String _selectedCarriage = "Eksekutif 3";
  String _selectedSeat = "4A";

  // Addons State
  bool _includeInsurance = true;
  bool _includeMeal = false;

  final int _ticketPrice = 150000;
  final int _insurancePrice = 5000;
  final int _mealPrice = 35000;
  final int _serviceFee = 2500;

  @override
  void initState() {
    super.initState();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int get _calculatedTotalPrice {
    int total = _ticketPrice + _serviceFee;
    if (_includeInsurance) total += _insurancePrice;
    if (_includeMeal) total += _mealPrice;
    return total;
  }

  void _openSeatSelector() {
    TrainSeatSelectorModal.show(
      context,
      selectedCarriage: _selectedCarriage,
      selectedSeat: _selectedSeat,
      onSeatSelected: (data) {
        setState(() {
          _selectedCarriage = data['carriage'] ?? _selectedCarriage;
          _selectedSeat = data['seat'] ?? _selectedSeat;
        });
      },
    );
  }

  void _openPaymentModal() {
    final name = _nameController.text.trim();
    final nik = _nikController.text.trim();

    if (name.isEmpty || nik.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Mohon lengkapi Nama dan NIK KTP penumpang."),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    TrainPaymentModalSheet.show(
      context,
      basePrice: _ticketPrice + (_includeMeal ? _mealPrice : 0),
      insurancePrice: _includeInsurance ? _insurancePrice : 0,
      serviceFee: _serviceFee,
      onPaymentSuccess: (paymentData) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TrainBoardingPassReceiptPage(
              bookingData: {
                'passengerName': name,
                'passengerNik': nik,
                'carriage': _selectedCarriage,
                'seat': _selectedSeat,
                'paymentMethod': paymentData['paymentMethod'],
                'totalAmount': paymentData['totalAmount'],
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pemesanan Tiket Kereta",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Session Timer Banner (15 Minutes)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      color: Color(0xFF2563EB), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Sisa Waktu Sesi Pemesanan: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2. Train Trip Summary Card
            _buildTripSummaryCard(),
            const SizedBox(height: 18),

            // 3. Seat & Carriage Selection Box
            _buildSeatSelectionBox(),
            const SizedBox(height: 24),

            // 4. Passenger Form Section
            _buildPassengerForm(),
            const SizedBox(height: 24),

            // 5. Trip Addons (Insurance & Meals)
            _buildAddonsSection(),
            const SizedBox(height: 24),

            // 6. Price Summary Breakdown
            _buildPriceBreakdownCard(),
            const SizedBox(height: 28),

            // 7. Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _openPaymentModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Lanjutkan Pembayaran (Rp ${_formatNumber(_calculatedTotalPrice)})",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.train_rounded,
                      color: Color(0xFFFF7A00),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Argo Parahyangan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        "KA 40 • Eksekutif",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "Rp ${_formatNumber(_ticketPrice)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("08:30",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text("St. Gambir (GMR)",
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155))),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.arrow_forward_rounded, color: Color(0xFF94A3B8)),
                  SizedBox(height: 2),
                  Text("2j 45m",
                      style:
                          TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("11:15",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text("St. Bandung (BD)",
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatSelectionBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.event_seat_rounded,
                    color: Color(0xFF2563EB), size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kursi Terpilih",
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(
                    "$_selectedCarriage • Kursi $_selectedSeat",
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          OutlinedButton(
            onPressed: _openSeatSelector,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              side: const BorderSide(color: Color(0xFF2563EB)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text("Ubah",
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Data Penumpang 1 (Dewasa)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text("Sesuai KTP",
                style: TextStyle(fontSize: 12, color: Color(0xFF2563EB))),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField("Nama Lengkap", "Contoh: Zainal Salamun",
            controller: _nameController),
        const SizedBox(height: 12),
        _buildInputField("Nomor Induk Kependudukan (NIK KTP)",
            "3201234567890001",
            controller: _nikController, keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        _buildInputField("Nomor Handphone", "081234567890",
            controller: _phoneController, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _buildAddonsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Layanan Tambahan",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // Insurance Switch
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _includeInsurance,
            onChanged: (val) {
              setState(() {
                _includeInsurance = val;
              });
            },
            title: const Text("Asuransi Perjalanan KAI Care",
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
            subtitle: const Text(
                "Kompensasi pembatalan & kecelakaan hingga Rp 50 Juta",
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            secondary: const Icon(Icons.shield_outlined,
                color: Color(0xFF2563EB), size: 22),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // Meals Switch
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _includeMeal,
            onChanged: (val) {
              setState(() {
                _includeMeal = val;
              });
            },
            title: const Text("Nasi Goreng Parahyangan + Teh",
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
            subtitle: const Text("Disajikan hangat oleh kru restorasi kereta",
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            secondary: const Icon(Icons.restaurant_rounded,
                color: Color(0xFFFF7A00), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildRowPrice("Tiket Eksekutif (1x)", _ticketPrice),
          if (_includeInsurance) ...[
            const SizedBox(height: 6),
            _buildRowPrice("Asuransi Perjalanan", _insurancePrice),
          ],
          if (_includeMeal) ...[
            const SizedBox(height: 6),
            _buildRowPrice("Makanan Restorasi Kereta", _mealPrice),
          ],
          const SizedBox(height: 6),
          _buildRowPrice("Biaya Layanan Sistem", _serviceFee),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                "Rp ${_formatNumber(_calculatedTotalPrice)}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowPrice(String label, int amount) {
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

  Widget _buildInputField(String label, String hint,
      {required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
