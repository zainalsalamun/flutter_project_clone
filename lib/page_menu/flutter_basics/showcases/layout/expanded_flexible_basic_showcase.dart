import 'package:flutter/material.dart';

class ExpandedFlexibleBasicShowcase extends StatefulWidget {
  const ExpandedFlexibleBasicShowcase({super.key});

  @override
  State<ExpandedFlexibleBasicShowcase> createState() =>
      _ExpandedFlexibleBasicShowcaseState();
}

class _ExpandedFlexibleBasicShowcaseState
    extends State<ExpandedFlexibleBasicShowcase> {
  int _flex1 = 1;
  int _flex2 = 2;
  int _flex3 = 1;
  bool _useSpacer = false;
  FlexFit _box2Fit = FlexFit.tight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Row Container (Bounded Width)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      // Item 1: Expanded
                      Expanded(
                        flex: _flex1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Flex: $_flex1\n(Expanded)',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Item 2: Flexible with fit
                      Flexible(
                        flex: _flex2,
                        fit: _box2Fit,
                        child: Container(
                          width: _box2Fit == FlexFit.loose ? 60 : null,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Flex: $_flex2\n(${_box2Fit.name})',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      if (_useSpacer) ...[
                        const Spacer(flex: 1),
                        const SizedBox(width: 6),
                      ],

                      // Item 3: Expanded
                      Expanded(
                        flex: _flex3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Flex: $_flex3\n(Expanded)',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Flex Factor Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        _buildFlexSteppers(
          'Box 1 (Blue) Flex:',
          _flex1,
          (v) => setState(() => _flex1 = v),
        ),
        _buildFlexSteppers(
          'Box 2 (Green) Flex:',
          _flex2,
          (v) => setState(() => _flex2 = v),
        ),
        _buildFlexSteppers(
          'Box 3 (Orange) Flex:',
          _flex3,
          (v) => setState(() => _flex3 = v),
        ),

        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Box 2 FlexFit:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            ChoiceChip(
              label: const Text(
                'tight (Forces Fill)',
                style: TextStyle(fontSize: 11),
              ),
              selected: _box2Fit == FlexFit.tight,
              onSelected: (v) => setState(() => _box2Fit = FlexFit.tight),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('loose', style: TextStyle(fontSize: 11)),
              selected: _box2Fit == FlexFit.loose,
              onSelected: (v) => setState(() => _box2Fit = FlexFit.loose),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Insert Spacer(flex: 1):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _useSpacer,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _useSpacer = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlexSteppers(
    String label,
    int val,
    ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            onPressed: val > 1 ? () => onChanged(val - 1) : null,
          ),
          Text(
            '$val',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 18),
            onPressed: val < 5 ? () => onChanged(val + 1) : null,
          ),
        ],
      ),
    );
  }
}
