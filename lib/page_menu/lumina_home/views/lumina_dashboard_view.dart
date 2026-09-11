import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../models/smart_device_model.dart';
import '../theme/lumina_theme.dart';
import '../widgets/room_tab_bar.dart';
import '../widgets/room_thermostat_card.dart';
import '../widgets/smart_device_card.dart';

class LuminaDashboardView extends StatefulWidget {
  final List<RoomModel> rooms;
  final Function(String command) onVoiceCommand;

  const LuminaDashboardView({
    super.key,
    required this.rooms,
    required this.onVoiceCommand,
  });

  @override
  State<LuminaDashboardView> createState() => _LuminaDashboardViewState();
}

class _LuminaDashboardViewState extends State<LuminaDashboardView> {
  int _selectedRoomIndex = 0;

  void _toggleMasterPower(RoomModel room) {
    setState(() {
      room.isMasterPowered = !room.isMasterPowered;
      for (var device in room.devices) {
        device.isPoweredOn = room.isMasterPowered;
      }
    });
  }

  void _increaseTemp(RoomModel room) {
    if (room.temperature < 32.0) {
      setState(() {
        room.temperature += 0.5;
      });
    }
  }

  void _decreaseTemp(RoomModel room) {
    if (room.temperature > 16.0) {
      setState(() {
        room.temperature -= 0.5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeScope = LuminaThemeScope.of(context);
    final theme = themeScope.colors;
    final activeRoom = widget.rooms[_selectedRoomIndex];

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header: User & Status & Quick Theme Toggle
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Home,',
                          style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Zainal Salamun',
                          style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Theme Toggle Button (Light/Dark Mode)
                        GestureDetector(
                          onTap: themeScope.onToggleTheme,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.cardBackground,
                              borderRadius: BorderRadius.circular(16),
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
                            child: Icon(
                              themeScope.isDark
                                  ? Icons.wb_sunny_outlined
                                  : Icons.nightlight_outlined,
                              color:
                                  themeScope.isDark
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF6366F1),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Notification Button
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.cardBackground,
                            borderRadius: BorderRadius.circular(16),
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
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: theme.secondaryText,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFF59E0B),
                          child: Text(
                            'AM',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Room Selector Tab Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoomTabBar(
                  rooms: widget.rooms,
                  selectedIndex: _selectedRoomIndex,
                  onRoomSelected: (idx) {
                    setState(() {
                      _selectedRoomIndex = idx;
                    });
                  },
                ),
              ),
            ),

            // Thermostat & Master Control Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: RoomThermostatCard(
                  room: activeRoom,
                  onToggleMasterPower: () => _toggleMasterPower(activeRoom),
                  onIncreaseTemp: () => _increaseTemp(activeRoom),
                  onDecreaseTemp: () => _decreaseTemp(activeRoom),
                ),
              ),
            ),

            // Section Header: Devices & Quick Add
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${activeRoom.name} Devices',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showAddDeviceDialog(context, activeRoom);
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFFF59E0B),
                      ),
                      label: const Text(
                        'Add Device',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Smart Devices Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final device = activeRoom.devices[index];
                  return SmartDeviceCard(
                    device: device,
                    onToggle: () {
                      setState(() {
                        device.isPoweredOn = !device.isPoweredOn;
                        if (activeRoom.devices.any((d) => d.isPoweredOn)) {
                          activeRoom.isMasterPowered = true;
                        }
                      });
                    },
                    onUpdate: () {
                      setState(() {});
                    },
                  );
                }, childCount: activeRoom.devices.length),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context, RoomModel room) {
    final theme = LuminaThemeScope.of(context).colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.modalBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pair New Smart Device',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scanning for nearby Matter / Zigbee IoT accessories...',
                style: TextStyle(color: theme.secondaryText, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.pillBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.lightbulb, color: Color(0xFFF59E0B)),
                ),
                title: Text(
                  'Lumina RGB Smart Strip',
                  style: TextStyle(color: theme.primaryText),
                ),
                subtitle: Text(
                  'Living Room • Ready to pair',
                  style: TextStyle(color: theme.secondaryText, fontSize: 12),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      room.devices.add(
                        SmartDeviceModel(
                          id:
                              'rgb_strip_${DateTime.now().millisecondsSinceEpoch}',
                          title: 'RGB Light Strip',
                          subtitle: 'Cabinet Mood',
                          icon: Icons.lightbulb,
                          type: DeviceType.light,
                          activeColor: const Color(0xFFEC4899),
                          lightColor: const Color(0xFFEC4899),
                          isPoweredOn: true,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Pair'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
