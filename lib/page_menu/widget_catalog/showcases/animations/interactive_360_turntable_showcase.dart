import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _RenderMode {
  solid('Solid Shaded', Icons.view_in_ar_rounded),
  wireframe('Neon Wireframe', Icons.grid_4x4_rounded),
  xray('X-Ray Glass', Icons.blur_on_rounded);

  final String label;
  final IconData icon;
  const _RenderMode(this.label, this.icon);
}

enum _Model3DType {
  visor('Spatial Visor Headset'),
  geosphere('Icosahedron Crystal'),
  tesseract('Hypercube Matrix');

  final String label;
  const _Model3DType(this.label);
}

class _Vec3 {
  final double x, y, z;
  const _Vec3(this.x, this.y, this.z);

  _Vec3 operator +(_Vec3 other) => _Vec3(x + other.x, y + other.y, z + other.z);
  _Vec3 operator -(_Vec3 other) => _Vec3(x - other.x, y - other.y, z - other.z);
  _Vec3 operator *(double s) => _Vec3(x * s, y * s, z * s);

  double dot(_Vec3 other) => x * other.x + y * other.y + z * other.z;

  _Vec3 cross(_Vec3 other) => _Vec3(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  double get length => math.sqrt(x * x + y * y + z * z);

  _Vec3 get normalized {
    final len = length;
    if (len == 0) return const _Vec3(0, 0, 0);
    return _Vec3(x / len, y / len, z / len);
  }

  _Vec3 rotateY(double angle) {
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    return _Vec3(x * cosA + z * sinA, y, -x * sinA + z * cosA);
  }

  _Vec3 rotateX(double angle) {
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    return _Vec3(x, y * cosA - z * sinA, y * sinA + z * cosA);
  }
}

class _Face3D {
  final List<int> vertexIndices;
  final Color baseColor;
  final String? annotation;

  const _Face3D(this.vertexIndices, this.baseColor, [this.annotation]);
}

class Interactive360TurntableShowcase extends StatefulWidget {
  const Interactive360TurntableShowcase({super.key});

  @override
  State<Interactive360TurntableShowcase> createState() =>
      _Interactive360TurntableShowcaseState();
}

class _Interactive360TurntableShowcaseState
    extends State<Interactive360TurntableShowcase>
    with SingleTickerProviderStateMixin {
  // Rotation angles in radians
  double _yaw = 0.45;
  double _pitch = -0.25;

  // Interaction controls
  bool _isAutoSpin = true;
  double _spinSpeed = 1.0;
  double _explodedFactor = 0.0; // 0.0 to 1.0 (disassembly)
  _RenderMode _renderMode = _RenderMode.solid;
  _Model3DType _selectedModel = _Model3DType.visor;

  // Hotspot selection
  int? _selectedHotspotIndex;

  late AnimationController _turntableTicker;

  @override
  void initState() {
    super.initState();
    _turntableTicker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      if (_isAutoSpin) {
        setState(() {
          _yaw += 0.012 * _spinSpeed;
          if (_yaw > math.pi * 2) _yaw -= math.pi * 2;
        });
      }
    });

