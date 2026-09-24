import 'package:flutter/material.dart';

import '../models/app_storage_metrics_model.dart';
import '../services/app_storage_cleaner_service.dart';
import '../theme/diagnostics_colors.dart';

class AppStorageCleanerCard extends StatefulWidget {
  const AppStorageCleanerCard({super.key});

  @override
  State<AppStorageCleanerCard> createState() => _AppStorageCleanerCardState();
}

class _AppStorageCleanerCardState extends State<AppStorageCleanerCard> {
  final AppStorageCleanerService _cleanerService =
      AppStorageCleanerService.instance;

  AppStorageMetrics _metrics = AppStorageMetrics.empty();
  bool _isLoading = true;
  bool _isCleaning = false;

  @override
  void initState() {
    super.initState();
    _loadStorageData();
  }

  Future<void> _loadStorageData() async {
    setState(() => _isLoading = true);
    final data = await _cleanerService.scanStorageUsage();
    if (mounted) {
      setState(() {
        _metrics = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeepClean() async {
    if (_isCleaning) return;

    setState(() => _isCleaning = true);

    final result = await _cleanerService.executeDeepClean();

    if (mounted) {
      setState(() {
        _isCleaning = false;
        _metrics = result['after'] as AppStorageMetrics;
      });

      final totalFreed = result['formattedTotalFreed'] ?? '0 B';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Pembersihan Selesai! Membebaskan $totalFreed ruang memori.",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showJunkFilesModal() async {
    final files = await _cleanerService.listJunkFiles();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rincian File Cache Sementara",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Ditemukan ${files.length} file temporary aman dihapus",
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E293B)),
                Expanded(
                  child: files.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada file sampah ditemukan.\nSemua cache sudah bersih!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: files.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, idx) {
                            final f = files[idx];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.insert_drive_file_outlined,
                                      color: Color(0xFFF59E0B),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          f.fileName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          f.category,
                                          style: const TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    f.formattedSize,
                                    style: const TextStyle(
                                      color: Color(0xFF38BDF8),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                      label: const Text("Bersihkan Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleDeepClean();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DiagnosticsColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DiagnosticsColors.border),
        boxShadow: [
          BoxShadow(
            color: DiagnosticsColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cleaning_services_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "STORAGE & CACHE OPTIMIZER",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: DiagnosticsColors.textPrimary,
                                letterSpacing: 0.6,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Pembersih cache, RAM buffer & file sampah",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: DiagnosticsColors.textSubtle,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _metrics.needsCleaning
                        ? const Color(0xFFF59E0B).withOpacity(0.12)
                        : const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _metrics.needsCleaning
                          ? const Color(0xFFF59E0B).withOpacity(0.3)
                          : const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _metrics.needsCleaning ? "Perlu Bersih" : "Optimal",
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: _metrics.needsCleaning
                          ? const Color(0xFFD97706)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: DiagnosticsColors.divider),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Highlight Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "TOTAL SAMPAH DAPAT DIBERSIHKAN",
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8), size: 16),
                              onPressed: _loadStorageData,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _metrics.formattedCleanable,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF38BDF8).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Total: ${_metrics.formattedTotalAppStorage}",
                                  style: const TextStyle(
                                    color: Color(0xFF38BDF8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Storage Metrics Breakdown Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStorageTile(
                          icon: Icons.folder_delete_outlined,
                          color: const Color(0xFFF59E0B),
                          title: "Cache Disk",
                          value: _metrics.formattedTempCache,
                          subtitle: "${_metrics.temporaryFilesCount} File Temp",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStorageTile(
                          icon: Icons.memory_rounded,
                          color: const Color(0xFF8B5CF6),
                          title: "RAM Buffers",
                          value: _metrics.formattedRamImageCache,
                          subtitle: "${_metrics.ramImageCount} Gambar RAM",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStorageTile(
                          icon: Icons.storage_rounded,
                          color: const Color(0xFF10B981),
                          title: "Database DB",
                          value: _metrics.formattedSqlite,
                          subtitle: "Data SQLite",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8B5CF6),
                            side: const BorderSide(color: Color(0xFF8B5CF6)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.list_alt_rounded, size: 16),
                          label: const Text(
                            "Rincian File",
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          onPressed: _showJunkFilesModal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: _isCleaning
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.auto_awesome_rounded, size: 16),
                          label: Text(
                            _isCleaning ? "Membersihkan..." : "Bersihkan (1-Klik)",
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          onPressed: _isCleaning ? null : _handleDeepClean,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStorageTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: DiagnosticsColors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9.5,
              color: DiagnosticsColors.textSubtle,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
