import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';

class LuminaProfileView extends StatefulWidget {
  const LuminaProfileView({super.key});

  @override
  State<LuminaProfileView> createState() => _LuminaProfileViewState();
}

class _LuminaProfileViewState extends State<LuminaProfileView> {
  bool _geoFencing = true;
  bool _autoNightMode = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final themeScope = LuminaThemeScope.of(context);
    final theme = themeScope.colors;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Home Settings',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage members, routines & IoT hub',
                style: TextStyle(color: theme.secondaryText, fontSize: 13),
              ),

              const SizedBox(height: 24),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFF59E0B),
                      child: Text(
                        'AM',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Morgan',
                            style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Home Owner • Lumina Prime Member',
                            style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: theme.secondaryText,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Appearance Theme Switcher Tile
              Text(
                'Appearance & Theme',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (theme.isDark
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF6366F1))
                          .withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      theme.isDark
                          ? Icons.nightlight_outlined
                          : Icons.wb_sunny_outlined,
                      color:
                          theme.isDark
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    theme.isDark ? 'Dark Mode (Active)' : 'Light Mode (Active)',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    theme.isDark
                        ? 'Deep slate background'
                        : 'Clean bright appearance',
                    style: TextStyle(color: theme.secondaryText, fontSize: 12),
                  ),
                  activeThumbColor: const Color(0xFFF59E0B),
                  value: theme.isDark,
                  onChanged: (val) => themeScope.onToggleTheme(),
                ),
              ),

              const SizedBox(height: 24),

              // Automated Routines Section
              Text(
                'Smart Routines & Scenarios',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildRoutineCard(
                'Leaving Home Routine',
                'Turns off all ACs, locks doors & arms motion sensors.',
                Icons.directions_walk,
                const Color(0xFF38BDF8),
                theme,
              ),
              _buildRoutineCard(
                'Good Night Routine',
                'Dims lights to 10%, sets AC to 23°C & enables silent mode.',
                Icons.bedtime_outlined,
                const Color(0xFF8B5CF6),
                theme,
              ),
              _buildRoutineCard(
                'Movie Time Scene',
                'Turns TV ON, switches HDMI to Netflix & dims living room lights to amber.',
                Icons.movie_filter_outlined,
                const Color(0xFFF59E0B),
                theme,
              ),

              const SizedBox(height: 24),

              // System Preferences & Toggles
              Text(
                'System Automation',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Geo-fencing Auto Off',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Turn off devices when everyone leaves home',
                        style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      activeThumbColor: const Color(0xFFF59E0B),
                      value: _geoFencing,
                      onChanged: (val) {
                        setState(() {
                          _geoFencing = val;
                        });
                      },
                    ),
                    Divider(color: theme.cardBorder, height: 1),
                    SwitchListTile(
                      title: Text(
                        'Circadian Sleep Lighting',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Warm color shift after 8:00 PM',
                        style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      activeThumbColor: const Color(0xFFF59E0B),
                      value: _autoNightMode,
                      onChanged: (val) {
                        setState(() {
                          _autoNightMode = val;
                        });
                      },
                    ),
                    Divider(color: theme.cardBorder, height: 1),
                    SwitchListTile(
                      title: Text(
                        'Push Notifications',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Device alerts & high power warnings',
                        style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      activeThumbColor: const Color(0xFFF59E0B),
                      value: _notifications,
                      onChanged: (val) {
                        setState(() {
                          _notifications = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Hub Connectivity Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.hub_outlined,
                          color: Color(0xFF10B981),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lumina Bridge Hub v2.4',
                              style: TextStyle(
                                color: theme.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Matter 1.3 • Zigbee 3.0 Online',
                              style: TextStyle(
                                color: theme.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Connected',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineCard(
    String title,
    String desc,
    IconData icon,
    Color color,
    LuminaThemeColors theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          if (!theme.isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(color: theme.secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.play_circle_fill,
              color: theme.secondaryText,
              size: 28,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Triggering "$title"...'),
                  backgroundColor: const Color(0xFF2A2D3A),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
