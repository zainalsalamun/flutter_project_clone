import 'package:flutter/material.dart';

class ListTileCardBasicShowcase extends StatefulWidget {
  const ListTileCardBasicShowcase({super.key});

  @override
  State<ListTileCardBasicShowcase> createState() =>
      _ListTileCardBasicShowcaseState();
}

class _ListTileCardBasicShowcaseState extends State<ListTileCardBasicShowcase> {
  double _elevation = 4.0;
  double _borderRadius = 14.0;
  bool _dense = false;
  String _status = 'Silakan sentuh salah satu list tile di atas';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Card(
                elevation: _elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: ListTile(
                  dense: _dense,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF6366F1),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: const Text(
                    'Zainal Salamun',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Senior Flutter Mobile Engineer'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap:
                      () => setState(
                        () => _status = 'ListTile #1 (Zainal) disentuh',
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: _elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: ListTile(
                  dense: _dense,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF10B981),
                    child: Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Security & Privacy',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('2-Factor Authentication Aktif'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap:
                      () => setState(
                        () => _status = 'ListTile #2 (Security) disentuh',
                      ),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4338CA),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Card & ListTile Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'Card Elevation:',
          value: _elevation,
          min: 0,
          max: 16,
          onChanged: (v) => setState(() => _elevation = v),
        ),
        _buildSlider(
          label: 'Border Radius:',
          value: _borderRadius,
          min: 0,
          max: 30,
          onChanged: (v) => setState(() => _borderRadius = v),
        ),

        const SizedBox(height: 6),
        Row(
          children: [
            const Expanded(
              child: Text(
                'dense (Compact Padding):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _dense,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _dense = v),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
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