    _turntableTicker.repeat();
  }

  @override
  void dispose() {
    _turntableTicker.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _yaw += details.delta.dx * 0.01;
      _pitch = (_pitch - details.delta.dy * 0.01).clamp(-1.2, 1.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.threed_rotation_rounded,
                    color: Color(0xFF38BDF8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '360° Spatial Turntable',
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
                        '3D Mesh Shading & Exploded Assembly',
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
                IconButton(
                  tooltip: _isAutoSpin ? 'Pause Auto Spin' : 'Resume Auto Spin',
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _isAutoSpin = !_isAutoSpin);
                  },
                  icon: Icon(
                    _isAutoSpin
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: const Color(0xFF38BDF8),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. 3D TURNTABLE VIEWPORT CANVAS
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: Container(
              height: 270,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 0.85,
                  colors:
                      isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF090D16)]
                          : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Canvas Turntable Painter
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _Turntable3DPainter(
                          yaw: _yaw,
                          pitch: _pitch,
                          exploded: _explodedFactor,
                          renderMode: _renderMode,
                          modelType: _selectedModel,
                          isDark: isDark,
                        ),
                      ),
                    ),

                    // Top Status Tag
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black54 : Colors.white70),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Yaw: ${(_yaw * 180 / math.pi % 360).toInt()}° • Pitch: ${(_pitch * 180 / math.pi).toInt()}°',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Floating Hotspot Annotations
                    Positioned(
                      bottom: 12,
                      left: 14,
                      right: 14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHotspotTag(
                            'Micro-OLED 4K Visor',
                            Icons.remove_red_eye_rounded,
                            isDark,
                          ),
                          _buildHotspotTag(
                            'LiDAR Spatial Sensor',
                            Icons.radar_rounded,
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. MODEL SELECTION & RENDER MODE TABS
          Row(
            children: [
              // Model Selector
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<_Model3DType>(
                      value: _selectedModel,
                      isExpanded: true,
                      dropdownColor:
                          isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      items:
                          _Model3DType.values.map((m) {
                            return DropdownMenuItem(
                              value: m,
                              child: Text(m.label),
                            );
                          }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedModel = val);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Shading Mode Switcher
              Container(
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      _RenderMode.values.map((mode) {
                        final isSel = _renderMode == mode;
                        return IconButton(
                          tooltip: mode.label,
                          icon: Icon(
                            mode.icon,
                            size: 20,
                            color:
                                isSel
                                    ? const Color(0xFF38BDF8)
                                    : (isDark
                                        ? Colors.white54
                                        : Colors.black45),
                          ),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setState(() => _renderMode = mode);
                          },
                        );
                      }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 4. EXPLODED DISASSEMBLY & AUTO SPIN CONTROLS
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
                // Exploded View Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.unfold_more_rounded,
                          size: 18,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Exploded View (Disassembly)',
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
                      '${(_explodedFactor * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _explodedFactor,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  activeColor: const Color(0xFF38BDF8),
                  onChanged: (val) {
                    setState(() => _explodedFactor = val);
                  },
                ),

                const Divider(height: 16),

                // Turntable Speed Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          size: 18,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kecepatan Putar Turntable',
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
                      '${_spinSpeed.toStringAsFixed(1)}x',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _spinSpeed,
                  min: 0.2,
                  max: 3.0,
                  divisions: 14,
                  activeColor: const Color(0xFF10B981),
                  onChanged: (val) {
                    setState(() => _spinSpeed = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotspotTag(String label, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isDark ? Colors.black54 : Colors.white70),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF38BDF8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3D GEOMETRY CANVAS PAINTER WITH PROJECTION & SHADING
// -------------------------------------------------------------
class _Turntable3DPainter extends CustomPainter {
  final double yaw;
  final double pitch;
  final double exploded;
  final _RenderMode renderMode;
  final _Model3DType modelType;
  final bool isDark;

  _Turntable3DPainter({
    required this.yaw,
    required this.pitch,
    required this.exploded,
    required this.renderMode,
    required this.modelType,
    required this.isDark,
  });

  // Directional Key Light Vector
  final _Vec3 _lightDir = const _Vec3(0.5, 0.8, -0.6).normalized;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw Turntable Radial Floor Grid
    _drawTurntableFloor(canvas, center, size);

    // 2. Generate Model Geometry
    final vertices = _getVertices(modelType);
    final faces = _getFaces(modelType);

    // 3. Transform & Project
    const focalLength = 360.0;
    final scale = modelType == _Model3DType.visor ? 85.0 : 95.0;

    // Transform all vertices
    final transformedVertices =
        vertices.map((v) {
          return v.rotateY(yaw).rotateX(pitch);
        }).toList();

    // Compute Face Centers for Z-Sorting & Exploded View Offset
    final faceData = <_TransformedFace>[];

    for (int fIdx = 0; fIdx < faces.length; fIdx++) {
      final face = faces[fIdx];
      _Vec3 faceCenter = const _Vec3(0, 0, 0);
      for (final idx in face.vertexIndices) {
        faceCenter = faceCenter + transformedVertices[idx];
      }
      faceCenter = faceCenter * (1.0 / face.vertexIndices.length);

      // Compute Normal Vector for Shading
      final v0 = transformedVertices[face.vertexIndices[0]];
      final v1 = transformedVertices[face.vertexIndices[1]];
      final v2 = transformedVertices[face.vertexIndices[2]];

      final edge1 = v1 - v0;
      final edge2 = v2 - v0;
      final normal = edge1.cross(edge2).normalized;

      // Exploded translation along normal
      final explodedOffset = normal * (exploded * 0.45);

      // Average Z for Depth-Sorting (Painter's Algorithm)
      final avgZ = faceCenter.z + explodedOffset.z;

      faceData.add(
        _TransformedFace(
          faceIndex: fIdx,
          face: face,
          avgZ: avgZ,
          normal: normal,
          explodedOffset: explodedOffset,
        ),
      );
    }

    // Sort from back to front (Highest Z is furthest away if positive Z into screen)
    faceData.sort((a, b) => a.avgZ.compareTo(b.avgZ));

    // 4. Render Faces
    for (final tf in faceData) {
      final face = tf.face;
      final normal = tf.normal;
      final offset = tf.explodedOffset;

      // Projected 2D Points
      final points2D = <Offset>[];
      for (final idx in face.vertexIndices) {
        final v = transformedVertices[idx] + offset;
        final projZ = focalLength / (focalLength - v.z * scale);
        final px = center.dx + v.x * scale * projZ;
        final py = center.dy + v.y * scale * projZ;
        points2D.add(Offset(px, py));
      }

      final path = Path();
      path.moveTo(points2D[0].dx, points2D[0].dy);
      for (int i = 1; i < points2D.length; i++) {
        path.lineTo(points2D[i].dx, points2D[i].dy);
      }
      path.close();

      // Shading calculation (Lambertian diffuse + ambient)
      final diffuse = math.max(0.0, normal.dot(_lightDir));
      final brightness = 0.35 + diffuse * 0.65;

      Color faceColor = face.baseColor;
      if (renderMode == _RenderMode.solid) {
        final r = (faceColor.r * 255 * brightness).clamp(0, 255).toInt();
        final g = (faceColor.g * 255 * brightness).clamp(0, 255).toInt();
        final b = (faceColor.b * 255 * brightness).clamp(0, 255).toInt();
        final paint =
            Paint()
              ..color = Color.fromARGB(240, r, g, b)
              ..style = PaintingStyle.fill;
        canvas.drawPath(path, paint);

        final strokePaint =
            Paint()
              ..color = Colors.white.withValues(alpha: 0.15)
              ..strokeWidth = 1.0
              ..style = PaintingStyle.stroke;
        canvas.drawPath(path, strokePaint);
      } else if (renderMode == _RenderMode.wireframe) {
        final strokePaint =
            Paint()
              ..color = const Color(0xFF38BDF8)
              ..strokeWidth = 1.5
              ..style = PaintingStyle.stroke;
        canvas.drawPath(path, strokePaint);
      } else if (renderMode == _RenderMode.xray) {
        final paint =
            Paint()
              ..color = faceColor.withValues(alpha: 0.25)
              ..style = PaintingStyle.fill;
        canvas.drawPath(path, paint);

        final strokePaint =
            Paint()
              ..color = const Color(0xFF818CF8).withValues(alpha: 0.6)
              ..strokeWidth = 1.2
              ..style = PaintingStyle.stroke;
        canvas.drawPath(path, strokePaint);
      }
    }
  }

  void _drawTurntableFloor(Canvas canvas, Offset center, Size size) {
    final floorY = center.dy + 85.0;
    final floorPaint =
        Paint()
          ..color = const Color(
            0xFF38BDF8,
          ).withValues(alpha: isDark ? 0.2 : 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Elliptical rings
    for (int r = 1; r <= 3; r++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, floorY),
          width: r * 80.0,
          height: r * 28.0,
        ),
        floorPaint,
      );
    }
  }

  List<_Vec3> _getVertices(_Model3DType type) {
    if (type == _Model3DType.visor) {
      return const [
        // Visor Front Facets
        _Vec3(-1.1, -0.4, 0.6),
        _Vec3(1.1, -0.4, 0.6),
        _Vec3(0.9, 0.4, 0.6),
        _Vec3(-0.9, 0.4, 0.6),
        // Visor Mid Chassis
        _Vec3(-1.2, -0.5, 0.0),
        _Vec3(1.2, -0.5, 0.0),
        _Vec3(1.0, 0.5, 0.0),
        _Vec3(-1.0, 0.5, 0.0),
        // Visor Back Headband Cushion
        _Vec3(-0.9, -0.3, -0.9),
        _Vec3(0.9, -0.3, -0.9),
        _Vec3(0.8, 0.3, -0.9),
        _Vec3(-0.8, 0.3, -0.9),
      ];
    } else if (type == _Model3DType.geosphere) {
      // Regular Octahedron / Crystal
      return const [
        _Vec3(0.0, -1.2, 0.0),
        _Vec3(1.0, 0.0, 0.0),
        _Vec3(0.0, 0.0, 1.0),
        _Vec3(-1.0, 0.0, 0.0),
        _Vec3(0.0, 0.0, -1.0),
        _Vec3(0.0, 1.2, 0.0),
      ];
    } else {
      // Hypercube outer box
      return const [
        _Vec3(-0.7, -0.7, -0.7),
        _Vec3(0.7, -0.7, -0.7),
        _Vec3(0.7, 0.7, -0.7),
        _Vec3(-0.7, 0.7, -0.7),
        _Vec3(-0.7, -0.7, 0.7),
        _Vec3(0.7, -0.7, 0.7),
        _Vec3(0.7, 0.7, 0.7),
        _Vec3(-0.7, 0.7, 0.7),
      ];
    }
  }

  List<_Face3D> _getFaces(_Model3DType type) {
    if (type == _Model3DType.visor) {
      return const [
        _Face3D([0, 1, 2, 3], Color(0xFF1E293B)), // Visor Front Glass
        _Face3D([0, 4, 5, 1], Color(0xFF64748B)), // Top Brow
        _Face3D([3, 2, 6, 7], Color(0xFF475569)), // Bottom Chin
        _Face3D([0, 3, 7, 4], Color(0xFF0EA5E9)), // Left Temple
        _Face3D([1, 5, 6, 2], Color(0xFF0EA5E9)), // Right Temple
        _Face3D([4, 8, 9, 5], Color(0xFF334155)), // Top Strap
        _Face3D([7, 6, 10, 11], Color(0xFF334155)), // Bottom Strap
        _Face3D([8, 11, 10, 9], Color(0xFF0284C7)), // Rear Fit Dial
      ];
    } else if (type == _Model3DType.geosphere) {
      return const [
        _Face3D([0, 1, 2], Color(0xFF8B5CF6)),
        _Face3D([0, 2, 3], Color(0xFF6366F1)),
        _Face3D([0, 3, 4], Color(0xFF3B82F6)),
        _Face3D([0, 4, 1], Color(0xFF06B6D4)),
        _Face3D([5, 2, 1], Color(0xFFEC4899)),
        _Face3D([5, 3, 2], Color(0xFFD946EF)),
        _Face3D([5, 4, 3], Color(0xFFA855F7)),
        _Face3D([5, 1, 4], Color(0xFF3B82F6)),
      ];
    } else {
      return const [
        _Face3D([0, 1, 2, 3], Color(0xFF10B981)), // Back
        _Face3D([4, 5, 6, 7], Color(0xFF059669)), // Front
        _Face3D([0, 4, 7, 3], Color(0xFF34D399)), // Left
        _Face3D([1, 5, 6, 2], Color(0xFF10B981)), // Right
        _Face3D([0, 1, 5, 4], Color(0xFF6EE7B7)), // Top
        _Face3D([3, 2, 6, 7], Color(0xFF047857)), // Bottom
      ];
    }
  }

  @override
  bool shouldRepaint(covariant _Turntable3DPainter oldDelegate) => true;
}

class _TransformedFace {
  final int faceIndex;
  final _Face3D face;
  final double avgZ;
  final _Vec3 normal;
  final _Vec3 explodedOffset;

  _TransformedFace({
    required this.faceIndex,
    required this.face,
    required this.avgZ,
    required this.normal,
    required this.explodedOffset,
  });
}
