import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_and_carrier_service.dart';
import '../theme/diagnostics_colors.dart';

enum MapTileLayer {
  street,
  satellite,
  dark,
}

class LiveGeotagMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final String? address;
  final double height;
  final bool isInteractive;
  final VoidCallback? onExpandFullscreen;

  const LiveGeotagMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.accuracyMeters = 10.0,
    this.address,
    this.height = 240,
    this.isInteractive = true,
    this.onExpandFullscreen,
  });

  /// Helper to convert decimal degrees to DMS format (Degrees Minutes Seconds)
  static String formatToDms(double lat, double lon) {
    if (lat == 0.0 && lon == 0.0) return "0°0'0.0\" N, 0°0'0.0\" E";
    final latDms = _toDmsString(lat, isLat: true);
    final lonDms = _toDmsString(lon, isLat: false);
    return "$latDms, $lonDms";
  }

  static String _toDmsString(double val, {required bool isLat}) {
    final direction = isLat
        ? (val >= 0 ? "N" : "S")
        : (val >= 0 ? "E" : "W");
    final absVal = val.abs();
    final degrees = absVal.floor();
    final minutesNotTruncated = (absVal - degrees) * 60;
    final minutes = minutesNotTruncated.floor();
    final seconds = (minutesNotTruncated - minutes) * 60;
    return "$degrees°$minutes'${seconds.toStringAsFixed(1)}\" $direction";
  }

  @override
  State<LiveGeotagMapView> createState() => _LiveGeotagMapViewState();
}

