import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _EnvironmentPreset {
  mountHood('Mount Hood Sunset', [
    Color(0xFF1E1B4B),
    Color(0xFF831843),
    Color(0xFFF97316),
  ], Icons.terrain_rounded),
  whiteSands('White Sands Night', [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFF475569),
  ], Icons.nights_stay_rounded),
  deepCosmos('Deep Nebula', [
    Color(0xFF030712),
    Color(0xFF311042),
    Color(0xFF4C1D95),
  ], Icons.auto_awesome_rounded),
  passthrough('AR Passthrough', [
    Color(0xFF18181B),
    Color(0xFF27272A),
    Color(0xFF3F3F46),
  ], Icons.camera_alt_rounded);

  final String label;
  final List<Color> bgGradient;
  final IconData icon;
  const _EnvironmentPreset(this.label, this.bgGradient, this.icon);
}

class _SpatialAudioSource {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  double
  angle; // Radians (0 is front, pi/2 is right, pi is back, -pi/2 is left)
  double distance; // 0.2 to 1.0 (normalized distance)
  bool isMuted;

  _SpatialAudioSource({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.angle,
    required this.distance,
  }) : isMuted = false;

  // Pan (-1.0 left to +1.0 right)
  double get pan => math.sin(angle);

  // Volume based on distance (inverse-square approximation)
  double get volume => isMuted ? 0.0 : (1.0 - distance * 0.5).clamp(0.1, 1.0);
}

class VisionSpatialHudWindowShowcase extends StatefulWidget {
  const VisionSpatialHudWindowShowcase({super.key});

  @override
  State<VisionSpatialHudWindowShowcase> createState() =>
      _VisionSpatialHudWindowShowcaseState();
}

