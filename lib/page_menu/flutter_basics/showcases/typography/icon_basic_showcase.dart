import 'package:flutter/material.dart';

class IconBasicShowcase extends StatefulWidget {
  const IconBasicShowcase({super.key});

  @override
  State<IconBasicShowcase> createState() => _IconBasicShowcaseState();
}

class _IconBasicShowcaseState extends State<IconBasicShowcase> {
  double _iconSize = 48.0;
  final Color _iconColor = const Color(0xFF6366F1);
  IconData _selectedIcon = Icons.favorite_rounded;
  int _clickCount = 0;

  final List<IconData> _iconList = [
    Icons.favorite_rounded,
    Icons.star_rounded,
    Icons.bolt_rounded,
    Icons.rocket_launch_rounded,
    Icons.shield_rounded,
    Icons.code_rounded,
    Icons.palette_rounded,
    Icons.flutter_dash,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: _iconSize,
                color: _iconColor,
                splashRadius: _iconSize * 0.8,
                tooltip: 'Tap Icon!',
                icon: Icon(_selectedIcon),
                onPressed: () => setState(() => _clickCount++),
              ),
              const SizedBox(height: 8),
              Text(
                'IconButton Tapped: $_clickCount kali',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Icon Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        // Icon Picker
        Wrap(
          spacing: 8,
          children:
              _iconList.map((ic) {
                final isSel = _selectedIcon == ic;
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = ic),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isSel
                              ? const Color(0xFF6366F1)
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      ic,
                      size: 22,
                      color: isSel ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 12),
        _buildSlider(
          label: 'Icon Size:',
          value: _iconSize,
          min: 24,
          max: 96,
          onChanged: (v) => setState(() => _iconSize = v),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label ${value.toInt()}px',
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
