import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/diagnostics_bloc.dart';
import 'bloc/diagnostics_bloc_event.dart';
import 'bloc/diagnostics_bloc_state.dart';
import 'services/location_and_carrier_service.dart';
import 'theme/diagnostics_colors.dart';
import 'widgets/device_id_hero_card.dart';
import 'widgets/display_specs_card.dart';
import 'widgets/export_and_share_card.dart';
import 'widgets/geotag_permission_dialogs.dart';
import 'widgets/geotagging_and_gps_card.dart';
import 'widgets/live_debug_log_console.dart';
import 'widgets/metrics_overview_card.dart';
import 'widgets/network_status_card.dart';
import 'widgets/schema_mapping_view.dart';
import 'widgets/sensors_catalog_card.dart';
import 'widgets/system_specs_card.dart';
import 'services/diagnostics_report_service.dart';
import 'pages/network_speed_diagnostics_page.dart';

class DeviceDiagnosticsPage extends StatelessWidget {
  const DeviceDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiagnosticsBloc()..add(const LoadInitialDiagnostics()),
      child: const _DeviceDiagnosticsView(),
    );
  }
}

class _DeviceDiagnosticsView extends StatefulWidget {
  const _DeviceDiagnosticsView();

  @override
  State<_DeviceDiagnosticsView> createState() => _DeviceDiagnosticsViewState();
}

