import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/geotagged_photo_model.dart';
import '../models/location_and_carrier_data.dart';
import '../pages/camera_geotag_preview_page.dart';
import '../pages/interactive_geotag_map_page.dart';
import '../pages/saved_geotag_photos_page.dart';
import '../services/geotag_sqlite_service.dart';
import '../services/geotagging_camera_service.dart';
import '../services/location_and_carrier_service.dart';
import '../theme/diagnostics_colors.dart';
import 'geotag_permission_dialogs.dart';
import 'live_geotag_map_view.dart';

class GeotaggingAndGpsCard extends StatefulWidget {
  final LocationAndCarrierData locationCarrier;
  final double compassHeading;
  final Function(GeotaggingCondition) onSimulateCondition;
  final VoidCallback onResetSimulation;

  const GeotaggingAndGpsCard({
    super.key,
    required this.locationCarrier,
    required this.compassHeading,
    required this.onSimulateCondition,
    required this.onResetSimulation,
  });

  @override
  State<GeotaggingAndGpsCard> createState() => _GeotaggingAndGpsCardState();
}

class _GeotaggingAndGpsCardState extends State<GeotaggingAndGpsCard> {
  GeotaggedPhotoModel? _recentPhoto;
  bool _isCapturing = false;
  int _savedSqliteCount = 0;

  @override
  void initState() {
    super.initState();
    _recentPhoto = GeotaggingCameraService.instance.lastCapturedPhoto;
    _refreshSqliteCount();
  }

  Future<void> _refreshSqliteCount() async {
    final stats = await GeotagSqliteService.instance.getStats();
    if (mounted) {
      setState(() {
        _savedSqliteCount = (stats['totalPhotos'] as num?)?.toInt() ?? 0;
      });
    }
  }

