import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/location_and_carrier_data.dart';
import '../services/device_collector_service.dart';
import '../services/diagnostics_logger_service.dart';
import '../services/location_and_carrier_service.dart';
import '../services/network_connectivity_service.dart';
import 'diagnostics_bloc_event.dart';
import 'diagnostics_bloc_state.dart';

class DiagnosticsBloc extends Bloc<DiagnosticsBlocEvent, DiagnosticsBlocState> {
  final DiagnosticsLoggerService logger = DiagnosticsLoggerService.instance;
  final DeviceCollectorService collector = DeviceCollectorService.instance;
  final NetworkConnectivityService networkService =
      NetworkConnectivityService.instance;
  final LocationAndCarrierService locationService =
      LocationAndCarrierService.instance;

  StreamSubscription<NetworkInfoData>? _networkSubscription;
  StreamSubscription<double>? _compassSubscription;

  DiagnosticsBloc() : super(DiagnosticsBlocState.initial()) {
    on<LoadInitialDiagnostics>(_onLoadInitialDiagnostics);
    on<ScanLiveDeviceHardware>(_onScanLiveDeviceHardware);
    on<ToggleDeviceIdMaskEvent>(_onToggleDeviceIdMask);
    on<RegenerateDeviceIdEvent>(_onRegenerateDeviceId);
    on<ClearLogsEvent>(_onClearLogs);
    on<NetworkConnectivityChangedEvent>(_onNetworkConnectivityChanged);
    on<ProbePingLatencyEvent>(_onProbePingLatency);
    on<SimulateBadConnectionEvent>(_onSimulateBadConnection);
    on<CompassHeadingChangedEvent>(_onCompassHeadingChanged);
    on<SimulateGeotaggingConditionEvent>(_onSimulateGeotaggingCondition);
    on<ResetGeotaggingSimulationEvent>(_onResetGeotaggingSimulation);

    // Start live monitoring of WiFi / Mobile Data ON/OFF toggles
    networkService.startMonitoring();
    _networkSubscription = networkService.networkStream.listen((info) {
      add(NetworkConnectivityChangedEvent(info));
    });

    // Start live compass listener
    locationService.startCompass();
    _compassSubscription = locationService.compassStream.listen((heading) {
      add(CompassHeadingChangedEvent(heading));
    });
  }

  Future<void> _onLoadInitialDiagnostics(
    LoadInitialDiagnostics event,
    Emitter<DiagnosticsBlocState> emit,
  ) async {
    emit(state.copyWith(status: DiagnosticsStatus.loading));

    final liveEvent = await collector.collectLiveDeviceData();
    final osVer = collector.getRealOsVersion();
    final osBuild = collector.getRealOsBuild();
    final isRooted = collector.checkIsRooted();
    final isDeveloperMode = collector.checkIsDeveloperMode();
    final netInfo = await networkService.checkCurrentNetwork();
    final locData = await locationService.checkLocationAndCarrier();

    final entity = logger.processDiagnosticsPipeline(
      liveEvent,
      osVersion: osVer,
      osBuild: osBuild,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
    );

    emit(state.copyWith(
      status: DiagnosticsStatus.success,
      currentEvent: liveEvent,
      dbEntity: entity,
      networkInfo: netInfo,
      displaySpecs: collector.displaySpecs,
      sensorsCatalog: collector.sensorsCatalog,
      locationCarrier: locData,
      compassHeading: locationService.currentHeading,
      osVersion: osVer,
      osBuild: osBuild,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
      isMockLocation: collector.isMockLocation,
      isEmulator: collector.isEmulator,
      hasBiometricHardware: collector.hasBiometricHardware,
      isBiometricEnrolled: collector.isBiometricEnrolled,
      isVpnActive: collector.isVpnActive,
      captureCount: 1,
      successMessage: "Telemetry loaded directly from device hardware!",
    ));
  }

