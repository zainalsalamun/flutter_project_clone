import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../models/location_and_carrier_data.dart';
import 'diagnostics_logger_service.dart';

class LocationAndCarrierService {
  static final LocationAndCarrierService instance =
      LocationAndCarrierService._internal();

  LocationAndCarrierService._internal();

  static const MethodChannel _platformChannel =
      MethodChannel('com.naltech.project_clone/device_diagnostics');

  LocationAndCarrierData _currentData = LocationAndCarrierData.initial();
  LocationAndCarrierData get currentData => _currentData;

  double _currentHeading = 42.0; // Heading degrees (0 - 360)
  double get currentHeading => _currentHeading;

  Timer? _compassTimer;
  final StreamController<double> _compassStreamController =
      StreamController<double>.broadcast();
  Stream<double> get compassStream => _compassStreamController.stream;

  bool _isSimulating = false;

  void startCompass() {
    _compassTimer?.cancel();
    // Smooth live compass needle drift / responsive orientation updates
    _compassTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isSimulating) {
        // Natural gentle heading fluctuation
        _currentHeading = (_currentHeading + (Random().nextDouble() * 2 - 1)) % 360;
        if (_currentHeading < 0) _currentHeading += 360;
      }
      _compassStreamController.add(_currentHeading);
    });
  }

  /// Queries live location and cellular carrier telemetry from native platform
  Future<LocationAndCarrierData> checkLocationAndCarrier() async {
    Map<dynamic, dynamic>? nativeData;
    try {
      nativeData = await _platformChannel.invokeMethod('getDeviceDiagnostics');
    } catch (_) {}

    if (nativeData != null) {
      _currentData = LocationAndCarrierData.fromMap(nativeData);
    }

    DiagnosticsLoggerService.instance.info(
      "GEOTAGGING_AUDIT",
      "Geotagging Status: '${_currentData.conditionTitle}' (Coord: ${_currentData.formattedCoordinates}, Accuracy: ${_currentData.formattedAccuracy}, Carrier: ${_currentData.carrierName})",
      payload: {
        "condition": _currentData.condition.name,
        "latitude": _currentData.latitude,
        "longitude": _currentData.longitude,
        "accuracyMeters": _currentData.accuracyMeters,
        "isMock": _currentData.isLocationMock,
        "isGpsEnabled": _currentData.isGpsEnabled,
        "carrier": _currentData.carrierName,
        "simState": _currentData.simState,
      },
    );

    return _currentData;
  }

  /// Simulates weak GPS accuracy (e.g. Indoor / Deep in Basement ±120m)
  void simulateWeakGps() {
    _isSimulating = true;
    _currentData = LocationAndCarrierData(
      carrierName: _currentData.carrierName,
      simState: _currentData.simState,
      countryIso: _currentData.countryIso,
      isGpsEnabled: true,
      isNetworkLocEnabled: true,
      isLocationPermissionGranted: true,
      hasGpsHardware: true,
      latitude: _currentData.latitude,
      longitude: _currentData.longitude,
      altitudeMeters: _currentData.altitudeMeters,
      accuracyMeters: 118.0, // Low accuracy / weak satellite signal
      speedKmh: 0.0,
      bearingDegrees: 45.0,
      isLocationMock: false,
      locationProvider: "network_cell_tower",
    );

    DiagnosticsLoggerService.instance.warn(
      "GEOTAGGING_WARNING",
      "⚠️ Kondisi Geotagging TIDAK SESUAI: Sinyal Satelit Lemah / Indoor (Akurasi: ±118m)",
      payload: {"condition": "weakSignal", "accuracy": 118.0},
    );
  }

  /// Simulates Location Services (GPS) disabled
  void simulateGpsOff() {
    _isSimulating = true;
    _currentData = LocationAndCarrierData(
      carrierName: _currentData.carrierName,
      simState: _currentData.simState,
      countryIso: _currentData.countryIso,
      isGpsEnabled: false,
      isNetworkLocEnabled: false,
      isLocationPermissionGranted: true,
      hasGpsHardware: true,
      latitude: 0.0,
      longitude: 0.0,
      altitudeMeters: 0.0,
      accuracyMeters: 0.0,
      speedKmh: 0.0,
      bearingDegrees: 0.0,
      isLocationMock: false,
      locationProvider: "none",
    );

    DiagnosticsLoggerService.instance.error(
      "GEOTAGGING_ERROR",
      "❌ Kondisi Geotagging TIDAK SESUAI: Layanan Lokasi (GPS) dalam kondisi OFF!",
      payload: {"condition": "gpsDisabled", "isGpsEnabled": false},
    );
  }

  /// Simulates Mock Location / Fake GPS fraud
  void simulateMockGps() {
    _isSimulating = true;
    _currentData = LocationAndCarrierData(
      carrierName: _currentData.carrierName,
      simState: _currentData.simState,
      countryIso: _currentData.countryIso,
      isGpsEnabled: true,
      isNetworkLocEnabled: true,
      isLocationPermissionGranted: true,
      hasGpsHardware: true,
      latitude: -6.2000,
      longitude: 106.8166,
      altitudeMeters: 10.0,
      accuracyMeters: 5.0,
      speedKmh: 0.0,
      bearingDegrees: 0.0,
      isLocationMock: true, // Mock location provider active
      locationProvider: "mock_fake_gps_app",
    );

    DiagnosticsLoggerService.instance.error(
      "ANTI_FRAUD_ALERT",
      "🚨 PERINGATAN FRAUD: Fake GPS / Mock Location terdeteksi aktif memanipulasi koordinat!",
      payload: {"condition": "mockLocation", "isMock": true},
    );
  }

  /// Requests Android runtime ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION, and CAMERA permissions
  Future<Map<String, dynamic>> requestLocationPermission() async {
    // 1. Try MethodChannel first
    try {
      final res = await _platformChannel.invokeMethod('requestLocationPermission');
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (_) {}

    // 2. Seamless fallback to permission_handler package
    try {
      final statuses = await [
        ph.Permission.location,
        ph.Permission.camera,
      ].request();

      final locGranted = statuses[ph.Permission.location]?.isGranted ?? false;
      final camGranted = statuses[ph.Permission.camera]?.isGranted ?? false;
      final serviceStatus = await ph.Permission.location.serviceStatus;
      final isGpsEnabled = serviceStatus.isEnabled;

      return {
        "fineLocationGranted": locGranted,
        "coarseLocationGranted": locGranted,
        "cameraGranted": camGranted,
        "isLocationGranted": locGranted,
        "isGpsEnabled": isGpsEnabled,
        "isNetworkLocEnabled": isGpsEnabled,
      };
    } catch (phError) {
      DiagnosticsLoggerService.instance.error(
        "PERMISSION_REQUEST_ERROR",
        "Gagal meminta izin runtime: $phError",
      );
    }

    return {
      "fineLocationGranted": false,
      "coarseLocationGranted": false,
      "cameraGranted": false,
      "isLocationGranted": false,
      "isGpsEnabled": false,
      "isNetworkLocEnabled": false,
    };
  }

  /// Checks current permission status and whether GPS hardware provider is active
  Future<Map<String, dynamic>> checkLocationStatus() async {
    try {
      final res = await _platformChannel.invokeMethod('checkLocationStatus');
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (_) {}

    try {
      final locGranted = await ph.Permission.location.isGranted;
      final camGranted = await ph.Permission.camera.isGranted;
      final serviceStatus = await ph.Permission.location.serviceStatus;
      final isGpsEnabled = serviceStatus.isEnabled;

      return {
        "fineLocationGranted": locGranted,
        "coarseLocationGranted": locGranted,
        "cameraGranted": camGranted,
        "isLocationGranted": locGranted,
        "isGpsEnabled": isGpsEnabled,
        "isNetworkLocEnabled": isGpsEnabled,
      };
    } catch (_) {}

    return {
      "fineLocationGranted": false,
      "coarseLocationGranted": false,
      "cameraGranted": false,
      "isLocationGranted": false,
      "isGpsEnabled": false,
      "isNetworkLocEnabled": false,
    };
  }

  /// Opens Android Location Settings (Settings.ACTION_LOCATION_SOURCE_SETTINGS)
  Future<bool> openLocationSettings() async {
    try {
      final res = await _platformChannel.invokeMethod('openLocationSettings');
      if (res == true) return true;
    } catch (_) {}

    try {
      return await ph.openAppSettings();
    } catch (_) {
      return false;
    }
  }

  /// Opens Application Details Settings to allow permissions
  Future<bool> openAppSettings() async {
    try {
      final res = await _platformChannel.invokeMethod('openAppSettings');
      if (res == true) return true;
    } catch (_) {}

    try {
      return await ph.openAppSettings();
    } catch (_) {
      return false;
    }
  }

  /// Native reverse geocoding via Android Geocoder
  Future<String?> reverseGeocodeNative(double latitude, double longitude) async {
    try {
      final res = await _platformChannel.invokeMethod('reverseGeocodeNative', {
        'latitude': latitude,
        'longitude': longitude,
      });
      if (res is Map) {
        final full = res['fullAddress']?.toString();
        if (full != null && full.isNotEmpty) {
          return full;
        }
        final parts = <String>[];
        final thoroughfare = res['thoroughfare']?.toString() ?? '';
        final subThoroughfare = res['subThoroughfare']?.toString() ?? '';
        final locality = res['locality']?.toString() ?? '';
        final subLocality = res['subLocality']?.toString() ?? '';
        final adminArea = res['adminArea']?.toString() ?? '';

        if (thoroughfare.isNotEmpty) {
          parts.add(subThoroughfare.isNotEmpty ? "$thoroughfare No $subThoroughfare" : thoroughfare);
        }
        if (subLocality.isNotEmpty && subLocality != thoroughfare) parts.add(subLocality);
        if (locality.isNotEmpty && locality != subLocality) parts.add(locality);
        if (adminArea.isNotEmpty && adminArea != locality) parts.add(adminArea);

        if (parts.isNotEmpty) return parts.join(", ");
      }
    } catch (_) {}
    return null;
  }

  /// Restores normal live sensor & GPS reading
  Future<LocationAndCarrierData> resetSimulation() async {
    _isSimulating = false;
    return await checkLocationAndCarrier();
  }

  void dispose() {
    _compassTimer?.cancel();
    _compassStreamController.close();
  }
}
