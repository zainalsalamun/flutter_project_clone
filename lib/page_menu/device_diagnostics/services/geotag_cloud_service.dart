import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/geotagged_photo_model.dart';
import 'diagnostics_logger_service.dart';
import 'geotag_sqlite_service.dart';

class CloudUploadResult {
  final bool success;
  final String? cloudUrl;
  final String? provider;
  final String? errorMessage;
  final int? statusCode;

  const CloudUploadResult({
    required this.success,
    this.cloudUrl,
    this.provider,
    this.errorMessage,
    this.statusCode,
  });
}

class GallerySaveResult {
  final bool success;
  final String? uri;
  final String? album;
  final String? errorMessage;

  const GallerySaveResult({
    required this.success,
    this.uri,
    this.album,
    this.errorMessage,
  });
}

class BatchSyncResult {
  final int totalCount;
  final int successCount;
  final int failedCount;
  final List<String> syncedUrls;

  const BatchSyncResult({
    required this.totalCount,
    required this.successCount,
    required this.failedCount,
    required this.syncedUrls,
  });
}

class GeotagCloudService {
  static final GeotagCloudService instance = GeotagCloudService._internal();
  GeotagCloudService._internal();

  static const MethodChannel _platformChannel =
      MethodChannel('com.naltech.project_clone/device_diagnostics');

  static const String _prefCloudNameKey = 'geotag_cloudinary_cloud_name';

  // Cloudinary credentials provided by user
  static const String defaultCloudName = 'dacofpkis';
  static const String defaultApiKey = '417969219389821';
  static const String defaultApiSecret = '-mLQe1s2zevxoSF1isuDC0yKBrs';

