enum GeotaggingCondition {
  optimal,
  weakSignal,
  mockLocation,
  gpsDisabled,
  permissionDenied,
}

class LocationAndCarrierData {
  final String carrierName;
  final String simState;
  final String countryIso;
  final bool isGpsEnabled;
  final bool isNetworkLocEnabled;
  final bool isLocationPermissionGranted;
  final bool hasGpsHardware;
  final double latitude;
  final double longitude;
  final double altitudeMeters;
  final double accuracyMeters;
  final double speedKmh;
  final double bearingDegrees;
  final bool isLocationMock;
  final String locationProvider;

  const LocationAndCarrierData({
    this.carrierName = "No SIM / WiFi Only",
    this.simState = "READY",
    this.countryIso = "id",
    this.isGpsEnabled = false,
    this.isNetworkLocEnabled = false,
    this.isLocationPermissionGranted = false,
    this.hasGpsHardware = true,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.altitudeMeters = 0.0,
    this.accuracyMeters = 0.0,
    this.speedKmh = 0.0,
    this.bearingDegrees = 0.0,
    this.isLocationMock = false,
    this.locationProvider = "none",
  });

  factory LocationAndCarrierData.initial() {
    return const LocationAndCarrierData();
  }

  factory LocationAndCarrierData.fromMap(Map<dynamic, dynamic> map) {
    return LocationAndCarrierData(
      carrierName: map['carrierName']?.toString() ?? 'No SIM / WiFi Only',
      simState: map['simState']?.toString() ?? 'READY',
      countryIso: map['countryIso']?.toString() ?? 'id',
      isGpsEnabled: map['isGpsEnabled'] as bool? ?? false,
      isNetworkLocEnabled: map['isNetworkLocEnabled'] as bool? ?? false,
      isLocationPermissionGranted:
          map['isLocationPermissionGranted'] as bool? ?? false,
      hasGpsHardware: map['hasGpsHardware'] as bool? ?? true,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      altitudeMeters: (map['altitudeMeters'] as num?)?.toDouble() ?? 0.0,
      accuracyMeters: (map['accuracyMeters'] as num?)?.toDouble() ?? 0.0,
      speedKmh: (map['speedKmh'] as num?)?.toDouble() ?? 0.0,
      bearingDegrees: (map['bearingDegrees'] as num?)?.toDouble() ?? 0.0,
      isLocationMock: map['isLocationMock'] as bool? ?? false,
      locationProvider: map['locationProvider']?.toString() ?? 'none',
    );
  }

  /// Evaluates real Geotagging Condition State
  GeotaggingCondition get condition {
    if (!isLocationPermissionGranted) {
      return GeotaggingCondition.permissionDenied;
    }
    if (!isGpsEnabled && !isNetworkLocEnabled) {
      return GeotaggingCondition.gpsDisabled;
    }
    if (isLocationMock) {
      return GeotaggingCondition.mockLocation;
    }
    if ((latitude == 0.0 && longitude == 0.0) || accuracyMeters <= 0 || accuracyMeters > 35.0) {
      return GeotaggingCondition.weakSignal;
    }
    return GeotaggingCondition.optimal;
  }

  String get conditionTitle {
    switch (condition) {
      case GeotaggingCondition.optimal:
        return "Geotagging Valid & Akurat";
      case GeotaggingCondition.weakSignal:
        return "Akurasi Rendah / Sinyal Satelit Lemah";
      case GeotaggingCondition.mockLocation:
        return "Peringatan Fraud: Fake GPS / Mock Terdeteksi";
      case GeotaggingCondition.gpsDisabled:
        return "Layanan Lokasi (GPS) Dimatikan";
      case GeotaggingCondition.permissionDenied:
        return "Izin Akses Lokasi Belum Diberikan";
    }
  }

