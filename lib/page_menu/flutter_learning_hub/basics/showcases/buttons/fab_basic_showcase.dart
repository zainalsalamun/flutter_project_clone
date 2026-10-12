import 'package:flutter/material.dart';

class FabBasicShowcase extends StatefulWidget {
  const FabBasicShowcase({super.key});

  @override
  State<FabBasicShowcase> createState() => _FabBasicShowcaseState();
}

class _FabBasicShowcaseState extends State<FabBasicShowcase> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Mini FAB
                  FloatingActionButton.small(
                    heroTag: 'fab_mini_basic',
                    backgroundColor: const Color(0xFF10B981),
                    onPressed: () => setState(() => _counter++),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),

                  // Standard FAB
                  FloatingActionButton(
                    heroTag: 'fab_std_basic',
                    backgroundColor: const Color(0xFF6366F1),
                    onPressed: () => setState(() => _counter++),
                    child: const Icon(Icons.bolt, color: Colors.white),
                  ),

                  // Extended FAB
                  FloatingActionButton.extended(
                    heroTag: 'fab_ext_basic',
                    backgroundColor: const Color(0xFFF59E0B),
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    label: const Text(
                      'Kirim Data',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => setState(() => _counter++),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total FAB Pressed: $_counter kali',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Tips FloatingActionButton:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        const Text(
          '• Gunakan `FloatingActionButton.extended(...)` jika membutuhkan icon dan teks label.\n• Gunakan `heroTag: null` atau unique key jika ada lebih dari 1 FAB di satu halaman untuk mencegah konflik Hero animation.',
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
        ),
      ],
    );
  }
}
