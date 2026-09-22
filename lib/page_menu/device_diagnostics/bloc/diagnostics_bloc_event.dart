import 'package:equatable/equatable.dart';

abstract class DiagnosticsBlocEvent extends Equatable {
  const DiagnosticsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialDiagnostics extends DiagnosticsBlocEvent {
  const LoadInitialDiagnostics();
}

class ScanLiveDeviceHardware extends DiagnosticsBlocEvent {
  const ScanLiveDeviceHardware();
}

class ToggleDeviceIdMaskEvent extends DiagnosticsBlocEvent {
  const ToggleDeviceIdMaskEvent();
}

class RegenerateDeviceIdEvent extends DiagnosticsBlocEvent {
  const RegenerateDeviceIdEvent();
}

class ClearLogsEvent extends DiagnosticsBlocEvent {
  const ClearLogsEvent();
}

class NetworkConnectivityChangedEvent extends DiagnosticsBlocEvent {
  final dynamic networkInfo; // NetworkInfoData
  const NetworkConnectivityChangedEvent(this.networkInfo);

  @override
  List<Object?> get props => [networkInfo];
}

class ProbePingLatencyEvent extends DiagnosticsBlocEvent {
  const ProbePingLatencyEvent();
}

class SimulateBadConnectionEvent extends DiagnosticsBlocEvent {
  const SimulateBadConnectionEvent();
}
