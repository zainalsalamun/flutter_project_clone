import 'package:flutter/material.dart';

class AlignCenterBasicShowcase extends StatefulWidget {
  const AlignCenterBasicShowcase({super.key});

  @override
  State<AlignCenterBasicShowcase> createState() =>
      _AlignCenterBasicShowcaseState();
}

class _AlignCenterBasicShowcaseState extends State<AlignCenterBasicShowcase> {
  double _x = 0.0;
  double _y = 0.0;
  String _selectedPreset = 'center';

  final Map<String, Alignment> _presets = {
    'topLeft': Alignment.topLeft,
    'topCenter': Alignment.topCenter,
    'topRight': Alignment.topRight,
    'centerLeft': Alignment.centerLeft,
    'center': Alignment.center,
    'centerRight': Alignment.centerRight,
    'bottomLeft': Alignment.bottomLeft,
    'bottomCenter': Alignment.bottomCenter,
    'bottomRight': Alignment.bottomRight,
  };

  void _applyPreset(String name) {
    final a = _presets[name]!;
    setState(() {
      _selectedPreset = name;
      _x = a.x;
      _y = a.y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 230,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Stack(
            children: [
              // Coordinate Center Crosshairs
              Center(
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Center(
                child: Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),

              // The Align Widget
              Align(
                alignment: Alignment(_x, _y),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.my_location_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${_x.toStringAsFixed(1)}, ${_y.toStringAsFixed(1)})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
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
          'Alignment 9-Point Presets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 10),

        // 3x3 Grid of presets
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPresetBtn('topLeft', '↖ TL'),
            const SizedBox(width: 6),
            _buildPresetBtn('topCenter', '↑ TC'),
            const SizedBox(width: 6),
            _buildPresetBtn('topRight', '↗ TR'),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPresetBtn('centerLeft', '← CL'),
            const SizedBox(width: 6),
            _buildPresetBtn('center', '• Center'),
            const SizedBox(width: 6),
            _buildPresetBtn('centerRight', '→ CR'),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPresetBtn('bottomLeft', '↙ BL'),
            const SizedBox(width: 6),
            _buildPresetBtn('bottomCenter', '↓ BC'),
            const SizedBox(width: 6),
            _buildPresetBtn('bottomRight', '↘ BR'),
          ],
        ),

        const SizedBox(height: 12),
        _buildSlider(
          label: 'Alignment.x (-1.0 s/d 1.0):',
          value: _x,
          onChanged:
              (v) => setState(() {
                _x = v;
                _selectedPreset = '';
              }),
        ),
        _buildSlider(
          label: 'Alignment.y (-1.0 s/d 1.0):',
          value: _y,
          onChanged:
              (v) => setState(() {
                _y = v;
                _selectedPreset = '';
              }),
        ),
      ],
    );
  }

  Widget _buildPresetBtn(String key, String label) {
    final isSelected = _selectedPreset == key;
    return InkWell(
      onTap: () => _applyPreset(key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              '$label ${value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
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
                value: value.clamp(-1.0, 1.0),
                min: -1.0,
                max: 1.0,
                onChanged: (v) => onChanged(v.clamp(-1.0, 1.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
