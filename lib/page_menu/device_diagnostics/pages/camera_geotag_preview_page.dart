import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import '../models/geotagged_photo_model.dart';
import '../models/location_and_carrier_data.dart';
import '../services/geotag_sqlite_service.dart';
import '../services/geotagging_camera_service.dart';
import '../services/geotag_cloud_service.dart';
import '../services/biometric_auth_service.dart';
import 'interactive_geotag_map_page.dart';
import 'saved_geotag_photos_page.dart';

class CameraGeotagPreviewPage extends StatefulWidget {
  final GeotaggedPhotoModel? initialPhoto;
  final LocationAndCarrierData locationData;

  const CameraGeotagPreviewPage({
    super.key,
    this.initialPhoto,
    required this.locationData,
  });

  @override
  State<CameraGeotagPreviewPage> createState() =>
      _CameraGeotagPreviewPageState();
}

class _CameraGeotagPreviewPageState extends State<CameraGeotagPreviewPage> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final GeotaggingCameraService _cameraService =
      GeotaggingCameraService.instance;
  final GeotagSqliteService _sqliteService = GeotagSqliteService.instance;

  GeotaggedPhotoModel? _currentPhoto;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isSavedToSqlite = false;
  bool _isSavingToGallery = false;
  bool _isSavedToGallery = false;
  bool _isUploadingCloud = false;
  double _cloudProgress = 0.0;
  File? _savedWatermarkFile;

  @override
  void initState() {
    super.initState();
    _currentPhoto = widget.initialPhoto;
    if (_currentPhoto == null) {
      _triggerCapture(ImageSource.camera);
    }
  }

  Future<void> _triggerCapture(ImageSource source) async {
    setState(() => _isLoading = true);
    final photo = await _cameraService.captureGeotaggedPhoto(
      source: source,
      locationData: widget.locationData,
    );
    setState(() {
      _isLoading = false;
      if (photo != null) {
        _currentPhoto = photo;
        _savedWatermarkFile = null;
        _isSavedToSqlite = false;
        _isSavedToGallery = false;
        _cloudProgress = 0.0;
      }
    });
  }

  Future<void> _saveAndCompressWatermarkedImage() async {
    if (_currentPhoto == null) return;
    setState(() => _isSaving = true);

    // 1. Render Watermark + Compress Image
    final updatedPhoto = await _cameraService.renderAndCompressWatermarkedImage(
      boundaryKey: _repaintBoundaryKey,
      photo: _currentPhoto!,
    );

    if (updatedPhoto != null) {
      // 2. Save directly into native SQLite Database
      final dbId = await _sqliteService.insertPhoto(updatedPhoto);
      final finalModel = updatedPhoto.copyWith(id: dbId);

      setState(() {
        _isSaving = false;
        _currentPhoto = finalModel;
        _savedWatermarkFile = finalModel.compressedFile ?? finalModel.watermarkedFile;
        _isSavedToSqlite = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Foto dikompresi & tersimpan di SQLite!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                      ),
                      Text(
                        "${finalModel.formattedOriginalSize} ➔ ${finalModel.formattedCompressedSize} (Hemat ${finalModel.formattedSavings}) • ID #$dbId",
                        style: const TextStyle(fontSize: 11, color: Color(0xFFD1FAE5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _saveToDeviceGallery() async {
    if (_currentPhoto == null) return;
    setState(() => _isSavingToGallery = true);

    // 1. Ensure watermarked and compressed
    GeotaggedPhotoModel? photo = _currentPhoto;
    if (_savedWatermarkFile == null) {
      photo = await _cameraService.renderAndCompressWatermarkedImage(
        boundaryKey: _repaintBoundaryKey,
        photo: _currentPhoto!,
      );
      if (photo != null) {
        _currentPhoto = photo;
        _savedWatermarkFile = photo.displayFile;
      }
    }

    if (photo != null && _savedWatermarkFile != null) {
      final res = await GeotagCloudService.instance.saveToDeviceGallery(
        _savedWatermarkFile!,
        title: "geotag_${photo.id ?? DateTime.now().millisecondsSinceEpoch}",
        description: "Foto Geotagging [${photo.formattedCoordinates}] - ${photo.fullAddress}",
      );

      setState(() {
        _isSavingToGallery = false;
        if (res.success) {
          _isSavedToGallery = true;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  res.success ? Icons.photo_library_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        res.success
                            ? "Foto berhasil disimpan ke Galeri HP!"
                            : "Gagal menyimpan ke galeri",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                      ),
                      Text(
                        res.success
                            ? "Tersimpan di album: ${res.album ?? 'Pictures/Geotagging'}"
                            : (res.errorMessage ?? 'Terjadi kesalahan sistem'),
                        style: const TextStyle(fontSize: 11, color: Color(0xFFE0F2FE)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: res.success ? const Color(0xFF0284C7) : const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      setState(() => _isSavingToGallery = false);
    }
  }

  Future<void> _uploadToCloudStorage() async {
    if (_currentPhoto == null) return;

    // Optional biometric authentication before cloud backup
    final hasBiometrics = await BiometricAuthService.instance.checkBiometricStatus();
    if (hasBiometrics['hasHardware'] == true && hasBiometrics['isEnrolled'] == true) {
      final authOk = await BiometricAuthService.instance.authenticate(
        title: "Autentikasi Cloud Backup",
        subtitle: "Verifikasi sidik jari untuk mencadangkan foto ke Cloud",
      );
      if (!authOk) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Autentikasi biometrik dibatalkan"),
              backgroundColor: Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
    }

    // Check if Cloudinary Cloud Name is configured
    final existingCloud = await GeotagCloudService.instance.getCloudName();
    if (existingCloud == null || existingCloud.isEmpty) {
      if (mounted) {
        await GeotagCloudService.instance.showCloudinaryConfigDialog(context);
      }
    }

    setState(() {
      _isUploadingCloud = true;
      _cloudProgress = 0.05;
    });

    // 1. Ensure watermarked and compressed & in SQLite
    GeotaggedPhotoModel? photo = _currentPhoto;
    if (_savedWatermarkFile == null || photo?.id == null) {
      final rendered = await _cameraService.renderAndCompressWatermarkedImage(
        boundaryKey: _repaintBoundaryKey,
        photo: _currentPhoto!,
      );
      if (rendered != null) {
        final dbId = await _sqliteService.insertPhoto(rendered);
        photo = rendered.copyWith(id: dbId);
        _currentPhoto = photo;
        _savedWatermarkFile = photo.displayFile;
        _isSavedToSqlite = true;
      }
    }

    if (photo != null) {
      final result = await GeotagCloudService.instance.uploadPhotoToCloud(
        photo,
        onProgress: (p) {
          if (mounted) setState(() => _cloudProgress = p);
        },
      );

      setState(() {
        _isUploadingCloud = false;
        if (result.success && result.cloudUrl != null) {
          _currentPhoto = photo!.copyWith(
            isCloudSynced: true,
            cloudUrl: result.cloudUrl,
            cloudProvider: result.provider ?? "Cloud Storage",
            cloudSyncedAt: DateTime.now(),
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  result.success ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        result.success
                            ? "Foto berhasil dicadangkan ke Cloud!"
                            : "Gagal mencadangkan ke cloud",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                      ),
                      Text(
                        result.success
                            ? "${result.provider ?? 'Cloud'}: ${result.cloudUrl}"
                            : (result.errorMessage ?? "Gagal upload"),
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFFD1FAE5)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (result.success && result.cloudUrl != null)
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: result.cloudUrl!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("URL Cloud disalin ke clipboard!"),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text("SALIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
              ],
            ),
            backgroundColor:
                result.success ? const Color(0xFF059669) : const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      setState(() => _isUploadingCloud = false);
    }
  }

  Future<void> _shareWatermarkedImage() async {
    if (_currentPhoto == null) return;

    // Ensure image is rendered first
    File? fileToShare = _savedWatermarkFile;
    if (fileToShare == null) {
      setState(() => _isSaving = true);
      final updated = await _cameraService.renderAndCompressWatermarkedImage(
        boundaryKey: _repaintBoundaryKey,
        photo: _currentPhoto!,
      );
      setState(() {
        _isSaving = false;
        if (updated != null) {
          _currentPhoto = updated;
          fileToShare = updated.displayFile;
          _savedWatermarkFile = fileToShare;
        }
      });
    }

    if (fileToShare != null && mounted) {
      final bytes = await fileToShare!.readAsBytes();
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'geotag_${DateTime.now().millisecondsSinceEpoch}.png',
      );
    }
  }

  void _openSqliteGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedGeotagPhotosPage(),
      ),
    );
  }

  void _openMap() {
    final photo = _currentPhoto;
    final lat = photo?.latitude ?? widget.locationData.latitude;
    final lon = photo?.longitude ?? widget.locationData.longitude;
    final alt = photo?.altitude ?? widget.locationData.altitude;
    final acc = photo?.accuracy ?? widget.locationData.accuracy;
    final addr = photo?.fullAddress ?? widget.locationData.fullAddress;
    final carrier = photo?.carrierName ?? widget.locationData.simCarrierName;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InteractiveGeotagMapPage(
          latitude: lat,
          longitude: lon,
          altitude: alt,
          accuracy: acc,
          address: addr,
          carrier: carrier,
          locationData: widget.locationData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context, _savedWatermarkFile),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Camera Geotagging & SQLite",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Kompresi Gambar Cerdas & Database Lokal",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Lihat Koordinat di Peta",
            icon: const Icon(Icons.map_rounded, color: Color(0xFF38BDF8)),
            onPressed: _openMap,
          ),
          IconButton(
            tooltip: "Buka Galeri Database SQLite",
            icon: const Icon(Icons.storage_rounded, color: Color(0xFF38BDF8)),
            onPressed: _openSqliteGallery,
          ),
          IconButton(
            tooltip: "Pilih dari Galeri",
            icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
            onPressed: () => _triggerCapture(ImageSource.gallery),
          ),
          IconButton(
            tooltip: "Ambil Foto Baru",
            icon: const Icon(Icons.camera_alt_rounded, color: Color(0xFF38BDF8)),
            onPressed: () => _triggerCapture(ImageSource.camera),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF38BDF8)),
                  SizedBox(height: 16),
                  Text(
                    "Membaca koordinat GPS & Geocoding alamat...",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            )
          : _currentPhoto == null
              ? _buildEmptyState()
              : _buildPhotoWithWatermarkView(),
      bottomNavigationBar: _currentPhoto == null
          ? null
          : _buildBottomActionBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: Color(0xFF38BDF8),
                size: 48,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Belum Ada Foto Geotagging",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Ambil foto langsung melalui kamera HP untuk menambahkan watermark geotagging, mengompresi ukuran, dan menyimpannya ke database SQLite.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text("Buka Kamera HP"),
              onPressed: () => _triggerCapture(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  /// Main View containing the RepaintBoundary for watermark burning & preview
  Widget _buildPhotoWithWatermarkView() {
    final photo = _currentPhoto!;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  // 1. Original Image Photo
                  Image.file(
                    photo.originalFile,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),

                  // 2. Subtle Dark Gradient Overlay for optimal contrast
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 220,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Geotag Watermark Element (Matching the reference screenshot exactly)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: _buildWatermarkBadge(photo),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Exact replica of the reference screenshot watermark badge
  Widget _buildWatermarkBadge(GeotaggedPhotoModel photo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vertical Orange Bar Accent (as in reference image)
        Container(
          width: 4,
          height: 64,
          margin: const EdgeInsets.only(right: 10, top: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B), // Vibrant Amber / Orange Bar
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),

        // 3-Line Geotagging Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Line 1: Timestamp (e.g. Mon, 21 Sep 2026 13:37)
              Text(
                photo.formattedDateTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),

              // Line 2: Full Real Street Address
              Text(
                photo.fullAddress,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  height: 1.25,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),

              // Line 3: Latitude & Longitude Coordinates
              Text(
                photo.formattedCoordinates,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bottom action toolbar (Save to SQLite, Share, Retake, and Compression Stats)
  Widget _buildBottomActionBar() {
    final photo = _currentPhoto;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          top: BorderSide(color: Color(0xFF334155), width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Storage & Cloud Status Badges
            if (photo != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SQLite Status
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.storage_rounded,
                              color: Color(0xFF38BDF8), size: 13),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _isSavedToSqlite
                                  ? "SQLite: #${photo.id ?? '?'}"
                                  : "SQLite: Siap",
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Cloud Sync Status
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            photo.isCloudSynced
                                ? Icons.cloud_done_rounded
                                : Icons.cloud_queue_rounded,
                            color: photo.isCloudSynced
                                ? const Color(0xFF10B981)
                                : const Color(0xFF38BDF8),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              photo.isCloudSynced
                                  ? "Cloud: Synced ✅"
                                  : "Cloud: Siap Backup",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: photo.isCloudSynced
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF38BDF8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_isUploadingCloud) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            SizedBox(
                              width: 13,
                              height: 13,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF818CF8)),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Mengunggah ke Cloudinary...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "${(_cloudProgress * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _cloudProgress,
                        backgroundColor: const Color(0xFF0F172A),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF818CF8)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 2. Row 1: Save to SQLite & Save to Phone Gallery
            Row(
              children: [
                // Save & Compress to SQLite Button
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSavedToSqlite
                          ? const Color(0xFF047857)
                          : const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isSaving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isSavedToSqlite
                                ? Icons.check_circle_rounded
                                : Icons.save_alt_rounded,
                            size: 16,
                          ),
                    label: Text(
                      _isSaving
                          ? "Menyimpan..."
                          : (_isSavedToSqlite ? "SQLite OK" : "Simpan SQLite"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: _isSaving ? null : _saveAndCompressWatermarkedImage,
                  ),
                ),
                const SizedBox(width: 8),

                // Save to Phone Gallery Button (MediaStore)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSavedToGallery
                          ? const Color(0xFF0369A1)
                          : const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isSavingToGallery
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isSavedToGallery
                                ? Icons.photo_library_rounded
                                : Icons.download_for_offline_rounded,
                            size: 16,
                          ),
                    label: Text(
                      _isSavingToGallery
                          ? "Menyimpan..."
                          : (_isSavedToGallery ? "Galeri HP ✅" : "Galeri HP"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: _isSavingToGallery ? null : _saveToDeviceGallery,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3. Row 2: Cloud Storage Backup + Share + Retake
            Row(
              children: [
                // Retake Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF94A3B8),
                    side: const BorderSide(color: Color(0xFF475569)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 15),
                  label: const Text("Ulangi", style: TextStyle(fontSize: 11)),
                  onPressed: () => _triggerCapture(ImageSource.camera),
                ),
                const SizedBox(width: 6),

                // Cloud Storage Backup Button
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (photo?.isCloudSynced == true)
                          ? const Color(0xFF065F46)
                          : const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isUploadingCloud
                        ? const SizedBox(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            (photo?.isCloudSynced == true)
                                ? Icons.cloud_done_rounded
                                : Icons.cloud_upload_rounded,
                            size: 15,
                          ),
                    label: Text(
                      _isUploadingCloud
                          ? "Uploading ${(_cloudProgress * 100).toInt()}%"
                          : ((photo?.isCloudSynced == true)
                              ? "Cloud Backup ✅"
                              : "Backup ke Cloud"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: _isUploadingCloud ? null : _uploadToCloudStorage,
                  ),
                ),
                const SizedBox(width: 6),

                // Share Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF475569)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 14),
                  label: const Text("Share", style: TextStyle(fontSize: 11)),
                  onPressed: _shareWatermarkedImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
