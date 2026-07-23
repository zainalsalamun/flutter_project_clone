import 'package:flutter/material.dart';
import 'widgets/smart_device_card.dart';

class LuminaHomePage extends StatefulWidget {
  const LuminaHomePage({super.key});

  @override
  State<LuminaHomePage> createState() => _LuminaHomePageState();
}

class _LuminaHomePageState extends State<LuminaHomePage> {
  // Global power state for the room
  bool _isRoomPowered = true;
  final double _temperature = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F28), // Deep slate background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Home,',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Alex Morgan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
                    backgroundColor: Colors.grey,
                  ),
                ],
              ),
            ),

            // Environmental Control Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Living Room',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_temperature°C • 45% Humidity',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRoomPowered = !_isRoomPowered;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.power_settings_new_rounded,
                          color: _isRoomPowered ? Colors.white : Colors.white54,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Devices Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Smart Devices',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  const SmartDeviceCard(
                    title: 'Smart Light',
                    subtitle: 'Living Room',
                    icon: Icons.lightbulb_outline,
                    initialPowerState: true,
                    activeColor: Color(0xFFF59E0B), // Amber
                  ),
                  const SmartDeviceCard(
                    title: 'Air Conditioner',
                    subtitle: '24°C Auto',
                    icon: Icons.ac_unit,
                    initialPowerState: false,
                    activeColor: Color(0xFF3B82F6), // Blue
                  ),
                  const SmartDeviceCard(
                    title: 'Smart TV',
                    subtitle: 'Samsung QLED',
                    icon: Icons.tv,
                    initialPowerState: true,
                    activeColor: Color(0xFF8B5CF6), // Purple
                  ),
                  const SmartDeviceCard(
                    title: 'Router',
                    subtitle: 'Online',
                    icon: Icons.router,
                    initialPowerState: true,
                    activeColor: Color(0xFF10B981), // Emerald
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1F28),
        selectedItemColor: const Color(0xFFF59E0B),
        unselectedItemColor: Colors.white54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Stats',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mic_none), label: 'Voice'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
