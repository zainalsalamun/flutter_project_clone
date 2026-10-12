import 'package:flutter/material.dart';

class ContainerBasicShowcase extends StatefulWidget {
  const ContainerBasicShowcase({super.key});

  @override
  State<ContainerBasicShowcase> createState() => _ContainerBasicShowcaseState();
}

class _ContainerBasicShowcaseState extends State<ContainerBasicShowcase> {
  double _width = 180.0;
  double _height = 140.0;
  double _borderRadius = 16.0;
  double _padding = 16.0;
  double _margin = 12.0;
  Color _color = const Color(0xFF6366F1);
  bool _hasBorder = true;
  bool _hasShadow = true;
  final Alignment _alignment = Alignment.center;

  final List<Color> _colorOptions = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF10B981), // Emerald
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFEF4444), // Red
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF0F172A), // Dark Slate
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Box
        Container(
          height: 260,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Grid Background Lines
              Positioned.fill(
                child: CustomPaint(painter: _GridBackgroundPainter()),
              ),
              // The Interactive Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: _width,
                height: _height,
                margin: EdgeInsets.all(_margin),
                padding: EdgeInsets.all(_padding),
                alignment: _alignment,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border:
                      _hasBorder
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                  boxShadow:
                      _hasShadow
                          ? [
                            BoxShadow(
                              color: _color.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ]
                          : [],
                ),
                child: const Text(
                  'Container Widget',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              // Dimension Badge
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_width.toInt()} x ${_height.toInt()} px',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls Section
        const Text(
          'Live Parameter Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        // Sliders
        _buildSliderRow(
          label: 'Width',
          value: _width,
          min: 80,
          max: 280,
          onChanged: (v) => setState(() => _width = v),
        ),
        _buildSliderRow(
          label: 'Height',
          value: _height,
          min: 60,
          max: 200,
          onChanged: (v) => setState(() => _height = v),
        ),
        _buildSliderRow(
          label: 'BorderRadius',
          value: _borderRadius,
          min: 0,
          max: 50,
          onChanged: (v) => setState(() => _borderRadius = v),
        ),
        _buildSliderRow(
          label: 'Padding',
          value: _padding,
          min: 0,
          max: 32,
          onChanged: (v) => setState(() => _padding = v),
        ),
        _buildSliderRow(
          label: 'Margin',
          value: _margin,
          min: 0,
          max: 24,
          onChanged: (v) => setState(() => _margin = v),
        ),

        const SizedBox(height: 12),
        // Color Picker Row
        Row(
          children: [
            const SizedBox(
              width: 90,
              child: Text(
                'Color:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Wrap(
                spacing: 8,
                children:
                    _colorOptions.map((c) {
                      final isSelected = _color == c;
                      return GestureDetector(
                        onTap: () => setState(() => _color = c),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border:
                                isSelected
                                    ? Border.all(
                                      color: Colors.black,
                                      width: 2.5,
                                    )
                                    : null,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Switch Toggles Row
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Border', style: TextStyle(fontSize: 12)),
                Switch(
                  value: _hasBorder,
                  activeThumbColor: const Color(0xFF6366F1),
                  onChanged: (v) => setState(() => _hasBorder = v),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('BoxShadow', style: TextStyle(fontSize: 12)),
                Switch(
                  value: _hasShadow,
                  activeThumbColor: const Color(0xFF6366F1),
                  onChanged: (v) => setState(() => _hasShadow = v),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderRow({
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
            width: 90,
            child: Text(
              '$label: ${value.toInt()}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
                activeTrackColor: const Color(0xFF6366F1),
                inactiveTrackColor: Colors.grey.shade200,
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

class _GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.4)
          ..strokeWidth = 0.8;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
