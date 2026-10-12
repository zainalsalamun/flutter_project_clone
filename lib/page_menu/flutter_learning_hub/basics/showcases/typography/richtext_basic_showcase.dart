import 'package:flutter/material.dart';

class RichTextBasicShowcase extends StatelessWidget {
  const RichTextBasicShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Halo! Selamat datang di ',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flutter_dash,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Flutter',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const TextSpan(text: 'Framework. Pelajari '),
                    TextSpan(
                      text: 'Dasar Widget',
                      style: const TextStyle(
                        color: Color(0xFF0284C7),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' dan bangun aplikasi dengan '),
                    const TextSpan(
                      text: 'Performa Tinggi ',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const TextSpan(text: ' untuk Android, iOS, Web & Desktop.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF10B981),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'RichText mendukung perpaduan style teks berbeda & WidgetSpan inline!',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF065F46),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Tips RichText:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        const Text(
          '• Gunakan `Text.rich(...)` sebagai shortcut praktis untuk `RichText(...)`.\n• Gunakan `WidgetSpan` untuk menyematkan icon, badge, atau tombol kecil langsung di dalam baris kalimat.',
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
        ),
      ],
    );
  }
}