class _VisionSpatialHudWindowShowcaseState
    extends State<VisionSpatialHudWindowShowcase> {
  // Spatial depth (0.5m to 3.5m)
  double _zDepthMeters = 1.8;

  // Selected Environment
  _EnvironmentPreset _selectedEnv = _EnvironmentPreset.mountHood;

  // Immersion dial (0% passthrough to 100% full immersion)
  double _immersionLevel = 0.85;

  // Spatial Audio Sources
  final List<_SpatialAudioSource> _audioSources = [
    _SpatialAudioSource(
      id: 'vocal',
      label: 'Spatial Vocal',
      icon: Icons.mic_rounded,
      color: const Color(0xFFEC4899),
      angle: 0.35, // front right
      distance: 0.55,
    ),
    _SpatialAudioSource(
      id: 'synth',
      label: 'Ambient Synth',
      icon: Icons.graphic_eq_rounded,
      color: const Color(0xFF38BDF8),
      angle: -0.75, // front left
      distance: 0.70,
    ),
    _SpatialAudioSource(
      id: 'bass',
      label: 'Sub Bass',
      icon: Icons.speaker_rounded,
      color: const Color(0xFF10B981),
      angle: math.pi * 0.85, // rear right
      distance: 0.85,
    ),
  ];

  _SpatialAudioSource? _activeAudioSource;
  int _activeDockIndex = 2; // Soundstage Tab default

  @override
  void initState() {
    super.initState();
    _activeAudioSource = _audioSources.first;
  }

  void _onSoundstagePanUpdate(DragUpdateDetails details, Size fieldSize) {
    if (_activeAudioSource == null) return;

    final center = Offset(fieldSize.width / 2, fieldSize.height / 2);
    final touchPos = details.localPosition;
    final dx = touchPos.dx - center.dx;
    final dy = touchPos.dy - center.dy;

    final rawDist = math.sqrt(dx * dx + dy * dy);
    final maxRadius = fieldSize.width / 2 - 16;
    final normalizedDist = (rawDist / maxRadius).clamp(0.15, 0.95);

    // Calculate angle where -Y is front (angle 0)
    // dy negative is front, dx positive is right
    final calculatedAngle = math.atan2(dx, -dy);

    setState(() {
      _activeAudioSource!.distance = normalizedDist;
      _activeAudioSource!.angle = calculatedAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Window scale factor based on Z-depth (closer = bigger, further = smaller)
    final windowScale = (2.6 / (_zDepthMeters + 0.8)).clamp(0.82, 1.15);

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HEADER INFO BANNER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [Colors.white, const Color(0xFFF1F5F9)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.spatial_audio_rounded,
                    color: Color(0xFFA855F7),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spatial HUD & Soundstage',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'VisionOS Floating Window & 3D Polar Audio',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${_zDepthMeters.toStringAsFixed(1)}m Depth',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA855F7),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. SPATIAL AMBIENT VIEWPORT & FLOATING GLASS WINDOW
          Container(
            height: 310,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Ambient Environment Backdrop
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.3),
                        radius: 1.1,
                        colors: _selectedEnv.bgGradient,
                      ),
                    ),
                  ),

                  // Spatial Immersion Dimmer
                  Container(
                    color: Colors.black.withValues(
                      alpha: 0.35 + (1.0 - _immersionLevel) * 0.35,
                    ),
                  ),

                  // Ambient Horizon Starfield Lines
                  CustomPaint(painter: _SpatialHorizonGridPainter()),

                  // FLOATING SPATIAL WINDOW (Scales with Z-Depth)
                  Center(
                    child: Transform.scale(
                      scale: windowScale,
                      child: Container(
                        width: 320,
                        height: 230,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 25 * (_zDepthMeters / 1.5),
                              spreadRadius: 2,
                              offset: Offset(0, 8 * _zDepthMeters),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Column(
                            children: [
                              // Window Top Bar
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.blur_on_rounded,
                                          size: 14,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Spatial Soundstage 360°',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Interactive Soundstage Radar Field
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final fieldSize = Size(
                                      constraints.maxWidth,
                                      constraints.maxHeight,
                                    );

                                    return GestureDetector(
                                      onPanUpdate:
                                          (details) => _onSoundstagePanUpdate(
                                            details,
                                            fieldSize,
                                          ),
                                      child: CustomPaint(
                                        size: fieldSize,
                                        painter: _SpatialSoundstageRadarPainter(
                                          sources: _audioSources,
                                          activeSource: _activeAudioSource,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Bottom Floating Orbit Dock Bar
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildDockIcon(
                                      Icons.apps_rounded,
                                      0,
                                      'Apps',
                                    ),
                                    _buildDockIcon(
                                      Icons.landscape_rounded,
                                      1,
                                      'Environments',
                                    ),
                                    _buildDockIcon(
                                      Icons.surround_sound_rounded,
                                      2,
                                      'Audio',
                                    ),
                                    _buildDockIcon(
                                      Icons.tune_rounded,
                                      3,
                                      'Controls',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Window Floor Distance Indicator
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          'Drag audio pins inside radar to reposition sound sources in 3D',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. AUDIO SOURCE SELECTOR & REALTIME TELEMETRY
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AUDIO TRACK SPATIAL AKTIF',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children:
                      _audioSources.map((source) {
                        final isSel = _activeAudioSource == source;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _activeAudioSource = source);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    isSel
                                        ? source.color.withValues(alpha: 0.15)
                                        : (isDark
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      isSel
                                          ? source.color
                                          : (isDark
                                              ? Colors.white12
                                              : Colors.black12),
                                  width: isSel ? 1.5 : 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    source.icon,
                                    size: 18,
                                    color:
                                        isSel
                                            ? source.color
                                            : (isDark
                                                ? Colors.white54
                                                : Colors.black45),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    source.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight:
                                          isSel
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isSel
                                              ? source.color
                                              : (isDark
                                                  ? Colors.white70
                                                  : Colors.black87),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const Divider(height: 18),

                // Active Source Telemetry (Azimuth Angle, Stereo Pan, Distance)
                if (_activeAudioSource != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTelemetryItem(
                        'Azimuth',
                        '${(_activeAudioSource!.angle * 180 / math.pi).toInt()}°',
                        Icons.rotate_90_degrees_ccw_rounded,
                        _activeAudioSource!.color,
                        isDark,
                      ),
                      _buildDivider(isDark),
                      _buildTelemetryItem(
                        'Stereo Pan',
                        _activeAudioSource!.pan < -0.1
                            ? '${(_activeAudioSource!.pan.abs() * 100).toInt()}% L'
                            : _activeAudioSource!.pan > 0.1
                            ? '${(_activeAudioSource!.pan * 100).toInt()}% R'
                            : 'Center',
                        Icons.hearing_rounded,
                        _activeAudioSource!.color,
                        isDark,
                      ),
                      _buildDivider(isDark),
                      _buildTelemetryItem(
                        'Volume Output',
                        '${(_activeAudioSource!.volume * 100).toInt()}%',
                        Icons.volume_up_rounded,
                        _activeAudioSource!.color,
                        isDark,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Z-DEPTH DISTANCE & IMMERSION SLIDERS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              children: [
                // Z-Depth Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.straighten_rounded,
                          size: 18,
                          color: Color(0xFFA855F7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jarak Jendela Spatial (Z-Depth)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_zDepthMeters.toStringAsFixed(1)} Meter',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA855F7),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _zDepthMeters,
                  min: 0.6,
                  max: 3.5,
                  divisions: 29,
                  activeColor: const Color(0xFFA855F7),
                  onChanged: (val) {
                    setState(() => _zDepthMeters = val);
                  },
                ),

                const Divider(height: 16),

                // Environment Immersion Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.dark_mode_rounded,
                          size: 18,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tingkat Imersi Lingkungan (Crown)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${(_immersionLevel * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _immersionLevel,
                  min: 0.1,
                  max: 1.0,
                  divisions: 18,
                  activeColor: const Color(0xFF38BDF8),
                  onChanged: (val) {
                    setState(() => _immersionLevel = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. ENVIRONMENT PRESET SWITCHER
          Text(
            'PILIHAN LINGKUNGAN VIRTUAL (SPATIAL SKYBOX)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _EnvironmentPreset.values.map((env) {
                    final isSelected = _selectedEnv == env;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(env.label),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedEnv = env);
                          }
                        },
                        avatar: Icon(
                          env.icon,
                          size: 16,
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFFA855F7),
                        ),
                        selectedColor: const Color(0xFFA855F7),
                        backgroundColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDockIcon(IconData icon, int index, String tooltip) {
    final isSelected = _activeDockIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _activeDockIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : Colors.white60,
        ),
      ),
    );
  }

  Widget _buildTelemetryItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 20,
      color: isDark ? Colors.white12 : Colors.black12,
    );
  }
}

// -------------------------------------------------------------
// RADAR 360 SOUNDSTAGE PAINTER
// -------------------------------------------------------------
class _SpatialSoundstageRadarPainter extends CustomPainter {
  final List<_SpatialAudioSource> sources;
  final _SpatialAudioSource? activeSource;

  _SpatialSoundstageRadarPainter({
    required this.sources,
    required this.activeSource,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 16;

    // 1. Draw Concentric Polar Radar Rings
    final ringPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final r = maxRadius * (i / 3.0);
      canvas.drawCircle(center, r, ringPaint);
    }

    // 2. Crosshair Axis Lines
    final axisPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.1)
          ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx, 10),
      Offset(center.dx, size.height - 10),
      axisPaint,
    );
    canvas.drawLine(
      Offset(10, center.dy),
      Offset(size.width - 10, center.dy),
      axisPaint,
    );

    // Front FOV Cone Arc
    final conePaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFA855F7).withValues(alpha: 0.25),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
          ..style = PaintingStyle.fill;

    final conePath =
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx - maxRadius * 0.7, center.dy - maxRadius * 0.7)
          ..arcToPoint(
            Offset(center.dx + maxRadius * 0.7, center.dy - maxRadius * 0.7),
            radius: Radius.circular(maxRadius),
          )
          ..close();
    canvas.drawPath(conePath, conePaint);

    // 3. Draw Center Listener Node (Head)
    final listenerPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7, listenerPaint);

    // Listener direction nose triangle
    final nosePath =
        Path()
          ..moveTo(center.dx - 4, center.dy - 6)
          ..lineTo(center.dx + 4, center.dy - 6)
          ..lineTo(center.dx, center.dy - 12)
          ..close();
    canvas.drawPath(nosePath, listenerPaint);

    // 4. Draw Audio Sources
    for (final source in sources) {
      final isSelected = activeSource == source;
      final dist = source.distance * maxRadius;
      // angle 0 is front (negative y), angle > 0 is right (positive x)
      final px = center.dx + dist * math.sin(source.angle);
      final py = center.dy - dist * math.cos(source.angle);
      final nodePos = Offset(px, py);

      // Line connecting center to source
      final linePaint =
          Paint()
            ..color = source.color.withValues(alpha: isSelected ? 0.6 : 0.2)
            ..strokeWidth = isSelected ? 1.5 : 1.0;
      canvas.drawLine(center, nodePos, linePaint);

      // Glowing Aura for active source
      if (isSelected) {
        final auraPaint =
            Paint()
              ..color = source.color.withValues(alpha: 0.3)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(nodePos, 16, auraPaint);
      }

      // Main Node Circle
      final nodePaint =
          Paint()
            ..color = source.color
            ..style = PaintingStyle.fill;
      canvas.drawCircle(nodePos, isSelected ? 10 : 7, nodePaint);

      // Outer White Stroke
      final strokePaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;
      canvas.drawCircle(nodePos, isSelected ? 10 : 7, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpatialSoundstageRadarPainter oldDelegate) =>
      true;
}

class _SpatialHorizonGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.06)
          ..strokeWidth = 0.8;

    final horizonY = size.height * 0.65;

    // Horizon line
    canvas.drawLine(Offset(0, horizonY), Offset(size.width, horizonY), paint);

    // Perspective lines receding to horizon center
    final vanishingPoint = Offset(size.width / 2, horizonY);
    for (double x = -size.width; x <= size.width * 2; x += 36) {
      canvas.drawLine(vanishingPoint, Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpatialHorizonGridPainter oldDelegate) => false;
}
