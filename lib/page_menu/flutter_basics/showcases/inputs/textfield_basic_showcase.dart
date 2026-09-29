import 'package:flutter/material.dart';

class TextFieldBasicShowcase extends StatefulWidget {
  const TextFieldBasicShowcase({super.key});

  @override
  State<TextFieldBasicShowcase> createState() => _TextFieldBasicShowcaseState();
}

class _TextFieldBasicShowcaseState extends State<TextFieldBasicShowcase> {
  final TextEditingController _textCtrl = TextEditingController(
    text: 'John Doe',
  );
  bool _obscure = false;
  bool _isFilled = true;
  bool _showError = false;
  double _borderRadius = 12.0;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              TextField(
                controller: _textCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Username / Email',
                  hintText: 'Masukkan nama pengguna...',
                  helperText: _showError ? null : 'Gunakan minimal 6 karakter',
                  errorText: _showError ? 'Format username tidak valid!' : null,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  filled: _isFilled,
                  fillColor: _isFilled ? const Color(0xFFF1F5F9) : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    borderSide: BorderSide(
                      color:
                          _isFilled ? Colors.transparent : Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nilai Input: "${_textCtrl.text}"',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'InputDecoration Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Filled Background:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _isFilled,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _isFilled = v),
            ),
          ],
        ),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Simulate Error State:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _showError,
              activeThumbColor: const Color(0xFFEF4444),
              onChanged: (v) => setState(() => _showError = v),
            ),
          ],
        ),

        _buildSlider(
          label: 'BorderRadius:',
          value: _borderRadius,
          min: 0,
          max: 30,
          onChanged: (v) => setState(() => _borderRadius = v),
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
