import 'package:flutter/material.dart';

class StateManagementMasterVisualizerWidget extends StatefulWidget {
  const StateManagementMasterVisualizerWidget({super.key});

  @override
  State<StateManagementMasterVisualizerWidget> createState() =>
      _StateManagementMasterVisualizerWidgetState();
}

class _StateManagementMasterVisualizerWidgetState
    extends State<StateManagementMasterVisualizerWidget> {
  int _activeTab = 0; // 0: BLoC/Cubit, 1: Riverpod 2.x

  // BLoC State Simulator
  String _blocCurrentState = 'AuthInitial';
  final List<String> _blocLog = [
    '[BlocProvider]: AuthBloc diinisialisasi dengan state AuthInitial',
  ];

  // Riverpod State Simulator
  int _riverpodCount = 10;
  int _rebuildCounterWidget = 0;

  void _dispatchBlocEvent(
    String eventName,
    String nextState,
    String description,
  ) {
    setState(() {
      _blocLog.insert(0, '[Event Dispatched]: $eventName');
      _blocCurrentState = 'AuthLoading';
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _blocCurrentState = nextState;
          _blocLog.insert(0, '[State Emitted]: $nextState ($description)');
        });
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
          const Row(
            children: [
              Icon(Icons.hub_rounded, color: Color(0xFFC084FC), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Simulator Alur State Management Lanjutan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Pattern Toggle (BLoC vs Riverpod)
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeTab = 0),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          _activeTab == 0
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            _activeTab == 0
                                ? const Color(0xFFA855F7)
                                : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'BLoC / Cubit Pattern',
                      style: TextStyle(
                        color: _activeTab == 0 ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight:
                            _activeTab == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeTab = 1),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          _activeTab == 1
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            _activeTab == 1
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Riverpod 2.x Pattern',
                      style: TextStyle(
                        color: _activeTab == 1 ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight:
                            _activeTab == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (_activeTab == 0)
            _buildBlocSimulator()
          else
            _buildRiverpodSimulator(),
        ],
      ),
    );
  }

  Widget _buildBlocSimulator() {
    Color stateColor;
    switch (_blocCurrentState) {
      case 'AuthLoading':
        stateColor = const Color(0xFFF59E0B);
        break;
      case 'AuthSuccess':
        stateColor = const Color(0xFF22C55E);
        break;
      case 'AuthFailure':
        stateColor = const Color(0xFFEF4444);
        break;
      default:
        stateColor = const Color(0xFF94A3B8);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current State Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: stateColor.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: stateColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Current State: ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _blocCurrentState,
                style: TextStyle(
                  color: stateColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const Spacer(),
              if (_blocCurrentState == 'AuthLoading')
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFF59E0B),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Event Trigger Buttons
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ElevatedButton(
              onPressed:
                  () => _dispatchBlocEvent(
                    'LoginSubmitted("zainal", "pass123")',
                    'AuthSuccess',
                    'Token berhasil diverifikasi',
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Event: Login Sukses'),
            ),
            ElevatedButton(
              onPressed:
                  () => _dispatchBlocEvent(
                    'LoginSubmitted("guest", "wrong")',
                    'AuthFailure',
                    'Kredensial tidak valid (401)',
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Event: Login Gagal'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _blocCurrentState = 'AuthInitial';
                  _blocLog.insert(
                    0,
                    '[Reset]: State dikembalikan ke AuthInitial',
                  );
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Color(0xFF475569)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                textStyle: const TextStyle(fontSize: 10.5),
              ),
              child: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Transition Logs Console
        Container(
          padding: const EdgeInsets.all(10),
          height: 110,
          decoration: BoxDecoration(
            color: const Color(0xFF020617),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: ListView.builder(
            itemCount: _blocLog.length,
            itemBuilder: (context, index) {
              final log = _blocLog[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  log,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color:
                        log.contains('Event')
                            ? const Color(0xFFFDE047)
                            : log.contains('Success')
                            ? const Color(0xFF4ADE80)
                            : log.contains('Failure')
                            ? const Color(0xFFF87171)
                            : const Color(0xFF94A3B8),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRiverpodSimulator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Provider Tree Cards
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF0284C7).withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ProviderScope Hierarchy:',
                style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'itemCountProvider: $_riverpodCount item',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'totalPriceProvider (Computed): Rp ${_riverpodCount * 25000}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Live Consumer Rebuild Box
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF020617),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ConsumerWidget Rebuild Count:',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                  ),
                  Text(
                    '$_rebuildCounterWidget kali rebuild',
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _riverpodCount++;
                    _rebuildCounterWidget++;
                  });
                },
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Color(0xFF38BDF8),
                  size: 28,
                ),
                tooltip:
                    'Tambah Item (ref.read(itemCountProvider.notifier).increment())',
              ),
              IconButton(
                onPressed:
                    _riverpodCount > 0
                        ? () {
                          setState(() {
                            _riverpodCount--;
                            _rebuildCounterWidget++;
                          });
                        }
                        : null,
                icon: const Icon(
                  Icons.remove_circle_rounded,
                  color: Color(0xFFF87171),
                  size: 28,
                ),
                tooltip: 'Kurangi Item',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
