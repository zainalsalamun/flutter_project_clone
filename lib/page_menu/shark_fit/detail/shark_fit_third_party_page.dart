import 'package:flutter/material.dart';

class SharkFitThirdPartyPage extends StatelessWidget {
  const SharkFitThirdPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Third-party Access',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildThirdPartyItem(
                    icon: Icons.health_and_safety, // Placeholder for Google Fit
                    iconColor: Colors.red,
                    title: 'Google Fit',
                    isConnected: false,
                  ),
                  _buildDivider(),
                  _buildThirdPartyItem(
                    icon: Icons.directions_run, // Placeholder for Strava
                    iconColor: Colors.deepOrange,
                    title: 'Strava',
                    isConnected: true,
                  ),
                  _buildDivider(),
                  _buildThirdPartyItem(
                    icon: Icons.apple,
                    iconColor: Colors.black,
                    title: 'Apple Health',
                    isConnected: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Sync your health data with these third-party services to get a comprehensive view of your fitness.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
    );
  }

  Widget _buildThirdPartyItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isConnected,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            isConnected ? 'Connected' : 'Link',
            style: TextStyle(
              color: isConnected ? Colors.grey : const Color(0xFF00C853),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isConnected) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Color(0xFF00C853), size: 20),
          ] else ...[
            const SizedBox(width: 4),
            const Icon(Icons.check_circle, color: Colors.grey, size: 20),
          ],
        ],
      ),
    );
  }
}
