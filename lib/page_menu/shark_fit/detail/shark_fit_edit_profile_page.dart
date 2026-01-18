import 'package:flutter/material.dart';

class SharkFitEditProfilePage extends StatefulWidget {
  const SharkFitEditProfilePage({super.key});

  @override
  State<SharkFitEditProfilePage> createState() =>
      _SharkFitEditProfilePageState();
}

class _SharkFitEditProfilePageState extends State<SharkFitEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF00C853),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // List of profile items
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildAvatarItem(),
                  _buildDivider(),
                  _buildProfileItem('Nickname', 'John Doe'),
                  _buildDivider(),
                  _buildProfileItem('Gender', 'Male'),
                  _buildDivider(),
                  _buildProfileItem('Birthday', '1990-01-01'),
                  _buildDivider(),
                  _buildProfileItem('Height', '175 cm'),
                  _buildDivider(),
                  _buildProfileItem('Weight', '70 kg', isLast: true),
                ],
              ),
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

  Widget _buildAvatarItem() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picker
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Text(
              'Avatar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value, {bool isLast = false}) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement edit dialog/page
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
