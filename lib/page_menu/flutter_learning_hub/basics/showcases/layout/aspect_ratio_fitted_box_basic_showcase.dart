import 'package:flutter/material.dart';

class AspectRatioFittedBoxBasicShowcase extends StatefulWidget {
  const AspectRatioFittedBoxBasicShowcase({super.key});

  @override
  State<AspectRatioFittedBoxBasicShowcase> createState() =>
      _AspectRatioFittedBoxBasicShowcaseState();
}

class _AspectRatioFittedBoxBasicShowcaseState
    extends State<AspectRatioFittedBoxBasicShowcase> {
  double _aspectRatio = 16 / 9;
  String _ratioLabel = '16:9 (Video Widescreen)';
  BoxFit _fittedBoxFit = BoxFit.contain;

  final Map<String, double> _ratios = {
    '16:9 (Video Widescreen)': 16 / 9,
    '4:3 (Classic TV)': 4 / 3,
    '1:1 (Instagram Square)': 1 / 1,
    '21:9 (Ultrawide Cinema)': 21 / 9,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 260, maxHeight: 180),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: _aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  fit: _fittedBoxFit,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'AspectRatio: $_ratioLabel',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'FittedBox(fit: ${_fittedBoxFit.name})',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'AspectRatio & FittedBox Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'AspectRatio Preset:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<String>(
              value: _ratioLabel,
              isDense: true,
              items:
                  _ratios.keys.map((label) {
                    return DropdownMenuItem(
                      value: label,
                      child: Text(label, style: const TextStyle(fontSize: 11)),
                    );
                  }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _ratioLabel = val;
                    _aspectRatio = _ratios[val]!;
                  });
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'FittedBox Fit Mode:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<BoxFit>(
              value: _fittedBoxFit,
              isDense: true,
              items: const [
                DropdownMenuItem(
                  value: BoxFit.contain,
                  child: Text('contain', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: BoxFit.scaleDown,
                  child: Text('scaleDown', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: BoxFit.fitWidth,
                  child: Text('fitWidth', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: BoxFit.cover,
                  child: Text('cover', style: TextStyle(fontSize: 11)),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _fittedBoxFit = val);
              },
            ),
          ],
        ),
      ],
    );
  }
}
