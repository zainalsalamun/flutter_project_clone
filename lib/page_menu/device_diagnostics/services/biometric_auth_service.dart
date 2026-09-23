import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diagnostics_logger_service.dart';

class BiometricAuthService {
  static final BiometricAuthService instance = BiometricAuthService._internal();
  BiometricAuthService._internal();

  static const MethodChannel _channel =
      MethodChannel('com.naltech.project_clone/device_diagnostics');

  static const String _prefVaultEnabledKey = 'geotag_biometric_vault_enabled';

  bool _isSessionUnlocked = false;
  bool get isSessionUnlocked => _isSessionUnlocked;

  /// Returns true if the user has enabled biometric vault protection in SharedPreferences
  Future<bool> isVaultProtectionEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_prefVaultEnabledKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Saves the biometric vault protection preference to SharedPreferences
  Future<void> setVaultProtectionEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefVaultEnabledKey, enabled);
      if (!enabled) {
        _isSessionUnlocked = true;
      }
    } catch (_) {}
  }

  /// Sets in-memory session unlock state
  void setSessionUnlocked(bool unlocked) {
    _isSessionUnlocked = unlocked;
  }

  /// Checks if the device has biometric hardware and whether credentials are enrolled
  Future<Map<String, bool>> checkBiometricStatus() async {
    try {
      final dynamic res = await _channel.invokeMethod('checkBiometrics');
      if (res is Map) {
        final hasHardware = res['hasHardware'] == true || res['hasBiometricHardware'] == true;
        final isEnrolled = res['isEnrolled'] == true || res['isBiometricEnrolled'] == true;
        return {
          'hasHardware': hasHardware,
          'isEnrolled': isEnrolled,
        };
      }
    } catch (_) {
      try {
        final dynamic res = await _channel.invokeMethod('getDeviceDiagnostics');
        if (res is Map) {
          final hasHardware = res['hasBiometricHardware'] == true;
          final isEnrolled = res['isBiometricEnrolled'] == true;
          return {
            'hasHardware': hasHardware,
            'isEnrolled': isEnrolled,
          };
        }
      } catch (e) {
        DiagnosticsLoggerService.instance.warn(
          "BIOMETRIC_CHECK_WARN",
          "Gagal memeriksa status hardware biometrik: $e",
        );
      }
    }
    return {'hasHardware': false, 'isEnrolled': false};
  }

  /// Prompts native Fingerprint / Face ID authentication
  Future<bool> authenticate({
    String title = "Autentikasi Biometrik",
    String subtitle = "Verifikasi identitas untuk mengakses data geotagging",
    String description = "Pindai sidik jari atau gunakan Face Unlock untuk membuka",
  }) async {
    try {
      final dynamic res = await _channel.invokeMethod('authenticateBiometric', {
        'title': title,
        'subtitle': subtitle,
        'description': description,
      });

      if (res is Map) {
        final bool authenticated = res['authenticated'] == true;
        final error = res['error']?.toString();

        if (authenticated) {
          _isSessionUnlocked = true;
        }

        DiagnosticsLoggerService.instance.info(
          "BIOMETRIC_AUTH_RESULT",
          "Hasil autentikasi biometrik: ${authenticated ? 'BERHASIL' : 'DITOLAK ($error)'}",
        );

        return authenticated;
      }
    } catch (e) {
      DiagnosticsLoggerService.instance.error(
        "BIOMETRIC_AUTH_ERROR",
        "Kesalahan sistem autentikasi biometrik: $e",
      );
    }

    // Fallback if platform error or cancelled
    return false;
  }
}
