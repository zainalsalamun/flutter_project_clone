import 'package:flutter/material.dart';

class InteractiveViewerBasicShowcase extends StatefulWidget {
  const InteractiveViewerBasicShowcase({super.key});

  @override
  State<InteractiveViewerBasicShowcase> createState() =>
      _InteractiveViewerBasicShowcaseState();
}

class _InteractiveViewerBasicShowcaseState
    extends State<InteractiveViewerBasicShowcase> {
  final TransformationController _transController = TransformationController();
  bool _panEnabled = true;
  bool _scaleEnabled = true;

  @override
  void dispose() {
    _transController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transController.value = Matrix4.identity();
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
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              InteractiveViewer(
                transformationController: _transController,
                panEnabled: _panEnabled,
                scaleEnabled: _scaleEnabled,
                minScale: 0.5,
                maxScale: 3.5,
                boundaryMargin: const EdgeInsets.all(40),
                child: Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF312E81)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pinch_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Pinch to Zoom \nDrag to Pan ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: FilledButton.tonal(
                  onPressed: _resetZoom,
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    'Reset Zoom',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'InteractiveViewer Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text(
                  'Pan Enabled (Drag):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                value: _panEnabled,
                activeThumbColor: const Color(0xFF6366F1),
                onChanged: (v) => setState(() => _panEnabled = v),
              ),
            ),
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text(
                  'Scale (Pinch Zoom):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                value: _scaleEnabled,
                activeThumbColor: const Color(0xFF6366F1),
                onChanged: (v) => setState(() => _scaleEnabled = v),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
