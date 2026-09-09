import 'package:flutter/material.dart';
import 'smart_device_model.dart';

class RoomModel {
  final String id;
  final String name;
  final IconData icon;
  double temperature;
  int humidity;
  double powerUsageKwh;
  bool isMasterPowered;
  List<SmartDeviceModel> devices;

  RoomModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.temperature,
    required this.humidity,
    required this.powerUsageKwh,
    this.isMasterPowered = true,
    required this.devices,
  });
}
