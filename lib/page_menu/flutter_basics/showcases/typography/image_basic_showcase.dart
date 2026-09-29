import 'package:flutter/material.dart';

class ImageBasicShowcase extends StatefulWidget {
  const ImageBasicShowcase({super.key});

  @override
  State<ImageBasicShowcase> createState() => _ImageBasicShowcaseState();
}

class _ImageBasicShowcaseState extends State<ImageBasicShowcase> {
  BoxFit _boxFit = BoxFit.cover;
  double _borderRadius = 16.0;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Target Viewport Container
              Container(
                width: 240,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 1.5),
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  child: Opacity(
                    opacity: _opacity,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Vector Mountains / Sun Art (Zero network required)
                          Positioned(
                            top: 20,
                            right: 40,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDE047),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 10,
                            child: Container(
                              width: 140,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'BoxFit: ${_boxFit.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Image & BoxFit Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'BoxFit Mode:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<BoxFit>(
              value: _boxFit,
              isDense: true,
              items: const [
                DropdownMenuItem(
                  value: BoxFit.cover,
                  child: Text('BoxFit.cover', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: BoxFit.contain,
                  child: Text('BoxFit.contain', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: BoxFit.fill,
                  child: Text('BoxFit.fill', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: BoxFit.fitWidth,
                  child: Text(
                    'BoxFit.fitWidth',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DropdownMenuItem(
                  value: BoxFit.fitHeight,
                  child: Text(
                    'BoxFit.fitHeight',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DropdownMenuItem(
                  value: BoxFit.scaleDown,
                  child: Text(
                    'BoxFit.scaleDown',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _boxFit = v);
              },
            ),
          ],
        ),

        const SizedBox(height: 8),
        _buildSlider(
          label: 'ClipRRect Radius:',
          value: _borderRadius,
          min: 0,
          max: 60,
          onChanged: (v) => setState(() => _borderRadius = v),
        ),
        _buildSlider(
          label: 'Opacity:',
          value: _opacity,
          min: 0.1,
          max: 1.0,
          onChanged: (v) => setState(() => _opacity = v),
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
              '$label ${value > 1 ? value.toInt().toString() : value.toStringAsFixed(2)}',
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
