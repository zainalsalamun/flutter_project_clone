import 'dart:async';
import 'package:flutter/material.dart';

class DashedUploadDropzoneShowcase extends StatefulWidget {
  const DashedUploadDropzoneShowcase({super.key});

  @override
  State<DashedUploadDropzoneShowcase> createState() =>
      _DashedUploadDropzoneShowcaseState();
}

class _DashedUploadDropzoneShowcaseState
    extends State<DashedUploadDropzoneShowcase>
    with SingleTickerProviderStateMixin {
  final bool _isDragOver = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadingFileName = '';
  Timer? _uploadTimer;

  final List<Map<String, dynamic>> _uploadedFiles = [
    {
      'name': 'Invoice_Pembayaran_SEP2026.pdf',
      'size': '2.4 MB',
      'type': 'PDF',
      'color': const Color(0xFFEF4444),
      'icon': Icons.picture_as_pdf_rounded,
      'date': 'Hari ini, 14:20',
    },
    {
      'name': 'Bukti_Transfer_BCA.jpg',
      'size': '1.1 MB',
      'type': 'IMG',
      'color': const Color(0xFF3B82F6),
      'icon': Icons.image_rounded,
      'date': 'Kemarin, 09:15',
    },
  ];

  final List<Map<String, dynamic>> _sampleFilesToPick = [
    {
      'name': 'KTP_Identitas_Zainal.png',
      'size': '3.2 MB',
      'type': 'PNG',
      'color': const Color(0xFF10B981),
      'icon': Icons.badge_rounded,
    },
    {
      'name': 'Surat_Perjanjian_Kerja.docx',
      'size': '4.8 MB',
      'type': 'DOC',
      'color': const Color(0xFF6366F1),
      'icon': Icons.description_rounded,
    },
    {
      'name': 'Laporan_Keuangan_Q3.pdf',
      'size': '5.6 MB',
      'type': 'PDF',
      'color': const Color(0xFFEF4444),
      'icon': Icons.analytics_rounded,
    },
  ];

  int _samplePickIndex = 0;

  @override
  void dispose() {
    _uploadTimer?.cancel();
    super.dispose();
  }

  void _startSimulatedUpload() {
    if (_isUploading) return;

    final fileToUpload =
        _sampleFilesToPick[_samplePickIndex % _sampleFilesToPick.length];
    _samplePickIndex++;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.05;
      _uploadingFileName = fileToUpload['name'] as String;
    });

    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _uploadProgress += 0.05;
        if (_uploadProgress >= 1.0) {
          timer.cancel();
          _isUploading = false;
          _uploadedFiles.insert(0, {
            'name': fileToUpload['name'],
            'size': fileToUpload['size'],
            'type': fileToUpload['type'],
            'color': fileToUpload['color'],
            'icon': fileToUpload['icon'],
            'date': 'Baru saja',
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'File "${fileToUpload['name']}" berhasil diunggah!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    });
  }

  void _cancelUpload() {
    _uploadTimer?.cancel();
    setState(() {
      _isUploading = false;
      _uploadProgress = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proses unggah berkas dibatalkan.'),
        backgroundColor: Color(0xFF64748B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeFile(int index) {
    final removed = _uploadedFiles.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${removed['name']}" dihapus.'),
        action: SnackBarAction(
          label: 'BATAL',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _uploadedFiles.insert(index, removed);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. DASHED DROPZONE CARD ----------------
        GestureDetector(
          onTap: _isUploading ? null : _startSimulatedUpload,
          child: CustomPaint(
            painter: _DashedRRectPainter(
              color:
                  _isDragOver
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF94A3B8),
              strokeWidth: 1.6,
              gap: 5.0,
              dashWidth: 7.0,
              borderRadius: 20.0,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color:
                    _isDragOver
                        ? const Color(0xFF6366F1).withValues(alpha: 0.05)
                        : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Cloud / Upload Icon Container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_rounded,
                      color: Color(0xFF6366F1),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Tarik & Lepas Berkas di Sini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'atau klik untuk memilih file dari galeri / dokumen',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),

                  // Format Badge Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'PNG, JPG, PDF, DOCX (Maks. 10MB)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ---------------- 2. IN-PROGRESS UPLOAD BANNER ----------------
        if (_isUploading) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.upload_file_rounded,
                        color: Color(0xFF6366F1),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _uploadingFileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mengunggah... ${(_uploadProgress * 100).toInt()}% • 1.4 MB/s',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      color: Colors.grey.shade500,
                      onPressed: _cancelUpload,
                      tooltip: 'Batalkan',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _uploadProgress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ---------------- 3. UPLOADED FILES SECTION ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.folder_open_rounded,
                  size: 16,
                  color: Color(0xFF6366F1),
                ),
                const SizedBox(width: 6),
                Text(
                  'Berkas Terunggah (${_uploadedFiles.length})',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            if (_uploadedFiles.isNotEmpty)
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => setState(() => _uploadedFiles.clear()),
                child: const Text(
                  'Hapus Semua',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (_uploadedFiles.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 28,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 6),
                Text(
                  'Belum ada berkas terunggah',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          )
        else
          Column(
            children: List.generate(_uploadedFiles.length, (index) {
              final file = _uploadedFiles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // File Type Color Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (file['color'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        file['icon'] as IconData,
                        color: file['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // File Metadata
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${file['size']} • ${file['date']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Success Icon & Delete Action
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 18,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      color: Colors.grey.shade400,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _removeFile(index),
                      tooltip: 'Hapus Berkas',
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DASHED ROUNDED RECTANGLE PAINTER
// ---------------------------------------------------------------------------
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashWidth;
  final double borderRadius;

  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length =
            (distance + dashWidth < metric.length)
                ? dashWidth
                : metric.length - distance;
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.borderRadius != borderRadius;
}