  Future<void> _openCameraCapture(BuildContext context, ImageSource source) async {
    // 1. Verify Permission Status (ACCESS_FINE_LOCATION & CAMERA)
    final status = await LocationAndCarrierService.instance.checkLocationStatus();
    final bool isLocGranted = status['isLocationGranted'] == true || widget.locationCarrier.isLocationPermissionGranted;
    if (!isLocGranted) {
      if (context.mounted) {
        await GeotagPermissionDialogs.showPermissionRequiredDialog(
          context: context,
          onPermissionGranted: () {
            _openCameraCapture(context, source);
          },
        );
      }
      return;
    }

    // 2. Verify GPS Hardware Status (Must be active/ON)
    final bool isGpsOn = status['isGpsEnabled'] == true || widget.locationCarrier.isGpsEnabled;
    if (!isGpsOn) {
      if (context.mounted) {
        await GeotagPermissionDialogs.showGpsRequiredDialog(
          context: context,
          onSettingsOpened: () {
            // Refreshed after user opens settings
          },
        );
      }
      return;
    }

    setState(() => _isCapturing = true);

    final photo = await GeotaggingCameraService.instance.captureGeotaggedPhoto(
      source: source,
      locationData: widget.locationCarrier,
    );

    setState(() => _isCapturing = false);

    if (photo != null && context.mounted) {
      setState(() => _recentPhoto = photo);

      // Open preview page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraGeotagPreviewPage(
            initialPhoto: photo,
            locationData: widget.locationCarrier,
          ),
        ),
      ).then((_) {
        setState(() {
          _recentPhoto = GeotaggingCameraService.instance.lastCapturedPhoto;
        });
        _refreshSqliteCount();
      });
    }
  }

  void _openExistingPhotoPreview(BuildContext context) {
    if (_recentPhoto == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraGeotagPreviewPage(
          initialPhoto: _recentPhoto,
          locationData: widget.locationCarrier,
        ),
      ),
    ).then((_) {
      setState(() {
        _recentPhoto = GeotaggingCameraService.instance.lastCapturedPhoto;
      });
      _refreshSqliteCount();
    });
  }

  void _openSqliteGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedGeotagPhotosPage(),
      ),
    ).then((_) => _refreshSqliteCount());
  }

  @override
  Widget build(BuildContext context) {
    final condition = widget.locationCarrier.condition;
    final isOptimal = condition == GeotaggingCondition.optimal;
    final isMock = condition == GeotaggingCondition.mockLocation;
    final isGpsOff = condition == GeotaggingCondition.gpsDisabled;
    final isPermDenied = condition == GeotaggingCondition.permissionDenied;

    // Theme Color by Condition
    final Color conditionColor;
    final IconData conditionIcon;
    if (isOptimal) {
      conditionColor = const Color(0xFF10B981); // Emerald Green
      conditionIcon = Icons.verified_rounded;
    } else if (isMock) {
      conditionColor = const Color(0xFFEF4444); // Red
      conditionIcon = Icons.gpp_bad_rounded;
    } else if (isGpsOff) {
      conditionColor = const Color(0xFFEF4444); // Red
      conditionIcon = Icons.location_off_rounded;
    } else if (isPermDenied) {
      conditionColor = const Color(0xFFF97316); // Orange
      conditionIcon = Icons.lock_person_rounded;
    } else {
      conditionColor = const Color(0xFFF59E0B); // Amber / Weak
      conditionIcon = Icons.satellite_alt_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOptimal
              ? const Color(0xFFE2E8F0)
              : conditionColor.withOpacity(0.4),
          width: isOptimal ? 1.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isOptimal
                ? const Color(0xFF0F172A).withOpacity(0.04)
                : conditionColor.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with Icon & Condition Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.satellite_alt_rounded,
                    color: Color(0xFF0284C7),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GPS Satelit & Geotagging",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Live Telemetry, Compass & Evaluasi Geotagging",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: conditionColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: conditionColor.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(conditionIcon, size: 12, color: conditionColor),
                      const SizedBox(width: 4),
                      Text(
                        isOptimal ? "OPTIMAL" : (isMock ? "FRAUD" : "PERINGATAN"),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: conditionColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Geotagging Condition Alert Banner ("Kondisi Geotagging Tidak Sesuai")
            _buildGeotaggingConditionBanner(
                context, conditionColor, conditionIcon),
            const SizedBox(height: 16),

            // 3. 📸 CAMERA GEOTAGGING CAPTURE & WATERMARK SECTION
            _buildCameraGeotagSection(context),
            const SizedBox(height: 16),

            // 4. Live Digital Compass + Primary Coordinates Panel
            _buildCompassAndCoordinatesSection(context),
            const SizedBox(height: 16),

            // 5. 🗺️ LIVE INTERACTIVE GEOTAG MAP (Street, Satellite & Dark View)
            _buildInteractiveMapSection(context),
            const SizedBox(height: 16),

            // 6. Detailed Telemetry Grid (Altitude, Accuracy, Speed, Bearing)
            _buildTelemetryGrid(context),
            const SizedBox(height: 16),

            // 7. Cellular Carrier & SIM Card Badge
            _buildCarrierAndSimCard(context),
            const SizedBox(height: 16),

            // 8. Interactive Geotagging Condition Simulation Bar (Test Cases)
            _buildSimulationActionToolbar(context),
          ],
        ),
      ),
    );
  }

  /// 📸 Camera Geotagging Feature Card & Recent Captured Photo Thumbnail
  Widget _buildCameraGeotagSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Camera Geotagging & SQLite",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Kompresi Gambar & Database Lokal",
                        style: TextStyle(
                          color: Color(0xFFE0F2FE),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _openSqliteGallery(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.storage_rounded,
                            size: 11, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "$_savedSqliteCount SQLite",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // If a photo was captured, show thumbnail with watermark preview & compression tag
            if (_recentPhoto != null) ...[
              InkWell(
                onTap: () => _openExistingPhotoPreview(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.file(
                              _recentPhoto!.displayFile,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 3,
                              height: 24,
                              color: const Color(0xFFF59E0B),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 2.5,
                                  height: 10,
                                  color: const Color(0xFFF59E0B),
                                  margin: const EdgeInsets.only(right: 4),
                                ),
                                Expanded(
                                  child: Text(
                                    _recentPhoto!.formattedDateTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_recentPhoto!.compressedSizeBytes > 0) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981)
                                          .withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _recentPhoto!.formattedSavings.isNotEmpty
                                          ? "-${_recentPhoto!.formattedSavings}"
                                          : _recentPhoto!.formattedCompressedSize,
                                      style: const TextStyle(
                                        color: Color(0xFF6EE7B7),
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _recentPhoto!.fullAddress,
                              style: const TextStyle(
                                color: Color(0xFFE0F2FE),
                                fontSize: 9.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _recentPhoto!.formattedCoordinates,
                                    style: const TextStyle(
                                      color: Color(0xFFBAE6FD),
                                      fontSize: 9.5,
                                      fontFamily: 'monospace',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_recentPhoto!.compressedSizeBytes > 0) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    _recentPhoto!.formattedCompressedSize,
                                    style: const TextStyle(
                                      color: Color(0xFF6EE7B7),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.visibility_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Action Buttons (Open Camera / Gallery / SQLite Gallery)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0369A1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: _isCapturing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF0369A1),
                            ),
                          )
                        : const Icon(Icons.camera_alt_rounded, size: 16),
                    label: Text(
                      _isCapturing ? "Membaca GPS..." : "Ambil Foto Kamera",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _isCapturing
                        ? null
                        : () => _openCameraCapture(context, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: "Pilih dari Galeri",
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.photo_library_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: _isCapturing
                      ? null
                      : () => _openCameraCapture(context, ImageSource.gallery),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: "Buka Galeri SQLite",
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.storage_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => _openSqliteGallery(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Banner evaluating what happens when geotagging condition is abnormal or optimal
  Widget _buildGeotaggingConditionBanner(
      BuildContext context, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.locationCarrier.conditionTitle,
                  style: TextStyle(
                    fontSize: 13,
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
            widget.locationCarrier.conditionDescription,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF334155),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.locationCarrier.conditionRecommendation,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.locationCarrier.condition == GeotaggingCondition.gpsDisabled) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DiagnosticsColors.danger,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.settings_suggest_rounded, size: 15),
                label: const Text(
                  "Nyalakan GPS (Buka Pengaturan HP)",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  GeotagPermissionDialogs.showGpsRequiredDialog(context: context);
                },
              ),
            ),
          ] else if (widget.locationCarrier.condition == GeotaggingCondition.permissionDenied) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DiagnosticsColors.warning,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.security_rounded, size: 15),
                label: const Text(
                  "Izinkan Akses Lokasi (ACCESS_FINE_LOCATION)",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  final result = await LocationAndCarrierService.instance.requestLocationPermission();
                  if (result['isLocationGranted'] != true && context.mounted) {
                    await GeotagPermissionDialogs.showPermissionRequiredDialog(
                      context: context,
                      onPermissionGranted: () {
                        // Lifecycle observer auto rescans
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Live Compass & Coordinates Section
  Widget _buildCompassAndCoordinatesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Visual Rotating Compass Dial
          _buildCompassDial(),
          const SizedBox(width: 14),

          // Coordinates & Direction Summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "KOORDINAT GPS",
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: widget.locationCarrier.formattedCoordinates));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Koordinat disalin: ${widget.locationCarrier.formattedCoordinates}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.copy_rounded,
                                color: Color(0xFF38BDF8), size: 10),
                            SizedBox(width: 4),
                            Text(
                              "Salin",
                              style: TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.locationCarrier.formattedCoordinates,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.explore_rounded,
                        color: Color(0xFF38BDF8), size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Orientasi: ${widget.compassHeading.round()}° ${_getCardinal(widget.compassHeading)}",
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🗺️ Live Interactive Geotag Map Section (OpenStreetMap / ESRI Tiles)
  Widget _buildInteractiveMapSection(BuildContext context) {
    final lat = widget.locationCarrier.latitude;
    final lon = widget.locationCarrier.longitude;
    final dms = LiveGeotagMapView.formatToDms(lat, lon);

    return Container(
      decoration: BoxDecoration(
        color: DiagnosticsColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DiagnosticsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.map_rounded,
                          size: 16, color: Color(0xFF0284C7)),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "PETA VISUAL KOORDINAT (MAPS)",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: DiagnosticsColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InteractiveGeotagMapPage(
                          latitude: lat,
                          longitude: lon,
                          altitude: widget.locationCarrier.altitudeMeters,
                          accuracy: widget.locationCarrier.accuracyMeters,
                          bearing: widget.locationCarrier.bearingDegrees,
                          address: GeotaggingCameraService.instance.lastCapturedPhoto?.address ??
                              widget.locationCarrier.formattedCoordinates,
                          carrier: widget.locationCarrier.carrierName,
                          locationData: widget.locationCarrier,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fullscreen_rounded,
                            size: 13, color: Color(0xFF0284C7)),
                        SizedBox(width: 3),
                        Text(
                          "Peta Penuh",
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map Tile Canvas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LiveGeotagMapView(
              latitude: lat,
              longitude: lon,
              accuracyMeters: widget.locationCarrier.accuracyMeters,
              height: 200,
              isInteractive: true,
              onExpandFullscreen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InteractiveGeotagMapPage(
                      latitude: lat,
                      longitude: lon,
                      altitude: widget.locationCarrier.altitudeMeters,
                      accuracy: widget.locationCarrier.accuracyMeters,
                      bearing: widget.locationCarrier.bearingDegrees,
                      address: GeotaggingCameraService.instance.lastCapturedPhoto?.address ??
                          widget.locationCarrier.formattedCoordinates,
                      carrier: widget.locationCarrier.carrierName,
                      locationData: widget.locationCarrier,
                    ),
                  ),
                );
              },
            ),
          ),

          // DMS & Accuracy Info Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              children: [
                const Icon(Icons.pin_drop_outlined,
                    size: 13, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "DMS: $dms",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Smooth Compass Dial Widget with Rotating Needle
  Widget _buildCompassDial() {
    final rad = (widget.compassHeading * math.pi / 180);

    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0B132B),
        border: Border.all(
            color: const Color(0xFF38BDF8).withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withOpacity(0.12),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cardinal marks (N, S, E, W)
          const Positioned(
            top: 4,
            child: Text(
              "N",
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Positioned(
            bottom: 4,
            child: Text(
              "S",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Positioned(
            left: 5,
            child: Text(
              "W",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Positioned(
            right: 5,
            child: Text(
              "E",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Center Rotating Needle
          Transform.rotate(
            angle: rad,
            child: SizedBox(
              width: 50,
              height: 50,
              child: CustomPaint(
                painter: _CompassNeedlePainter(),
              ),
            ),
          ),

          // Center Pin
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF38BDF8),
            ),
          ),
        ],
      ),
    );
  }

  /// 4-Cell Telemetry Grid (Altitude, Accuracy, Speed, Provider)
  Widget _buildTelemetryGrid(BuildContext context) {
    // Accuracy Color Code
    final Color accColor;
    if (widget.locationCarrier.accuracyMeters <= 15) {
      accColor = const Color(0xFF10B981);
    } else if (widget.locationCarrier.accuracyMeters <= 35) {
      accColor = const Color(0xFF0284C7);
    } else {
      accColor = const Color(0xFFF59E0B);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTelemetryCell(
                icon: Icons.height_rounded,
                iconColor: const Color(0xFF8B5CF6),
                label: "Ketinggian (Altitude)",
                value: widget.locationCarrier.formattedAltitude,
                helper: "Diatas permukaan laut",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTelemetryCell(
                icon: Icons.radar_rounded,
                iconColor: accColor,
                label: "Radius Akurasi",
                value: widget.locationCarrier.formattedAccuracy,
                helper: widget.locationCarrier.accuracyMeters <= 25
                    ? "Presisi Tinggi"
                    : "Sinyal Melebar",
                valueColor: accColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTelemetryCell(
                icon: Icons.speed_rounded,
                iconColor: const Color(0xFF0EA5E9),
                label: "Kecepatan (Speed)",
                value: widget.locationCarrier.formattedSpeed,
                helper: widget.locationCarrier.speedKmh > 1.0
                    ? "Bergerak"
                    : "Diam/Statis",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTelemetryCell(
                icon: Icons.hub_rounded,
                iconColor: const Color(0xFF6366F1),
                label: "Provider Lokasi",
                value: widget.locationCarrier.locationProvider.toUpperCase(),
                helper: widget.locationCarrier.isLocationMock
                    ? "MOCK GPS AKTIF"
                    : "Hardware GPS Chip",
                valueColor: widget.locationCarrier.isLocationMock
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTelemetryCell({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String helper,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            helper,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF94A3B8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Carrier & SIM Status Section
  Widget _buildCarrierAndSimCard(BuildContext context) {
    final carrier = widget.locationCarrier.carrierName;
    final hasSim = widget.locationCarrier.simState == "READY";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              hasSim ? Icons.sim_card_rounded : Icons.sim_card_alert_rounded,
              color: hasSim ? const Color(0xFF0284C7) : const Color(0xFF94A3B8),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        carrier,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.locationCarrier.countryIso.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.locationCarrier.simStatusLabel,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasSim
                  ? const Color(0xFF10B981).withOpacity(0.12)
                  : const Color(0xFF94A3B8).withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              hasSim ? "Active SIM" : "No SIM",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color:
                    hasSim ? const Color(0xFF10B981) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Actionable Simulation Toolbar to test abnormal geotagging conditions
  Widget _buildSimulationActionToolbar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "SIMULASI KONDISI GEOTAGGING (QA / AUDIT)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: widget.onResetSimulation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  "Reset Normal",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildSimulationChip(
              label: "Sinyal Lemah (±118m)",
              color: const Color(0xFFF59E0B),
              icon: Icons.signal_cellular_nodata_rounded,
              onTap: () =>
                  widget.onSimulateCondition(GeotaggingCondition.weakSignal),
            ),
            _buildSimulationChip(
              label: "GPS Dimatikan (OFF)",
              color: const Color(0xFFEF4444),
              icon: Icons.location_off_rounded,
              onTap: () =>
                  widget.onSimulateCondition(GeotaggingCondition.gpsDisabled),
            ),
            _buildSimulationChip(
              label: "Fake / Mock GPS",
              color: const Color(0xFFDC2626),
              icon: Icons.gpp_bad_rounded,
              onTap: () =>
                  widget.onSimulateCondition(GeotaggingCondition.mockLocation),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimulationChip({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCardinal(double deg) {
    final d = (deg % 360 + 360) % 360;
    if (d >= 337.5 || d < 22.5) return "N";
    if (d >= 22.5 && d < 67.5) return "NE";
    if (d >= 67.5 && d < 112.5) return "E";
    if (d >= 112.5 && d < 157.5) return "SE";
    if (d >= 157.5 && d < 202.5) return "S";
    if (d >= 202.5 && d < 247.5) return "SW";
    if (d >= 247.5 && d < 292.5) return "W";
    return "NW";
  }
}

/// Custom painter for compass needle (North red arrow, South white arrow)
class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintNorth = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;

    final paintSouth = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // North Pointer (Red)
    final pathNorth = Path()
      ..moveTo(centerX, 2)
      ..lineTo(centerX - 4, centerY)
      ..lineTo(centerX + 4, centerY)
      ..close();
    canvas.drawPath(pathNorth, paintNorth);

    // South Pointer (Light Grey)
    final pathSouth = Path()
      ..moveTo(centerX, size.height - 2)
      ..lineTo(centerX - 4, centerY)
      ..lineTo(centerX + 4, centerY)
      ..close();
    canvas.drawPath(pathSouth, paintSouth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
