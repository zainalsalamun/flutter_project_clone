import 'package:flutter/material.dart';

class SharkFitDevicePage extends StatelessWidget {
  const SharkFitDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Title
          const Text(
            'Black Shark GTN',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // Device Card
          Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'F6:5F:53:E4:8E:BC',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Connected',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          '20%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.battery_3_bar,
                          size: 20,
                          color: Colors.green.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Watch Image Placeholder
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Simple shape to represent watch
                      Container(
                        width: 60,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black, // Screen
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade800),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.bolt,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                      ),
                      // Strap
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Watch Faces Header
          const Text(
            'Watch Faces',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Watch Faces Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWatchFaceItem(
                  label: 'Edit',
                  labelColor: Colors.white,
                  labelBgColor: const Color(0xFF00C853),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.blueAccent],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "09:28",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildWatchFaceItem(
                  label: 'DIAL 2',
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.change_history,
                          color: Colors.green,
                          size: 40,
                        ),
                        const Positioned(
                          bottom: 10,
                          child: Text(
                            "10:09",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildWatchFaceItem(
                  label: 'DIAL 3',
                  child: Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        "10:09",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Courier',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildWatchFaceItem(
                  label: 'DIAL 4',
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "10:09",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Settings Group 1
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildSettingsItem(
              Icons.notifications,
              Colors.blue,
              'Notifications',
              isLast: true,
            ),
          ),
          const SizedBox(height: 16),

          // Settings Group 2
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  Icons.contacts,
                  const Color(0xFF00C853),
                  'Favorite Contacts',
                ),
                _buildDivider(),
                _buildSettingsItem(Icons.alarm, Colors.orange, 'Alarms'),
                _buildDivider(),
                _buildSettingsItem(
                  Icons.camera_alt,
                  Colors.amber,
                  'Shutter',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Settings Group 3
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(Icons.search, Colors.cyan, 'Find Device'),
                _buildDivider(),
                _buildSettingsItem(
                  Icons.more_horiz,
                  Colors.blueAccent,
                  'Others',
                ),
                _buildDivider(),
                _buildSettingsItem(
                  Icons.cloud_upload,
                  Colors.orange,
                  'Upgrade',
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Remove Device Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Remove Device',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 46), // Align with text
      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
    );
  }

  Widget _buildWatchFaceItem({
    required String label,
    required Widget child,
    Color? labelColor,
    Color? labelBgColor,
  }) {
    return Column(
      children: [
        Container(
          width: 100, // Roughly watch face size
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: child,
          ),
        ),
        const SizedBox(height: 12),
        labelBgColor != null
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: labelBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: labelColor ?? Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            : Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    Color iconColor,
    String title, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}
