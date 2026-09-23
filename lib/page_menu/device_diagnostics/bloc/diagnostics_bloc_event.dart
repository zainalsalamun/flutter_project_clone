import 'package:equatable/equatable.dart';
import '../models/location_and_carrier_data.dart';

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

class CompassHeadingChangedEvent extends DiagnosticsBlocEvent {
  final double heading;
  const CompassHeadingChangedEvent(this.heading);

  @override
  List<Object?> get props => [heading];
}

class SimulateGeotaggingConditionEvent extends DiagnosticsBlocEvent {
  final GeotaggingCondition condition;
  const SimulateGeotaggingConditionEvent(this.condition);

  @override
  List<Object?> get props => [condition];
}

class ResetGeotaggingSimulationEvent extends DiagnosticsBlocEvent {
  const ResetGeotaggingSimulationEvent();
}
