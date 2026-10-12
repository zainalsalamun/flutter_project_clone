import 'package:flutter/material.dart';

class DismissibleBasicShowcase extends StatefulWidget {
  const DismissibleBasicShowcase({super.key});

  @override
  State<DismissibleBasicShowcase> createState() =>
      _DismissibleBasicShowcaseState();
}

class _DismissibleBasicShowcaseState extends State<DismissibleBasicShowcase> {
  List<String> _items = [
    'Email dari Google Play',
    'Tagihan Hosting Firebase',
    'Laporan Mingguan Sprint #4',
    'Undangan Meeting Tech Talk',
  ];

  String _lastAction = 'Geser (swipe) salah satu item ke kiri atau kanan';

  void _resetList() {
    setState(() {
      _items = [
        'Email dari Google Play',
        'Tagihan Hosting Firebase',
        'Laporan Mingguan Sprint #4',
        'Undangan Meeting Tech Talk',
      ];
      _lastAction = 'Daftar item direset';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child:
              _items.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.done_all_rounded,
                          size: 40,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Semua item telah dihapus!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _resetList,
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Reset Item'),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Dismissible(
                        key: Key(item),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.archive_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Arsipkan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Hapus',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          final action =
                              direction == DismissDirection.startToEnd
                                  ? 'diarsipkan'
                                  : 'dihapus';
                          setState(() {
                            _items.removeAt(index);
                            _lastAction = '"$item" berhasil $action';
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            dense: true,
                            leading: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0xFFEEF2FF),
                              child: Icon(
                                Icons.mail_outline_rounded,
                                size: 16,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                            title: Text(
                              item,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.drag_handle_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
        const SizedBox(height: 16),

        // Controls
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _lastAction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4338CA),
            ),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _resetList,
              icon: const Icon(Icons.replay_rounded, size: 16),
              label: const Text(
                'Reset Ulang Daftar',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
