import 'package:flutter/material.dart';

class TixIdFooter extends StatelessWidget {
  final VoidCallback? onBackToTop;

  const TixIdFooter({super.key, this.onBackToTop});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.movie_filter,
            size: 48,
            color: Colors.amber,
          ), // Clapperboard placeholder
          const SizedBox(height: 8),
          Text(
            "Dan... Cut! Yuks coba lihat lagi dari\npaling atas.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onBackToTop,
            child: const Text(
              "Kembali ke atas",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
