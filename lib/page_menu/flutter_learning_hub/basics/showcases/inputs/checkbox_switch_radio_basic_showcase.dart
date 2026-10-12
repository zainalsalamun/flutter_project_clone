import 'package:flutter/material.dart';

class CheckboxSwitchRadioBasicShowcase extends StatefulWidget {
  const CheckboxSwitchRadioBasicShowcase({super.key});

  @override
  State<CheckboxSwitchRadioBasicShowcase> createState() =>
      _CheckboxSwitchRadioBasicShowcaseState();
}

class _CheckboxSwitchRadioBasicShowcaseState
    extends State<CheckboxSwitchRadioBasicShowcase> {
  bool _checkboxVal = true;
  bool _switchVal = true;
  int _selectedRadio = 1;

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
            children: [
              // Checkbox Row
              CheckboxListTile(
                value: _checkboxVal,
                title: const Text(
                  'CheckboxListTile',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                subtitle: const Text(
                  'Menerima syarat dan ketentuan',
                  style: TextStyle(fontSize: 11),
                ),
                activeColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onChanged: (v) => setState(() => _checkboxVal = v ?? false),
              ),
              const Divider(height: 1),

              // Switch Row
              SwitchListTile(
                value: _switchVal,
                title: const Text(
                  'SwitchListTile',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                subtitle: const Text(
                  'Aktifkan notifikasi push',
                  style: TextStyle(fontSize: 11),
                ),
                activeThumbColor: const Color(0xFF10B981),
                onChanged: (v) => setState(() => _switchVal = v),
              ),
              const Divider(height: 1),

              // Radio Options
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pilihan Radio (Tipe Akun):',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      value: 1,
                      groupValue: _selectedRadio,
                      title: const Text('Free', style: TextStyle(fontSize: 12)),
                      activeColor: const Color(0xFF6366F1),
                      onChanged: (v) => setState(() => _selectedRadio = v!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      value: 2,
                      groupValue: _selectedRadio,
                      title: const Text(
                        'Pro ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      activeColor: const Color(0xFF6366F1),
                      onChanged: (v) => setState(() => _selectedRadio = v!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Status State -> Checkbox: $_checkboxVal | Switch: $_switchVal | Radio: ${_selectedRadio == 1 ? "Free" : "Pro"}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