  Future<void> _onScanLiveDeviceHardware(
    ScanLiveDeviceHardware event,
    Emitter<DiagnosticsBlocState> emit,
  ) async {
    emit(state.copyWith(status: DiagnosticsStatus.loading));

    final liveEvent = await collector.collectLiveDeviceData();
    final osVer = collector.getRealOsVersion();
    final osBuild = collector.getRealOsBuild();
    final isRooted = collector.checkIsRooted();
    final isDeveloperMode = collector.checkIsDeveloperMode();
    final netInfo = await networkService.checkCurrentNetwork();
    final locData = await locationService.checkLocationAndCarrier();

    final entity = logger.processDiagnosticsPipeline(
      liveEvent,
      osVersion: osVer,
      osBuild: osBuild,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
    );

    emit(state.copyWith(
      status: DiagnosticsStatus.success,
      currentEvent: liveEvent,
      dbEntity: entity,
      networkInfo: netInfo,
      displaySpecs: collector.displaySpecs,
      sensorsCatalog: collector.sensorsCatalog,
      locationCarrier: locData,
      compassHeading: locationService.currentHeading,
      osVersion: osVer,
      osBuild: osBuild,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
      isMockLocation: collector.isMockLocation,
      isEmulator: collector.isEmulator,
      hasBiometricHardware: collector.hasBiometricHardware,
      isBiometricEnrolled: collector.isBiometricEnrolled,
      isVpnActive: collector.isVpnActive,
      captureCount: state.captureCount + 1,
      successMessage: "Rescanned live device metrics, battery & network!",
    ));
  }

  Future<void> _onRegenerateDeviceId(
    RegenerateDeviceIdEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) async {
    await collector.regenerateDeviceId();
    final freshEvent = await collector.collectLiveDeviceData();
    final osVer = collector.getRealOsVersion();
    final osBuild = collector.getRealOsBuild();
    final isRooted = collector.checkIsRooted();
    final isDeveloperMode = collector.checkIsDeveloperMode();

    final entity = logger.processDiagnosticsPipeline(
      freshEvent,
      osVersion: osVer,
      osBuild: osBuild,
      isRooted: isRooted,
      isDeveloperMode: isDeveloperMode,
    );

    emit(state.copyWith(
      status: DiagnosticsStatus.success,
      currentEvent: freshEvent,
      dbEntity: entity,
      successMessage: "Hardware SHA-256 Device ID recalculated!",
    ));
  }

  void _onToggleDeviceIdMask(
    ToggleDeviceIdMaskEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) {
    emit(state.copyWith(isDeviceIdMasked: !state.isDeviceIdMasked));
  }

  void _onClearLogs(
    ClearLogsEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) {
    logger.clear();
    logger.info("SYSTEM", "Debug logs cleared by user");
  }

  void _onNetworkConnectivityChanged(
    NetworkConnectivityChangedEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) {
    if (event.networkInfo is NetworkInfoData) {
      emit(state.copyWith(networkInfo: event.networkInfo as NetworkInfoData));
    }
  }

  Future<void> _onProbePingLatency(
    ProbePingLatencyEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) async {
    emit(state.copyWith(isTestingPing: true));
    final updatedInfo = await networkService.checkCurrentNetwork();
    emit(state.copyWith(
      isTestingPing: false,
      networkInfo: updatedInfo,
      successMessage: updatedInfo.isOnline
          ? "Ping Latency: ${updatedInfo.latencyMs} ms"
          : "Network is Offline / No Internet",
    ));
  }

  void _onSimulateBadConnection(
    SimulateBadConnectionEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) {
    networkService.simulateBadConnection();
    final updatedInfo = networkService.currentInfo;
    emit(state.copyWith(
      networkInfo: updatedInfo,
      successMessage: updatedInfo.isBadConnection
          ? "⚠️ Mode Simulasi: Koneksi Jelek / High Ping Diaktifkan!"
          : "✅ Koneksi dinormalkan kembali ke status asli!",
    ));
  }

  void _onCompassHeadingChanged(
    CompassHeadingChangedEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) {
    emit(state.copyWith(compassHeading: event.heading));
  }

  void _onSimulateGeotaggingCondition(
    SimulateGeotaggingConditionEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) {
    switch (event.condition) {
      case GeotaggingCondition.weakSignal:
        locationService.simulateWeakGps();
        break;
      case GeotaggingCondition.gpsDisabled:
        locationService.simulateGpsOff();
        break;
      case GeotaggingCondition.mockLocation:
        locationService.simulateMockGps();
        break;
      default:
        break;
    }
    final loc = locationService.currentData;
    emit(state.copyWith(
      locationCarrier: loc,
      successMessage: "Simulasi Geotagging: ${loc.conditionTitle}",
    ));
  }

  Future<void> _onResetGeotaggingSimulation(
    ResetGeotaggingSimulationEvent event,
    Emitter<DiagnosticsBlocState> emit,
  ) async {
    final loc = await locationService.resetSimulation();
    emit(state.copyWith(
      locationCarrier: loc,
      successMessage: "✅ Status Geotagging GPS & Jaringan Seluler dinormalkan!",
    ));
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    _compassSubscription?.cancel();
    locationService.dispose();
    return super.close();
  }
}
