import 'package:flutter/material.dart';

class ListViewBasicShowcase extends StatefulWidget {
  const ListViewBasicShowcase({super.key});

  @override
  State<ListViewBasicShowcase> createState() => _ListViewBasicShowcaseState();
}

class _ListViewBasicShowcaseState extends State<ListViewBasicShowcase> {
  int _itemCount = 8;
  bool _useSeparated = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child:
              _useSeparated
                  ? ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _itemCount,
                    separatorBuilder:
                        (context, index) => const Divider(height: 12),
                    itemBuilder: (context, index) => _buildListItem(index),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _itemCount,
                    itemBuilder: (context, index) => _buildListItem(index),
                  ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'ListView Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'ListView.separated (Dengan Divider):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _useSeparated,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _useSeparated = v),
            ),
          ],
        ),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Item Count:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed:
                  _itemCount > 2 ? () => setState(() => _itemCount--) : null,
            ),
            Text(
              '$_itemCount',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed:
                  _itemCount < 30 ? () => setState(() => _itemCount++) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.15),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Item #${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Lazy rendered on scroll viewport',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
