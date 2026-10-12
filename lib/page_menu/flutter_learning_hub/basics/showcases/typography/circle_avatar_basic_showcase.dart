import 'package:flutter/material.dart';

class CircleAvatarBasicShowcase extends StatefulWidget {
  const CircleAvatarBasicShowcase({super.key});

  @override
  State<CircleAvatarBasicShowcase> createState() =>
      _CircleAvatarBasicShowcaseState();
}

class _CircleAvatarBasicShowcaseState extends State<CircleAvatarBasicShowcase> {
  double _radius = 45.0;
  bool _isOnline = true;
  final Color _bgColor = const Color(0xFF6366F1);
  final String _initials = 'FL';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: _radius,
                  backgroundColor: _bgColor,
                  child: Text(
                    _initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: _radius * 0.45,
                    ),
                  ),
                ),
                if (_isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: _radius * 0.4,
                      height: _radius * 0.4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'CircleAvatar Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'Radius:',
          value: _radius,
          min: 20,
          max: 70,
          onChanged: (v) => setState(() => _radius = v),
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Show Online Badge:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _isOnline,
              activeThumbColor: const Color(0xFF10B981),
              onChanged: (v) => setState(() => _isOnline = v),
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
