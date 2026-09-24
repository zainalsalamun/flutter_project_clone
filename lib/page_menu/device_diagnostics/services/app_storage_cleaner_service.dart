import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_storage_metrics_model.dart';
import 'diagnostics_logger_service.dart';

class AppStorageCleanerService {
  static final AppStorageCleanerService instance =
      AppStorageCleanerService._internal();

  AppStorageCleanerService._internal();

  /// Scans the full storage footprint and RAM image cache of the application
  Future<AppStorageMetrics> scanStorageUsage() async {
    int tempBytes = 0;
    int tempFilesCount = 0;
    int docsBytes = 0;
    int sqliteBytes = 0;

    // 1. Scan Temporary Directory (Cache)
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        final stat = await _calculateDirectorySize(tempDir);
        tempBytes = stat['bytes'] ?? 0;
        tempFilesCount = stat['count'] ?? 0;
      }
    } catch (_) {}

    // 2. Scan Application Documents Directory
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      if (await docsDir.exists()) {
        final stat = await _calculateDirectorySize(docsDir);
        docsBytes = stat['bytes'] ?? 0;
      }
    } catch (_) {}

    // 3. Scan SQLite Database Files (.db, -wal, -shm)
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dbFile = File('${docsDir.path}/geotag_diagnostics.db');
      if (await dbFile.exists()) {
        sqliteBytes += await dbFile.length();
      }
      final walFile = File('${docsDir.path}/geotag_diagnostics.db-wal');
      if (await walFile.exists()) {
        sqliteBytes += await walFile.length();
      }
      final shmFile = File('${docsDir.path}/geotag_diagnostics.db-shm');
      if (await shmFile.exists()) {
        sqliteBytes += await shmFile.length();
      }
    } catch (_) {}

    // 4. Read RAM Image Cache
    int ramBytes = 0;
    int ramCount = 0;
    try {
      final binding = PaintingBinding.instance;
      ramBytes = binding.imageCache.currentSizeBytes;
      ramCount = binding.imageCache.currentSize;
    } catch (_) {}

    final metrics = AppStorageMetrics(
      tempCacheBytes: tempBytes,
      documentsBytes: docsBytes,
      sqliteDatabaseBytes: sqliteBytes,
      ramImageCacheBytes: ramBytes,
      ramImageCount: ramCount,
      temporaryFilesCount: tempFilesCount,
      scannedAt: DateTime.now(),
    );

    DiagnosticsLoggerService.instance.info(
      "STORAGE_AUDIT",
      "Storage Scan: Cache ${metrics.formattedTempCache}, RAM ${metrics.formattedRamImageCache}, Dokumen ${metrics.formattedDocuments}",
    );

    return metrics;
  }

  /// Lists all discoverable junk / temporary files for user inspection
  Future<List<JunkFileDetail>> listJunkFiles() async {
    final List<JunkFileDetail> files = [];

    // Temporary Directory files
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await for (final entity in tempDir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            final len = await entity.length();
            final name = entity.path.split(Platform.pathSeparator).last;
            final lastMod = await entity.lastModified();
            String cat = "HTTP / Data Cache";
            if (name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png")) {
              cat = "Image Buffer";
            } else if (name.endsWith(".pdf")) {
              cat = "PDF Temporary";
            }

            files.add(JunkFileDetail(
              path: entity.path,
              fileName: name,
              sizeBytes: len,
              category: cat,
              lastModified: lastMod,
            ));
          }
        }
      }
    } catch (_) {}

    // Temporary PDF files in Documents
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      if (await docsDir.exists()) {
        await for (final entity in docsDir.list(recursive: false, followLinks: false)) {
          if (entity is File && entity.path.endsWith(".pdf")) {
            final len = await entity.length();
            final name = entity.path.split(Platform.pathSeparator).last;
            final lastMod = await entity.lastModified();

            files.add(JunkFileDetail(
              path: entity.path,
              fileName: name,
              sizeBytes: len,
              category: "PDF Export Cache",
              lastModified: lastMod,
            ));
          }
        }
      }
    } catch (_) {}

    files.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
    return files;
  }

  /// Clears in-memory RAM image buffer (instantly frees RAM)
  int trimRamImageCache() {
    int freed = 0;
    try {
      final binding = PaintingBinding.instance;
      freed = binding.imageCache.currentSizeBytes;
      binding.imageCache.clear();
      binding.imageCache.clearLiveImages();
    } catch (_) {}
    return freed;
  }

  /// Clears the temporary cache directory
  Future<int> clearTempDirectory() async {
    int freedBytes = 0;
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await for (final entity in tempDir.list(recursive: true, followLinks: false)) {
          try {
            if (entity is File) {
              freedBytes += await entity.length();
              await entity.delete();
            } else if (entity is Directory) {
              await entity.delete(recursive: true);
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
    return freedBytes;
  }

  /// Cleans old generated PDF report files from documents directory
  Future<int> clearOldPdfExports() async {
    int freedBytes = 0;
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      if (await docsDir.exists()) {
        await for (final entity in docsDir.list(recursive: false, followLinks: false)) {
          if (entity is File && entity.path.endsWith(".pdf")) {
            try {
              freedBytes += await entity.length();
              await entity.delete();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return freedBytes;
  }

  /// Executes 1-Click Deep Clean: Clears Temp Cache + RAM ImageCache + Old PDF previews
  Future<Map<String, dynamic>> executeDeepClean() async {
    final beforeMetrics = await scanStorageUsage();

    final ramFreed = trimRamImageCache();
    final tempFreed = await clearTempDirectory();
    final pdfFreed = await clearOldPdfExports();

    final totalFreed = ramFreed + tempFreed + pdfFreed;

    final afterMetrics = await scanStorageUsage();

    DiagnosticsLoggerService.instance.info(
      "STORAGE_DEEP_CLEAN",
      "Pembersihan Memori Selesai! Membebaskan ${_formatBytes(totalFreed)} (RAM: ${_formatBytes(ramFreed)}, Disk Cache: ${_formatBytes(tempFreed + pdfFreed)})",
      payload: {
        'totalFreedBytes': totalFreed,
        'ramFreedBytes': ramFreed,
        'diskFreedBytes': tempFreed + pdfFreed,
      },
    );

    return {
      'success': true,
      'totalFreedBytes': totalFreed,
      'formattedTotalFreed': _formatBytes(totalFreed),
      'ramFreedBytes': ramFreed,
      'diskFreedBytes': tempFreed + pdfFreed,
      'before': beforeMetrics,
      'after': afterMetrics,
    };
  }

  Future<Map<String, int>> _calculateDirectorySize(Directory dir) async {
    int totalBytes = 0;
    int count = 0;
    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalBytes += await entity.length();
          count++;
        }
      }
    } catch (_) {}
    return {'bytes': totalBytes, 'count': count};
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024.0).toStringAsFixed(1)} KB";
    }
    return "${(bytes / (1024.0 * 1024.0)).toStringAsFixed(1)} MB";
  }
}
