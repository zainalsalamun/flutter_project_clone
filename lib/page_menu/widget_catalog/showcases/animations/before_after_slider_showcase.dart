import 'package:flutter/material.dart';

class BeforeAfterSliderShowcase extends StatefulWidget {
  const BeforeAfterSliderShowcase({super.key});

  @override
  State<BeforeAfterSliderShowcase> createState() =>
      _BeforeAfterSliderShowcaseState();
}

class _BeforeAfterSliderShowcaseState extends State<BeforeAfterSliderShowcase>
    with SingleTickerProviderStateMixin {
  double _sliderPosition = 0.5; // Range 0.0 to 1.0
  int _selectedThemeIndex = 0;
  bool _isAutoScanning = false;
  late AnimationController _scanController;

  final List<_ComparisonTheme> _themes = [
    _ComparisonTheme(
      title: 'Sunset Color Grade',
      subtitle: 'Flat RAW vs Cinematic Grade',
      beforeColor1: const Color(0xFF64748B),
      beforeColor2: const Color(0xFF94A3B8),
      afterColor1: const Color(0xFFF97316),
      afterColor2: const Color(0xFF9333EA),
      icon: Icons.filter_hdr_rounded,
      beforeLabel: 'RAW / Asli',
      afterLabel: 'Graded / Edit',
    ),
    _ComparisonTheme(
      title: 'Day vs Cyberpunk Night',
      subtitle: 'Siang Terang vs Gemerlap Neon',
      beforeColor1: const Color(0xFF38BDF8),
      beforeColor2: const Color(0xFFFDE047),
      afterColor1: const Color(0xFF0F172A),
      afterColor2: const Color(0xFFEC4899),
      icon: Icons.nightlight_round,
      beforeLabel: 'Siang',
      afterLabel: 'Malam Neon',
    ),
    _ComparisonTheme(
      title: 'Blueprint vs Render 3D',
      subtitle: 'Sketsa Garis vs Visualisasi Realis',
      beforeColor1: const Color(0xFF1E3A8A),
      beforeColor2: const Color(0xFF3B82F6),
      afterColor1: const Color(0xFF10B981),
      afterColor2: const Color(0xFF064E3B),
      icon: Icons.architecture_rounded,
      beforeLabel: 'Blueprint',
      afterLabel: '3D Render',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      if (_isAutoScanning) {
        setState(() {
          _sliderPosition = _scanController.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _toggleAutoScan() {
    setState(() {
      _isAutoScanning = !_isAutoScanning;
      if (_isAutoScanning) {
        _scanController.repeat(reverse: true);
      } else {
        _scanController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_selectedThemeIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Comparison Lens Card Container
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                return GestureDetector(
                  onPanUpdate: (details) {
                    if (_isAutoScanning) {
                      setState(() => _isAutoScanning = false);
                      _scanController.stop();
                    }
                    setState(() {
                      _sliderPosition = (details.localPosition.dx / width)
                          .clamp(0.0, 1.0);
                    });
                  },
                  child: Stack(
                    children: [
                      // 1. BEFORE LAYER (Full Canvas Background)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [theme.beforeColor1, theme.beforeColor2],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Opacity(
                                  opacity: 0.18,
                                  child: Icon(
                                    theme.icon,
                                    size: 110,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 14,
                                left: 14,
                                child: _buildGlassBadge(theme.beforeLabel),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 2. AFTER LAYER (Clipped by slider position)
                      Positioned.fill(
                        child: ClipRect(
                          clipper: _HorizontalSplitClipper(
                            splitPosition: _sliderPosition,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [theme.afterColor1, theme.afterColor2],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Opacity(
                                    opacity: 0.28,
                                    child: Icon(
                                      theme.icon,
                                      size: 110,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 14,
                                  right: 14,
                                  child: _buildGlassBadge(theme.afterLabel),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 3. DIVIDER LINE
                      Positioned(
                        left: (width * _sliderPosition) - 1.5,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 4. DRAGGABLE HANDLE THUMB
                      Positioned(
                        left: (width * _sliderPosition) - 20,
                        top: (height / 2) - 20,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_left_rounded,
                                  size: 18,
                                  color: Color(0xFF334155),
                                ),
                                Icon(
                                  Icons.arrow_right_rounded,
                                  size: 18,
                                  color: Color(0xFF334155),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Quick Position & Auto-Scan Controls
        Row(
          children: [
            // Quick jump percentage buttons
            Expanded(
              child: Row(
                children: [
                  _buildQuickPosButton('25%', 0.25),
                  const SizedBox(width: 6),
                  _buildQuickPosButton('50%', 0.50),
                  const SizedBox(width: 6),
                  _buildQuickPosButton('75%', 0.75),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Auto Scan Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isAutoScanning
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                visualDensity: VisualDensity.compact,
              ),
              icon: Icon(
                _isAutoScanning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 16,
              ),
              label: Text(
                _isAutoScanning ? 'Stop Scan' : 'Auto Scan',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _toggleAutoScan,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Theme Preset Switcher
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Contoh Objek Komparasi:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: List.generate(_themes.length, (index) {
                  final t = _themes[index];
                  final isSelected = _selectedThemeIndex == index;
                  return ChoiceChip(
                    avatar: Icon(
                      t.icon,
                      size: 14,
                      color:
                          isSelected ? Colors.white : const Color(0xFF6366F1),
                    ),
                    label: Text(t.title),
                    selected: isSelected,
                    selectedColor: const Color(0xFF6366F1),
                    labelStyle: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedThemeIndex = index);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildQuickPosButton(String label, double position) {
    final isSelected =
        (_sliderPosition - position).abs() < 0.05 && !_isAutoScanning;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (_isAutoScanning) {
            setState(() => _isAutoScanning = false);
            _scanController.stop();
          }
          setState(() => _sliderPosition = position);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color:
                    isSelected ? const Color(0xFF6366F1) : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ComparisonTheme {
  final String title;
  final String subtitle;
  final Color beforeColor1;
  final Color beforeColor2;
  final Color afterColor1;
  final Color afterColor2;
  final IconData icon;
  final String beforeLabel;
  final String afterLabel;

  _ComparisonTheme({
    required this.title,
    required this.subtitle,
    required this.beforeColor1,
    required this.beforeColor2,
    required this.afterColor1,
    required this.afterColor2,
    required this.icon,
    required this.beforeLabel,
    required this.afterLabel,
  });
}

class _HorizontalSplitClipper extends CustomClipper<Rect> {
  final double splitPosition; // 0.0 to 1.0

  _HorizontalSplitClipper({required this.splitPosition});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      size.width * splitPosition,
      0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant _HorizontalSplitClipper oldClipper) {
    return oldClipper.splitPosition != splitPosition;
  }
}
