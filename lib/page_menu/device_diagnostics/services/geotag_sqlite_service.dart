import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/geotagged_photo_model.dart';
import 'diagnostics_logger_service.dart';

class GeotagSqliteService {
  static final GeotagSqliteService instance = GeotagSqliteService._internal();

  GeotagSqliteService._internal();

  static const MethodChannel _platformChannel =
      MethodChannel('com.naltech.project_clone/device_diagnostics');

  final List<GeotaggedPhotoModel> _fallbackMemoryDb = [];
  final StreamController<List<GeotaggedPhotoModel>> _photosStreamController =
      StreamController<List<GeotaggedPhotoModel>>.broadcast();

  Stream<List<GeotaggedPhotoModel>> get photosStream =>
      _photosStreamController.stream;

  /// Compresses a watermarked image file using downsampling and optimized JPEG quality
  Future<File> compressWatermarkedImage(
    File sourceFile, {
    int targetMaxWidth = 1280,
    int targetQuality = 75,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final timeId = DateTime.now().millisecondsSinceEpoch;
      final outPath = '${appDir.path}/geotag_compressed_$timeId.jpg';

      // 1. Try Native Android JPEG Compression via MethodChannel
      try {
        final dynamic res = await _platformChannel.invokeMethod('compressImage', {
          'inputPath': sourceFile.path,
          'outputPath': outPath,
          'targetWidth': targetMaxWidth,
          'quality': targetQuality,
        });

        if (res is Map) {
          final savedPath = res['path']?.toString() ?? outPath;
          final outFile = File(savedPath);
          if (await outFile.exists()) {
            final origSize = (res['originalSize'] as num?)?.toInt() ?? await sourceFile.length();
            final compSize = (res['compressedSize'] as num?)?.toInt() ?? await outFile.length();
            final savingsPercent = (res['savingsPercent'] as num?)?.toDouble() ?? 0.0;

            DiagnosticsLoggerService.instance.info(
              "IMAGE_COMPRESSION_NATIVE",
              "Foto berhasil dikompresi JPEG: ${_formatBytes(origSize)} ➔ ${_formatBytes(compSize)} (Hemat ${savingsPercent.toStringAsFixed(0)}%)",
              payload: {
                "originalBytes": origSize,
                "compressedBytes": compSize,
                "savingsPercent": savingsPercent,
                "path": savedPath,
              },
            );

            return outFile;
          }
        }
      } catch (nativeError) {
        DiagnosticsLoggerService.instance.warn(
          "NATIVE_COMPRESS_FALLBACK",
          "Native compression channel fallback to Dart: $nativeError",
        );
      }

      // 2. Pure Flutter Fallback (downsampled bitmap)
      final Uint8List originalBytes = await sourceFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(
        originalBytes,
        targetWidth: targetMaxWidth,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        return sourceFile;
      }

      final Uint8List compressedBytes = byteData.buffer.asUint8List();
      final compressedFile = File(outPath);
      await compressedFile.writeAsBytes(compressedBytes);

      final originalSize = originalBytes.length;
      final compressedSize = compressedBytes.length;
      final savedBytes = originalSize > compressedSize ? originalSize - compressedSize : 0;
      final savingsPercent = originalSize > 0 ? (savedBytes / originalSize * 100) : 0.0;

      DiagnosticsLoggerService.instance.info(
        "IMAGE_COMPRESSION_DART",
        "Foto berhasil dikompresi Dart: ${_formatBytes(originalSize)} ➔ ${_formatBytes(compressedSize)} (Hemat ${savingsPercent.toStringAsFixed(0)}%)",
        payload: {
          "originalBytes": originalSize,
          "compressedBytes": compressedSize,
          "savingsPercent": savingsPercent,
          "path": compressedFile.path,
        },
      );

      return compressedFile;
    } catch (e) {
      DiagnosticsLoggerService.instance.warn(
        "COMPRESSION_FALLBACK",
        "Kompresi fallback ke file asli karena: $e",
      );
      return sourceFile;
    }
  }

