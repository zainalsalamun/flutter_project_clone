import 'package:flutter/material.dart';

enum ClipType { rounded, oval, diamond }

class ClipRRectOvalBasicShowcase extends StatefulWidget {
  const ClipRRectOvalBasicShowcase({super.key});

  @override
  State<ClipRRectOvalBasicShowcase> createState() =>
      _ClipRRectOvalBasicShowcaseState();
}

class _ClipRRectOvalBasicShowcaseState
    extends State<ClipRRectOvalBasicShowcase> {
  ClipType _selectedClip = ClipType.rounded;
  double _borderRadius = 24.0;

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
          child: _buildClippedWidget(),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Clipping Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Clip Shape Mode:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            SegmentedButton<ClipType>(
              segments: const [
                ButtonSegment(
                  value: ClipType.rounded,
                  label: Text('ClipRRect', style: TextStyle(fontSize: 10)),
                ),
                ButtonSegment(
                  value: ClipType.oval,
                  label: Text('ClipOval', style: TextStyle(fontSize: 10)),
                ),
                ButtonSegment(
                  value: ClipType.diamond,
                  label: Text('ClipPath', style: TextStyle(fontSize: 10)),
                ),
              ],
              selected: {_selectedClip},
              showSelectedIcon: false,
              onSelectionChanged:
                  (s) => setState(() => _selectedClip = s.first),
              style: ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ],
        ),

        if (_selectedClip == ClipType.rounded) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    'BorderRadius: ${_borderRadius.toInt()}px',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      trackHeight: 3,
                      activeTrackColor: const Color(0xFF10B981),
                      thumbColor: const Color(0xFF10B981),
                    ),
                    child: Slider(
                      value: _borderRadius.clamp(0.0, 60.0),
                      min: 0.0,
                      max: 60.0,
                      onChanged:
                          (v) => setState(
                            () => _borderRadius = v.clamp(0.0, 60.0),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildClippedWidget() {
    Widget childContent = Container(
      width: 160,
      height: 140,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.content_cut_rounded, color: Colors.white, size: 36),
          SizedBox(height: 6),
          Text(
            'Clipped Surface',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    switch (_selectedClip) {
      case ClipType.rounded:
        return ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: childContent,
        );
      case ClipType.oval:
        return ClipOval(child: childContent);
      case ClipType.diamond:
        return ClipPath(clipper: _DiamondClipper(), child: childContent);
    }
  }
}

class _DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
