import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/diagnostics_bloc.dart';
import 'bloc/diagnostics_bloc_event.dart';
import 'bloc/diagnostics_bloc_state.dart';
import 'widgets/device_id_hero_card.dart';
import 'widgets/display_specs_card.dart';
import 'widgets/export_and_share_card.dart';
import 'widgets/live_debug_log_console.dart';
import 'widgets/metrics_overview_card.dart';
import 'widgets/network_status_card.dart';
import 'widgets/schema_mapping_view.dart';
import 'widgets/sensors_catalog_card.dart';
import 'widgets/system_specs_card.dart';
import 'services/diagnostics_report_service.dart';

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

class _DeviceDiagnosticsView extends StatelessWidget {
  const _DeviceDiagnosticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Device Diagnostics & ID",
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Real Hardware Telemetry & Live Debug Log",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            tooltip: "Share & Export Report",
            icon: const Icon(Icons.ios_share_rounded, color: Color(0xFF0284C7)),
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
            tooltip: "Rescan Live Device",
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
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
                backgroundColor: Colors.redAccent,
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
                backgroundColor: const Color(0xFF1E293B),
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
                  CircularProgressIndicator(color: Color(0xFF0284C7)),
                  SizedBox(height: 16),
                  Text(
                    "Collecting telemetry directly from device...",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
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
            color: const Color(0xFF0284C7),
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
                    color: const Color(0xFF0284C7).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF0284C7).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sensors_rounded,
                          color: Color(0xFF10B981), size: 16),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          "LIVE HARDWARE SOURCE",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF0284C7),
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
                          color: Color(0xFF64748B),
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

                // 5. SYSTEM & SECURITY SPECIFICATIONS
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

                // 6. DISPLAY & SCREEN SPECIFICATIONS
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
                        color: Color(0xFF64748B),
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
