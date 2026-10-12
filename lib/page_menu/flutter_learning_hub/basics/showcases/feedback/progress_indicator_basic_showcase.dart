import 'package:flutter/material.dart';

class ProgressIndicatorBasicShowcase extends StatefulWidget {
  const ProgressIndicatorBasicShowcase({super.key});

  @override
  State<ProgressIndicatorBasicShowcase> createState() =>
      _ProgressIndicatorBasicShowcaseState();
}

class _ProgressIndicatorBasicShowcaseState
    extends State<ProgressIndicatorBasicShowcase> {
  bool _isDeterminate = false;
  double _progress = 0.65;

  @override
  Widget build(BuildContext context) {
    final val = _isDeterminate ? _progress : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // Circular Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircularProgressIndicator(
                        value: val,
                        strokeWidth: 4,
                        color: const Color(0xFF6366F1),
                        backgroundColor: const Color(
                          0xFF6366F1,
                        ).withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'CircularProgress',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (_isDeterminate)
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Linear Progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LinearProgressIndicator:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: val,
                      minHeight: 8,
                      color: const Color(0xFF10B981),
                      backgroundColor: const Color(
                        0xFF10B981,
                      ).withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Progress Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Mode (Indeterminate vs Determinate):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            ChoiceChip(
              label: const Text(
                'Indeterminate (Spinning)',
                style: TextStyle(fontSize: 11),
              ),
              selected: !_isDeterminate,
              onSelected: (v) => setState(() => _isDeterminate = false),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text(
                'Determinate (%)',
                style: TextStyle(fontSize: 11),
              ),
              selected: _isDeterminate,
              onSelected: (v) => setState(() => _isDeterminate = true),
            ),
          ],
        ),

        if (_isDeterminate) ...[
          const SizedBox(height: 8),
          _buildSlider(
            label: 'Progress Value:',
            value: _progress,
            min: 0.0,
            max: 1.0,
            onChanged: (v) => setState(() => _progress = v),
          ),
        ],
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
            width: 130,
            child: Text(
              '$label ${(value * 100).toInt()}%',
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
