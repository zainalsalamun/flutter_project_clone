import 'package:flutter/material.dart';

class PinchZoomViewerShowcase extends StatefulWidget {
  const PinchZoomViewerShowcase({super.key});

  @override
  State<PinchZoomViewerShowcase> createState() =>
      _PinchZoomViewerShowcaseState();
}

class _PinchZoomViewerShowcaseState extends State<PinchZoomViewerShowcase>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformController;
  late AnimationController _animController;
  Animation<Matrix4>? _zoomAnimation;

  double _currentScale = 1.0;
  int _quarterTurns = 0;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
      if (_zoomAnimation != null) {
        _transformController.value = _zoomAnimation!.value;
      }
    });

    _transformController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    _transformController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final matrix = _transformController.value;
    final scale = matrix.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.02) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  void _animateToMatrix(Matrix4 targetMatrix) {
    _zoomAnimation = Matrix4Tween(
      begin: _transformController.value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0);
  }

  void _resetZoom() {
    setState(() => _quarterTurns = 0);
    _animateToMatrix(Matrix4.identity());
  }

  void _zoomIn() {
    final newScale = (_currentScale * 1.35).clamp(0.8, 4.5);
    final target = Matrix4.identity()..scale(newScale);
    _animateToMatrix(target);
  }

  void _zoomOut() {
    final newScale = (_currentScale / 1.35).clamp(0.8, 4.5);
    final target = Matrix4.identity()..scale(newScale);
    _animateToMatrix(target);
  }

  void _handleDoubleTap(TapDownDetails details) {
    if (_currentScale > 1.2) {
      _resetZoom();
    } else {
      // Zoom into 2.5x centered at tap position
      final position = details.localPosition;
      final target =
          Matrix4.identity()
            ..translate(-position.dx * 1.5, -position.dy * 1.5)
            ..scale(2.5);
      _animateToMatrix(target);
    }
  }

  void _rotate() {
    setState(() {
      _quarterTurns = (_quarterTurns + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Interactive Zoom & Pan Container Box
        Container(
          height: 260,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Interactive Viewer Area
                GestureDetector(
                  onDoubleTapDown: _handleDoubleTap,
                  onDoubleTap: () {},
                  child: InteractiveViewer(
                    transformationController: _transformController,
                    minScale: 0.8,
                    maxScale: 4.5,
                    boundaryMargin: const EdgeInsets.all(80),
                    child: RotatedBox(
                      quarterTurns: _quarterTurns,
                      child: const _HighDetailFloorPlanCanvas(),
                    ),
                  ),
                ),

                // Top Info & Zoom Percentage Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.zoom_in_rounded,
                          size: 14,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${(_currentScale * 100).toInt()}% Zoom',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Right Double-Tap Hint
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 12,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Double tap: Quick Zoom',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Floating Tool Action Buttons
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToolButton(
                          icon: Icons.zoom_in_rounded,
                          tooltip: 'Perbesar',
                          onTap: _zoomIn,
                        ),
                        _buildToolButton(
                          icon: Icons.zoom_out_rounded,
                          tooltip: 'Perkecil',
                          onTap: _zoomOut,
                        ),
                        _buildToolButton(
                          icon: Icons.rotate_right_rounded,
                          tooltip: 'Putar 90°',
                          onTap: _rotate,
                        ),
                        _buildToolButton(
                          icon: Icons.restart_alt_rounded,
                          tooltip: 'Reset Center',
                          onTap: _resetZoom,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Features & Interaction Guide Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.pinch_rounded, size: 16, color: Color(0xFF6366F1)),
                  SizedBox(width: 6),
                  Text(
                    'Gestur Interaktif yang Didukung:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Gunakan 2 jari (Pinch) untuk memperbesar hingga 450%.\n• Geser (Pan / Drag) ke segala arah dengan inersia lentur.\n• Ketuk dua kali (Double-tap) untuk zoom instan ke 250%.\n• Tombol toolbar di kanan bawah untuk rotasi dan reset posisi.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: const EdgeInsets.all(4),
      icon: Icon(icon, size: 18, color: Colors.white),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// HIGH-DETAIL VECTOR BLUEPRINT / FLOOR PLAN CANVAS
// ---------------------------------------------------------------------------
class _HighDetailFloorPlanCanvas extends StatelessWidget {
  const _HighDetailFloorPlanCanvas();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 260,
      decoration: const BoxDecoration(color: Color(0xFF0F172A)),
      child: CustomPaint(painter: _BlueprintPainter()),
    );
  }
}

class _BlueprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Grid lines background
    final gridPaint =
        Paint()
          ..color = const Color(0xFF1E293B)
          ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Blueprint Architectural Rooms & Walls
    final wallPaint =
        Paint()
          ..color = const Color(0xFF38BDF8)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

    final room1 = Rect.fromLTWH(30, 30, 150, 90);
    final room2 = Rect.fromLTWH(190, 30, 180, 90);
    final room3 = Rect.fromLTWH(30, 130, 340, 100);

    canvas.drawRect(room1, wallPaint);
    canvas.drawRect(room2, wallPaint);
    canvas.drawRect(room3, wallPaint);

    // 3. Highlight Nodes & Furniture representations
    final fillPaint =
        Paint()
          ..color = const Color(0xFF38BDF8).withValues(alpha: 0.08)
          ..style = PaintingStyle.fill;
    canvas.drawRect(room1, fillPaint);
    canvas.drawRect(room2, fillPaint);
    canvas.drawRect(room3, fillPaint);

    // 4. Detailed Dimension Texts
    _drawText(
      canvas,
      'MASTER SUITE (4.5m x 3.0m)',
      const Offset(40, 40),
      const Color(0xFF38BDF8),
      10,
    );
    _drawText(
      canvas,
      'LIVING ROOM / LOUNGE',
      const Offset(205, 40),
      const Color(0xFF38BDF8),
      10,
    );
    _drawText(
      canvas,
      'OPEN CONCEPT KITCHEN & BALCONY',
      const Offset(40, 140),
      const Color(0xFF38BDF8),
      10,
    );

    _drawText(
      canvas,
      '[NODE #A1: SMART HUB]',
      const Offset(40, 90),
      const Color(0xFFFDE047),
      8,
    );
    _drawText(
      canvas,
      '[NODE #B2: FIBER OPTIC]',
      const Offset(205, 90),
      const Color(0xFF4ADE80),
      8,
    );
    _drawText(
      canvas,
      '[NODE #C3: HVAC CONTROL]',
      const Offset(40, 195),
      const Color(0xFFF472B6),
      8,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double fontSize,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
