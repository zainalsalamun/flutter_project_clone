import 'package:flutter/material.dart';

class TextStyleBasicShowcase extends StatefulWidget {
  const TextStyleBasicShowcase({super.key});

  @override
  State<TextStyleBasicShowcase> createState() => _TextStyleBasicShowcaseState();
}

class _TextStyleBasicShowcaseState extends State<TextStyleBasicShowcase> {
  double _fontSize = 18.0;
  FontWeight _fontWeight = FontWeight.w600;
  final FontStyle _fontStyle = FontStyle.normal;
  double _letterSpacing = 0.5;
  double _height = 1.3;
  TextDecoration _decoration = TextDecoration.none;
  final Color _textColor = const Color(0xFF0F172A);
  final int _maxLines = 3;
  final TextOverflow _overflow = TextOverflow.ellipsis;

  final String _sampleText =
      'Flutter adalah framework open-source Google untuk membangun aplikasi multi-platform (Android, iOS, Web, Desktop) dari satu basis kode Dart yang cepat dan indah.';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Text(
              _sampleText,
              maxLines: _maxLines,
              overflow: _overflow,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: _fontWeight,
                fontStyle: _fontStyle,
                letterSpacing: _letterSpacing,
                height: _height,
                decoration: _decoration,
                color: _textColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'TextStyle Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'fontSize:',
          value: _fontSize,
          min: 10,
          max: 32,
          onChanged: (v) => setState(() => _fontSize = v),
        ),
        _buildSlider(
          label: 'letterSpacing:',
          value: _letterSpacing,
          min: -1.0,
          max: 6.0,
          onChanged: (v) => setState(() => _letterSpacing = v),
        ),
        _buildSlider(
          label: 'line height:',
          value: _height,
          min: 0.8,
          max: 2.5,
          onChanged: (v) => setState(() => _height = v),
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'FontWeight:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<FontWeight>(
              value: _fontWeight,
              isDense: true,
              items: const [
                DropdownMenuItem(
                  value: FontWeight.w300,
                  child: Text('w300 Light', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: FontWeight.w400,
                  child: Text('w400 Regular', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: FontWeight.w600,
                  child: Text('w600 SemiBold', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: FontWeight.w700,
                  child: Text('w700 Bold', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: FontWeight.w900,
                  child: Text('w900 Black', style: TextStyle(fontSize: 12)),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _fontWeight = v);
              },
            ),
          ],
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Decoration:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            ChoiceChip(
              label: const Text('None', style: TextStyle(fontSize: 11)),
              selected: _decoration == TextDecoration.none,
              onSelected:
                  (v) => setState(() => _decoration = TextDecoration.none),
            ),
            const SizedBox(width: 6),
            ChoiceChip(
              label: const Text('Underline', style: TextStyle(fontSize: 11)),
              selected: _decoration == TextDecoration.underline,
              onSelected:
                  (v) => setState(() => _decoration = TextDecoration.underline),
            ),
            const SizedBox(width: 6),
            ChoiceChip(
              label: const Text('Strike', style: TextStyle(fontSize: 11)),
              selected: _decoration == TextDecoration.lineThrough,
              onSelected:
                  (v) =>
                      setState(() => _decoration = TextDecoration.lineThrough),
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
            width: 140,
            child: Text(
              '$label ${value.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
                activeTrackColor: const Color(0xFF10B981),
                thumbColor: const Color(0xFF10B981),
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