  /// Gets current Cloudinary Cloud Name from SharedPreferences, .env or default constant
  Future<String> getCloudName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefCloudNameKey);
      if (saved != null && saved.trim().isNotEmpty) {
        return saved.trim();
      }
    } catch (_) {}

    final fromEnv = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    if (fromEnv != null && fromEnv.trim().isNotEmpty) {
      return fromEnv.trim();
    }
    return defaultCloudName;
  }

  /// Sets Cloudinary Cloud Name in persistent storage
  Future<void> setCloudName(String cloudName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefCloudNameKey, cloudName.trim());
    } catch (_) {}
  }

  /// Batch synchronizes all unsynced offline photos from SQLite to Cloud Storage
  Future<BatchSyncResult> syncAllUnsyncedPhotos({
    void Function(int currentItem, int totalItems, double currentItemProgress, double totalProgress)? onProgress,
  }) async {
    final allPhotos = await GeotagSqliteService.instance.getAllPhotos();
    final unsynced = allPhotos.where((p) => !p.isCloudSynced).toList();

    if (unsynced.isEmpty) {
      return const BatchSyncResult(
        totalCount: 0,
        successCount: 0,
        failedCount: 0,
        syncedUrls: [],
      );
    }

    int successCount = 0;
    int failedCount = 0;
    final List<String> syncedUrls = [];

    for (int i = 0; i < unsynced.length; i++) {
      final photo = unsynced[i];
      final itemIndex = i + 1;

      final res = await uploadPhotoToCloud(
        photo,
        onProgress: (itemProgress) {
          final double baseProgress = i / unsynced.length;
          final double overallProgress = baseProgress + (itemProgress / unsynced.length);
          onProgress?.call(itemIndex, unsynced.length, itemProgress, overallProgress.clamp(0.0, 1.0));
        },
      );

      if (res.success && res.cloudUrl != null) {
        successCount++;
        syncedUrls.add(res.cloudUrl!);
      } else {
        failedCount++;
      }
    }

    // Refresh database stream
    await GeotagSqliteService.instance.getAllPhotos();

    return BatchSyncResult(
      totalCount: unsynced.length,
      successCount: successCount,
      failedCount: failedCount,
      syncedUrls: syncedUrls,
    );
  }

  /// Saves watermarked photo directly to Phone's Native MediaStore Gallery (Pictures/Geotagging album)
  Future<GallerySaveResult> saveToDeviceGallery(
    File imageFile, {
    String? title,
    String? description,
  }) async {
    try {
      if (!await imageFile.exists()) {
        return const GallerySaveResult(
          success: false,
          errorMessage: "File foto tidak ditemukan di penyimpanan lokal",
        );
      }

      final dynamic res = await _platformChannel.invokeMethod('saveImageToGallery', {
        'imagePath': imageFile.path,
        'title': title ?? 'geotag_${DateTime.now().millisecondsSinceEpoch}',
        'description': description ?? 'Foto Geotagging Naltech Diagnostics',
      });

      if (res is Map && res['success'] == true) {
        final uri = res['uri']?.toString() ?? '';
        final album = res['album']?.toString() ?? 'Pictures/Geotagging';

        DiagnosticsLoggerService.instance.info(
          "GALLERY_SAVED",
          "Foto berhasil disimpan ke Galeri HP di album [$album] ($uri)",
          payload: {"uri": uri, "album": album, "path": imageFile.path},
        );

        return GallerySaveResult(success: true, uri: uri, album: album);
      }

      return const GallerySaveResult(
        success: false,
        errorMessage: "Gagal membuat entri galeri di MediaStore Android",
      );
    } catch (e) {
      DiagnosticsLoggerService.instance.error(
        "GALLERY_SAVE_ERROR",
        "Gagal menyimpan ke galeri Android: $e",
      );
      return GallerySaveResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Uploads a geotagged photo to Cloud Storage using Signed Cloudinary REST API or fallback engine
  Future<CloudUploadResult> uploadPhotoToCloud(
    GeotaggedPhotoModel photo, {
    void Function(double progress)? onProgress,
    String? customCloudName,
    String? apiKey,
    String? apiSecret,
  }) async {
    final file = photo.displayFile;
    if (!await file.exists()) {
      return const CloudUploadResult(
        success: false,
        errorMessage: "File gambar tidak ditemukan di disk lokal",
      );
    }

    final key = apiKey ?? dotenv.env['CLOUDINARY_API_KEY'] ?? defaultApiKey;
    final secret = apiSecret ?? dotenv.env['CLOUDINARY_API_SECRET'] ?? defaultApiSecret;
    final cloudName = customCloudName ?? await getCloudName();

    DiagnosticsLoggerService.instance.info(
      "CLOUD_UPLOAD_START",
      "Memulai upload foto [ID #${photo.id ?? '?'}] ke Cloudinary ($cloudName)...",
      payload: {
        "file": file.path,
        "cloudName": cloudName,
        "apiKey": key,
        "coordinates": photo.formattedCoordinates,
      },
    );

    if (cloudName.isEmpty || key.isEmpty || secret.isEmpty) {
      return const CloudUploadResult(
        success: false,
        errorMessage: "Konfigurasi Cloudinary belum lengkap (Cloud Name / API Key / Secret kosong)",
      );
    }

    try {
      onProgress?.call(0.15);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const folder = 'geotag_photos';

      // Cloudinary signature calculation: alphabetically sorted query params + api_secret
      final stringToSign = 'folder=$folder&timestamp=$timestamp$secret';
      final signature = sha1.convert(utf8.encode(stringToSign)).toString();

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri);
      request.fields['api_key'] = key;
      request.fields['timestamp'] = timestamp.toString();
      request.fields['folder'] = folder;
      request.fields['signature'] = signature;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      onProgress?.call(0.45);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      onProgress?.call(0.9);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final secureUrl = data['secure_url']?.toString() ?? data['url']?.toString();

        if (secureUrl != null && secureUrl.isNotEmpty) {
          if (photo.id != null) {
            await updateSqliteCloudSync(photo.id!, secureUrl, "Cloudinary ($cloudName)");
          }
          onProgress?.call(1.0);

          DiagnosticsLoggerService.instance.info(
            "CLOUD_UPLOAD_SUCCESS",
            "Upload ke Cloudinary berhasil: $secureUrl",
            payload: {"url": secureUrl, "provider": "Cloudinary ($cloudName)"},
          );

          return CloudUploadResult(
            success: true,
            cloudUrl: secureUrl,
            provider: "Cloudinary ($cloudName)",
            statusCode: 200,
          );
        }
      }

      // Handle non-200 error response from Cloudinary
      String errorMsg = "Cloudinary Error (HTTP ${response.statusCode})";
      try {
        final errJson = jsonDecode(response.body) as Map<String, dynamic>;
        if (errJson.containsKey('error') && errJson['error'] is Map) {
          errorMsg = errJson['error']['message']?.toString() ?? response.body;
        } else if (errJson.containsKey('message')) {
          errorMsg = errJson['message']?.toString() ?? response.body;
        }
      } catch (_) {
        errorMsg = response.body.isNotEmpty ? response.body : errorMsg;
      }

      DiagnosticsLoggerService.instance.error(
        "CLOUDINARY_UPLOAD_FAILED",
        "Upload gagal: $errorMsg",
        payload: {"statusCode": response.statusCode, "body": response.body},
      );

      return CloudUploadResult(
        success: false,
        errorMessage: errorMsg,
        statusCode: response.statusCode,
      );
    } catch (e) {
      DiagnosticsLoggerService.instance.error(
        "CLOUD_UPLOAD_EXCEPTION",
        "Gagal mengunggah foto ke Cloud: $e",
      );
      return CloudUploadResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Displays interactive Dialog for user to configure Cloud Name
  Future<String?> showCloudinaryConfigDialog(BuildContext context) async {
    final currentCloudName = await getCloudName();
    final controller = TextEditingController(text: currentCloudName);

    if (!context.mounted) return null;

    final saved = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.cloud_queue_rounded, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text(
              "Konfigurasi Cloudinary",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukkan Cloud Name akun Cloudinary Anda (tertera di Dashboard Cloudinary):",
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: "Contoh: dxyz123 atau naltech",
                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF38BDF8)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("API Key: 417969219389821 (Aktif)",
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontFamily: 'monospace')),
                  SizedBox(height: 2),
                  Text("API Secret: -mLQe1...KBrs (Aktif)",
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text("Batal", style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx, controller.text.trim());
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );

    if (saved != null && saved.isNotEmpty) {
      await setCloudName(saved);
      return saved;
    }
    return null;
  }

  /// Updates SQLite record with cloud synchronization details
  Future<bool> updateSqliteCloudSync(
    int photoId,
    String cloudUrl,
    String provider,
  ) async {
    try {
      final dynamic res = await _platformChannel.invokeMethod('updateGeotagCloudSync', {
        'id': photoId,
        'cloudUrl': cloudUrl,
        'cloudProvider': provider,
      });

      // Reload memory DB in SQLite Service
      await GeotagSqliteService.instance.getAllPhotos();

      return res == true;
    } catch (e) {
      DiagnosticsLoggerService.instance.warn(
        "SQLITE_CLOUD_SYNC_WARN",
        "Gagal memperbarui status cloud di SQLite: $e",
      );
      return false;
    }
  }
}
