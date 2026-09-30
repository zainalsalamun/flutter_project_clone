import 'package:flutter/material.dart';

class DeviceFrameMockupShowcase extends StatefulWidget {
  const DeviceFrameMockupShowcase({super.key});

  @override
  State<DeviceFrameMockupShowcase> createState() =>
      _DeviceFrameMockupShowcaseState();
}

class _DeviceFrameMockupShowcaseState extends State<DeviceFrameMockupShowcase> {
  int _deviceType = 0; // 0: iPhone (Dynamic Island), 1: Android (Punch Hole)
  int _frameColorIndex = 0; // 0: Titanium Dark, 1: Silver, 2: Deep Purple

  bool _inAppDarkMode = true;
  bool _isFollowing = false;
  int _followCount = 2480;

  final List<Color> _chassisColors = [
    const Color(0xFF1E293B), // Dark Titanium
    const Color(0xFF94A3B8), // Natural Silver
    const Color(0xFF581C87), // Deep Purple
  ];

  @override
  Widget build(BuildContext context) {
    final chassisColor = _chassisColors[_frameColorIndex];
    final isIPhone = _deviceType == 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. DEVICE FRAME STAGE ----------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SizedBox(
            width: 240,
            height: 380,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Left Hardware Buttons (Volume Up/Down)
                Positioned(
                  left: -3,
                  top: 70,
                  child: Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: chassisColor.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -3,
                  top: 102,
                  child: Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: chassisColor.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(2),
                      ),
                    ),
                  ),
                ),

                // Right Hardware Button (Power)
                Positioned(
                  right: -3,
                  top: 85,
                  child: Container(
                    width: 3,
                    height: 34,
                    decoration: BoxDecoration(
                      color: chassisColor.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(2),
                      ),
                    ),
                  ),
                ),

                // Outer Smartphone Chassis Body
                Container(
                  decoration: BoxDecoration(
                    color: chassisColor,
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      color:
                          _inAppDarkMode
                              ? const Color(0xFF090D16)
                              : const Color(0xFFF8FAFC),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top Status Bar Area & Dynamic Island / Punch Hole
                          Container(
                            padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '09:41',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _inAppDarkMode
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                  ),
                                ),

                                // Notch / Island
                                if (isIPhone)
                                  Container(
                                    width: 60,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                          ),
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1E293B),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 6,
                                          ),
                                          child: Container(
                                            width: 4,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF10B981),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.signal_cellular_alt_rounded,
                                      size: 11,
                                      color:
                                          _inAppDarkMode
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      Icons.wifi_rounded,
                                      size: 11,
                                      color:
                                          _inAppDarkMode
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      Icons.battery_full_rounded,
                                      size: 12,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Embedded Live Mini App Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // User Avatar & Name
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: const Color(
                                          0xFF6366F1,
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Zainal Salamun',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _inAppDarkMode
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text(
                                        'Senior Mobile Engineer',
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          color:
                                              _inAppDarkMode
                                                  ? Colors.white54
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // In-Screen Stat Badges
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildInScreenStat(
                                        '$_followCount',
                                        'Followers',
                                      ),
                                      _buildInScreenStat('48', 'Projects'),
                                      _buildInScreenStat('4.9*', 'Rating'),
                                    ],
                                  ),

                                  // In-Screen Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 24,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  _isFollowing
                                                      ? const Color(0xFF10B981)
                                                      : const Color(0xFF6366F1),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isFollowing = !_isFollowing;
                                                _followCount +=
                                                    _isFollowing ? 1 : -1;
                                              });
                                            },
                                            child: Text(
                                              _isFollowing
                                                  ? 'Following [v]'
                                                  : 'Follow +',
                                              style: const TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        onTap: () {
                                          setState(
                                            () =>
                                                _inAppDarkMode =
                                                    !_inAppDarkMode,
                                          );
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color:
                                                _inAppDarkMode
                                                    ? Colors.white.withValues(
                                                      alpha: 0.12,
                                                    )
                                                    : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Icon(
                                            _inAppDarkMode
                                                ? Icons.wb_sunny_rounded
                                                : Icons.nightlight_round,
                                            size: 13,
                                            color:
                                                _inAppDarkMode
                                                    ? Colors.amber
                                                    : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom Home Indicator Bar
                          Container(
                            padding: const EdgeInsets.only(bottom: 6),
                            alignment: Alignment.center,
                            child: Container(
                              width: 65,
                              height: 3.5,
                              decoration: BoxDecoration(
                                color:
                                    _inAppDarkMode
                                        ? Colors.white.withValues(alpha: 0.4)
                                        : Colors.black26,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. CONTROLS BAR ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Tipe Mockup Perangkat:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPresetButton(0, 'iPhone 16 Pro', Icons.apple),
                      const SizedBox(width: 4),
                      _buildPresetButton(1, 'Android Flagship', Icons.android),
                    ],
                  ),
                ],
              ),
              const Divider(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Warna Frame Chassis:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_chassisColors.length, (idx) {
                      final isSel = _frameColorIndex == idx;
                      return GestureDetector(
                        onTap: () => setState(() => _frameColorIndex = idx),
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _chassisColors[idx],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSel
                                      ? const Color(0xFF6366F1)
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButton(int index, String label, IconData icon) {
    final isSelected = _deviceType == index;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _deviceType = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInScreenStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: _inAppDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 7.5,
            color: _inAppDarkMode ? Colors.white38 : Colors.grey,
          ),
        ),
      ],
    );
  }
}
