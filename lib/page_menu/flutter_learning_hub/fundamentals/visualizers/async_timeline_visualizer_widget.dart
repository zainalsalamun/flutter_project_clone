import 'dart:async';
import 'package:flutter/material.dart';

class AsyncTimelineVisualizerWidget extends StatefulWidget {
  const AsyncTimelineVisualizerWidget({super.key});

  @override
  State<AsyncTimelineVisualizerWidget> createState() => _AsyncTimelineVisualizerWidgetState();
}

class _AsyncTimelineVisualizerWidgetState extends State<AsyncTimelineVisualizerWidget> {
  bool _isFutureMode = true;
  String _futureState = 'Idle (Belum Dijalankan)';
  Color _futureColor = Colors.grey;
  bool _isLoadingFuture = false;

  final List<String> _streamEvents = [];
  int _streamTick = 0;
  Timer? _streamTimer;

  @override
  void dispose() {
    _streamTimer?.cancel();
    super.dispose();
  }

  void _runFutureSimulation() async {
    setState(() {
      _isLoadingFuture = true;
      _futureState = 'Uncompleted (Menunggu Network Response... )';
      _futureColor = const Color(0xFFF59E0B);
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoadingFuture = false;
        _futureState = 'Completed! Data HTTP 200 OK diterima ';
        _futureColor = const Color(0xFF10B981);
      });
    }
  }

  void _toggleStreamSimulation() {
    if (_streamTimer != null && _streamTimer!.isActive) {
      _streamTimer?.cancel();
      setState(() {
        _streamEvents.add('Stream Ditutup (Done) ');
      });
    } else {
      _streamEvents.clear();
      _streamTick = 0;
      _streamTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
        if (_streamTick >= 5) {
          timer.cancel();
          setState(() {
            _streamEvents.add('Stream Selesai (onDone) ');
          });
        } else {
          _streamTick++;
          setState(() {
            _streamEvents.add('Event #$_streamTick: Lokasi GPS diperbarui ');
          });
        }
      });
    }
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
              const Icon(Icons.cloud_sync_rounded, color: Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Future (Single Value) vs Stream (Event Sequence)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Future (Satu Nilai)', style: TextStyle(fontSize: 11))),
              ButtonSegment(value: false, label: Text('Stream (Deretan Event)', style: TextStyle(fontSize: 11))),
            ],
            selected: {_isFutureMode},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _isFutureMode = s.first),
            style: ButtonStyle(visualDensity: VisualDensity.compact),
          ),
          const SizedBox(height: 14),

          if (_isFutureMode) ...[
            // Future Visualizer Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _futureColor.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoadingFuture)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF59E0B)),
                        ),
                      if (_isLoadingFuture) const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _futureState,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _futureColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _isLoadingFuture ? null : _runFutureSimulation,
                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: const Text('Jalankan async / await (2 Detik)', style: TextStyle(fontSize: 11)),
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Stream Visualizer Box
            Container(
              height: 160,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _streamEvents.isEmpty
                        ? const Center(
                            child: Text(
                              'Stream belum dimulai.\nTekan tombol di bawah untuk memancarkan event reaktif.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _streamEvents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_right_rounded, color: Color(0xFF14B8A6), size: 16),
                                    Text(
                                      _streamEvents[index],
                                      style: const TextStyle(color: Color(0xFF99F6E4), fontSize: 11),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  FilledButton.icon(
                    onPressed: _toggleStreamSimulation,
                    icon: Icon(_streamTimer?.isActive == true ? Icons.stop_rounded : Icons.sensors_rounded, size: 16),
                    label: Text(
                      _streamTimer?.isActive == true ? 'Hentikan Stream' : 'Mulai Stream Data Reaktif',
                      style: const TextStyle(fontSize: 11),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _streamTimer?.isActive == true ? const Color(0xFFEF4444) : const Color(0xFF14B8A6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
