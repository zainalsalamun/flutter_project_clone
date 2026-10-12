import 'package:flutter/material.dart';

class SnackbarBasicShowcase extends StatefulWidget {
  const SnackbarBasicShowcase({super.key});

  @override
  State<SnackbarBasicShowcase> createState() => _SnackbarBasicShowcaseState();
}

class _SnackbarBasicShowcaseState extends State<SnackbarBasicShowcase> {
  bool _isFloating = true;

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(child: Text('Data berhasil disimpan ke cloud!')),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior:
            _isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        shape:
            _isFloating
                ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
                : null,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            // Undo logic
          },
        ),
      ),
    );
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(child: Text('Koneksi internet terputus!')),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior:
            _isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        shape:
            _isFloating
                ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
                : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _showSuccessSnackbar,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Show Success SnackBar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showErrorSnackbar,
                    icon: const Icon(Icons.error_outline, size: 18),
                    label: const Text('Show Error SnackBar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SnackBarBehavior: ',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  ChoiceChip(
                    label: const Text(
                      'Floating',
                      style: TextStyle(fontSize: 11),
                    ),
                    selected: _isFloating,
                    onSelected: (v) => setState(() => _isFloating = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Fixed', style: TextStyle(fontSize: 11)),
                    selected: !_isFloating,
                    onSelected: (v) => setState(() => _isFloating = false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