  String get conditionDescription {
    switch (condition) {
      case GeotaggingCondition.optimal:
        return "Sinyal satelit GPS terkunci presisi tinggi (±${accuracyMeters.toStringAsFixed(1)}m). Sangat aman untuk validasi presensi & transaksi lokasi.";
      case GeotaggingCondition.weakSignal:
        return "Radius akurasi melebar (±${accuracyMeters.toStringAsFixed(0)}m) akibat sinyal GPS terhalang dinding/atap gedung. Berpotensi meleset dari radius geotagging presensi.";
      case GeotaggingCondition.mockLocation:
        return "Aplikasi Mock Location aktif memanipulasi koordinat. Sistem akan menolak transaksi atau presensi untuk mencegah fraud.";
      case GeotaggingCondition.gpsDisabled:
        return "Hardware GPS perangkat nonaktif. Aplikasi tidak dapat mendeteksi koordinat aktual.";
      case GeotaggingCondition.permissionDenied:
        return "Aplikasi tidak memiliki izin 'ACCESS_FINE_LOCATION' untuk membaca koordinat GPS perangkat.";
    }
  }

  String get conditionRecommendation {
    switch (condition) {
      case GeotaggingCondition.optimal:
        return "Kondisi optimal. Tidak ada tindakan diperlukan.";
      case GeotaggingCondition.weakSignal:
        return "💡 Solusi: Dekati jendela atau keluar ke area terbuka selama 5-10 detik agar GPS mengunci satelit.";
      case GeotaggingCondition.mockLocation:
        return "🚨 Solusi: Matikan Developer Options 'Select mock location app' atau hapus aplikasi Fake GPS.";
      case GeotaggingCondition.gpsDisabled:
        return "⚙️ Solusi: Buka Pengaturan Cepat / Settings dan aktifkan 'Lokasi / GPS'.";
      case GeotaggingCondition.permissionDenied:
        return "🔒 Solusi: Buka Info Aplikasi > Izin > Lokasi, lalu pilih 'Izinkan hanya saat aplikasi digunakan (Tepat/Precise)'.";
    }
  }

  String get formattedCoordinates {
    if (latitude == 0.0 && longitude == 0.0) {
      return "0.000000, 0.000000 (Menunggu GPS)";
    }
    return "${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";
  }

  /// Alias getters for telemetry access
  double get altitude => altitudeMeters;
  double get accuracy => accuracyMeters;
  String get simCarrierName => carrierName;
  String get fullAddress => formattedCoordinates;

  String get formattedAltitude =>
      "${altitudeMeters.toStringAsFixed(1)} m dpl";

  String get formattedAccuracy =>
      "± ${accuracyMeters.toStringAsFixed(1)} m";

  String get formattedSpeed =>
      "${speedKmh.toStringAsFixed(1)} km/h";

  String get cardinalDirection {
    final deg = (bearingDegrees % 360 + 360) % 360;
    if (deg >= 337.5 || deg < 22.5) return "U (Utara - N)";
    if (deg >= 22.5 && deg < 67.5) return "TL (Timur Laut - NE)";
    if (deg >= 67.5 && deg < 112.5) return "T (Timur - E)";
    if (deg >= 112.5 && deg < 157.5) return "TG (Tenggara - SE)";
    if (deg >= 157.5 && deg < 202.5) return "S (Selatan - S)";
    if (deg >= 202.5 && deg < 247.5) return "BD (Barat Daya - SW)";
    if (deg >= 247.5 && deg < 292.5) return "B (Barat - W)";
    return "BL (Barat Laut - NW)";
  }

  String get formattedBearing =>
      "${bearingDegrees.round()}° $cardinalDirection";

  String get simStatusLabel {
    final st = simState.toUpperCase();
    if (st == "READY") return "SIM Terpasang (Aktif)";
    if (st == "ABSENT") return "Tanpa SIM Card";
    if (st == "LOCKED") return "SIM Terkunci PIN/PUK";
    return "SIM Siap";
  }
}
