import 'package:equatable/equatable.dart';
import '../models/device_diagnostics_event.dart';
import '../models/user_device_diagnostics_entity.dart';
import '../services/network_connectivity_service.dart';

enum DiagnosticsStatus { initial, loading, success, failure }

class DiagnosticsBlocState extends Equatable {
  final DiagnosticsStatus status;
  final DeviceDiagnosticsEvent? currentEvent;
  final UserDeviceDiagnosticsEntity? dbEntity;
  final NetworkInfoData networkInfo;
  final bool isTestingPing;
  final bool isDeviceIdMasked;
  final String? errorMessage;
  final String? successMessage;
  final String osVersion;
  final String osBuild;
  final bool isRooted;
  final bool isDeveloperMode;
  final int captureCount;

  const DiagnosticsBlocState({
    required this.status,
    this.currentEvent,
    this.dbEntity,
    required this.networkInfo,
    this.isTestingPing = false,
    this.isDeviceIdMasked = true,
    this.errorMessage,
    this.successMessage,
    this.osVersion = "",
    this.osBuild = "",
    this.isRooted = false,
    this.isDeveloperMode = false,
    this.captureCount = 0,
  });

  factory DiagnosticsBlocState.initial() {
    return DiagnosticsBlocState(
      status: DiagnosticsStatus.initial,
      currentEvent: null,
      dbEntity: null,
      networkInfo: NetworkInfoData.initial(),
      isDeviceIdMasked: true,
    );
  }

  DiagnosticsBlocState copyWith({
    DiagnosticsStatus? status,
    DeviceDiagnosticsEvent? currentEvent,
    UserDeviceDiagnosticsEntity? dbEntity,
    NetworkInfoData? networkInfo,
    bool? isTestingPing,
    bool? isDeviceIdMasked,
    String? errorMessage,
    String? successMessage,
    String? osVersion,
    String? osBuild,
    bool? isRooted,
    bool? isDeveloperMode,
    int? captureCount,
  }) {
    return DiagnosticsBlocState(
      status: status ?? this.status,
      currentEvent: currentEvent ?? this.currentEvent,
      dbEntity: dbEntity ?? this.dbEntity,
      networkInfo: networkInfo ?? this.networkInfo,
      isTestingPing: isTestingPing ?? this.isTestingPing,
      isDeviceIdMasked: isDeviceIdMasked ?? this.isDeviceIdMasked,
      errorMessage: errorMessage,
      successMessage: successMessage,
      osVersion: osVersion ?? this.osVersion,
      osBuild: osBuild ?? this.osBuild,
      isRooted: isRooted ?? this.isRooted,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      captureCount: captureCount ?? this.captureCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentEvent,
        dbEntity,
        networkInfo,
        isTestingPing,
        isDeviceIdMasked,
        errorMessage,
        successMessage,
        osVersion,
        osBuild,
        isRooted,
        isDeveloperMode,
        captureCount,
      ];
}
