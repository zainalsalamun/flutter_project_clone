import 'package:flutter/material.dart';

class ConstraintsRuleVisualizerWidget extends StatefulWidget {
  const ConstraintsRuleVisualizerWidget({super.key});

  @override
  State<ConstraintsRuleVisualizerWidget> createState() =>
      _ConstraintsRuleVisualizerWidgetState();
}

class _ConstraintsRuleVisualizerWidgetState
    extends State<ConstraintsRuleVisualizerWidget> {
  double _parentWidth = 240;
  final double _parentHeight = 140;
  double _childRequestedWidth = 160;
  final double _childRequestedHeight = 90;
  bool _isTightConstraints = false;

  @override
  Widget build(BuildContext context) {
    // Calculate effective child size bounded by parent constraints
    final double effectiveWidth =
        _isTightConstraints
            ? _parentWidth
            : _childRequestedWidth.clamp(40.0, _parentWidth);
    final double effectiveHeight =
        _isTightConstraints
            ? _parentHeight
            : _childRequestedHeight.clamp(30.0, _parentHeight);

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
              Icon(Icons.rule_rounded, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Aturan Emas Layout: Constraints & Sizing',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Three Golden Rules Summary Pills
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '1. Constraints ↓\n(Parent kirim batasan)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF93C5FD),
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '2. Sizes ↑\n(Child tentukan ukuran)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6EE7B7),
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '3. Position \n(Parent atur letak X,Y)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFCD34D),
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Live Simulation Viewport
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Parent Box
                Container(
                  width: _parentWidth,
                  height: _parentHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF60A5FA),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Parent Constraints: Max ${_parentWidth.toInt()} x ${_parentHeight.toInt()} px',
                          style: const TextStyle(
                            color: Color(0xFF93C5FD),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Child Box Inside
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: effectiveWidth,
                        height: effectiveHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Child Size:\n${effectiveWidth.toInt()} x ${effectiveHeight.toInt()} px',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Sliders & Controls
          _buildSlider(
            label: 'Parent Max Width:',
            value: _parentWidth,
            min: 140,
            max: 270,
            onChanged: (v) => setState(() => _parentWidth = v),
          ),
          _buildSlider(
            label: 'Child Requested Width:',
            value: _childRequestedWidth,
            min: 60,
            max: 300,
            onChanged: (v) => setState(() => _childRequestedWidth = v),
          ),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tight Constraints (Paksa isi penuh):',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: _isTightConstraints,
                activeThumbColor: const Color(0xFF38BDF8),
                onChanged: (v) => setState(() => _isTightConstraints = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label ${value.toInt()}px',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                trackHeight: 2.5,
                activeTrackColor: const Color(0xFF38BDF8),
                thumbColor: const Color(0xFF38BDF8),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                onChanged: (v) => onChanged(v.clamp(min, max)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
