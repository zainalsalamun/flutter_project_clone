import 'package:flutter/material.dart';

class RefreshIndicatorBasicShowcase extends StatefulWidget {
  const RefreshIndicatorBasicShowcase({super.key});

  @override
  State<RefreshIndicatorBasicShowcase> createState() =>
      _RefreshIndicatorBasicShowcaseState();
}

class _RefreshIndicatorBasicShowcaseState
    extends State<RefreshIndicatorBasicShowcase> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  List<String> _items = ['Data Awal #1', 'Data Awal #2', 'Data Awal #3'];
  int _refreshCount = 0;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _refreshCount++;
      _items = [
        'Data Refreshed v$_refreshCount.1',
        'Data Refreshed v$_refreshCount.2',
        'Data Refreshed v$_refreshCount.3',
        'Data Refreshed v$_refreshCount.4',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          clipBehavior: Clip.hardEdge,
          child: RefreshIndicator(
            key: _refreshKey,
            color: const Color(0xFF6366F1),
            backgroundColor: Colors.white,
            strokeWidth: 3.0,
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sync_rounded,
                        color: Color(0xFF6366F1),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _items[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'RefreshIndicator Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _refreshKey.currentState?.show(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Trigger Pull to Refresh Programmatically'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Total Refresh Selesai: $_refreshCount kali (atau tarik list ke bawah)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
