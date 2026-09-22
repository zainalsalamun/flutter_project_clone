import 'package:equatable/equatable.dart';
import '../models/device_diagnostics_event.dart';
import '../models/display_and_sensors_data.dart';
import '../models/user_device_diagnostics_entity.dart';
import '../services/network_connectivity_service.dart';

enum DiagnosticsStatus { initial, loading, success, failure }

class DiagnosticsBlocState extends Equatable {
  final DiagnosticsStatus status;
  final DeviceDiagnosticsEvent? currentEvent;
  final UserDeviceDiagnosticsEntity? dbEntity;
  final NetworkInfoData networkInfo;
  final DisplaySpecsData displaySpecs;
  final SensorsCatalogData sensorsCatalog;
  final bool isTestingPing;
  final bool isDeviceIdMasked;
  final String? errorMessage;
  final String? successMessage;
  final String osVersion;
  final String osBuild;
  final bool isRooted;
  final bool isDeveloperMode;
  final bool isMockLocation;
  final bool isEmulator;
  final bool hasBiometricHardware;
  final bool isBiometricEnrolled;
  final bool isVpnActive;
  final int captureCount;

  const DiagnosticsBlocState({
    required this.status,
    this.currentEvent,
    this.dbEntity,
    required this.networkInfo,
    required this.displaySpecs,
    required this.sensorsCatalog,
    this.isTestingPing = false,
    this.isDeviceIdMasked = true,
    this.errorMessage,
    this.successMessage,
    this.osVersion = "",
    this.osBuild = "",
    this.isRooted = false,
    this.isDeveloperMode = false,
    this.isMockLocation = false,
    this.isEmulator = false,
    this.hasBiometricHardware = true,
    this.isBiometricEnrolled = true,
    this.isVpnActive = false,
    this.captureCount = 0,
  });

  factory DiagnosticsBlocState.initial() {
    return DiagnosticsBlocState(
      status: DiagnosticsStatus.initial,
      currentEvent: null,
      dbEntity: null,
      networkInfo: NetworkInfoData.initial(),
      displaySpecs: DisplaySpecsData.initial(),
      sensorsCatalog: SensorsCatalogData.initial(),
      isDeviceIdMasked: true,
    );
  }

  DiagnosticsBlocState copyWith({
    DiagnosticsStatus? status,
    DeviceDiagnosticsEvent? currentEvent,
    UserDeviceDiagnosticsEntity? dbEntity,
    NetworkInfoData? networkInfo,
    DisplaySpecsData? displaySpecs,
    SensorsCatalogData? sensorsCatalog,
    bool? isTestingPing,
    bool? isDeviceIdMasked,
    String? errorMessage,
    String? successMessage,
    String? osVersion,
    String? osBuild,
    bool? isRooted,
    bool? isDeveloperMode,
    bool? isMockLocation,
    bool? isEmulator,
    bool? hasBiometricHardware,
    bool? isBiometricEnrolled,
    bool? isVpnActive,
    int? captureCount,
  }) {
    return DiagnosticsBlocState(
      status: status ?? this.status,
      currentEvent: currentEvent ?? this.currentEvent,
      dbEntity: dbEntity ?? this.dbEntity,
      networkInfo: networkInfo ?? this.networkInfo,
      displaySpecs: displaySpecs ?? this.displaySpecs,
      sensorsCatalog: sensorsCatalog ?? this.sensorsCatalog,
      isTestingPing: isTestingPing ?? this.isTestingPing,
      isDeviceIdMasked: isDeviceIdMasked ?? this.isDeviceIdMasked,
      errorMessage: errorMessage,
      successMessage: successMessage,
      osVersion: osVersion ?? this.osVersion,
      osBuild: osBuild ?? this.osBuild,
      isRooted: isRooted ?? this.isRooted,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      isMockLocation: isMockLocation ?? this.isMockLocation,
      isEmulator: isEmulator ?? this.isEmulator,
      hasBiometricHardware: hasBiometricHardware ?? this.hasBiometricHardware,
      isBiometricEnrolled: isBiometricEnrolled ?? this.isBiometricEnrolled,
      isVpnActive: isVpnActive ?? this.isVpnActive,
      captureCount: captureCount ?? this.captureCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentEvent,
        dbEntity,
        networkInfo,
        displaySpecs,
        sensorsCatalog,
        isTestingPing,
        isDeviceIdMasked,
        errorMessage,
        successMessage,
        osVersion,
        osBuild,
        isRooted,
        isDeveloperMode,
        isMockLocation,
        isEmulator,
        hasBiometricHardware,
        isBiometricEnrolled,
        isVpnActive,
        captureCount,
      ];
}
