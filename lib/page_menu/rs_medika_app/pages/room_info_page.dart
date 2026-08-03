import 'package:flutter/material.dart';

class RoomInfoPage extends StatelessWidget {
  const RoomInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Informasi Ruang',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildWardCard('Alamanda', [
            {'type': 'III', 'available': 2},
            {'type': 'II', 'available': 0},
            {'type': 'I', 'available': 2},
          ]),
          _buildWardCard('Anggrek', [
            {'type': 'III', 'available': 1},
            {'type': 'II', 'available': 5},
          ]),
          _buildWardCard('Aster', [
            {'type': 'ISO', 'available': 0},
          ]),
          _buildWardCard('Edelweiss', [
            {'type': 'I', 'available': 0},
            {'type': 'VIP', 'available': 0},
          ]),
        ],
      ),
    );
  }

  Widget _buildWardCard(String wardName, List<Map<String, dynamic>> rooms) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Orange Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade500,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.meeting_room, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  wardName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    'Type Ruangan',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tersedia',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 24), // Placeholder for dropdown icon alignment
              ],
            ),
          ),
          // Rows
          ...rooms.map((room) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      room['type'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${room['available']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                    size: 20,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
