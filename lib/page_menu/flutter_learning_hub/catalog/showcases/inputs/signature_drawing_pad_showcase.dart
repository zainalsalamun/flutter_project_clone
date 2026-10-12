import 'package:flutter/material.dart';

class SignatureDrawingPadShowcase extends StatefulWidget {
  const SignatureDrawingPadShowcase({super.key});

  @override
  State<SignatureDrawingPadShowcase> createState() =>
      _SignatureDrawingPadShowcaseState();
}

class _SignatureDrawingPadShowcaseState
    extends State<SignatureDrawingPadShowcase> {
  List<DrawnStroke>? _savedStrokes;
  String? _savedTimestamp;

  void _openSignatureDialog() async {
    final result = await showDialog<List<DrawnStroke>>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _SignatureDialogModal(),
    );

    if (result != null && result.isNotEmpty) {
      _applySavedSignature(result);
    }
  }

  void _openSignatureBottomSheet() async {
    final result = await showModalBottomSheet<List<DrawnStroke>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _SignatureBottomSheetModal(),
    );

    if (result != null && result.isNotEmpty) {
      _applySavedSignature(result);
    }
  }

  void _applySavedSignature(List<DrawnStroke> strokes) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
    setState(() {
      _savedStrokes = strokes;
      _savedTimestamp = timeStr;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.verified_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tanda tangan berhasil disimpan & diverifikasi!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearSavedSignature() {
    setState(() {
      _savedStrokes = null;
      _savedTimestamp = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Modal Trigger Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text(
                  'Buka Dialog Modal',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: _openSignatureDialog,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6366F1),
                  side: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.vertical_align_bottom_rounded, size: 18),
                label: const Text(
                  'Buka Bottom Sheet',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: _openSignatureBottomSheet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Signature Result Card or Empty State
        if (_savedStrokes != null && _savedStrokes!.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF10B981), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF10B981),
                            size: 16,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Tanda Tangan Terverifikasi',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_savedTimestamp != null)
                      Text(
                        _savedTimestamp!,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Signature Rendered Canvas Box
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 35,
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        left: 16,
                        child: Text(
                          'Digital Signature Certificate #VAL-9921',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: _SignaturePainter(strokes: _savedStrokes!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action buttons below result
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 16),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _clearSavedSignature,
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.edit_rounded, size: 14),
                      label: const Text(
                        'Ubah Tanda Tangan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _openSignatureDialog,
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          // Empty State Placeholder Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.draw_rounded,
                    size: 38,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Belum Ada Tanda Tangan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Klik salah satu tombol modal di atas untuk membuka canvas tanda tangan bebas hambatan gestur tab bar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DIALOG MODAL WRAPPER
// ---------------------------------------------------------------------------
class _SignatureDialogModal extends StatelessWidget {
  const _SignatureDialogModal();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const _SignaturePadContent(
          title: 'Tanda Tangan Digital (Dialog)',
          subtitle: 'Goreskan tanda tangan Anda di area canvas',
          isBottomSheet: false,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BOTTOM SHEET MODAL WRAPPER
// ---------------------------------------------------------------------------
class _SignatureBottomSheetModal extends StatelessWidget {
  const _SignatureBottomSheetModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const _SignaturePadContent(
        title: 'Canvas Tanda Tangan (Bottom Sheet)',
        subtitle: 'Tanda tangani dokumen di bawah ini',
        isBottomSheet: true,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// REUSABLE SIGNATURE PAD CONTENT & TOOLBAR
// ---------------------------------------------------------------------------
class _SignaturePadContent extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isBottomSheet;

  const _SignaturePadContent({
    required this.title,
    required this.subtitle,
    required this.isBottomSheet,
  });

  @override
  State<_SignaturePadContent> createState() => _SignaturePadContentState();
}

class _SignaturePadContentState extends State<_SignaturePadContent> {
  final List<DrawnStroke> _strokes = [];
  final List<DrawnStroke> _undoneStrokes = [];

  Color _selectedColor = const Color(0xFF0F172A);
  double _strokeWidth = 3.5;
  bool _isEraser = false;

  final List<Color> _colors = const [
    Color(0xFF0F172A),
    Color(0xFF2563EB),
    Color(0xFFDC2626),
    Color(0xFF16A34A),
    Color(0xFF9333EA),
  ];

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _undoneStrokes.clear();
    });
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _undoneStrokes.add(_strokes.removeLast());
      });
    }
  }

  void _redo() {
    if (_undoneStrokes.isNotEmpty) {
      setState(() {
        _strokes.add(_undoneStrokes.removeLast());
      });
    }
  }

  void _submit() {
    if (_strokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan buat tanda tangan terlebih dahulu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.of(context).pop(_strokes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Drag handle if bottom sheet
        if (widget.isBottomSheet)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

        // Header Title Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.draw_rounded,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Toolbar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Color dots
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      _colors.map((c) {
                        final isSelected = !_isEraser && _selectedColor == c;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = c;
                              _isEraser = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFF6366F1)
                                        : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(width: 12),

                // Stroke Widths
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      [2.0, 4.0, 7.0].map((w) {
                        final isSelected = _strokeWidth == w && !_isEraser;
                        return GestureDetector(
                          onTap:
                              () => setState(() {
                                _strokeWidth = w;
                                _isEraser = false;
                              }),
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              w == 2.0
                                  ? 'Tipis'
                                  : w == 4.0
                                  ? 'Sedang'
                                  : 'Tebal',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(width: 12),

                // Tools: Eraser, Undo, Redo, Clear
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(6),
                      icon: Icon(
                        Icons.cleaning_services_rounded,
                        color:
                            _isEraser
                                ? const Color(0xFFEF4444)
                                : Colors.grey.shade600,
                        size: 18,
                      ),
                      tooltip: 'Eraser',
                      onPressed: () => setState(() => _isEraser = !_isEraser),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(6),
                      icon: Icon(
                        Icons.undo_rounded,
                        color:
                            _strokes.isNotEmpty
                                ? const Color(0xFF6366F1)
                                : Colors.grey.shade300,
                        size: 18,
                      ),
                      onPressed: _strokes.isNotEmpty ? _undo : null,
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(6),
                      icon: Icon(
                        Icons.redo_rounded,
                        color:
                            _undoneStrokes.isNotEmpty
                                ? const Color(0xFF6366F1)
                                : Colors.grey.shade300,
                        size: 18,
                      ),
                      onPressed: _undoneStrokes.isNotEmpty ? _redo : null,
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(6),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                      tooltip: 'Bersihkan',
                      onPressed: _clearCanvas,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Drawing Canvas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: widget.isBottomSheet ? 230 : 210,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Guide Line
                  Positioned(
                    bottom: 45,
                    left: 24,
                    right: 24,
                    child: Container(height: 1, color: Colors.grey.shade300),
                  ),
                  Positioned(
                    bottom: 18,
                    left: 24,
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Garis panduan tanda tangan',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gesture Detector for drawing
                  GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        final strokeColor =
                            _isEraser
                                ? const Color(0xFFFAFAFA)
                                : _selectedColor;
                        final strokeW = _isEraser ? 24.0 : _strokeWidth;
                        _strokes.add(
                          DrawnStroke(
                            points: [details.localPosition],
                            color: strokeColor,
                            width: strokeW,
                          ),
                        );
                        _undoneStrokes.clear();
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        if (_strokes.isNotEmpty) {
                          _strokes.last.points.add(details.localPosition);
                        }
                      });
                    },
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _SignaturePainter(strokes: _strokes),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Footer Action Buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text(
                    'Simpan & Terapkan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DATA MODELS & PAINTER
// ---------------------------------------------------------------------------
class DrawnStroke {
  final List<Offset> points;
  final Color color;
  final double width;

  DrawnStroke({required this.points, required this.color, required this.width});
}

class _SignaturePainter extends CustomPainter {
  final List<DrawnStroke> strokes;

  _SignaturePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final paint =
          Paint()
            ..color = stroke.color
            ..strokeWidth = stroke.width
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first,
          stroke.width / 2,
          paint..style = PaintingStyle.fill,
        );
      } else {
        final path = Path();
        path.moveTo(stroke.points.first.dx, stroke.points.first.dy);

        for (int i = 0; i < stroke.points.length - 1; i++) {
          final p0 = stroke.points[i];
          final p1 = stroke.points[i + 1];
          final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
        }

        path.lineTo(stroke.points.last.dx, stroke.points.last.dy);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return true;
  }
}
