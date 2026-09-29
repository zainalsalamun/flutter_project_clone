import 'package:flutter/material.dart';

class DialogBasicShowcase extends StatefulWidget {
  const DialogBasicShowcase({super.key});

  @override
  State<DialogBasicShowcase> createState() => _DialogBasicShowcaseState();
}

class _DialogBasicShowcaseState extends State<DialogBasicShowcase> {
  String _dialogResult = 'Belum ada dialog dibuka';

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
                SizedBox(width: 8),
                Text('Konfirmasi Aksi', style: TextStyle(fontSize: 16)),
              ],
            ),
            content: const Text(
              'Apakah Anda yakin ingin menghapus cache aplikasi? Aksi ini tidak dapat dibatalkan.',
              style: TextStyle(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _dialogResult = 'AlertDialog: Batal ditekan');
                },
                child: const Text('Batal'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(
                    () =>
                        _dialogResult =
                            'AlertDialog: Hapus Cache Dikonfirmasi! ',
                  );
                },
                child: const Text('Hapus Sekarang'),
              ),
            ],
          ),
    );
  }

  void _showSimpleDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: const Text(
              'Pilih Bahasa Pemrograman',
              style: TextStyle(fontSize: 15),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(
                    () =>
                        _dialogResult = 'SimpleDialog: Dart / Flutter dipilih',
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.flutter_dash, color: Color(0xFF0284C7)),
                    SizedBox(width: 10),
                    Text('Dart (Flutter)'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(
                    () => _dialogResult = 'SimpleDialog: Kotlin dipilih',
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.android, color: Color(0xFF10B981)),
                    SizedBox(width: 10),
                    Text('Kotlin (Android)'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _dialogResult = 'SimpleDialog: Swift dipilih');
                },
                child: const Row(
                  children: [
                    Icon(Icons.apple, color: Colors.black87),
                    SizedBox(width: 10),
                    Text('Swift (iOS)'),
                  ],
                ),
              ),
            ],
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
                    onPressed: _showAlertDialog,
                    icon: const Icon(Icons.quiz_rounded, size: 18),
                    label: const Text('Buka AlertDialog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showSimpleDialog,
                    icon: const Icon(Icons.list_alt_rounded, size: 18),
                    label: const Text('Buka SimpleDialog'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Hasil Dialog: $_dialogResult',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
