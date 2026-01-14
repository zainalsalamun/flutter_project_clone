import 'package:flutter/material.dart';

class SharkFitEditCardPage extends StatefulWidget {
  const SharkFitEditCardPage({super.key});

  @override
  State<SharkFitEditCardPage> createState() => _SharkFitEditCardPageState();
}

class _SharkFitEditCardPageState extends State<SharkFitEditCardPage> {
  // Initial list of visible cards
  final List<Map<String, dynamic>> _visibleItems = [
    {
      'icon': Icons.directions_run,
      'color': const Color(0xFF00B0FF),
      'title': 'Activity',
    },
    {'icon': Icons.hotel, 'color': const Color(0xFF7E57C2), 'title': 'Sleep'},
    {
      'icon': Icons.favorite,
      'color': const Color(0xFFEF5350),
      'title': 'Heart Rate',
    },
    {
      'icon': Icons.water_drop,
      'color': const Color(0xFF26A69A),
      'title': 'Blood Oxygen',
    },
    {
      'icon': Icons.monitor_weight_outlined,
      'color': const Color(0xFF00C853),
      'title': 'Weight',
    },
    {
      'icon': Icons.local_drink,
      'color': const Color(0xFF03A9F4),
      'title': 'Intake Reminder',
    },
  ];

  final List<Map<String, dynamic>> _hiddenItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Data Card',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Save action (mock)
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF00C853),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Show on Home',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Press and hold the right side of the list and drag up or down to adjust the order.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Visible Items List (Reorderable)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int index = 0; index < _visibleItems.length; index++)
                    _buildListItem(
                      key: ValueKey(_visibleItems[index]['title']),
                      item: _visibleItems[index],
                      isLast: index == _visibleItems.length - 1,
                    ),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = _visibleItems.removeAt(oldIndex);
                    _visibleItems.insert(newIndex, item);
                  });
                },
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              'Hide from Home',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            if (_hiddenItems.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  "No hidden cards",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Implementation for hidden items if needed
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required Key key,
    required Map<String, dynamic> item,
    required bool isLast,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item['color'],
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'], color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const Icon(Icons.drag_handle, color: Colors.grey),
        ],
      ),
    );
  }
}
