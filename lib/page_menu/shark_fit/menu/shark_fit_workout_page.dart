import 'package:flutter/material.dart';

class SharkFitWorkoutPage extends StatefulWidget {
  const SharkFitWorkoutPage({super.key});

  @override
  State<SharkFitWorkoutPage> createState() => _SharkFitWorkoutPageState();
}

class _SharkFitWorkoutPageState extends State<SharkFitWorkoutPage> {
  int _selectedTab = 0; // 0: Running, 1: Walking, 2: Cycling
  int _selectedRunType = 0; // 0: GPS Running, 1: Trail, 2: Indoor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Workout',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Link
                  Row(
                    children: const [
                      Text(
                        'View Exercise Records',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem('0', 'Mins', 'Total exercise time'),
                      _buildStatItem('0', 'Times', 'Total times'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTabItem(0, 'Running'),
                      _buildTabItem(1, 'Walking'),
                      _buildTabItem(2, 'Cycling'),
                    ],
                  ),
                ],
              ),
            ),

            // Map / Main Content Area
            Expanded(
              child: Stack(
                children: [
                  // Map Background (Mock)
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFF0F4C3), // Light map-like color
                      child: Stack(
                        children: [
                          // Drawn Grid/Streets Mock
                          Positioned(
                            top: 50,
                            left: 0,
                            right: 0,
                            height: 20,
                            child: Container(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            top: 150,
                            left: 0,
                            right: 0,
                            height: 15,
                            child: Container(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 100,
                            width: 20,
                            child: Container(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 80,
                            width: 25,
                            child: Container(
                              color: Colors.blue.withOpacity(0.2),
                            ),
                          ), // River
                          // Center Locator Icon
                          const Center(
                            child: Icon(
                              Icons.navigation,
                              color: Color(0xFF00C853),
                              size: 40,
                            ),
                          ),
                          // Random POI Icons
                          const Positioned(
                            top: 100,
                            left: 40,
                            child: Icon(
                              Icons.train,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const Positioned(
                            bottom: 200,
                            right: 60,
                            child: Icon(
                              Icons.local_dining,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top Overlay (GPS & Weather)
                  Positioned(
                    top: 16,
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'GPS:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Row(
                                children: List.generate(
                                  4,
                                  (index) => Container(
                                    width: 4,
                                    height: 10,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    color:
                                        index < 2
                                            ? Colors.green
                                            : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.watch, size: 14, color: Colors.blue),
                              SizedBox(width: 4),
                              Text('Connected', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.cloud, size: 14, color: Colors.orange),
                              SizedBox(width: 4),
                              Text('27°C', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Controls Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.white, Colors.white.withOpacity(0.0)],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Run Type Selector
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                _buildRunTypeItem(0, 'GPS Running'),
                                Container(
                                  width: 1,
                                  height: 16,
                                  color: Colors.grey.shade300,
                                ),
                                _buildRunTypeItem(1, 'GPS Trail Running'),
                                Container(
                                  width: 1,
                                  height: 16,
                                  color: Colors.grey.shade300,
                                ),
                                _buildRunTypeItem(2, 'Indoor Running'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Main Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCircleButton(Icons.refresh),

                              // Start Button
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C853),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF00C853,
                                      ).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.directions_run,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    Text(
                                      'Start',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              _buildCircleButton(Icons.settings_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String unit, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFF00C853) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 2,
            color: isSelected ? const Color(0xFF00C853) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildRunTypeItem(int index, String label) {
    final isSelected = _selectedRunType == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedRunType = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? const Color(0xFF00C853) : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.grey.shade700),
    );
  }
}
