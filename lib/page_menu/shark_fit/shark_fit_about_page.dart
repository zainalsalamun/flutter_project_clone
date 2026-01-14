import 'package:flutter/material.dart';

class SharkFitAboutPage extends StatelessWidget {
  const SharkFitAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // App Logo
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.fitness_center, // Placeholder logo
                size: 40,
                color: Color(0xFF00C853),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Shark Fit",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Version 2.0.1",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 40),

          // Menu Items
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildAboutItem("User Agreement"),
                _buildDivider(),
                _buildAboutItem("Privacy Policy"),
                _buildDivider(),
                _buildAboutItem("Check for Updates", trailing: "v2.0.1"),
              ],
            ),
          ),

          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              "Copyright © 2024 Shark Fit. All Rights Reserved.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
    );
  }

  Widget _buildAboutItem(String title, {String? trailing}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
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
            if (trailing != null) ...[
              Text(trailing, style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
