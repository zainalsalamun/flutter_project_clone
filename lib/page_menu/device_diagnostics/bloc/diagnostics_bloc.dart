import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/device_collector_service.dart';
import '../services/diagnostics_logger_service.dart';
import '../services/network_connectivity_service.dart';
import 'diagnostics_bloc_event.dart';
import 'diagnostics_bloc_state.dart';

class DiagnosticsBloc extends Bloc<DiagnosticsBlocEvent, DiagnosticsBlocState> {
  final DiagnosticsLoggerService logger = DiagnosticsLoggerService.instance;
  final DeviceCollectorService collector = DeviceCollectorService.instance;
  final NetworkConnectivityService networkService =
      NetworkConnectivityService.instance;

  StreamSubscription<NetworkInfoData>? _networkSubscription;

  DiagnosticsBloc() : super(DiagnosticsBlocState.initial()) {
    on<LoadInitialDiagnostics>(_onLoadInitialDiagnostics);
    on<ScanLiveDeviceHardware>(_onScanLiveDeviceHardware);
    on<ToggleDeviceIdMaskEvent>(_onToggleDeviceIdMask);
    on<RegenerateDeviceIdEvent>(_onRegenerateDeviceId);
    on<ClearLogsEvent>(_onClearLogs);
    on<NetworkConnectivityChangedEvent>(_onNetworkConnectivityChanged);
    on<ProbePingLatencyEvent>(_onProbePingLatency);
    on<SimulateBadConnectionEvent>(_onSimulateBadConnection);

    // Start live monitoring of WiFi / Mobile Data ON/OFF toggles
    networkService.startMonitoring();
    _networkSubscription = networkService.networkStream.listen((info) {
      add(NetworkConnectivityChangedEvent(info));
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

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    return super.close();
  }
}
