import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/location_and_carrier_data.dart';
import '../services/geotagging_camera_service.dart';
import '../services/location_and_carrier_service.dart';
import '../theme/diagnostics_colors.dart';
import '../widgets/live_geotag_map_view.dart';

class InteractiveGeotagMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final double bearing;
  final String address;
  final String carrier;
  final LocationAndCarrierData? locationData;

  const InteractiveGeotagMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.altitude = 0.0,
    this.accuracy = 10.0,
    this.bearing = 0.0,
    this.address = "Alamat tidak tersedia",
    this.carrier = "No SIM / WiFi Only",
    this.locationData,
  });

  @override
  State<InteractiveGeotagMapPage> createState() =>
      _InteractiveGeotagMapPageState();
}

class _InteractiveGeotagMapPageState extends State<InteractiveGeotagMapPage> {
  bool _isPanelExpanded = true;
  bool _isRefreshing = false;

  late double _lat;
  late double _lon;
  late double _alt;
  late double _acc;
  late String _address;
  late String _carrier;

  @override
  void initState() {
    super.initState();
    _lat = widget.latitude;
    _lon = widget.longitude;
    _alt = widget.altitude;
    _acc = widget.accuracy;
    _address = widget.address;
    _carrier = widget.carrier;

    // If zero or placeholder coordinates, fetch live location immediately
    if (_lat == 0.0 && _lon == 0.0) {
      _refreshCurrentLocation();
    }
  }

  Future<void> _refreshCurrentLocation() async {
    setState(() => _isRefreshing = true);
    final fresh = await LocationAndCarrierService.instance.checkLocationAndCarrier();
    String addr = _address;
    if (fresh.latitude != 0.0 && fresh.longitude != 0.0) {
      addr = await GeotaggingCameraService.instance.reverseGeocode(
        fresh.latitude,
        fresh.longitude,
      );
    }
    if (mounted) {
      setState(() {
        _isRefreshing = false;
        if (fresh.latitude != 0.0 && fresh.longitude != 0.0) {
          _lat = fresh.latitude;
          _lon = fresh.longitude;
          _alt = fresh.altitudeMeters;
          _acc = fresh.accuracyMeters;
          _address = addr;
          _carrier = fresh.carrierName;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.my_location_rounded, color: Colors.greenAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Lokasi saat ini terkunci: ${_lat.toStringAsFixed(5)}, ${_lon.toStringAsFixed(5)}",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: DiagnosticsColors.darkCard,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openGoogleMaps() async {
    final lat = _lat != 0.0 ? _lat : -6.2088;
    final lon = _lon != 0.0 ? _lon : 106.8456;
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _copyAllTelemetry() {
    final dms = LiveGeotagMapView.formatToDms(_lat, _lon);
    final text = """
📍 TELEMETRI KOORDINAT & GEOTAGGING MAP (LOKASI SAAT INI)
Alamat: $_address
Latitude: ${_lat.toStringAsFixed(7)}
Longitude: ${_lon.toStringAsFixed(7)}
Format DMS: $dms
Ketinggian: ${_alt.toStringAsFixed(1)} m dpl
Akurasi GPS: ± ${_acc.toStringAsFixed(1)} m
Operator/SIM: $_carrier
Link Google Maps: https://www.google.com/maps/search/?api=1&query=$_lat,$_lon
""";

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16),
            SizedBox(width: 8),
            Text("Seluruh data telemetri & koordinat berhasil disalin!",
                style: TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: DiagnosticsColors.darkCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dms = LiveGeotagMapView.formatToDms(_lat, _lon);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Peta Visual Lokasi Saat Ini",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Translasi Koordinat GPS & Visual Spasial",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Sinkronkan Lokasi Saat Ini",
            icon: _isRefreshing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Color(0xFF38BDF8),
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.my_location_rounded,
                    color: Color(0xFF38BDF8), size: 20),
            onPressed: _isRefreshing ? null : _refreshCurrentLocation,
          ),
          IconButton(
            tooltip: "Salin Info Telemetri",
            icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
            onPressed: _copyAllTelemetry,
          ),
          IconButton(
            tooltip: "Buka di Google Maps",
            icon: const Icon(Icons.open_in_new_rounded,
                color: Color(0xFF38BDF8), size: 20),
            onPressed: _openGoogleMaps,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          // 1. Fullscreen Map Canvas
          Positioned.fill(
            child: LiveGeotagMapView(
              key: ValueKey("map_${_lat}_${_lon}"),
              latitude: _lat,
              longitude: _lon,
              accuracyMeters: _acc,
              address: _address,
              height: double.infinity,
              isInteractive: true,
            ),
          ),

          // 2. Sliding Bottom Coordinate Translation Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: DiagnosticsColors.cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: DiagnosticsColors.border, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag / Collapse Handle
                      Center(
                        child: InkWell(
                          onTap: () {
                            setState(() => _isPanelExpanded = !_isPanelExpanded);
                          },
                          child: Container(
                            width: 38,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: DiagnosticsColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),

                      // Address Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFF0284C7),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "LOKASI & ALAMAT TERPANTAU",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: DiagnosticsColors.textSubtle,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _address,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: DiagnosticsColors.textPrimary,
                                    height: 1.3,
                                  ),
                                  maxLines: _isPanelExpanded ? 3 : 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isPanelExpanded
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded,
                              color: DiagnosticsColors.textSubtle,
                            ),
                            onPressed: () {
                              setState(() => _isPanelExpanded = !_isPanelExpanded);
                            },
                          ),
                        ],
                      ),

                      if (_isPanelExpanded) ...[
                        const Divider(height: 20, color: DiagnosticsColors.divider),

                        // Coordinates Grid (Decimal vs DMS)
                        Row(
                          children: [
                            Expanded(
                              child: _buildCoordinateTile(
                                label: "Latitude (Desimal)",
                                value: _lat.toStringAsFixed(7),
                                icon: Icons.straighten_rounded,
                                accentColor: const Color(0xFF0284C7),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCoordinateTile(
                                label: "Longitude (Desimal)",
                                value: _lon.toStringAsFixed(7),
                                icon: Icons.straighten_rounded,
                                accentColor: const Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // DMS & Accuracy Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildCoordinateTile(
                                label: "Derajat Menit Detik (DMS)",
                                value: dms,
                                icon: Icons.explore_rounded,
                                accentColor: const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCoordinateTile(
                                label: "Akurasi & Ketinggian",
                                value: "±${_acc.toStringAsFixed(1)}m • ${_alt.toStringAsFixed(1)}m dpl",
                                icon: Icons.satellite_alt_rounded,
                                accentColor: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Bottom Actions (Open Google Maps & Copy)
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0284C7),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                                  label: const Text(
                                    "Buka Google Maps",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: _openGoogleMaps,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 44,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: DiagnosticsColors.textPrimary,
                                  side: const BorderSide(color: DiagnosticsColors.border),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.copy_rounded, size: 16),
                                label: const Text(
                                  "Salin Info",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: _copyAllTelemetry,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateTile({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: DiagnosticsColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DiagnosticsColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: accentColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: DiagnosticsColors.textSubtle,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: DiagnosticsColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
