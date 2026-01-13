import 'package:flutter/material.dart';

class SharkFitProfilePage extends StatelessWidget {
  const SharkFitProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Header
          const Text(
            'My',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // Account Section Group
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.grid_view_rounded,
                  iconColor: Colors.blue,
                  title: 'Login and registration',
                  subtitle:
                      'After logging in, data can be synchronized to the server.',
                ),
                _buildDivider(),
                _buildProfileItem(
                  icon: Icons.edit,
                  iconColor: Colors.deepOrange,
                  title: 'Profile',
                ),
                _buildDivider(),
                _buildProfileItem(
                  icon: Icons.track_changes,
                  iconColor: Colors.orange,
                  title: 'Goal',
                  trailingText: '10000STEP',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Settings Section Group
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.share,
                  iconColor: const Color(0xFF00BFA5), // Teal
                  title: 'Third-party data management',
                ),
                _buildDivider(),
                _buildProfileItem(
                  icon: Icons.help_outline,
                  iconColor: Colors.amber,
                  title: 'Online Service',
                ),
                _buildDivider(),
                _buildProfileItem(
                  icon: Icons.open_in_new, // Strava-ish substitute
                  iconColor: Colors.deepOrangeAccent,
                  title: 'Strava',
                ),
                _buildDivider(),
                _buildProfileItem(
                  icon: Icons.description,
                  iconColor: Colors.blue,
                  title: 'About',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 56), // Align with text start
      child: Divider(height: 1, color: Color(0xFFF5F5F5)),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon with circular background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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
                    if (trailingText != null) ...[
                      Text(
                        trailingText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Chevron
          Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 24),
        ],
      ),
    );
  }
}