class _DeviceDiagnosticsViewState extends State<_DeviceDiagnosticsView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGpsAndPermissionsOnStartup();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User returned from Location Settings or App Settings!
      if (mounted) {
        context.read<DiagnosticsBloc>().add(const ScanLiveDeviceHardware());
      }
    }
  }

  Future<void> _checkGpsAndPermissionsOnStartup() async {
    final status = await LocationAndCarrierService.instance.checkLocationStatus();
    final bool isGranted = status['isLocationGranted'] == true;
    final bool isGpsEnabled = status['isGpsEnabled'] == true;

    if (!isGranted) {
      // Prompt runtime permission request
      final permResult = await LocationAndCarrierService.instance.requestLocationPermission();
      final grantedNow = permResult['isLocationGranted'] == true;
      final gpsActiveNow = permResult['isGpsEnabled'] == true;

      if (mounted) {
        if (grantedNow && !gpsActiveNow) {
          // User allowed permission, but GPS is OFF
          await GeotagPermissionDialogs.showGpsRequiredDialog(
            context: context,
            onSettingsOpened: () {
              context.read<DiagnosticsBloc>().add(const ScanLiveDeviceHardware());
            },
          );
        } else if (!grantedNow) {
          await GeotagPermissionDialogs.showPermissionRequiredDialog(
            context: context,
            onPermissionGranted: () {
              context.read<DiagnosticsBloc>().add(const ScanLiveDeviceHardware());
            },
          );
        } else {
          context.read<DiagnosticsBloc>().add(const ScanLiveDeviceHardware());
        }
      }
    } else if (!isGpsEnabled) {
      // Permission granted, but GPS is OFF
      if (mounted) {
        await GeotagPermissionDialogs.showGpsRequiredDialog(
          context: context,
          onSettingsOpened: () {
            context.read<DiagnosticsBloc>().add(const ScanLiveDeviceHardware());
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DiagnosticsColors.pageBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Device Diagnostics & ID",
              style: TextStyle(
                color: DiagnosticsColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Real Hardware Telemetry & Live Debug Log",
              style: TextStyle(
                color: DiagnosticsColors.textSubtle,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: DiagnosticsColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: DiagnosticsColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            tooltip: "Share & Export Report",
            icon: const Icon(Icons.ios_share_rounded, color: DiagnosticsColors.primary),
            onPressed: () {
              final state = context.read<DiagnosticsBloc>().state;
              final event = state.currentEvent;
              if (event != null) {
                DiagnosticsReportService.instance.previewOrPrintPdf(
                  context: context,
                  event: event,
                  state: state,
                );
              }
            },
          ),
          IconButton(
            tooltip: "Speedtest & Uji Jaringan",
            icon: const Icon(Icons.speed_rounded, color: Color(0xFF38BDF8)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NetworkSpeedDiagnosticsPage(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Rescan Live Device",
            icon: const Icon(Icons.refresh_rounded, color: DiagnosticsColors.primary),
            onPressed: () {
              context
                  .read<DiagnosticsBloc>()
                  .add(const ScanLiveDeviceHardware());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<DiagnosticsBloc, DiagnosticsBlocState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                backgroundColor: DiagnosticsColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.greenAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.successMessage!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                backgroundColor: DiagnosticsColors.darkCard,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          final event = state.currentEvent;
          final entity = state.dbEntity;

          if (state.status == DiagnosticsStatus.loading && event == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: DiagnosticsColors.primary),
                  SizedBox(height: 16),
                  Text(
                    "Collecting telemetry directly from device...",
                    style: TextStyle(color: DiagnosticsColors.textSubtle, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          if (event == null) {
            return Center(
              child: ElevatedButton.icon(
                onPressed: () => context
                    .read<DiagnosticsBloc>()
                    .add(const LoadInitialDiagnostics()),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Scan Device"),
              ),
            );
          }

          return RefreshIndicator(
            color: DiagnosticsColors.primary,
            onRefresh: () async {
              context
                  .read<DiagnosticsBloc>()
                  .add(const ScanLiveDeviceHardware());
              await Future.delayed(const Duration(milliseconds: 600));
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // 1. Live Device Status Pill (Fully Responsive)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: DiagnosticsColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: DiagnosticsColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sensors_rounded,
                          color: DiagnosticsColors.success, size: 16),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          "LIVE HARDWARE SOURCE",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: DiagnosticsColors.primary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Scan #${state.captureCount}",
                        style: const TextStyle(
                          color: DiagnosticsColors.textSubtle,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2. HERO SECTION: DEVICE ID (Primary Focus)
                DeviceIdHeroCard(
                  event: event,
                  isMasked: state.isDeviceIdMasked,
                  isLiveDevice: true,
                  onToggleMask: () => context
                      .read<DiagnosticsBloc>()
                      .add(const ToggleDeviceIdMaskEvent()),
                  onRegenerateId: () => context
                      .read<DiagnosticsBloc>()
                      .add(const RegenerateDeviceIdEvent()),
                ),
                const SizedBox(height: 16),

                // 3. HARDWARE & BATTERY METRICS
                MetricsOverviewCard(event: event),
                const SizedBox(height: 16),

                // 4. LIVE NETWORK & WIFI ON/OFF CONNECTION
                NetworkStatusCard(
                  networkInfo: state.networkInfo,
                  isTestingPing: state.isTestingPing,
                  onTestPing: () => context
                      .read<DiagnosticsBloc>()
                      .add(const ProbePingLatencyEvent()),
                  onSimulateBadConnection: () => context
                      .read<DiagnosticsBloc>()
                      .add(const SimulateBadConnectionEvent()),
                ),
                const SizedBox(height: 16),

                // 5. GPS SATELLITE, LIVE COMPASS & GEOTAGGING CONDITION EVALUATION
                GeotaggingAndGpsCard(
                  locationCarrier: state.locationCarrier,
                  compassHeading: state.compassHeading,
                  onSimulateCondition: (cond) => context
                      .read<DiagnosticsBloc>()
                      .add(SimulateGeotaggingConditionEvent(cond)),
                  onResetSimulation: () => context
                      .read<DiagnosticsBloc>()
                      .add(const ResetGeotaggingSimulationEvent()),
                ),
                const SizedBox(height: 16),

                // 6. SYSTEM & SECURITY SPECIFICATIONS
                SystemSpecsCard(
                  event: event,
                  osVersion: state.osVersion,
                  osBuild: state.osBuild,
                  isRooted: state.isRooted,
                  isDeveloperMode: state.isDeveloperMode,
                  isMockLocation: state.isMockLocation,
                  isEmulator: state.isEmulator,
                  hasBiometricHardware: state.hasBiometricHardware,
                  isBiometricEnrolled: state.isBiometricEnrolled,
                  isVpnActive: state.isVpnActive,
                ),
                const SizedBox(height: 16),

                // 7. DISPLAY & SCREEN SPECIFICATIONS
                DisplaySpecsCard(displaySpecs: state.displaySpecs),
                const SizedBox(height: 16),

                // 7. HARDWARE SENSORS CHECKLIST
                SensorsCatalogCard(sensorsCatalog: state.sensorsCatalog),
                const SizedBox(height: 16),

                // 8. EXPORT REPORT & SHARE (PDF / JSON / SHARE)
                ExportAndShareCard(event: event, state: state),
                const SizedBox(height: 16),

                // 9. LIVE IN-APP DEBUG LOG CONSOLE (Debug Log Requirement)
                LiveDebugLogConsole(
                  onTriggerSync: () => context
                      .read<DiagnosticsBloc>()
                      .add(const ScanLiveDeviceHardware()),
                  onClearLogs: () => context
                      .read<DiagnosticsBloc>()
                      .add(const ClearLogsEvent()),
                ),
                const SizedBox(height: 16),

                // 6. SCHEMA & DATABASE TABLE MAPPING (user_device_diagnostics)
                if (entity != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      "DATABASE & SQL MAPPING (user_device_diagnostics)",
                      style: TextStyle(
                        color: DiagnosticsColors.textSubtle,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SchemaMappingView(event: event, entity: entity),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
