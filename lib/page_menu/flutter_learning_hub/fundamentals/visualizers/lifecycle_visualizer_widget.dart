import 'package:flutter/material.dart';

class LifecycleVisualizerWidget extends StatefulWidget {
  const LifecycleVisualizerWidget({super.key});

  @override
  State<LifecycleVisualizerWidget> createState() => _LifecycleVisualizerWidgetState();
}

class _LifecycleVisualizerWidgetState extends State<LifecycleVisualizerWidget> {
  int _selectedStep = 3; // default on build()
  int _rebuildCount = 0;
  String _simulatedEvent = 'Aplikasi baru dimulai (Initial Mount)';

  final List<Map<String, dynamic>> _steps = [
    {
      'title': '1. createState()',
      'frequency': 'Sekali',
      'frequencyColor': Color(0xFF10B981),
      'desc': 'Framework membuat instance State objek baru untuk StatefulWidget ini.',
      'code': 'State<MyWidget> createState() => _MyWidgetState();',
      'tips': 'Hanya dieksekusi 1 kali saat widget pertama kali dibuat.',
    },
    {
      'title': '2. initState()',
      'frequency': 'Sekali',
      'frequencyColor': Color(0xFF10B981),
      'desc': 'Inisialisasi data awal, controller (Animation/Scroll), subscribe event, atau timer.',
      'code': '@override\nvoid initState() {\n  super.initState();\n  _ctrl = TextEditingController();\n}',
      'tips': 'Wajib panggil super.initState() di awal! Belum boleh akses context yang bergantung pada InheritedWidget.',
    },
    {
      'title': '3. didChangeDependencies()',
      'frequency': 'Saat Dependency Berubah',
      'frequencyColor': Color(0xFFF59E0B),
      'desc': 'Dipanggil setelah initState atau saat InheritedWidget (Theme, MediaQuery, Provider) berubah.',
      'code': '@override\nvoid didChangeDependencies() {\n  super.didChangeDependencies();\n  // Aman membaca Theme.of(context)\n}',
      'tips': 'Tempat yang tepat untuk membaca InheritedWidget saat awal mount.',
    },
    {
      'title': '4. build()',
      'frequency': 'Berkali-kali (Rebuild)',
      'frequencyColor': Color(0xFFEF4444),
      'desc': 'Merender visual tree widget ke layar. Dijalankan setiap setState() atau dependency berubah.',
      'code': '@override\nWidget build(BuildContext context) {\n  return Scaffold(\n    body: Text("Hello"),\n  );\n}',
      'tips': 'Wajib PURE function! Jangan pernah melakukan API request atau panggil setState() di dalam build().',
    },
    {
      'title': '5. didUpdateWidget()',
      'frequency': 'Saat Parent Di-rebuild',
      'frequencyColor': Color(0xFF8B5CF6),
      'desc': 'Dipanggil jika parent widget mengirimkan parameter atau props baru ke widget ini.',
      'code': '@override\nvoid didUpdateWidget(covariant MyWidget oldWidget) {\n  super.didUpdateWidget(oldWidget);\n  if (oldWidget.id != widget.id) _refresh();\n}',
      'tips': 'Bandingkan nilai oldWidget vs widget untuk merespons perubahan props dari parent.',
    },
    {
      'title': '6. deactivate()',
      'frequency': 'Saat Dicopot Sementara',
      'frequencyColor': Color(0xFF64748B),
      'desc': 'State dicopot sementara dari tree (misal saat dipindahkan antar subtree dengan GlobalKey).',
      'code': '@override\nvoid deactivate() {\n  super.deactivate();\n}',
      'tips': 'Jarang dioverride langsung kecuali untuk manipulasi hierarki kompleks.',
    },
    {
      'title': '7. dispose()',
      'frequency': 'Sekali (Destruksi)',
      'frequencyColor': Color(0xFFEF4444),
      'desc': 'Membersihkan memori permanen saat widget dihapus (dispose controller, cancel timer).',
      'code': '@override\nvoid dispose() {\n  _controller.dispose();\n  _timer.cancel();\n  super.dispose();\n}',
      'tips': 'Pencegah MEMORY LEAK nomor satu di Flutter! Selalu dispose StreamSubscription & Controllers.',
    },
  ];

  void _triggerSetState() {
    setState(() {
      _selectedStep = 3;
      _rebuildCount++;
      _simulatedEvent = 'setState() dipanggil! -> Menjadwalkan eksekusi build() ke-$_rebuildCount ';
    });
  }

  void _triggerParentUpdate() {
    setState(() {
      _selectedStep = 4;
      _simulatedEvent = 'Parent mengirim props baru -> didUpdateWidget() terpanggil ';
    });
  }

  void _triggerUnmount() {
    setState(() {
      _selectedStep = 6;
      _simulatedEvent = 'Widget ditutup / Navigator.pop() -> dispose() dijalankan ';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cur = _steps[_selectedStep];

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
          Row(
            children: [
              const Icon(Icons.sync_rounded, color: Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'StatefulWidget Lifecycle Pipeline',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Rebuilds: $_rebuildCount',
                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Stepper Bar
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _steps.length,
              separatorBuilder: (context, index) => const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 16),
              itemBuilder: (context, index) {
                final isSelected = _selectedStep == index;
                final step = _steps[index];

                return InkWell(
                  onTap: () => setState(() => _selectedStep = index),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF334155),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          step['title'].toString().split(' ')[1],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: step['frequencyColor'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Detail Card of Selected Step
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cur['title'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (cur['frequencyColor'] as Color).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cur['frequency'] as String,
                        style: TextStyle(
                          color: cur['frequencyColor'] as Color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  cur['desc'] as String,
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11.5, height: 1.35),
                ),
                const SizedBox(height: 8),

                // Code Sample
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    cur['code'] as String,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF38BDF8),
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Pro Tip
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFFDE047), size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        cur['tips'] as String,
                        style: const TextStyle(color: Color(0xFFFDE047), fontSize: 10.5, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Simulation Triggers
          const Text(
            'Simulasikan Event Lifecycle:',
            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              FilledButton.tonal(
                onPressed: _triggerSetState,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  foregroundColor: const Color(0xFFA5B4FC),
                ),
                child: const Text('Panggil setState()', style: TextStyle(fontSize: 11)),
              ),
              FilledButton.tonal(
                onPressed: _triggerParentUpdate,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                  foregroundColor: const Color(0xFFDDD6FE),
                ),
                child: const Text('Update Props Parent', style: TextStyle(fontSize: 11)),
              ),
              FilledButton.tonal(
                onPressed: _triggerUnmount,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.3),
                  foregroundColor: const Color(0xFFFECACA),
                ),
                child: const Text('Tutup Layar (Dispose)', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _simulatedEvent,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
