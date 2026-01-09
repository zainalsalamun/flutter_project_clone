import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: const Color(0xFFF6F6F6),
        foregroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: const Center(child: Text('Reviews Content')),
    );
  }
}
