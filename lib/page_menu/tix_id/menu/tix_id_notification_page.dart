import 'package:flutter/material.dart';

class TixIdNotificationPage extends StatelessWidget {
  const TixIdNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color: Color(0xFF1A2C50),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2C50)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        itemCount: 15,
        separatorBuilder:
            (context, index) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF1A2C50),
              ),
            ),
            title: Text(
              "Promo Spesial Hari Ini! ${index + 1}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2C50),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Dapatkan diskon hingga 50% untuk pembelian tiket bioskop favoritmu. Cek sekarang sebelum kehabisan!",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "2 Jam lalu",
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
                if (index < 5) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            onTap: () {
              // Handle individual notification tap if needed
            },
          );
        },
      ),
    );
  }
}
