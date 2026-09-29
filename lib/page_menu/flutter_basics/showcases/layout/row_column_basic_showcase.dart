import 'package:flutter/material.dart';

class RowColumnBasicShowcase extends StatefulWidget {
  const RowColumnBasicShowcase({super.key});

  @override
  State<RowColumnBasicShowcase> createState() => _RowColumnBasicShowcaseState();
}

class _RowColumnBasicShowcaseState extends State<RowColumnBasicShowcase> {
  bool _isRow = true;
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.spaceEvenly;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
  int _itemCount = 3;

  final List<Color> _itemColors = [
    const Color(0xFF6366F1),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
    const Color(0xFF3B82F6),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Box
        Container(
          height: 250,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Stack(
            children: [
              // Axis indicator labels
              Positioned(
                top: 4,
                left: 8,
                child: Text(
                  _isRow ? 'MainAxis (Horizontal) →' : 'MainAxis (Vertical) ↓',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Text(
                  _isRow
                      ? 'CrossAxis (Vertical) ↓'
                      : 'CrossAxis (Horizontal) →',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // The Row / Column Container
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child:
                        _isRow
                            ? Row(
                              mainAxisAlignment: _mainAxisAlignment,
                              crossAxisAlignment: _crossAxisAlignment,
                              children: _buildItems(),
                            )
                            : Column(
                              mainAxisAlignment: _mainAxisAlignment,
                              crossAxisAlignment: _crossAxisAlignment,
                              children: _buildItems(),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls Section
        const Text(
          'Row & Column Parameters',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        // Direction Switcher
        Row(
          children: [
            const Expanded(
              child: Text(
                'Layout Direction:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text(
                    'Row (Horizontal)',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                ButtonSegment(
                  value: false,
                  label: Text(
                    'Column (Vertical)',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
              selected: {_isRow},
              showSelectedIcon: false,
              onSelectionChanged: (set) => setState(() => _isRow = set.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // MainAxisAlignment Dropdown
        _buildDropdownRow<MainAxisAlignment>(
          label: 'MainAxisAlignment:',
          value: _mainAxisAlignment,
          items: MainAxisAlignment.values,
          itemLabel: (v) => v.name,
          onChanged: (v) {
            if (v != null) setState(() => _mainAxisAlignment = v);
          },
        ),
        const SizedBox(height: 8),

        // CrossAxisAlignment Dropdown
        _buildDropdownRow<CrossAxisAlignment>(
          label: 'CrossAxisAlignment:',
          value: _crossAxisAlignment,
          items: const [
            CrossAxisAlignment.start,
            CrossAxisAlignment.center,
            CrossAxisAlignment.end,
            CrossAxisAlignment.stretch,
          ],
          itemLabel: (v) => v.name,
          onChanged: (v) {
            if (v != null) setState(() => _crossAxisAlignment = v);
          },
        ),
        const SizedBox(height: 10),

        // Item Count Buttons
        Row(
          children: [
            const Expanded(
              child: Text(
                'Children Count:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed:
                  _itemCount > 1 ? () => setState(() => _itemCount--) : null,
            ),
            Text(
              '$_itemCount',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed:
                  _itemCount < 5 ? () => setState(() => _itemCount++) : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildItems() {
    return List.generate(_itemCount, (index) {
      final color = _itemColors[index % _itemColors.length];
      final heights = [45.0, 60.0, 38.0, 50.0, 42.0];
      final widths = [45.0, 60.0, 38.0, 50.0, 42.0];
      final h =
          _crossAxisAlignment == CrossAxisAlignment.stretch && _isRow
              ? null
              : heights[index % heights.length];
      final w =
          _crossAxisAlignment == CrossAxisAlignment.stretch && !_isRow
              ? null
              : widths[index % widths.length];

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: w,
        height: h,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '#${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    });
  }

  Widget _buildDropdownRow<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                isDense: true,
                items:
                    items.map((e) {
                      return DropdownMenuItem<T>(
                        value: e,
                        child: Text(
                          itemLabel(e),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
