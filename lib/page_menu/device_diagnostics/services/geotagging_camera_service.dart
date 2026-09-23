import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/geotagged_photo_model.dart';
import '../models/location_and_carrier_data.dart';
import 'diagnostics_logger_service.dart';
import 'geotag_sqlite_service.dart';
import 'location_and_carrier_service.dart';

class GeotaggingCameraService {
  static final GeotaggingCameraService instance =
      GeotaggingCameraService._internal();

  GeotaggingCameraService._internal();

  final ImagePicker _picker = ImagePicker();
  GeotaggedPhotoModel? _lastCapturedPhoto;
  GeotaggedPhotoModel? get lastCapturedPhoto => _lastCapturedPhoto;

  /// Captures photo using camera or picks from gallery, then creates a GeotaggedPhotoModel
  Future<GeotaggedPhotoModel?> captureGeotaggedPhoto({
    required ImageSource source,
    LocationAndCarrierData? locationData,
  }) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (picked == null) return null;

      final originalFile = File(picked.path);
      final now = DateTime.now();

      // Retrieve current GPS telemetries
      final loc = locationData ?? LocationAndCarrierService.instance.currentData;
      final lat = loc.latitude;
      final lon = loc.longitude;
      final alt = loc.altitudeMeters;
      final acc = loc.accuracyMeters;
      final carrier = loc.carrierName;

      // Reverse geocode coordinate to real street address
      final address = await reverseGeocode(lat, lon);

      final origSize = await originalFile.length();

      final photo = GeotaggedPhotoModel(
        originalFile: originalFile,
        originalSizeBytes: origSize,
        timestamp: now,
        latitude: lat,
        longitude: lon,
        altitude: alt,
        accuracy: acc,
        fullAddress: address,
        carrierName: carrier,
      );

      _lastCapturedPhoto = photo;

      DiagnosticsLoggerService.instance.info(
        "CAMERA_GEOTAG",
        "Captured photo with Geotag at [${photo.formattedCoordinates}] - $address (Ukuran Asli: ${photo.formattedOriginalSize})",
        payload: {
          "lat": lat,
          "lon": lon,
          "accuracy": acc,
          "address": address,
          "file": picked.path,
          "originalBytes": origSize,
        },
      );

