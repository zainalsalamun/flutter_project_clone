import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoryCameraFilterWheelShowcase extends StatefulWidget {
  const StoryCameraFilterWheelShowcase({super.key});

  @override
  State<StoryCameraFilterWheelShowcase> createState() =>
      _StoryCameraFilterWheelShowcaseState();
}

class _CameraFilter {
  final String id;
  final String name;
  final String icon;
  final Color tintColor;
  final BlendMode blendMode;

  const _CameraFilter({
    required this.id,
    required this.name,
    required this.icon,
    required this.tintColor,
    required this.blendMode,
  });
}

class _StoryCameraFilterWheelShowcaseState
    extends State<StoryCameraFilterWheelShowcase> {
  final List<_CameraFilter> _filters = const [
    _CameraFilter(
      id: 'normal',
      name: 'Normal',
      icon: '',
      tintColor: Colors.transparent,
      blendMode: BlendMode.srcOver,
    ),
    _CameraFilter(
      id: 'cyberpunk',
      name: 'Cyberpunk',
      icon: '',
      tintColor: Color(0x66FF007F),
      blendMode: BlendMode.color,
    ),
    _CameraFilter(
      id: 'golden',
      name: 'Golden Hour',
      icon: '',
      tintColor: Color(0x55F59E0B),
      blendMode: BlendMode.softLight,
    ),
    _CameraFilter(
      id: 'vintage',
      name: 'Vintage 90s',
      icon: '',
      tintColor: Color(0x6678350F),
      blendMode: BlendMode.colorBurn,
    ),
    _CameraFilter(
      id: 'noir',
      name: 'Noir B&W',
      icon: '',
      tintColor: Color(0x88000000),
      blendMode: BlendMode.saturation,
    ),
  ];

  int _selectedFilterIndex = 0;
  bool _isFlashOn = false;
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  // Flash animation trigger
  bool _showFlashScreen = false;
  bool _isFrontCamera = true;

  @override
  void dispose() {
    _recordTimer?.cancel();
    super.dispose();
  }

  void _onFilterSelected(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFilterIndex = index;
    });
  }

  void _takePhoto() {
    HapticFeedback.heavyImpact();
    setState(() {
      _showFlashScreen = true;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() {
          _showFlashScreen = false;
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(
              Icons.photo_camera_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Foto berhasil diambil dengan filter ${_filters[_selectedFilterIndex].name}!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startRecording() {
    HapticFeedback.heavyImpact();
    _recordTimer?.cancel();
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordSeconds++;
          if (_recordSeconds >= 10) {
            _stopRecording();
          }
        });
      }
    });
  }

  void _stopRecording() {
    _recordTimer?.cancel();
    if (!_isRecording) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text('Video direkam selama $_recordSeconds detik!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeFilter = _filters[_selectedFilterIndex];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        width: 280,
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white12, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // 1. CAMERA PREVIEW SCENERY BACKGROUND
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Simulated Subject / Portrait Silhouette
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                              border: Border.all(
                                color: Colors.white24,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _isFrontCamera
                                    ? Icons.face_rounded
                                    : Icons.landscape_rounded,
                                size: 54,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isFrontCamera ? 'Front Camera' : 'Back Camera',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. FILTER SHADER TINT OVERLAY
              if (activeFilter.tintColor != Colors.transparent)
                Positioned.fill(
                  child: Container(color: activeFilter.tintColor),
                ),

              // 3. FLASH EFFECT WHITE SCREEN
              if (_showFlashScreen)
                Positioned.fill(child: Container(color: Colors.white)),

              // 4. TOP CONTROLS (FLASH, FLIP, REC TIMER)
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
                      icon: Icon(
                        _isFlashOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        color: _isFlashOn ? Colors.amber : Colors.white70,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black45,
                      ),
                    ),
                    if (_isRecording)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'REC 00:0$_recordSeconds',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    IconButton(
                      onPressed:
                          () =>
                              setState(() => _isFrontCamera = !_isFrontCamera),
                      icon: const Icon(
                        Icons.flip_camera_ios_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              // 5. BOTTOM SHUTTER & FILTER WHEEL
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FILTER NAME LABEL
                    Text(
                      activeFilter.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // FILTER SELECTOR WHEEL
                    SizedBox(
                      height: 70,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _filters.length,
                          itemBuilder: (context, index) {
                            final filter = _filters[index];
                            final isSelected = _selectedFilterIndex == index;

                            return GestureDetector(
                              onTap: () => _onFilterSelected(index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: isSelected ? 52 : 38,
                                    height: isSelected ? 52 : 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          isSelected
                                              ? Colors.white24
                                              : Colors.black45,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? const Color(0xFFEC4899)
                                                : Colors.white30,
                                        width: isSelected ? 3 : 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        filter.icon,
                                        style: TextStyle(
                                          fontSize: isSelected ? 20 : 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // MAIN SHUTTER BUTTON (TAP: PHOTO, HOLD: VIDEO)
                    GestureDetector(
                      onTap: _takePhoto,
                      onLongPressStart: (_) => _startRecording(),
                      onLongPressEnd: (_) => _stopRecording(),
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                _isRecording
                                    ? const Color(0xFFEF4444)
                                    : Colors.white,
                            width: 4,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isRecording
                                    ? const Color(0xFFEF4444)
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
