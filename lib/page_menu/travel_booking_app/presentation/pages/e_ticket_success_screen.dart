import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../data/models/travel_item_model.dart';
import '../widgets/animated_booking_button.dart';
import '../widgets/ticket_pass_painter.dart';

class ETicketSuccessScreen extends StatefulWidget {
  final BookingOrder order;

  const ETicketSuccessScreen({
    super.key,
    required this.order,
  });

  @override
  State<ETicketSuccessScreen> createState() => _ETicketSuccessScreenState();
}

class _ETicketSuccessScreenState extends State<ETicketSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyBookingCode() {
    Clipboard.setData(ClipboardData(text: widget.order.bookingCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode booking ${widget.order.bookingCode} berhasil disalin! 📋'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: TravelTheme.dark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.order.flight;
    final destination = widget.order.destination;

    return Scaffold(
      backgroundColor: TravelTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: TravelTheme.dark),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          children: [
            // Success Animated Checkmark
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: TravelTheme.emerald,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: TravelTheme.emerald.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _checkAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _AnimatedCheckmarkPainter(progress: _checkAnimation.value),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(
                color: TravelTheme.dark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'E-Ticket & Bukti Transaksi telah diterbitkan',
              style: TextStyle(
                color: TravelTheme.muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Digital Boarding Pass Ticket Card
            TicketPassCard(
              cutoutRadius: 16,
              cutoutPositionFactor: 0.68,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Card Header (Transport / Tour name + Status badge)
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
                                child: Icon(
                                  flight != null
                                      ? Icons.flight_takeoff_rounded
                                      : widget.order.train != null
                                          ? Icons.train_rounded
                                          : widget.order.experience != null
                                              ? Icons.explore_rounded
                                              : Icons.hotel_rounded,
                                  color: TravelTheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flight?.airlineName ??
                                          widget.order.train?.trainName ??
                                          widget.order.experience?.title ??
                                          destination?.title ??
                                          'Wanderlust Pass',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: TravelTheme.dark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      flight?.flightNumber ??
                                          widget.order.train?.trainNumber ??
                                          widget.order.experience?.duration ??
                                          destination?.tag ??
                                          'Confirmed Reservation',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: TravelTheme.muted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TravelTheme.emerald.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ISSUED',
                            style: TextStyle(
                              color: TravelTheme.emerald,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Flight / Train / Experience / Hotel Details
                    if (flight != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.originCode,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                flight.originCity,
                                style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.departureTime,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.flight_rounded, color: TravelTheme.primaryLight, size: 22),
                              const SizedBox(height: 2),
                              Text(
                                flight.duration,
                                style: const TextStyle(
                                  color: TravelTheme.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                flight.destinationCode,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                flight.destinationCity,
                                style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.arrivalTime,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else if (widget.order.train != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.order.train!.originCode,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                widget.order.train!.originCity,
                                style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.order.train!.departureTime,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.train_rounded, color: Color(0xFF0284C7), size: 22),
                              const SizedBox(height: 2),
                              Text(
                                widget.order.train!.duration,
                                style: const TextStyle(
                                  color: TravelTheme.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.order.train!.destinationCode,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                widget.order.train!.destinationCity,
                                style: const TextStyle(color: TravelTheme.muted, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.order.train!.arrivalTime,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else if (widget.order.experience != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Aktivitas Wisata', style: TextStyle(color: TravelTheme.muted, fontSize: 11)),
                              Text(
                                widget.order.experience!.categoryTag,
                                style: const TextStyle(
                                  color: TravelTheme.emerald,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Lokasi & Durasi', style: TextStyle(color: TravelTheme.muted, fontSize: 11)),
                              Text(
                                widget.order.experience!.location,
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Check-In', style: TextStyle(color: TravelTheme.muted, fontSize: 11)),
                              Text(
                                formatTravelDate(widget.order.travelDate),
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Lokasi', style: TextStyle(color: TravelTheme.muted, fontSize: 11)),
                              Text(
                                destination?.location ?? 'Bali',
                                style: const TextStyle(
                                  color: TravelTheme.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Passenger Details Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoColumn('PENUMPANG / TAMU', widget.order.passenger.fullName, flex: 3),
                        const SizedBox(width: 6),
                        _buildInfoColumn(
                          widget.order.experience != null ? 'SESI WAKTU' : 'KURSI / KAMAR',
                          widget.order.passenger.selectedSeat,
                          flex: 3,
                        ),
                        const SizedBox(width: 6),
                        _buildInfoColumn(
                          'KELAS / TIPE',
                          flight?.cabinClass ??
                              widget.order.train?.trainClass ??
                              (widget.order.experience != null ? 'VIP Tour' : 'Deluxe'),
                          crossAxisAlignment: CrossAxisAlignment.end,
                          flex: 3,
                        ),
                      ],
                    ),

                    const SizedBox(height: 48), // Spacing for cutout line

                    // Bottom QR Code & Booking Code Section
                    Row(
                      children: [
                        // QR Code Generator
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: TravelTheme.border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: QrImageView(
                            data: 'WANDERLUST-TICKET:${widget.order.bookingCode}|${widget.order.passenger.fullName}',
                            version: QrVersions.auto,
                            size: 80,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: TravelTheme.dark,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: TravelTheme.dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'KODE BOOKING (PNR)',
                                style: TextStyle(
                                  color: TravelTheme.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              GestureDetector(
                                onTap: _copyBookingCode,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.order.bookingCode,
                                      style: const TextStyle(
                                        color: TravelTheme.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.copy_rounded,
                                      color: TravelTheme.primaryLight,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Total: ${formatTravelCurrency(widget.order.totalPrice)} (${widget.order.paymentMethod})',
                                style: const TextStyle(
                                  color: TravelTheme.darkMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            AnimatedBookingButton(
              text: 'Unduh E-Ticket (PDF)',
              icon: Icons.download_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('E-Ticket PDF telah berhasil diunduh ke perangkat Anda 📄'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: TravelTheme.primary,
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(
                  color: TravelTheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: TravelTheme.muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: crossAxisAlignment == CrossAxisAlignment.end ? TextAlign.end : TextAlign.start,
            style: const TextStyle(
              color: TravelTheme.dark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCheckmarkPainter extends CustomPainter {
  final double progress;

  _AnimatedCheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final p1 = Offset(size.width * 0.28, size.height * 0.52);
    final p2 = Offset(size.width * 0.45, size.height * 0.68);
    final p3 = Offset(size.width * 0.74, size.height * 0.36);

    final totalLength1 = (p2 - p1).distance;
    final totalLength2 = (p3 - p2).distance;
    final totalLength = totalLength1 + totalLength2;

    final currentDistance = totalLength * progress;

    path.moveTo(p1.dx, p1.dy);

    if (currentDistance <= totalLength1) {
      final t = currentDistance / totalLength1;
      final currentPoint = Offset.lerp(p1, p2, t)!;
      path.lineTo(currentPoint.dx, currentPoint.dy);
    } else {
      path.lineTo(p2.dx, p2.dy);
      final remainingDistance = currentDistance - totalLength1;
      final t = remainingDistance / totalLength2;
      final currentPoint = Offset.lerp(p2, p3, t)!;
      path.lineTo(currentPoint.dx, currentPoint.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedCheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
