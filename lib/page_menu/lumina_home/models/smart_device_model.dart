import 'package:flutter/material.dart';

enum DeviceType {
  light,
  ac,
  tv,
  router,
  generic,
}

class SmartDeviceModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final DeviceType type;
  bool isPoweredOn;
  final Color activeColor;
  
  // Specific device attributes
  double brightness; // 0.0 - 100.0 (For Light)
  Color lightColor; // (For Light)
  double targetTemperature; // (For AC)
  String acMode; // Cool, Eco, Dry, Turbo (For AC)
  String fanSpeed; // Low, Mid, High, Auto (For AC)
  int volume; // 0 - 100 (For TV)
  bool isMuted; // (For TV)
  String activeSource; // HDMI 1, Netflix, YouTube, Spotify (For TV)
  int connectedClients; // (For Router)
  double downloadSpeed; // Mbps (For Router)
  double uploadSpeed; // Mbps (For Router)

  SmartDeviceModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
    this.isPoweredOn = false,
    required this.activeColor,
    this.brightness = 80.0,
    this.lightColor = const Color(0xFFF59E0B),
    this.targetTemperature = 22.0,
    this.acMode = 'Cool',
    this.fanSpeed = 'Auto',
    this.volume = 35,
    this.isMuted = false,
    this.activeSource = 'Netflix',
    this.connectedClients = 8,
    this.downloadSpeed = 124.5,
    this.uploadSpeed = 48.2,
  });
}
