import 'package:flutter/material.dart';

class StateFlowVisualizerWidget extends StatefulWidget {
  const StateFlowVisualizerWidget({super.key});

  @override
  State<StateFlowVisualizerWidget> createState() => _StateFlowVisualizerWidgetState();
}

class _StateFlowVisualizerWidgetState extends State<StateFlowVisualizerWidget> {
  bool _isGlobalState = false;
  int _counter = 0;
  String _flowLog = 'Tekan tombol di bawah untuk memicu perubahan state.';

  void _increment() {
    setState(() {
      _counter++;
      if (_isGlobalState) {
        _flowLog = 'Global State (BLoC/Provider): Memancarkan event state #$_counter -> Seluruh listener otomatis ter-update!';
      } else {
        _flowLog = 'Local State (setState): State #$_counter diperbarui secara lokal di dalam widget ini saja.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.dynamic_feed_rounded, color: Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Ephemeral State vs App (Global) State',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented Switcher
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Ephemeral (Local)', style: TextStyle(fontSize: 11))),
              ButtonSegment(value: true, label: Text('App (Global State)', style: TextStyle(fontSize: 11))),
            ],
            selected: {_isGlobalState},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() {
              _isGlobalState = s.first;
              _flowLog = _isGlobalState
                  ? 'Beralih ke App State: Cocok untuk Keranjang Belanja, Autentikasi User, Theme.'
                  : 'Beralih ke Ephemeral State: Cocok untuk input teks form, tab aktif, animasi lokal.';
            }),
            style: ButtonStyle(visualDensity: VisualDensity.compact),
          ),
          const SizedBox(height: 14),

          // Flow Architecture Diagram
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isGlobalState ? const Color(0xFF06B6D4) : const Color(0xFF6366F1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isGlobalState ? const Color(0xFF06B6D4).withValues(alpha: 0.2) : const Color(0xFF6366F1).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _isGlobalState ? 'App State Provider / Bloc' : 'Local StatefulWidget State',
                        style: TextStyle(
                          color: _isGlobalState ? const Color(0xFF67E8F9) : const Color(0xFFA5B4FC),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Simulated Widgets listening
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConsumerNode('Widget A\n(Navbar Badge)', _isGlobalState),
                    _buildConsumerNode('Widget B\n(Detail Card)', true),
                    _buildConsumerNode('Widget C\n(Checkout)', _isGlobalState),
                  ],
                ),
                const SizedBox(height: 12),

                // Counter Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'State Value: Counter = $_counter',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: _increment,
            icon: const Icon(Icons.touch_app_rounded, size: 16),
            label: Text(_isGlobalState ? 'Dispatch Global Event' : 'Trigger setState()'),
            style: FilledButton.styleFrom(
              backgroundColor: _isGlobalState ? const Color(0xFF06B6D4) : const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            _flowLog,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumerNode(String label, bool isUpdated) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 78,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isUpdated ? const Color(0xFF10B981).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUpdated ? const Color(0xFF34D399) : Colors.white24,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isUpdated ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 14,
            color: isUpdated ? const Color(0xFF34D399) : Colors.white38,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
