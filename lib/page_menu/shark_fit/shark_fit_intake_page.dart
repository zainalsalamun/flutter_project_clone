import 'package:flutter/material.dart';

class SharkFitIntakePage extends StatefulWidget {
  const SharkFitIntakePage({super.key});

  @override
  State<SharkFitIntakePage> createState() => _SharkFitIntakePageState();
}

class _SharkFitIntakePageState extends State<SharkFitIntakePage> {
  int _currentIntake = 0;
  final int _goal = 2000;

  void _addIntake(int amount) {
    setState(() {
      _currentIntake = (_currentIntake + amount).clamp(
        0,
        _goal * 2,
      ); // Cap at 2x goal for safety
    });
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (_currentIntake / _goal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context), // Close works as Back here
        ),
        title: const Text(
          'Intake Reminder',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Stats
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$_currentIntake',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const TextSpan(
                    text: ' ml',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Water intake goal: $_goal ml',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 40),

            // Water Glass Visualization
            Center(
              child: SizedBox(
                width: 180,
                height: 240,
                child: CustomPaint(
                  painter: WaterGlassPainter(percentage: percentage),
                  child: Center(
                    child: Text(
                      '${(percentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color:
                            percentage > 0.5
                                ? Colors.white
                                : Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Quick Add Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickAddButton(100),
                const SizedBox(width: 32),
                _buildQuickAddButton(200),
                const SizedBox(width: 32),
                _buildQuickAddButton(400),
              ],
            ),
            const SizedBox(height: 24),

            // Main Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addIntake(200), // Default add
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40C4FF), // Cyan/Light Blue
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '+ Add intake',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Record Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Drinking water record',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_currentIntake == 0)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_drink_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Didn't drink water today, let's drink some!",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  else
                    // Simple list of intakes if any (basic implementation)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          (_currentIntake / 200)
                              .ceil(), // Mock items based on intake
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '10:00 AM',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const Spacer(),
                              const Text(
                                '200 ml',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddButton(int amount) {
    return GestureDetector(
      onTap: () => _addIntake(amount),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              // Using transparent to match screenshot which shows just icon
              // Or maybe light blue background? Screenshot has blue cup icon.
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Icon(
                  Icons.local_drink,
                  size: 32,
                  color: const Color(0xFF40C4FF), // Cyan
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF40C4FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$amount ml',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class WaterGlassPainter extends CustomPainter {
  final double percentage;

  WaterGlassPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Glass shape path (Trapezoid with rounded corners)
    final Path glassPath = Path();
    double bottomWidth = size.width * 0.6;
    double topWidth = size.width * 0.9;

    double bottomX = (size.width - bottomWidth) / 2;
    double topX = (size.width - topWidth) / 2;

    glassPath.moveTo(topX, 0); // Top Left
    glassPath.lineTo(size.width - topX, 0); // Top Right
    glassPath.lineTo(
      size.width - bottomX,
      size.height - 20,
    ); // Bottom Right (before radius)

    // Bottom Curve
    glassPath.quadraticBezierTo(
      size.width / 2,
      size.height, // Control point
      bottomX,
      size.height - 20, // End point
    );

    glassPath.lineTo(topX, 0); // Close shape

    // Draw Glass Background (Empty)
    paint.color = const Color(0xFFE0E0E0).withOpacity(0.5); // Light Grey
    canvas.drawPath(glassPath, paint);

    // Draw Water
    if (percentage > 0) {
      canvas.save();
      canvas.clipPath(glassPath); // Clip to glass shape

      paint.color = const Color(0xFF40C4FF); // Water Blue

      double waterHeight = size.height * percentage;
      double waterTop = size.height - waterHeight;

      canvas.drawRect(
        Rect.fromLTWH(0, waterTop, size.width, waterHeight),
        paint,
      );

      // Optional: Draw slightly darker top surface for water if needed

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant WaterGlassPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
