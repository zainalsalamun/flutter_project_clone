import 'package:flutter/material.dart';

class GradientSliderShowcase extends StatefulWidget {
  const GradientSliderShowcase({super.key});

  @override
  State<GradientSliderShowcase> createState() => _GradientSliderShowcaseState();
}

class _GradientSliderShowcaseState extends State<GradientSliderShowcase> {
  double _volume = 65;
  double _brightness = 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.volume_up_rounded,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Sound Volume',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '${_volume.round()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomGradientSlider(
          value: _volume,
          min: 0,
          max: 100,
          colors: const [Color(0xFF6366F1), Color(0xFFEC4899)],
          onChanged: (val) => setState(() => _volume = val),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.light_mode_rounded, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  'Screen Brightness',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '${_brightness.round()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomGradientSlider(
          value: _brightness,
          min: 0,
          max: 100,
          colors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
          onChanged: (val) => setState(() => _brightness = val),
        ),
      ],
    );
  }
}

class CustomGradientSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final List<Color> colors;
  final ValueChanged<double> onChanged;

  const CustomGradientSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 10,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
          elevation: 4,
          pressedElevation: 6,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        thumbColor: Colors.white,
        overlayColor: colors.last.withValues(alpha: 0.2),
        trackShape: _GradientSliderTrackShape(colors: colors),
      ),
      child: Slider(value: value, min: min, max: max, onChanged: onChanged),
    );
  }
}

class _GradientSliderTrackShape extends SliderTrackShape {
  final List<Color> colors;

  _GradientSliderTrackShape({required this.colors});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 6;
    final trackLeft = offset.dx + 16;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - 32;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Inactive track (grey background)
    final inactivePaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRect.height / 2),
    );
    context.canvas.drawRRect(rrect, inactivePaint);

    // Active track (gradient)
    final activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    if (activeRect.width > 0) {
      final gradient = LinearGradient(colors: colors);
      final activePaint =
          Paint()
            ..shader = gradient.createShader(trackRect)
            ..style = PaintingStyle.fill;

      final activeRRect = RRect.fromRectAndRadius(
        activeRect,
        Radius.circular(trackRect.height / 2),
      );
      context.canvas.drawRRect(activeRRect, activePaint);
    }
  }
}
