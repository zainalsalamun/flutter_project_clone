import 'package:flutter/material.dart';
import 'models/room_model.dart';
import 'models/smart_device_model.dart';
import 'theme/lumina_theme.dart';
import 'views/lumina_dashboard_view.dart';
import 'views/lumina_stats_view.dart';
import 'views/lumina_voice_view.dart';
import 'views/lumina_profile_view.dart';

class LuminaHomePage extends StatefulWidget {
  const LuminaHomePage({super.key});

  @override
  State<LuminaHomePage> createState() => _LuminaHomePageState();
}

class _LuminaHomePageState extends State<LuminaHomePage> {
  int _currentTabIndex = 0;
  bool _isDarkMode = true;
  late List<RoomModel> _rooms;

  @override
  void initState() {
    super.initState();
    _initRoomData();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _initRoomData() {
    _rooms = [
      // 1. Living Room
      RoomModel(
        id: 'living_room',
        name: 'Living Room',
        icon: Icons.weekend_outlined,
        temperature: 24.0,
        humidity: 45,
        powerUsageKwh: 1.8,
        isMasterPowered: true,
        devices: [
          SmartDeviceModel(
            id: 'lr_light',
            title: 'Ambient Ceiling',
            subtitle: 'Living Room',
            icon: Icons.lightbulb_outline,
            type: DeviceType.light,
            activeColor: const Color(0xFFF59E0B),
            lightColor: const Color(0xFFF59E0B),
            brightness: 85,
            isPoweredOn: true,
          ),
          SmartDeviceModel(
            id: 'lr_ac',
            title: 'Air Conditioner',
            subtitle: '24°C Auto',
            icon: Icons.ac_unit,
            type: DeviceType.ac,
            activeColor: const Color(0xFF3B82F6),
            targetTemperature: 24.0,
            acMode: 'Cool',
            fanSpeed: 'Auto',
            isPoweredOn: true,
          ),
          SmartDeviceModel(
            id: 'lr_tv',
            title: 'Smart TV 4K',
            subtitle: 'Samsung QLED',
            icon: Icons.tv,
            type: DeviceType.tv,
            activeColor: const Color(0xFF8B5CF6),
            volume: 40,
            activeSource: 'Netflix',
            isPoweredOn: true,
          ),
          SmartDeviceModel(
            id: 'lr_router',
            title: 'Wi-Fi 6 Router',
            subtitle: 'Online',
            icon: Icons.router,
            type: DeviceType.router,
            activeColor: const Color(0xFF10B981),
            connectedClients: 12,
            downloadSpeed: 145.0,
            uploadSpeed: 52.4,
            isPoweredOn: true,
          ),
        ],
      ),

      // 2. Master Bedroom
      RoomModel(
        id: 'master_bedroom',
        name: 'Bedroom',
        icon: Icons.bed_outlined,
        temperature: 22.0,
        humidity: 50,
        powerUsageKwh: 1.2,
        isMasterPowered: true,
        devices: [
          SmartDeviceModel(
            id: 'br_light',
            title: 'Nightstand Lamp',
            subtitle: 'Warm Sleep',
            icon: Icons.lightbulb_outline,
            type: DeviceType.light,
            activeColor: const Color(0xFFFEF3C7),
            lightColor: const Color(0xFFFEF3C7),
            brightness: 30,
            isPoweredOn: true,
          ),
          SmartDeviceModel(
            id: 'br_ac',
            title: 'Bedroom AC',
            subtitle: '22°C Quiet',
            icon: Icons.ac_unit,
            type: DeviceType.ac,
            activeColor: const Color(0xFF3B82F6),
            targetTemperature: 22.0,
            acMode: 'Eco',
            fanSpeed: 'Quiet',
            isPoweredOn: true,
          ),
          SmartDeviceModel(
            id: 'br_air_purifier',
            title: 'Air Purifier',
            subtitle: 'Air Quality: Good',
            icon: Icons.air,
            type: DeviceType.generic,
            activeColor: const Color(0xFF10B981),
            isPoweredOn: true,
          ),
        ],
      ),

      // 3. Kitchen & Dining
      RoomModel(
        id: 'kitchen',
        name: 'Kitchen',
        icon: Icons.kitchen_outlined,
        temperature: 26.5,
        humidity: 58,
        powerUsageKwh: 2.4,
        isMasterPowered: false,
        devices: [
          SmartDeviceModel(
            id: 'kit_light',
            title: 'Island Spotlights',
            subtitle: 'Cool White',
            icon: Icons.lightbulb_outline,
            type: DeviceType.light,
            activeColor: const Color(0xFFE0F2FE),
            lightColor: const Color(0xFFE0F2FE),
            brightness: 100,
            isPoweredOn: false,
          ),
          SmartDeviceModel(
            id: 'kit_coffee',
            title: 'Smart Espresso',
            subtitle: 'Standby',
            icon: Icons.coffee_maker_outlined,
            type: DeviceType.generic,
            activeColor: const Color(0xFFD97706),
            isPoweredOn: false,
          ),
          SmartDeviceModel(
            id: 'kit_fridge',
            title: 'Smart Refrigerator',
            subtitle: '4°C / -18°C',
            icon: Icons.kitchen,
            type: DeviceType.generic,
            activeColor: const Color(0xFF0284C7),
            isPoweredOn: true,
          ),
        ],
      ),

      // 4. Home Office / Studio
      RoomModel(
        id: 'office',
        name: 'Office',
        icon: Icons.desktop_windows_outlined,
        temperature: 23.5,
        humidity: 42,
        powerUsageKwh: 0.9,
        isMasterPowered: true,
        devices: [
          SmartDeviceModel(
            id: 'off_strip',
            title: 'Desk Neon Bar',
            subtitle: 'Cyber Glow',
            icon: Icons.lightbulb_outline,
            type: DeviceType.light,
            activeColor: const Color(0xFFA855F7),
            lightColor: const Color(0xFFA855F7),
            brightness: 75,
            isPoweredOn: true,
          ),
          SmartDeviceModel(
            id: 'off_monitor',
            title: 'Studio Display',
            subtitle: 'Dual Setup',
            icon: Icons.desktop_mac_outlined,
            type: DeviceType.generic,
            activeColor: const Color(0xFF38BDF8),
            isPoweredOn: true,
          ),
        ],
      ),
    ];
  }

  void _handleVoiceCommand(String command) {
    final lower = command.toLowerCase();
    setState(() {
      if (lower.contains('turn off everything') || lower.contains('good night')) {
        for (var room in _rooms) {
          room.isMasterPowered = false;
          for (var device in room.devices) {
            device.isPoweredOn = false;
          }
        }
      } else if (lower.contains('turn on') || lower.contains('lights')) {
        for (var room in _rooms) {
          for (var device in room.devices) {
            if (device.type == DeviceType.light) {
              device.isPoweredOn = true;
            }
          }
        }
      } else if (lower.contains('22')) {
        for (var room in _rooms) {
          for (var device in room.devices) {
            if (device.type == DeviceType.ac) {
              device.targetTemperature = 22.0;
              device.isPoweredOn = true;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = _isDarkMode ? LuminaThemeColors.dark : LuminaThemeColors.light;

    final List<Widget> views = [
      LuminaDashboardView(
        rooms: _rooms,
        onVoiceCommand: _handleVoiceCommand,
      ),
      const LuminaStatsView(),
      LuminaVoiceView(
        onExecuteCommand: _handleVoiceCommand,
      ),
      const LuminaProfileView(),
    ];

    return LuminaThemeScope(
      colors: themeColors,
      isDark: _isDarkMode,
      onToggleTheme: _toggleTheme,
      child: Scaffold(
        backgroundColor: themeColors.background,
        body: IndexedStack(
          index: _currentTabIndex,
          children: views,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: themeColors.navBarBackground,
            border: Border(
              top: BorderSide(color: themeColors.navBarBorder, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: themeColors.navBarBackground,
            selectedItemColor: const Color(0xFFF59E0B),
            unselectedItemColor: themeColors.inactiveIcon,
            currentIndex: _currentTabIndex,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mic_none_rounded),
                label: 'Voice AI',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
