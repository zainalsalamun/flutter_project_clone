import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/talenta/menu/clock_success_page.dart';
import 'package:project_clone/page_menu/talenta/menu/location_page.dart';

class ClockInOutPage extends StatefulWidget {
  final String pageTitle;

  const ClockInOutPage({super.key, this.pageTitle = 'Clock in'});

  @override
  State<ClockInOutPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInOutPage> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = now.day;
    final month = months[now.month - 1];
    final year = now.year;
    final dateStr = '$day $month $year';

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F), // Red branding
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.pageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Camera View Placeholder (Bottom Layer)
          Positioned.fill(
            child: Container(
              color: Colors.grey[800],
              child: CustomPaint(painter: FaceOutlinePainter()),
            ),
          ),

          // 2. Info Card (Top Layer)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'R',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$dateStr (08:00 - 17:00)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Sheet Panel (Bottom Layer, but visually on top of camera)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Notes Option
                    Row(
                      children: [
                        Icon(Icons.notes, color: Colors.grey[600]),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              hintText: 'Notes (optional)',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Location Option
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LocationPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Show location',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ClockSuccessPage(
                                    clockType: widget.pageTitle,
                                    submissionTime: DateTime.now(),
                                    notes: _notesController.text,
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1565C0,
                          ), // Blue button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}

// Custom Painter to draw a dotted face outline
class FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Simple oval for face approximation
    final center = Offset(size.width / 2, size.height * 0.4);
    final rect = Rect.fromCenter(center: center, width: 200, height: 280);

    // Draw dashed path logic (simplified)
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
