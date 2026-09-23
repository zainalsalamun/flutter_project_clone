import 'package:flutter/material.dart';
import '../models/device_diagnostics_event.dart';
import '../theme/diagnostics_colors.dart';

class SystemSpecsCard extends StatelessWidget {
  final DeviceDiagnosticsEvent event;
  final String osVersion;
  final String osBuild;
  final bool isRooted;
  final bool isDeveloperMode;
  final bool isMockLocation;
  final bool isEmulator;
  final bool hasBiometricHardware;
  final bool isBiometricEnrolled;
  final bool isVpnActive;

  const SystemSpecsCard({
    super.key,
    required this.event,
    required this.osVersion,
    required this.osBuild,
    required this.isRooted,
    required this.isDeveloperMode,
    this.isMockLocation = false,
    this.isEmulator = false,
    this.hasBiometricHardware = true,
    this.isBiometricEnrolled = true,
    this.isVpnActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasSecurityThreat = isRooted || isMockLocation || isEmulator;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DiagnosticsColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasSecurityThreat
              ? DiagnosticsColors.danger.withValues(alpha: 0.3)
              : DiagnosticsColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.devices_other_rounded,
                        size: 18, color: DiagnosticsColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "DEVICE & OS SPECIFICATIONS",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: DiagnosticsColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: DiagnosticsColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "App v${event.appVersion}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: DiagnosticsColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Grid of Device Hardware Specs
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "Device Model",
                  value: event.model,
                  icon: Icons.smartphone_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "Codename",
                  value: event.device,
                  icon: Icons.code_rounded,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: DiagnosticsColors.divider),
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "Brand / Maker",
                  value: "${event.brand} (${event.manufacturer})",
                  icon: Icons.business_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "OS Version",
                  value: osVersion,
                  icon: Icons.android_rounded,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: DiagnosticsColors.divider),
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "OS Build ID",
                  value: osBuild,
                  icon: Icons.build_circle_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "Captured Time",
                  value:
                      "${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}:${event.timestamp.second.toString().padLeft(2, '0')} UTC",
                  icon: Icons.access_time_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Security & Anti-Fraud Matrix Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DiagnosticsColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasSecurityThreat
                    ? DiagnosticsColors.dangerBorder
                    : DiagnosticsColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            size: 15, color: DiagnosticsColors.primary),
                        SizedBox(width: 5),
                        Text(
                          "SECURITY & ANTI-FRAUD AUDIT",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: DiagnosticsColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: hasSecurityThreat
                            ? DiagnosticsColors.danger.withValues(alpha: 0.12)
                            : DiagnosticsColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        hasSecurityThreat ? "⚠️ ALERT" : "SECURE",
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: hasSecurityThreat
                              ? DiagnosticsColors.danger
                              : DiagnosticsColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 2x3 Matrix Grid of Security Checks
                // Row 1: Fake GPS & Emulator Detection
                Row(
                  children: [
                    // Fake GPS / Mock Location
                    Expanded(
                      child: _SecurityPill(
                        icon: isMockLocation
                            ? Icons.location_off_rounded
                            : Icons.location_on_rounded,
                        label: "Fake GPS (Mock)",
                        status: isMockLocation ? "Aktif (Mock)" : "Clean (Aman)",
                        isDanger: isMockLocation,
                        isWarning: false,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Emulator Detection
                    Expanded(
                      child: _SecurityPill(
                        icon: isEmulator
                            ? Icons.developer_board_off_rounded
                            : Icons.phone_android_rounded,
                        label: "Device Platform",
                        status: isEmulator ? "Emulator / VM" : "Fisik Asli",
                        isDanger: isEmulator,
                        isWarning: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Row 2: Biometric & VPN
                Row(
                  children: [
                    // Biometric Status
                    Expanded(
                      child: _SecurityPill(
                        icon: hasBiometricHardware
                            ? (isBiometricEnrolled
                                ? Icons.fingerprint_rounded
                                : Icons.fingerprint_outlined)
                            : Icons.lock_outline_rounded,
                        label: "Hardware Biometrik",
                        status: !hasBiometricHardware
                            ? "Tidak Tersedia"
                            : (isBiometricEnrolled
                                ? "Terdaftar (OK)"
                                : "Belum Didaftar"),
                        isDanger: false,
                        isWarning: hasBiometricHardware && !isBiometricEnrolled,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // VPN / Proxy Detection
                    Expanded(
                      child: _SecurityPill(
                        icon: Icons.vpn_lock_rounded,
                        label: "VPN / Proxy",
                        status: isVpnActive ? "VPN Aktif" : "Direct Link",
                        isDanger: false,
                        isWarning: isVpnActive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Row 3: Root & Developer Options
                Row(
                  children: [
                    // Root / Jailbreak
                    Expanded(
                      child: _SecurityPill(
                        icon: isRooted
                            ? Icons.warning_amber_rounded
                            : Icons.security_rounded,
                        label: "Root / Jailbreak",
                        status: isRooted ? "Rooted" : "Not Rooted",
                        isDanger: isRooted,
                        isWarning: false,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Developer Mode
                    Expanded(
                      child: _SecurityPill(
                        icon: isDeveloperMode
                            ? Icons.developer_mode_rounded
                            : Icons.lock_outline_rounded,
                        label: "Developer Options",
                        status: isDeveloperMode ? "Dev Mode ON" : "Dev Mode OFF",
                        isDanger: false,
                        isWarning: isDeveloperMode,
                      ),
                    ),
                  ],
                ),

                // Security Alert Explanation Banner
                if (isMockLocation) ...[
                  const SizedBox(height: 8),
                  _buildNotice(
                    icon: Icons.location_off_rounded,
                    title: "Peringatan Anti-Fraud Lokasi",
                    message:
                        "Aplikasi Fake GPS / Mock Location terdeteksi aktif. Sistem dapat menolak presensi atau transaksi lokasi.",
                    pair: DiagnosticsStatusPair.danger,
                  ),
                ],
                if (isEmulator) ...[
                  const SizedBox(height: 8),
                  _buildNotice(
                    icon: Icons.warning_amber_rounded,
                    title: "Lingkungan Virtual Terdeteksi",
                    message:
                        "Aplikasi berjalan di atas Emulator / VM. Beberapa fitur native hardware mungkin terbatas.",
                    pair: DiagnosticsStatusPair.danger,
                  ),
                ],
                if (isVpnActive) ...[
                  const SizedBox(height: 8),
                  _buildNotice(
                    icon: Icons.vpn_lock_rounded,
                    title: "Koneksi VPN Aktif",
                    message:
                        "Lalu lintas jaringan diteruskan melalui tunnel VPN/Proxy eksternal.",
                    pair: DiagnosticsStatusPair.warning,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice({
    required IconData icon,
    required String title,
    required String message,
    required DiagnosticsStatusPair pair,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: pair.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: pair.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: pair.color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: pair.color,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 8.5,
                    color: pair.color.withValues(alpha: 0.9),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final bool isDanger;
  final bool isWarning;

  const _SecurityPill({
    required this.icon,
    required this.label,
    required this.status,
    required this.isDanger,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    final DiagnosticsStatusPair pair;

    if (isDanger) {
      pair = DiagnosticsStatusPair.danger;
    } else if (isWarning) {
      pair = DiagnosticsStatusPair.warning;
    } else {
      pair = DiagnosticsStatusPair.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: pair.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: pair.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: pair.textColor),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.0,
                    color: pair.textColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: pair.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SpecItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: DiagnosticsColors.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: DiagnosticsColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: DiagnosticsColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
