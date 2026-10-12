import 'package:flutter/material.dart';

class SliderBasicShowcase extends StatefulWidget {
  const SliderBasicShowcase({super.key});

  @override
  State<SliderBasicShowcase> createState() => _SliderBasicShowcaseState();
}

class _SliderBasicShowcaseState extends State<SliderBasicShowcase> {
  double _continuousVal = 65.0;
  double _discreteVal = 3.0;
  RangeValues _rangeValues = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Continuous Slider
              Text(
                'Continuous Slider (${_continuousVal.toInt()}%)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Slider(
                value: _continuousVal.clamp(0.0, 100.0),
                min: 0,
                max: 100,
                activeColor: const Color(0xFF6366F1),
                onChanged: (v) => setState(() => _continuousVal = v),
              ),
              const SizedBox(height: 10),

              // Discrete Slider with Divisions
              Text(
                'Discrete Slider (Langkah: ${_discreteVal.toInt()} / 5)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Slider(
                value: _discreteVal.clamp(0.0, 5.0),
                min: 0,
                max: 5,
                divisions: 5,
                label: 'Level ${_discreteVal.toInt()}',
                activeColor: const Color(0xFF10B981),
                onChanged: (v) => setState(() => _discreteVal = v),
              ),
              const SizedBox(height: 10),

              // RangeSlider
              Text(
                'RangeSlider (${_rangeValues.start.toInt()} - ${_rangeValues.end.toInt()})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              RangeSlider(
                values: _rangeValues,
                min: 0,
                max: 100,
                activeColor: const Color(0xFFF59E0B),
                labels: RangeLabels(
                  '${_rangeValues.start.toInt()}',
                  '${_rangeValues.end.toInt()}',
                ),
                onChanged: (vals) => setState(() => _rangeValues = vals),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Tips Penggunaan Slider:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        const Text(
          '• Berikan parameter `divisions:` jika slider memerlukan nilai bertingkat yang pasti (discrete).\n• Gunakan `RangeSlider` untuk rentang filter harga (misal: Rp 10.000 s/d Rp 500.000).',
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
        ),
      ],
    );
  }
}
