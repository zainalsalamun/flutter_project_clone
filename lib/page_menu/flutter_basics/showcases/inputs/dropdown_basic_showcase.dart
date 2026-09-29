import 'package:flutter/material.dart';

class DropdownBasicShowcase extends StatefulWidget {
  const DropdownBasicShowcase({super.key});

  @override
  State<DropdownBasicShowcase> createState() => _DropdownBasicShowcaseState();
}

class _DropdownBasicShowcaseState extends State<DropdownBasicShowcase> {
  String? _selectedCity = 'Jakarta';
  String? _selectedFramework = 'Flutter';

  final List<String> _cities = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Yogyakarta',
    'Bali',
    'Medan',
  ];
  final List<String> _frameworks = [
    'Flutter',
    'React Native',
    'Swift (iOS)',
    'Kotlin (Android)',
  ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1. DropdownButtonFormField (Form Validation Ready):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items:
                    _cities.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                onChanged: (v) => setState(() => _selectedCity = v),
              ),
              const SizedBox(height: 16),

              const Text(
                '2. Clean Styled DropdownButton:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFramework,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF6366F1),
                    ),
                    items:
                        _frameworks.map((f) {
                          return DropdownMenuItem(
                            value: f,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.code_rounded,
                                  size: 16,
                                  color: Color(0xFF6366F1),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  f,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (v) => setState(() => _selectedFramework = v),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Pilihan: Kota -> $_selectedCity | Tech -> $_selectedFramework',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4338CA),
            ),
          ),
        ),
      ],
    );
  }
}