      return photo;
    } catch (e) {
      DiagnosticsLoggerService.instance.error(
        "CAMERA_GEOTAG_ERROR",
        "Gagal mengambil foto atau membaca lokasi geotagging: $e",
      );
      return null;
    }
  }

  /// Reverse geocodes coordinates (Latitude, Longitude) into human-readable Indonesian address
  Future<String> reverseGeocode(double lat, double lon) async {
    // If coordinates are not locked (0, 0)
    if (lat == 0.0 && lon == 0.0) {
      return "Koordinat Belum Terkunci (Menunggu Sinyal GPS)";
    }

    // 1. Try Native Android Geocoder (Offline/Google Play Services)
    try {
      final nativeAddress =
          await LocationAndCarrierService.instance.reverseGeocodeNative(lat, lon);
      if (nativeAddress != null && nativeAddress.isNotEmpty) {
        return nativeAddress;
      }
    } catch (_) {}

    // 2. Try OpenStreetMap Nominatim Geocoding API
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1',
      );

      final response = await http
          .get(uri, headers: {'User-Agent': 'ProjectCloneApp/1.0'}).timeout(
        const Duration(seconds: 4),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final addressObj = data['address'] as Map<String, dynamic>?;

        if (addressObj != null) {
          final road = addressObj['road'] ?? addressObj['pedestrian'] ?? '';
          final houseNumber = addressObj['house_number'] ?? '';
          final suburb = addressObj['suburb'] ?? addressObj['village'] ?? addressObj['neighbourhood'] ?? '';
          final district = addressObj['city_district'] ?? addressObj['county'] ?? addressObj['subdistrict'] ?? '';
          final city = addressObj['city'] ?? addressObj['town'] ?? addressObj['municipality'] ?? addressObj['state'] ?? '';
          final state = addressObj['state'] ?? '';

          final List<String> parts = [];
          if (road.isNotEmpty) {
            parts.add(houseNumber.isNotEmpty ? "$road No $houseNumber" : road);
          }
          if (suburb.isNotEmpty && suburb != road) parts.add(suburb);
          if (district.isNotEmpty && district != suburb) {
            parts.add(district.toLowerCase().contains("kecamatan")
                ? district
                : "Kecamatan $district");
          }
          if (state.isNotEmpty) {
            parts.add(state);
          } else if (city.isNotEmpty) {
            parts.add(city);
          }

          if (parts.isNotEmpty) {
            return parts.join(", ");
          }
        }

        final displayName = data['display_name']?.toString();
        if (displayName != null && displayName.isNotEmpty) {
          return displayName;
        }
      }
    } catch (_) {
      // Graceful offline fallback
    }

    // 3. Truthful Coordinate-based Fallback when offline & no reverse geocode available
    return "Lat: ${lat.toStringAsFixed(6)}, Long: ${lon.toStringAsFixed(6)} (Alamat offline)";
  }

  /// Burns the overlay watermark onto an image file, compresses it, and returns the updated model
  Future<GeotaggedPhotoModel?> renderAndCompressWatermarkedImage({
    required GlobalKey boundaryKey,
    required GeotaggedPhotoModel photo,
  }) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 2.2);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();
      final appDir = await getApplicationDocumentsDirectory();
      final timeId = DateTime.now().millisecondsSinceEpoch;
      final uncompressedWatermarkFile = File('${appDir.path}/geotag_raw_$timeId.png');

      await uncompressedWatermarkFile.writeAsBytes(pngBytes);

      // Perform Image Compression Pipeline (JPEG downsample & optimize)
      final compressedFile = await GeotagSqliteService.instance
          .compressWatermarkedImage(uncompressedWatermarkFile, targetMaxWidth: 1280, targetQuality: 75);
      final compressedSizeBytes = await compressedFile.length();
      
      final rawCanvasBytes = pngBytes.length;
      final rawPickedBytes = photo.originalSizeBytes > 0
          ? photo.originalSizeBytes
          : (await photo.originalFile.exists() ? await photo.originalFile.length() : 0);
      
      // Original size should accurately represent the full uncompressed canvas / raw photo
      final originalSizeBytes = rawCanvasBytes > rawPickedBytes ? rawCanvasBytes : rawPickedBytes;

      final updatedPhoto = photo.copyWith(
        watermarkedFile: uncompressedWatermarkFile,
        compressedFile: compressedFile,
        originalSizeBytes: originalSizeBytes,
        compressedSizeBytes: compressedSizeBytes,
      );

      _lastCapturedPhoto = updatedPhoto;

      DiagnosticsLoggerService.instance.info(
        "WATERMARK_COMPRESSION_READY",
        "Watermark rendered & compressed (${updatedPhoto.formattedOriginalSize} ➔ ${updatedPhoto.formattedCompressedSize}, Hemat ${updatedPhoto.formattedSavings})",
      );

      return updatedPhoto;
    } catch (e) {
      DiagnosticsLoggerService.instance.error(
        "WATERMARK_COMPRESS_ERROR",
        "Gagal merender dan mengompres foto: $e",
      );
      return null;
    }
  }

  /// Legacy helper for backwards-compatibility
  Future<File?> renderAndSaveWatermarkedImage({
    required GlobalKey boundaryKey,
    required GeotaggedPhotoModel photo,
  }) async {
    final res = await renderAndCompressWatermarkedImage(
      boundaryKey: boundaryKey,
      photo: photo,
    );
    return res?.compressedFile ?? res?.watermarkedFile;
  }

  /// Saves the geotagged photo to SQLite database
  Future<int> savePhotoToSqlite(GeotaggedPhotoModel photo) async {
    return await GeotagSqliteService.instance.insertPhoto(photo);
  }
}
