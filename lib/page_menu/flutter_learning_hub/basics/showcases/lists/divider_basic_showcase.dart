import 'package:flutter/material.dart';

class DividerBasicShowcase extends StatefulWidget {
  const DividerBasicShowcase({super.key});

  @override
  State<DividerBasicShowcase> createState() => _DividerBasicShowcaseState();
}

class _DividerBasicShowcaseState extends State<DividerBasicShowcase> {
  double _thickness = 2.0;
  double _indent = 20.0;
  double _endIndent = 20.0;
  final Color _dividerColor = const Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              const Text(
                'Bagian Atas (Section 1)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Divider(
                thickness: _thickness,
                indent: _indent,
                endIndent: _endIndent,
                color: _dividerColor,
              ),
              const SizedBox(height: 8),
              const Text(
                'Bagian Bawah (Section 2)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Vertical Divider Demo in IntrinsicHeight Row
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Poin: 1.250',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      VerticalDivider(
                        thickness: _thickness,
                        color: _dividerColor,
                        width: 20,
                      ),
                      const Text(
                        'Rank: Gold',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      VerticalDivider(
                        thickness: _thickness,
                        color: _dividerColor,
                        width: 20,
                      ),
                      const Text(
                        'Level: 24',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Divider Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'thickness:',
          value: _thickness,
          min: 0.5,
          max: 8.0,
          onChanged: (v) => setState(() => _thickness = v),
        ),
        _buildSlider(
          label: 'indent (Left):',
          value: _indent,
          min: 0,
          max: 60,
          onChanged: (v) => setState(() => _indent = v),
        ),
        _buildSlider(
          label: 'endIndent (Right):',
          value: _endIndent,
          min: 0,
          max: 60,
          onChanged: (v) => setState(() => _endIndent = v),
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
              '$label ${value.toStringAsFixed(1)}px',
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