class _LiveGeotagMapViewState extends State<LiveGeotagMapView>
    with SingleTickerProviderStateMixin {
  late double _zoom;
  late double _centerLat;
  late double _centerLon;
  MapTileLayer _currentLayer = MapTileLayer.street;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Pan offset delta
  double _panOffsetX = 0.0;
  double _panOffsetY = 0.0;

  @override
  void initState() {
    super.initState();
    _zoom = 16.0;
    _centerLat = widget.latitude != 0.0 ? widget.latitude : -6.2088;
    _centerLon = widget.longitude != 0.0 ? widget.longitude : 106.8456;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(LiveGeotagMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      if (widget.latitude != 0.0 && widget.longitude != 0.0) {
        setState(() {
          _centerLat = widget.latitude;
          _centerLon = widget.longitude;
          _panOffsetX = 0.0;
          _panOffsetY = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _recenter() async {
    double targetLat = widget.latitude;
    double targetLon = widget.longitude;

    if (targetLat == 0.0 && targetLon == 0.0) {
      final fresh = await LocationAndCarrierService.instance.checkLocationAndCarrier();
      if (fresh.latitude != 0.0 && fresh.longitude != 0.0) {
        targetLat = fresh.latitude;
        targetLon = fresh.longitude;
      }
    }

    if (mounted) {
      setState(() {
        _centerLat = targetLat != 0.0 ? targetLat : -6.2088;
        _centerLon = targetLon != 0.0 ? targetLon : 106.8456;
        _panOffsetX = 0.0;
        _panOffsetY = 0.0;
        _zoom = 16.0;
      });
    }
  }

  void _zoomIn() {
    if (_zoom < 19.0) {
      setState(() => _zoom = (_zoom + 1.0).clamp(3.0, 19.0));
    }
  }

  void _zoomOut() {
    if (_zoom > 4.0) {
      setState(() => _zoom = (_zoom - 1.0).clamp(3.0, 19.0));
    }
  }

  Future<void> _openGoogleMaps() async {
    final lat = widget.latitude != 0.0 ? widget.latitude : -6.2088;
    final lon = widget.longitude != 0.0 ? widget.longitude : 106.8456;
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _copyCoordinates() {
    final lat = widget.latitude.toStringAsFixed(6);
    final lon = widget.longitude.toStringAsFixed(6);
    Clipboard.setData(ClipboardData(text: "$lat, $lon"));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16),
            const SizedBox(width: 8),
            Text("Koordinat disalin: $lat, $lon", style: const TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: DiagnosticsColors.darkCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getTileUrl(int x, int y, int z) {
    switch (_currentLayer) {
      case MapTileLayer.satellite:
        // ESRI World Imagery (Citra Satelit Asli, 100% Free, Tanpa API Key)
        return "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/$z/$y/$x";
      case MapTileLayer.dark:
        // ESRI Canvas Dark Gray Base (Dark Theme Elegan, 100% Free, Tanpa API Key)
        return "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/$z/$y/$x";
      case MapTileLayer.street:
        // OpenStreetMap Tile Server (Open Source, 100% Free, Tanpa API Key)
        final s = ['a', 'b', 'c'][(x + y) % 3];
        return "https://$s.tile.openstreetmap.org/$z/$x/$y.png";
    }
  }

  // Mercator Projection formulas
  static double _lonToTileX(double lon, int zoom) {
    return ((lon + 180.0) / 360.0 * (1 << zoom));
  }

  static double _latToTileY(double lat, int zoom) {
    final latRad = lat * math.pi / 180.0;
    return ((1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) /
        2.0 *
        (1 << zoom));
  }

  @override
  Widget build(BuildContext context) {
    final int intZoom = _zoom.floor();
    final double centerTileX = _lonToTileX(_centerLon, intZoom);
    final double centerTileY = _latToTileY(_centerLat, intZoom);

    const double tileSize = 256.0;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DiagnosticsColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          children: [
            // 1. Slippy Map Tile Canvas
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;

                final double midX = width / 2 + _panOffsetX;
                final double midY = height / 2 + _panOffsetY;

                final int startTileX = (centerTileX - (midX / tileSize) - 1).floor();
                final int endTileX = (centerTileX + ((width - midX) / tileSize) + 1).ceil();
                final int startTileY = (centerTileY - (midY / tileSize) - 1).floor();
                final int endTileY = (centerTileY + ((height - midY) / tileSize) + 1).ceil();

                final int maxTiles = (1 << intZoom);

                final List<Widget> tileWidgets = [];

                for (int tx = startTileX; tx <= endTileX; tx++) {
                  for (int ty = startTileY; ty <= endTileY; ty++) {
                    if (ty < 0 || ty >= maxTiles) continue;
                    final int wrappedX = ((tx % maxTiles) + maxTiles) % maxTiles;

                    final double left = midX + (tx - centerTileX) * tileSize;
                    final double top = midY + (ty - centerTileY) * tileSize;

                    final url = _getTileUrl(wrappedX, ty, intZoom);

                    tileWidgets.add(
                      Positioned(
                        left: left,
                        top: top,
                        width: tileSize,
                        height: tileSize,
                        child: CachedNetworkImage(
                          imageUrl: url,
                          httpHeaders: const {
                            'User-Agent': 'DeviceDiagnosticsFlutterApp/1.0 (Android; LocationViewer)',
                          },
                          fit: BoxFit.cover,
                          placeholder: (context, _) => Container(
                            color: _currentLayer == MapTileLayer.dark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                          errorWidget: (context, _, __) => Container(
                            color: const Color(0xFF334155),
                            child: const Center(
                              child: Icon(Icons.broken_image_rounded,
                                  size: 16, color: Colors.white24),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                return GestureDetector(
                  onPanUpdate: widget.isInteractive
                      ? (details) {
                          setState(() {
                            _panOffsetX += details.delta.dx;
                            _panOffsetY += details.delta.dy;
                          });
                        }
                      : null,
                  child: Stack(
                    children: [
                      ...tileWidgets,

                      // Accuracy Circle Overlay anchored to location pin
                      Positioned(
                        left: midX - 40,
                        top: midY - 40,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            final pulse = _pulseAnimation.value;
                            final double diameter =
                                (widget.accuracyMeters * 3.5 * pulse).clamp(24.0, 110.0);
                            return Transform.translate(
                              offset: Offset((80 - diameter) / 2, (80 - diameter) / 2),
                              child: Container(
                                width: diameter,
                                height: diameter,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0284C7).withValues(alpha: 0.18),
                                  border: Border.all(
                                    color: const Color(0xFF0284C7).withValues(alpha: 0.55),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Location Pin Marker anchored to exact coordinate
                      Positioned(
                        left: midX - 15,
                        top: midY - 34,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.pin_drop_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 2. Top-Left: Layer Switcher Badges
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLayerTab(
                      label: "Street",
                      icon: Icons.map_outlined,
                      layer: MapTileLayer.street,
                    ),
                    const SizedBox(width: 3),
                    _buildLayerTab(
                      label: "Satelit",
                      icon: Icons.satellite_alt_rounded,
                      layer: MapTileLayer.satellite,
                    ),
                    const SizedBox(width: 3),
                    _buildLayerTab(
                      label: "Dark",
                      icon: Icons.dark_mode_rounded,
                      layer: MapTileLayer.dark,
                    ),
                  ],
                ),
              ),
            ),

            // 3. Top-Right: Quick Actions (Google Maps, Fullscreen, Copy)
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Google Maps Launcher Shortcut
                  _buildCircleActionButton(
                    icon: Icons.open_in_new_rounded,
                    tooltip: "Buka di Google Maps",
                    color: const Color(0xFF0284C7),
                    onTap: _openGoogleMaps,
                  ),
                  const SizedBox(width: 6),

                  // Copy Coordinates
                  _buildCircleActionButton(
                    icon: Icons.copy_rounded,
                    tooltip: "Salin Koordinat",
                    color: const Color(0xFF10B981),
                    onTap: _copyCoordinates,
                  ),

                  // Fullscreen Expand if callback provided
                  if (widget.onExpandFullscreen != null) ...[
                    const SizedBox(width: 6),
                    _buildCircleActionButton(
                      icon: Icons.fullscreen_rounded,
                      tooltip: "Peta Layar Penuh",
                      color: const Color(0xFFF59E0B),
                      onTap: widget.onExpandFullscreen!,
                    ),
                  ],
                ],
              ),
            ),

            // 4. Bottom-Right: Zoom & Recenter Controls
            if (widget.isInteractive)
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildZoomButton(
                        icon: Icons.add_rounded,
                        onTap: _zoomIn,
                      ),
                      Container(
                        width: 24,
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      _buildZoomButton(
                        icon: Icons.remove_rounded,
                        onTap: _zoomOut,
                      ),
                      Container(
                        width: 24,
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      _buildZoomButton(
                        icon: Icons.my_location_rounded,
                        color: const Color(0xFF38BDF8),
                        onTap: _recenter,
                      ),
                    ],
                  ),
                ),
              ),

            // 5. Bottom-Left: Live Coordinates Mini Pill
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)} (Zoom ${intZoom}x)",
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerTab({
    required String label,
    required IconData icon,
    required MapTileLayer layer,
  }) {
    final isSelected = _currentLayer == layer;
    return InkWell(
      onTap: () => setState(() => _currentLayer = layer),
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0284C7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 11,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 3.5),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}
