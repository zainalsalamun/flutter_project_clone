import 'package:flutter/material.dart';

class StackPositionedBasicShowcase extends StatefulWidget {
  const StackPositionedBasicShowcase({super.key});

  @override
  State<StackPositionedBasicShowcase> createState() =>
      _StackPositionedBasicShowcaseState();
}

class _StackPositionedBasicShowcaseState
    extends State<StackPositionedBasicShowcase> {
  double _top = 30.0;
  double _left = 40.0;
  double _badgeSize = 70.0;
  final Alignment _stackAlignment = Alignment.center;
  bool _clipContent = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          clipBehavior: _clipContent ? Clip.hardEdge : Clip.none,
          child: Stack(
            alignment: _stackAlignment,
            clipBehavior: _clipContent ? Clip.hardEdge : Clip.none,
            children: [
              // Background Base Layer
              Container(
                width: 220,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF60A5FA),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.layers_rounded,
                      color: Color(0xFF93C5FD),
                      size: 36,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Base Container\n(Alignment Child)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),

              // Positioned Overlay Layer
              Positioned(
                top: _top,
                left: _left,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _badgeSize,
                  height: _badgeSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.pin_drop_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        '(${_top.toInt()}, ${_left.toInt()})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Info Badge
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Stack Layers: [Base, Positioned]',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Stack & Positioned Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildSlider(
          label: 'Positioned top:',
          value: _top,
          min: 0,
          max: 180,
          onChanged: (v) => setState(() => _top = v),
        ),
        _buildSlider(
          label: 'Positioned left:',
          value: _left,
          min: 0,
          max: 240,
          onChanged: (v) => setState(() => _left = v),
        ),
        _buildSlider(
          label: 'Badge Size:',
          value: _badgeSize,
          min: 40,
          max: 100,
          onChanged: (v) => setState(() => _badgeSize = v),
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Clip Behavior:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            ChoiceChip(
              label: const Text(
                'Clip.hardEdge',
                style: TextStyle(fontSize: 11),
              ),
              selected: _clipContent,
              onSelected: (v) => setState(() => _clipContent = true),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Clip.none', style: TextStyle(fontSize: 11)),
              selected: !_clipContent,
              onSelected: (v) => setState(() => _clipContent = false),
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
                activeTrackColor: const Color(0xFFEF4444),
                thumbColor: const Color(0xFFEF4444),
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
