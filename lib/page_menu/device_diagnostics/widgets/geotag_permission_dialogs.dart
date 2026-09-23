import 'package:flutter/material.dart';
import '../services/location_and_carrier_service.dart';
import '../theme/diagnostics_colors.dart';

class GeotagPermissionDialogs {
  /// Displays a modal dialog when device GPS is turned OFF
  static Future<void> showGpsRequiredDialog({
    required BuildContext context,
    VoidCallback? onSettingsOpened,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: DiagnosticsColors.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: DiagnosticsColors.danger.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: DiagnosticsColors.danger.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Pulse Icon Header
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: DiagnosticsColors.dangerBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DiagnosticsColors.dangerBorder,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_off_rounded,
                      color: DiagnosticsColors.danger,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Layanan GPS Wajib Aktif!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: DiagnosticsColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Message
                const Text(
                  "Fitur Geotagging & Telemetri Presisi membutuhkan sensor GPS perangkat dalam kondisi AKTIF untuk mendeteksi koordinat satelit dan validasi presensi secara akurat.\n\nSilakan aktifkan GPS / Layanan Lokasi di Pengaturan HP Anda.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: DiagnosticsColors.textSubtle,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),

                // Action: Open Location Settings
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DiagnosticsColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.settings_suggest_rounded, size: 18),
                    label: const Text(
                      "Nyalakan GPS (Buka Pengaturan)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await LocationAndCarrierService.instance.openLocationSettings();
                      onSettingsOpened?.call();
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Action: Dismiss
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: DiagnosticsColors.textSubtle,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      "Nanti Saja",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Displays a modal dialog when ACCESS_FINE_LOCATION permission is missing
  static Future<void> showPermissionRequiredDialog({
    required BuildContext context,
    VoidCallback? onPermissionGranted,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: DiagnosticsColors.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: DiagnosticsColors.warning.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: DiagnosticsColors.warning.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lock Icon Header
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: DiagnosticsColors.warningBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DiagnosticsColors.warningBorder,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pin_drop_rounded,
                      color: DiagnosticsColors.warning,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Izin Lokasi Presisi Diperlukan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: DiagnosticsColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Message
                const Text(
                  "Aplikasi membutuhkan izin 'ACCESS_FINE_LOCATION' dan 'CAMERA' untuk membaca koordinat satelit aktual dan mengambil foto geotagging watermark.\n\nHarap izinkan akses lokasi presisi saat aplikasi digunakan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: DiagnosticsColors.textSubtle,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),

                // Action: Request Permission / Open App Settings
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DiagnosticsColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.security_rounded, size: 18),
                    label: const Text(
                      "Izinkan Akses Lokasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      final result = await LocationAndCarrierService.instance.requestLocationPermission();
                      final isGranted = result['isLocationGranted'] == true;
                      if (isGranted) {
                        onPermissionGranted?.call();
                      } else {
                        // Directly open Android App Settings so user can toggle Location Permission
                        await LocationAndCarrierService.instance.openAppSettings();
                        onPermissionGranted?.call();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Action: Dismiss
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: DiagnosticsColors.textSubtle,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
