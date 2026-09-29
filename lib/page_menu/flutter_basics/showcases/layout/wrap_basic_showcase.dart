import 'package:flutter/material.dart';

class WrapBasicShowcase extends StatefulWidget {
  const WrapBasicShowcase({super.key});

  @override
  State<WrapBasicShowcase> createState() => _WrapBasicShowcaseState();
}

class _WrapBasicShowcaseState extends State<WrapBasicShowcase> {
  double _spacing = 8.0;
  double _runSpacing = 8.0;
  WrapAlignment _alignment = WrapAlignment.start;
  final Axis _direction = Axis.horizontal;

  final List<String> _tags = [
    'Flutter',
    'Dart',
    'Widgets',
    'Stateful',
    'Stateless',
    'Provider',
    'BLoC',
    'Animation',
    'Canvas',
    'Material 3',
    'Cupertino',
    'Hot Reload',
    'Reactive',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: SingleChildScrollView(
            child: Wrap(
              direction: _direction,
              spacing: _spacing,
              runSpacing: _runSpacing,
              alignment: _alignment,
              children:
                  _tags.map((tag) {
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: const Color(0xFF6366F1),
                        child: Text(
                          tag[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      label: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Wrap Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'spacing (Horizontal):',
          value: _spacing,
          min: 2,
          max: 24,
          onChanged: (v) => setState(() => _spacing = v),
        ),
        _buildSlider(
          label: 'runSpacing (Vertical):',
          value: _runSpacing,
          min: 2,
          max: 24,
          onChanged: (v) => setState(() => _runSpacing = v),
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'WrapAlignment:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<WrapAlignment>(
              value: _alignment,
              isDense: true,
              items:
                  WrapAlignment.values.map((a) {
                    return DropdownMenuItem(
                      value: a,
                      child: Text(a.name, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _alignment = v);
              },
            ),
          ],
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
            width: 150,
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
