import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultimodalAttachmentTrayShowcase extends StatefulWidget {
  const MultimodalAttachmentTrayShowcase({super.key});

  @override
  State<MultimodalAttachmentTrayShowcase> createState() =>
      _MultimodalAttachmentTrayShowcaseState();
}

enum _AttachmentType { image, pdf, audio, csv }

class _AttachmentItem {
  final String id;
  final String name;
  final String size;
  final _AttachmentType type;
  final String tag;
  final Color color;
  double uploadProgress; // 0.0 to 1.0
  bool isComplete;

  _AttachmentItem({
    required this.id,
    required this.name,
    required this.size,
    required this.type,
    required this.tag,
    required this.color,
    this.uploadProgress = 1.0,
    this.isComplete = true,
  });
}

class _MultimodalAttachmentTrayShowcaseState
    extends State<MultimodalAttachmentTrayShowcase> {
  final List<_AttachmentItem> _attachments = [
    _AttachmentItem(
      id: '1',
      name: 'design_mockup_v2.png',
      size: '1.8 MB',
      type: _AttachmentType.image,
      tag: 'PNG',
      color: const Color(0xFFEC4899),
      uploadProgress: 1.0,
      isComplete: true,
    ),
    _AttachmentItem(
      id: '2',
      name: 'annual_audit_report.pdf',
      size: '3.4 MB',
      type: _AttachmentType.pdf,
      tag: 'PDF',
      color: const Color(0xFFEF4444),
      uploadProgress: 1.0,
      isComplete: true,
    ),
    _AttachmentItem(
      id: '3',
      name: 'voice_memo_meeting.m4a',
      size: '850 KB',
      type: _AttachmentType.audio,
      tag: 'AUDIO',
      color: const Color(0xFF8B5CF6),
      uploadProgress: 1.0,
      isComplete: true,
    ),
  ];

  int _fileIdCounter = 4;

  void _addAttachment(
    _AttachmentType type,
    String name,
    String size,
    String tag,
    Color color,
  ) {
    HapticFeedback.lightImpact();
    final newItem = _AttachmentItem(
      id: '${_fileIdCounter++}',
      name: name,
      size: size,
      type: type,
      tag: tag,
      color: color,
      uploadProgress: 0.0,
      isComplete: false,
    );

    setState(() {
      _attachments.add(newItem);
    });

    // Simulate Upload Progress
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (newItem.uploadProgress < 1.0) {
          newItem.uploadProgress = (newItem.uploadProgress + 0.15).clamp(
            0.0,
            1.0,
          );
        } else {
          newItem.isComplete = true;
          timer.cancel();
          HapticFeedback.selectionClick();
        }
      });
    });
  }

  void _removeAttachment(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _attachments.removeWhere((item) => item.id == id);
    });
  }

  void _showAddAttachmentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unggah Lampiran Baru:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPickerOption(
                      Icons.camera_alt_rounded,
                      'Kamera',
                      const Color(0xFFEC4899),
                      () {
                        Navigator.pop(ctx);
                        _addAttachment(
                          _AttachmentType.image,
                          'camera_snap_001.jpg',
                          '2.1 MB',
                          'JPG',
                          const Color(0xFFEC4899),
                        );
                      },
                    ),
                    _buildPickerOption(
                      Icons.photo_library_rounded,
                      'Galeri',
                      const Color(0xFF38BDF8),
                      () {
                        Navigator.pop(ctx);
                        _addAttachment(
                          _AttachmentType.image,
                          'figma_prototype.png',
                          '1.4 MB',
                          'PNG',
                          const Color(0xFF38BDF8),
                        );
                      },
                    ),
                    _buildPickerOption(
                      Icons.picture_as_pdf_rounded,
                      'Dokumen',
                      const Color(0xFFEF4444),
                      () {
                        Navigator.pop(ctx);
                        _addAttachment(
                          _AttachmentType.pdf,
                          'project_proposal.pdf',
                          '4.2 MB',
                          'PDF',
                          const Color(0xFFEF4444),
                        );
                      },
                    ),
                    _buildPickerOption(
                      Icons.mic_rounded,
                      'Rekaman',
                      const Color(0xFF8B5CF6),
                      () {
                        Navigator.pop(ctx);
                        _addAttachment(
                          _AttachmentType.audio,
                          'voice_brief.m4a',
                          '620 KB',
                          'AUDIO',
                          const Color(0xFF8B5CF6),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  Widget _buildPickerOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEC4899).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.perm_media_rounded,
                    color: Color(0xFFEC4899),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Multimodal File Attachment Tray',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Baki lampiran berkas multi-format dengan cincin progres upload interaktif dan tombol hapus cepat.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ATTACHMENT TRAY CONTAINER (SIMULATING CHAT COMPOSER)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TRAY HEADER & FILE COUNT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.folder_copy_rounded,
                          color: Color(0xFF38BDF8),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Lampiran Aktif (${_attachments.length} Berkas)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: _showAddAttachmentModal,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text(
                        'Tambah',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // HORIZONTAL SCROLLABLE ATTACHMENT CARDS TRAY
                if (_attachments.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.white38,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Belum ada berkas terlampir',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _showAddAttachmentModal,
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 16,
                          ),
                          label: const Text(
                            'Pilih Berkas',
                            style: TextStyle(fontSize: 11),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF334155),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _attachments.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final item = _attachments[index];
                        return _buildAttachmentCard(item);
                      },
                    ),
                  ),

                const SizedBox(height: 14),

                // FAKE CHAT INPUT BAR
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _showAddAttachmentModal,
                        icon: const Icon(
                          Icons.attach_file_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Tanyakan sesuatu tentang dokumen terlampir...',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEC4899),
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard(_AttachmentItem item) {
    IconData typeIcon = Icons.insert_drive_file_rounded;
    switch (item.type) {
      case _AttachmentType.image:
        typeIcon = Icons.image_rounded;
        break;
      case _AttachmentType.pdf:
        typeIcon = Icons.picture_as_pdf_rounded;
        break;
      case _AttachmentType.audio:
        typeIcon = Icons.graphic_eq_rounded;
        break;
      case _AttachmentType.csv:
        typeIcon = Icons.table_chart_rounded;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 140,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: item.color.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(typeIcon, color: item.color, size: 18),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.tag,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.size,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 9.5,
                        ),
                      ),
                      if (!item.isComplete)
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            value: item.uploadProgress,
                            strokeWidth: 2,
                            color: item.color,
                          ),
                        )
                      else
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF10B981),
                          size: 12,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // REMOVE BADGE (TOP RIGHT)
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => _removeAttachment(item.id),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEF4444),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
