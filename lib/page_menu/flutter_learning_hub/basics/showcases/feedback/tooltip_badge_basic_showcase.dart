import 'package:flutter/material.dart';

class TooltipBadgeBasicShowcase extends StatefulWidget {
  const TooltipBadgeBasicShowcase({super.key});

  @override
  State<TooltipBadgeBasicShowcase> createState() =>
      _TooltipBadgeBasicShowcaseState();
}

class _TooltipBadgeBasicShowcaseState extends State<TooltipBadgeBasicShowcase> {
  int _badgeCount = 5;

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
                spacing: 32,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Badge on Icon
                  Badge(
                    label: Text('$_badgeCount'),
                    isLabelVisible: _badgeCount > 0,
                    backgroundColor: const Color(0xFFEF4444),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_rounded,
                        size: 30,
                        color: Color(0xFF334155),
                      ),
                      onPressed: () => setState(() => _badgeCount++),
                    ),
                  ),

                  // Small dot badge
                  const Badge(
                    smallSize: 8,
                    backgroundColor: Color(0xFF10B981),
                    child: Icon(
                      Icons.mail_rounded,
                      size: 28,
                      color: Color(0xFF334155),
                    ),
                  ),

                  // Tooltip on Action Icon
                  Tooltip(
                    message: 'Klik untuk mengunduh laporan PDF',
                    waitDuration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            color: Color(0xFF6366F1),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Tahan untuk Tooltip',
                            style: TextStyle(
                              color: Color(0xFF6366F1),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Sentuh tombol lonceng notifikasi untuk menambah angka badge',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Badge Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Badge Notification Count:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed:
                  _badgeCount > 0 ? () => setState(() => _badgeCount--) : null,
            ),
            Text(
              '$_badgeCount',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed:
                  _badgeCount < 99 ? () => setState(() => _badgeCount++) : null,
            ),
          ],
        ),
      ],
    );
  }
}
