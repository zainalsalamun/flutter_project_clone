import 'package:flutter/material.dart';

class SizedBoxPaddingBasicShowcase extends StatefulWidget {
  const SizedBoxPaddingBasicShowcase({super.key});

  @override
  State<SizedBoxPaddingBasicShowcase> createState() =>
      _SizedBoxPaddingBasicShowcaseState();
}

class _SizedBoxPaddingBasicShowcaseState
    extends State<SizedBoxPaddingBasicShowcase> {
  double _boxWidth = 140.0;
  double _boxHeight = 80.0;
  double _paddingHorizontal = 16.0;
  double _paddingVertical = 12.0;

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
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              border: Border.all(
                color: Colors.amber.shade400,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _paddingHorizontal,
                vertical: _paddingVertical,
              ),
              child: SizedBox(
                width: _boxWidth,
                height: _boxHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'SizedBox\n${_boxWidth.toInt()} x ${_boxHeight.toInt()} px',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'SizedBox & Padding Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'SizedBox.width:',
          value: _boxWidth,
          min: 60,
          max: 220,
          onChanged: (v) => setState(() => _boxWidth = v),
        ),
        _buildSlider(
          label: 'SizedBox.height:',
          value: _boxHeight,
          min: 40,
          max: 140,
          onChanged: (v) => setState(() => _boxHeight = v),
        ),
        _buildSlider(
          label: 'Padding (Horizontal):',
          value: _paddingHorizontal,
          min: 0,
          max: 36,
          onChanged: (v) => setState(() => _paddingHorizontal = v),
        ),
        _buildSlider(
          label: 'Padding (Vertical):',
          value: _paddingVertical,
          min: 0,
          max: 36,
          onChanged: (v) => setState(() => _paddingVertical = v),
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
