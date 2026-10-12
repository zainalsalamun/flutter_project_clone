import 'package:flutter/material.dart';

class ThreeTreesVisualizerWidget extends StatefulWidget {
  const ThreeTreesVisualizerWidget({super.key});

  @override
  State<ThreeTreesVisualizerWidget> createState() => _ThreeTreesVisualizerWidgetState();
}

class _ThreeTreesVisualizerWidgetState extends State<ThreeTreesVisualizerWidget> {
  int _selectedTreeIndex = 0;

  final List<Map<String, dynamic>> _trees = [
    {
      'name': '1. Widget Tree',
      'role': 'Blueprint (Konfigurasi Immutable)',
      'weight': 'Sangat Ringan & Murah',
      'color': Color(0xFF6366F1),
      'icon': Icons.widgets_rounded,
      'desc': 'Kumpulan objek konfigurasi deklaratif yang dibuat ulang (recreated) secara instan setiap kali build() dipanggil.',
      'nodes': ['ContainerWidget', 'PaddingWidget', 'TextWidget("Hello")'],
      'keyInsight': 'Widget di Flutter adalah immutable blueprint. Membuat ribuan widget per detik sangat murah karena hanya berisi data konfigurasi.',
    },
    {
      'name': '2. Element Tree',
      'role': 'Skeleton (Struktur Hidup & State)',
      'weight': 'Sedang (Persistent)',
      'color': Color(0xFF10B981),
      'icon': Icons.account_tree_rounded,
      'desc': 'Menghubungkan Widget ke RenderObject. Mengelola State objek dan menentukan apakah RenderObject perlu dibuat ulang atau cukup di-update.',
      'nodes': ['ComponentElement', 'SingleChildRenderObjectElement', 'StatelessElement'],
      'keyInsight': 'Element tidak dihancurkan saat rebuild jika RuntimeType & Key widget sama! Inilah rahasia performa 60-120 FPS Flutter.',
    },
    {
      'name': '3. RenderObject Tree',
      'role': 'Piksel & Layout (Drawing ke GPU)',
      'weight': 'Objek Berat (Expensive)',
      'color': Color(0xFFEF4444),
      'icon': Icons.brush_rounded,
      'desc': 'Melakukan perhitungan ukuran (layout), koordinat posisi (hit-testing), dan menggambar (paint) piksel sesungguhnya ke layar melalui engine Skia/Impeller.',
      'nodes': ['RenderDecoratedBox', 'RenderPadding', 'RenderParagraph'],
      'keyInsight': 'RenderObject hanya dimutasi nilainya (misal ubah teks atau warna), bukan dibuat baru dari nol setiap frame.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cur = _trees[_selectedTreeIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.hub_rounded, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'The Three Trees of Flutter Architecture',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tree Selector Tabs
          Row(
            children: List.generate(_trees.length, (index) {
              final isSel = _selectedTreeIndex == index;
              final t = _trees[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTreeIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? (t['color'] as Color) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel ? Colors.white70 : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t['name'].toString().split(' ')[1],
                      style: TextStyle(
                        color: isSel ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Active Tree Display Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (cur['color'] as Color).withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(cur['icon'] as IconData, color: cur['color'] as Color, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cur['name'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            cur['role'] as String,
                            style: TextStyle(color: cur['color'] as Color, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  cur['desc'] as String,
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11.5, height: 1.35),
                ),
                const SizedBox(height: 12),

                // Nodes Diagram Visualizer
                const Text(
                  'Hierarki Pohon di Memori:',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Column(
                  children: (cur['nodes'] as List<String>).asMap().entries.map((entry) {
                    final idx = entry.key;
                    final node = entry.value;
                    return Row(
                      children: [
                        SizedBox(width: idx * 16.0),
                        if (idx > 0) const Text('└─ ', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (cur['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: (cur['color'] as Color).withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            node,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Key Insight Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.psychology_alt_rounded, color: Color(0xFF38BDF8), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cur['keyInsight'] as String,
                          style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 11, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
