import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:project_clone/page_menu/shark_fit/shark_fit_workout_page.dart';
import 'package:project_clone/page_menu/shark_fit/shark_fit_device_page.dart';
import 'package:project_clone/page_menu/shark_fit/shark_fit_profile_page.dart';
import 'package:project_clone/page_menu/shark_fit/shark_fit_intake_page.dart';
import 'package:project_clone/page_menu/shark_fit/shark_fit_edit_card_page.dart';

class SharkFitHomePage extends StatefulWidget {
  const SharkFitHomePage({super.key});

  @override
  State<SharkFitHomePage> createState() => _SharkFitHomePageState();
}

class _SharkFitHomePageState extends State<SharkFitHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DashboardPage(),
    const SharkFitWorkoutPage(),
    const SharkFitDevicePage(),
    const SharkFitProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.favorite, const Color(0xFF00C853), 0),
            _buildNavItem(
              Icons.directions_run_outlined,
              const Color(0xFF00C853),
              1,
            ),
            _buildNavItem(Icons.watch_outlined, const Color(0xFF00C853), 2),
            _buildNavItem(Icons.person_outline, const Color(0xFF00C853), 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, Color activeColor, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            isActive
                ? BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(12),
                )
                : null,
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
          size: 26,
        ),
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Header
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'True faith requires us to be open-minded and willing to learn and grow from new experiences.',
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),

            // Summary Sections (Stats & Rings)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Stats Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(
                      color: const Color(0xFF00B0FF), // Blue
                      value: '1451',
                      label: 'Steps',
                      isBold: true,
                    ),
                    const SizedBox(height: 20),
                    _buildStatRow(
                      color: const Color(0xFFFF9800), // Orange
                      value: '65',
                      label: 'Kcal',
                      isBold: true,
                    ),
                    const SizedBox(height: 20),
                    _buildStatRow(
                      color: const Color(0xFF4CAF50), // Green
                      value: '--', // Using dash as per screenshot
                      label: 'Mins',
                      isBold: true,
                      isDashed: true,
                    ),
                  ],
                ),
                const Spacer(),
                // Rings
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CustomPaint(painter: _RingsPainter()),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Activity Card
            _buildCard(
              icon: Icons.directions_run,
              iconColor: const Color(0xFF00B0FF), // Blue
              title: 'Activity',
              date: '13 Jan. 2026 Tue 10:16',
              value: '1451',
              unit: 'Steps',
              content: const _ActivityBarChart(),
            ),
            const SizedBox(height: 24),

            // Sleep Card
            _buildCard(
              icon: Icons.hotel, // Closest match
              iconColor: const Color(0xFF7E57C2), // Purple
              title: 'Sleep',
              date: '13 Jan. 2026 Tue 10:16',
              value: '-- H --',
              unit: 'M',
              content: const _SleepGraph(),
            ),
            const SizedBox(height: 24),

            // Heart Rate Card
            _buildCard(
              icon: Icons.favorite,
              iconColor: const Color(0xFFEF5350), // Red
              title: 'Heart Rate',
              date: '',
              value: '-- BPM',
              unit: '',
              content: const _HeartRateChart(),
              showDate: false,
            ),
            const SizedBox(height: 24),

            // Blood Oxygen Card
            _buildCard(
              icon: Icons.water_drop,
              iconColor: const Color(0xFF26A69A), // Teal/Cyan
              title: 'Blood Oxygen',
              date: '',
              value: '-- %',
              unit: '',
              content: const _BloodOxygenGauge(),
              showDate: false,
            ),
            const SizedBox(height: 24),

            // Weight Card
            _buildCard(
              icon: Icons.monitor_weight_outlined,
              iconColor: const Color(0xFF00C853), // Green
              title: 'Weight',
              date: '13 Jan. 2026 Tue 10:16',
              value: '65.0',
              unit: 'Kg',
              content: const _WeightGraph(),
              isWeightCard: true, // Special layout for weight
            ),
            const SizedBox(height: 24),

            // Intake Reminder Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SharkFitIntakePage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF03A9F4), // Light Blue
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_drink,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Intake Reminder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View drink records',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Edit Data Card Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SharkFitEditCardPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.swap_vert, color: Colors.black87),
                label: const Text(
                  'Edit Data Card',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80), // Bottom padding for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required Color color,
    required String value,
    required String label,
    required bool isBold,
    bool isDashed = false,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        isDashed
            ? Row(
              children: [
                Container(width: 12, height: 3, color: Colors.black87),
                const SizedBox(width: 4),
                Container(width: 12, height: 3, color: Colors.black87),
              ],
            )
            : Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String date,
    required String value,
    required String unit,
    required Widget content,
    bool showDate = true,
    bool isWeightCard = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (showDate) ...[
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isWeightCard) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height:
                isWeightCard ? 150 : 120, // Adjust height based on card type
            child: content,
          ),
        ],
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 14.0;

    // Background Circles (Light)
    final bgPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Outer Ring (Blue)
    bgPaint.color = const Color(0xFFE1F5FE); // Light Blue
    canvas.drawCircle(center, 60, bgPaint);

    // Middle Ring (Orange)
    bgPaint.color = const Color(0xFFFFE0B2); // Light Orange
    canvas.drawCircle(center, 44, bgPaint);

    // Inner Ring (Green)
    bgPaint.color = const Color(0xFFE8F5E9); // Light Green
    canvas.drawCircle(center, 28, bgPaint);

    // Progress Arcs
    final progressPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Outer Progress (Blue)
    progressPaint.color = const Color(0xFF00B0FF);
    // Draw arc starting from top (-pi/2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 60),
      -math.pi / 2, // Start at top
      math.pi * 0.4, // Mock progress
      false,
      progressPaint,
    );

    // Middle Progress (Orange)
    progressPaint.color = const Color(0xFFFF9800);
    // Offset start slightly
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 44),
      -math.pi / 2 + 0.2, // Slightly offset
      math.pi * 1.2, // More progress
      false,
      progressPaint,
    );

    // Inner Progress (Green) - Very small dot as per image
    progressPaint.color = const Color(0xFF4CAF50);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 28),
      -math.pi / 2,
      0.1, // Tiny dot
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityBarChart extends StatelessWidget {
  const _ActivityBarChart();

  @override
  Widget build(BuildContext context) {
    // Generate some mock bar heights typical for activity charts
    final heights = [
      0.1, 0.1, 0.15, 0.1, 0.1, 0.1, 0.15, 0.1, 0.1, 0.1, // Low activity
      0.6, 0.4, 0.8, 0.5, 0.2, // Spike
      0.1, 0.1, 0.3, 0.4, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
      0.1, 0.1, 0.7, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, // Another spike
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          heights.map((h) {
            return Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                height: 100 * h, // Scale to chart height
                decoration: BoxDecoration(
                  color: const Color(0xFF00B0FF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _SleepGraph extends StatelessWidget {
  const _SleepGraph();

  @override
  Widget build(BuildContext context) {
    // Implementing the blocky sleep graph look
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final blockWidth = width / 20; // 20 intervals

        // Mock data for sleep stages (Deep, Light, Awake)
        final stages = [
          1,
          0,
          1,
          1,
          0,
          2,
          0,
          1,
          0,
          1,
          2,
          0,
          1,
          0,
          1,
          1,
          2,
          1,
          0,
          2,
        ];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:
              stages.map((stage) {
                double blockHeight = 0;
                double bottomMargin = 0;
                Color color = const Color(0xFF7E57C2);

                if (stage == 2) {
                  // Top (Awake-ish)
                  blockHeight = height * 0.3;
                  bottomMargin = height * 0.6;
                  color = const Color(0xFF9575CD); // Lighter purple
                } else if (stage == 1) {
                  // Middle
                  blockHeight = height * 0.4;
                  bottomMargin = height * 0.2;
                } else {
                  // Bottom (Deep)
                  blockHeight = height * 0.3;
                  bottomMargin = 0;
                }

                return Container(
                  width: blockWidth - 2, // Gap
                  height: blockHeight,
                  margin: EdgeInsets.only(
                    left: 1,
                    right: 1,
                    bottom: bottomMargin, // Lift the block up
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}

class _HeartRateChart extends StatelessWidget {
  const _HeartRateChart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildBar(Colors.blue, 1),
              _buildBar(Colors.green, 2),
              _buildBar(Colors.amber, 2),
              _buildBar(Colors.orange, 2),
              _buildBar(Colors.red.shade400, 2),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Light', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('Weight', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('Aerobic', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              'Anaerobic',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text('VO2 Max', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildBar(Color color, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _BloodOxygenGauge extends StatelessWidget {
  const _BloodOxygenGauge();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF26A69A), width: 1.5),
          ),
          alignment: Alignment.centerLeft,
          // Empty bar as per screenshot ("-- %")
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('80', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('85', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('90', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('95', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('100', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _WeightGraph extends StatelessWidget {
  const _WeightGraph();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Green line
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(height: 1, color: const Color(0xFF00C853)),
        ),
        // Center label "65.0"
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: const Center(
            child: Text(
              '65.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
        // The dot
        const Center(
          child: CircleAvatar(
            radius: 4,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 2.5,
              backgroundColor: Color(0xFF00C853),
            ),
          ),
        ),
      ],
    );
  }
}
