import 'package:flutter/material.dart';

class GridViewBasicShowcase extends StatefulWidget {
  const GridViewBasicShowcase({super.key});

  @override
  State<GridViewBasicShowcase> createState() => _GridViewBasicShowcaseState();
}

class _GridViewBasicShowcaseState extends State<GridViewBasicShowcase> {
  int _crossAxisCount = 3;
  double _childAspectRatio = 1.0;
  double _spacing = 8.0;

  final List<Color> _gridColors = [
    const Color(0xFF6366F1),
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
    const Color(0xFF8B5CF6),
    const Color(0xFF06B6D4),
    const Color(0xFF14B8A6),
    const Color(0xFFF97316),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 240,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: GridView.builder(
            itemCount: _gridColors.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              crossAxisSpacing: _spacing,
              mainAxisSpacing: _spacing,
              childAspectRatio: _childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final color = _gridColors[index];
              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.grid_3x3_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'GridView Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'crossAxisCount (Kolom):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
                ButtonSegment(value: 4, label: Text('4')),
              ],
              selected: {_crossAxisCount},
              showSelectedIcon: false,
              onSelectionChanged:
                  (s) => setState(() => _crossAxisCount = s.first),
              style: ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ],
        ),

        const SizedBox(height: 8),
        _buildSlider(
          label: 'childAspectRatio:',
          value: _childAspectRatio,
          min: 0.6,
          max: 1.8,
          onChanged: (v) => setState(() => _childAspectRatio = v),
        ),
        _buildSlider(
          label: 'spacing:',
          value: _spacing,
          min: 2,
          max: 20,
          onChanged: (v) => setState(() => _spacing = v),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label ${value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
                activeTrackColor: const Color(0xFF6366F1),
                thumbColor: const Color(0xFF6366F1),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                onChanged: (v) => onChanged(v.clamp(min, max)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
