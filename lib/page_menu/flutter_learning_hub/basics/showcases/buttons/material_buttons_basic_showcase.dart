import 'package:flutter/material.dart';

class MaterialButtonsBasicShowcase extends StatefulWidget {
  const MaterialButtonsBasicShowcase({super.key});

  @override
  State<MaterialButtonsBasicShowcase> createState() =>
      _MaterialButtonsBasicShowcaseState();
}

class _MaterialButtonsBasicShowcaseState
    extends State<MaterialButtonsBasicShowcase> {
  bool _isEnabled = true;
  String _lastClicked = 'Belum ada tombol ditekan';

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
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  // ElevatedButton
                  ElevatedButton(
                    onPressed:
                        _isEnabled
                            ? () => setState(
                              () => _lastClicked = 'ElevatedButton ditekan',
                            )
                            : null,
                    child: const Text('ElevatedButton'),
                  ),

                  // FilledButton (M3)
                  FilledButton.icon(
                    onPressed:
                        _isEnabled
                            ? () => setState(
                              () => _lastClicked = 'FilledButton (M3) ditekan',
                            )
                            : null,
                    icon: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('FilledButton'),
                  ),

                  // FilledButton.tonal
                  FilledButton.tonal(
                    onPressed:
                        _isEnabled
                            ? () => setState(
                              () => _lastClicked = 'FilledButton.tonal ditekan',
                            )
                            : null,
                    child: const Text('Filled Tonal'),
                  ),

                  // OutlinedButton
                  OutlinedButton.icon(
                    onPressed:
                        _isEnabled
                            ? () => setState(
                              () => _lastClicked = 'OutlinedButton ditekan',
                            )
                            : null,
                    icon: const Icon(Icons.star_outline_rounded, size: 16),
                    label: const Text('OutlinedButton'),
                  ),

                  // TextButton
                  TextButton(
                    onPressed:
                        _isEnabled
                            ? () => setState(
                              () => _lastClicked = 'TextButton ditekan',
                            )
                            : null,
                    child: const Text('TextButton'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Feedback Banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 16,
                      color: Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _lastClicked,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Button State Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Enabled / Disabled State:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _isEnabled,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _isEnabled = v),
            ),
          ],
        ),
      ],
    );
  }
}
