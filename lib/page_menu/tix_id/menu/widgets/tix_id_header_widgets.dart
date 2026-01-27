import 'package:flutter/material.dart';

class TixIdAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TixIdAppBar({super.key});

  @override
  State<TixIdAppBar> createState() => _TixIdAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

class _TixIdAppBarState extends State<TixIdAppBar> {
  String selectedCity = "YOGYAKARTA";
  final List<String> cities = [
    "JAKARTA",
    "YOGYAKARTA",
    "BANDUNG",
    "SURABAYA",
    "MALANG",
    "SEMARANG",
    "BALI",
    "MEDAN",
    "MAKASSAR",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Search Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(Icons.search, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            "Cari di TIX ID",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile Icon
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 28,
                    color: Color(0xFF1A2C50),
                  ),
                  const SizedBox(width: 16),
                  // Notification Icon with Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_outlined,
                        size: 28,
                        color: Color(0xFF1A2C50),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "15",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Location Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCity,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                        isExpanded: true,
                        isDense:
                            true, // Reduces the vertical size of the button
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A2C50),
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCity = newValue;
                            });
                          }
                        },
                        items:
                            cities.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
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
}
