import 'package:flutter/material.dart';

enum ViewMode { day, week, month }

class SegmentedButtonBasicShowcase extends StatefulWidget {
  const SegmentedButtonBasicShowcase({super.key});

  @override
  State<SegmentedButtonBasicShowcase> createState() =>
      _SegmentedButtonBasicShowcaseState();
}

class _SegmentedButtonBasicShowcaseState
    extends State<SegmentedButtonBasicShowcase> {
  Set<ViewMode> _selectedMode = {ViewMode.week};
  Set<String> _multiSelect = {'dart', 'flutter'};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              const Text(
                'Single Selection:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<ViewMode>(
                segments: const [
                  ButtonSegment(
                    value: ViewMode.day,
                    label: Text('Hari'),
                    icon: Icon(Icons.calendar_view_day),
                  ),
                  ButtonSegment(
                    value: ViewMode.week,
                    label: Text('Minggu'),
                    icon: Icon(Icons.calendar_view_week),
                  ),
                  ButtonSegment(
                    value: ViewMode.month,
                    label: Text('Bulan'),
                    icon: Icon(Icons.calendar_month),
                  ),
                ],
                selected: _selectedMode,
                onSelectionChanged: (newSelection) {
                  setState(() => _selectedMode = newSelection);
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Multi Selection (Skills):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                multiSelectionEnabled: true,
                emptySelectionAllowed: true,
                segments: const [
                  ButtonSegment(value: 'dart', label: Text('Dart')),
                  ButtonSegment(value: 'flutter', label: Text('Flutter')),
                  ButtonSegment(value: 'firebase', label: Text('Firebase')),
                ],
                selected: _multiSelect,
                onSelectionChanged: (newSelection) {
                  setState(() => _multiSelect = newSelection);
                },
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Mode Terpilih: ${_selectedMode.first.name.toUpperCase()} | Multi: ${_multiSelect.join(", ")}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Keunggulan SegmentedButton (Material 3):',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        const Text(
          '• Menggantikan ToggleButtons dengan API yang jauh lebih modern, type-safe (menggunakan Set<T>), dan mendukung single serta multi-selection secara bawaan.',
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
        ),
      ],
    );
  }
}