  /// Inserts a geotagged photo into the native SQLite database
  Future<int> insertPhoto(GeotaggedPhotoModel photo) async {
    int generatedId = DateTime.now().millisecondsSinceEpoch;

    try {
      final origSize = photo.originalSizeBytes > 0
          ? photo.originalSizeBytes
          : (await photo.originalFile.exists()
              ? await photo.originalFile.length()
              : 0);

      final compFile = photo.compressedFile ?? photo.watermarkedFile ?? photo.originalFile;
      final compSize = photo.compressedSizeBytes > 0
          ? photo.compressedSizeBytes
          : (await compFile.exists() ? await compFile.length() : origSize);

      final dynamic res = await _platformChannel.invokeMethod(
        'insertGeotagPhoto',
        {
          'originalPath': photo.originalFile.path,
          'compressedPath': compFile.path,
          'originalSize': origSize,
          'compressedSize': compSize,
          'timestamp': photo.timestamp.millisecondsSinceEpoch,
          'latitude': photo.latitude,
          'longitude': photo.longitude,
          'altitude': photo.altitude,
          'accuracy': photo.accuracy,
          'address': photo.fullAddress,
          'carrier': photo.carrierName,
          'isCloudSynced': photo.isCloudSynced,
          'cloudUrl': photo.cloudUrl,
          'cloudProvider': photo.cloudProvider,
        },
      );

      if (res is num) {
        generatedId = res.toInt();
      }
    } catch (e) {
      DiagnosticsLoggerService.instance.warn(
        "SQLITE_FALLBACK",
        "SQLite native channel fallback: $e",
      );
    }

    final updatedPhoto = photo.copyWith(id: generatedId);
    _fallbackMemoryDb.removeWhere((p) => p.id == generatedId);
    _fallbackMemoryDb.insert(0, updatedPhoto);
    _notifyPhotosChanged();

    DiagnosticsLoggerService.instance.info(
      "SQLITE_INSERT",
      "Foto ber-geotagging tersimpan di SQLite [ID: $generatedId] (${updatedPhoto.formattedCoordinates})",
      payload: {
        "id": generatedId,
        "address": updatedPhoto.fullAddress,
        "compressedSize": updatedPhoto.formattedCompressedSize,
      },
    );

    return generatedId;
  }

  /// Queries all geotagged photos from SQLite
  Future<List<GeotaggedPhotoModel>> getAllPhotos() async {
    try {
      final dynamic res =
          await _platformChannel.invokeMethod('getAllGeotagPhotos');
      if (res is List) {
        final List<GeotaggedPhotoModel> photos = [];
        for (final item in res) {
          if (item is Map) {
            photos.add(GeotaggedPhotoModel.fromMap(item));
          }
        }
        if (photos.isNotEmpty) {
          _fallbackMemoryDb.clear();
          _fallbackMemoryDb.addAll(photos);
          _notifyPhotosChanged();
          return photos;
        }
      }
    } catch (_) {}

    return List.unmodifiable(_fallbackMemoryDb);
  }

  /// Deletes a photo from the SQLite database and deletes its file
  Future<bool> deletePhoto(int id) async {
    bool success = true;
    try {
      final dynamic res = await _platformChannel.invokeMethod(
        'deleteGeotagPhoto',
        {'id': id},
      );
      if (res is bool) {
        success = res;
      }
    } catch (_) {}

    _fallbackMemoryDb.removeWhere((p) => p.id == id);
    _notifyPhotosChanged();

    DiagnosticsLoggerService.instance.info(
      "SQLITE_DELETE",
      "Foto geotagging ID: $id berhasil dihapus dari SQLite",
    );

    return success;
  }

  /// Queries database statistics (Total Photos, Original Bytes, Compressed Bytes, Total Saved Bytes)
  Future<Map<String, dynamic>> getStats() async {
    try {
      final dynamic res =
          await _platformChannel.invokeMethod('getGeotagPhotoStats');
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (_) {}

    // Fallback calculation from memory
    int totalPhotos = _fallbackMemoryDb.length;
    int totalOrig = 0;
    int totalComp = 0;
    for (final p in _fallbackMemoryDb) {
      totalOrig += p.originalSizeBytes;
      totalComp += p.compressedSizeBytes;
    }
    final saved = totalOrig > totalComp ? totalOrig - totalComp : 0;
    final ratio = totalOrig > 0 ? (saved / totalOrig * 100) : 0.0;

    return {
      "totalPhotos": totalPhotos,
      "totalOriginalBytes": totalOrig,
      "totalCompressedBytes": totalComp,
      "totalSavedBytes": saved,
      "savingsPercent": ratio,
    };
  }

  void _notifyPhotosChanged() {
    _photosStreamController.add(List.unmodifiable(_fallbackMemoryDb));
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 KB";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  void dispose() {
    _photosStreamController.close();
  }
}
