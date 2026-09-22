import 'dart:math';

class DisplaySpecsData {
  final double refreshRate;
  final List<int> supportedRefreshRates;
  final int screenWidthPx;
  final int screenHeightPx;
  final int densityDpi;
  final double xdpi;
  final double ydpi;
  final double densityScale;
  final bool isHdr;

  const DisplaySpecsData({
    this.refreshRate = 60.0,
    this.supportedRefreshRates = const [60],
    this.screenWidthPx = 1080,
    this.screenHeightPx = 2400,
    this.densityDpi = 405,
    this.xdpi = 405.0,
    this.ydpi = 405.0,
    this.densityScale = 2.625,
    this.isHdr = false,
  });

  factory DisplaySpecsData.initial() {
    return const DisplaySpecsData();
  }

  factory DisplaySpecsData.fromMap(Map<dynamic, dynamic> map) {
    final rawRefresh = map['refreshRate'];
    final double rr = rawRefresh is num ? rawRefresh.toDouble() : 60.0;

    final rawSupported = map['supportedRefreshRates'];
    List<int> supported = [rr.toInt()];
    if (rawSupported is List) {
      supported = rawSupported.map((e) => (e as num).toInt()).toSet().toList()..sort();
    }

    return DisplaySpecsData(
      refreshRate: rr,
      supportedRefreshRates: supported,
      screenWidthPx: (map['screenWidthPx'] as num?)?.toInt() ?? 1080,
      screenHeightPx: (map['screenHeightPx'] as num?)?.toInt() ?? 2400,
      densityDpi: (map['densityDpi'] as num?)?.toInt() ?? 405,
      xdpi: (map['xdpi'] as num?)?.toDouble() ?? 405.0,
      ydpi: (map['ydpi'] as num?)?.toDouble() ?? 405.0,
      densityScale: (map['densityScale'] as num?)?.toDouble() ?? 2.625,
      isHdr: map['isHdr'] as bool? ?? false,
    );
  }

  String get formattedRefreshRate => "${refreshRate.round()} Hz";

  String get refreshRateCategory {
    final r = refreshRate.round();
    if (r >= 144) return "Ultra Gaming ($r Hz)";
    if (r >= 120) return "ProMotion ($r Hz)";
    if (r >= 90) return "Smooth Display ($r Hz)";
    return "Standard ($r Hz)";
  }

  String get resolutionString => "$screenWidthPx × $screenHeightPx px";

  String get densityBucket {
    if (densityDpi >= 560) return "xxxhdpi";
    if (densityDpi >= 400) return "xxhdpi";
    if (densityDpi >= 280) return "xhdpi";
    if (densityDpi >= 200) return "hdpi";
    if (densityDpi >= 140) return "mdpi";
    return "ldpi";
  }

  String get densityDpiString => "$densityDpi DPI ($densityBucket)";

  String get scaleString => "${densityScale.toStringAsFixed(2)}x";

  /// Calculates aspect ratio using Greatest Common Divisor (GCD)
  String get aspectRatioString {
    if (screenWidthPx <= 0 || screenHeightPx <= 0) return "20:9";
    int a = screenHeightPx;
    int b = screenWidthPx;
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    final gcd = a;
    final rH = screenHeightPx ~/ gcd;
    final rW = screenWidthPx ~/ gcd;

    // Normalizing common modern mobile phone aspect ratios
    final ratioVal = screenHeightPx / screenWidthPx;
    if ((ratioVal - 20 / 9).abs() < 0.05) return "20:9";
    if ((ratioVal - 19.5 / 9).abs() < 0.05) return "19.5:9";
    if ((ratioVal - 19 / 9).abs() < 0.05) return "19:9";
    if ((ratioVal - 18 / 9).abs() < 0.05) return "18:9 (2:1)";
    if ((ratioVal - 16 / 9).abs() < 0.05) return "16:9";

    return "$rH:$rW";
  }

  /// Calculates estimated physical screen diagonal size in inches
  String get screenDiagonalInches {
    final effXdpi = xdpi > 0 ? xdpi : densityDpi.toDouble();
    final effYdpi = ydpi > 0 ? ydpi : densityDpi.toDouble();
    if (effXdpi <= 0 || effYdpi <= 0) return "6.72\"";
    final wInches = screenWidthPx / effXdpi;
    final hInches = screenHeightPx / effYdpi;
    final diag = sqrt(wInches * wInches + hInches * hInches);
    return '${diag.toStringAsFixed(2)}"';
  }
}

class SensorChecklistItem {
  final String keyName;
  final String label;
  final String typeDescription;
  final bool isAvailable;
  final String hardwareName;

  const SensorChecklistItem({
    required this.keyName,
    required this.label,
    required this.typeDescription,
    required this.isAvailable,
    this.hardwareName = "",
  });
}

class SensorsCatalogData {
  final int totalSensorsCount;
  final bool hasGyroscope;
  final String gyroscopeName;
  final bool hasAccelerometer;
  final String accelerometerName;
  final bool hasMagnetometer;
  final String magnetometerName;
  final bool hasProximity;
  final String proximityName;
  final bool hasLightSensor;
  final String lightSensorName;
  final bool hasBarometer;
  final String barometerName;
  final bool hasGravity;
  final String gravityName;
  final bool hasStepCounter;
  final String stepCounterName;

  const SensorsCatalogData({
    this.totalSensorsCount = 0,
    this.hasGyroscope = false,
    this.gyroscopeName = '',
    this.hasAccelerometer = false,
    this.accelerometerName = '',
    this.hasMagnetometer = false,
    this.magnetometerName = '',
    this.hasProximity = false,
    this.proximityName = '',
    this.hasLightSensor = false,
    this.lightSensorName = '',
    this.hasBarometer = false,
    this.barometerName = '',
    this.hasGravity = false,
    this.gravityName = '',
    this.hasStepCounter = false,
    this.stepCounterName = '',
  });

  factory SensorsCatalogData.initial() {
    return const SensorsCatalogData();
  }

  factory SensorsCatalogData.fromMap(Map<dynamic, dynamic> map) {
    return SensorsCatalogData(
      totalSensorsCount: (map['totalSensorsCount'] as num?)?.toInt() ?? 0,
      hasGyroscope: map['hasGyroscope'] as bool? ?? false,
      gyroscopeName: map['gyroscopeName']?.toString() ?? '',
      hasAccelerometer: map['hasAccelerometer'] as bool? ?? false,
      accelerometerName: map['accelerometerName']?.toString() ?? '',
      hasMagnetometer: map['hasMagnetometer'] as bool? ?? false,
      magnetometerName: map['magnetometerName']?.toString() ?? '',
      hasProximity: map['hasProximity'] as bool? ?? false,
      proximityName: map['proximityName']?.toString() ?? '',
      hasLightSensor: map['hasLightSensor'] as bool? ?? false,
      lightSensorName: map['lightSensorName']?.toString() ?? '',
      hasBarometer: map['hasBarometer'] as bool? ?? false,
      barometerName: map['barometerName']?.toString() ?? '',
      hasGravity: map['hasGravity'] as bool? ?? false,
      gravityName: map['gravityName']?.toString() ?? '',
      hasStepCounter: map['hasStepCounter'] as bool? ?? false,
      stepCounterName: map['stepCounterName']?.toString() ?? '',
    );
  }

  List<SensorChecklistItem> get checklist => [
        SensorChecklistItem(
          keyName: "gyroscope",
          label: "Gyroscope",
          typeDescription: "Deteksi rotasi sumbu 3D & orientasi gaming",
          isAvailable: hasGyroscope,
          hardwareName: gyroscopeName,
        ),
        SensorChecklistItem(
          keyName: "accelerometer",
          label: "Accelerometer",
          typeDescription: "Percepatan gerak linier & tilt gesture",
          isAvailable: hasAccelerometer,
          hardwareName: accelerometerName,
        ),
        SensorChecklistItem(
          keyName: "magnetometer",
          label: "Magnetometer / Kompas",
          typeDescription: "Medan magnet bumi & navigasi peta arah",
          isAvailable: hasMagnetometer,
          hardwareName: magnetometerName,
        ),
        SensorChecklistItem(
          keyName: "proximity",
          label: "Proximity Sensor",
          typeDescription: "Sensor jarak objek / telinga saat panggilan",
          isAvailable: hasProximity,
          hardwareName: proximityName,
        ),
        SensorChecklistItem(
          keyName: "light",
          label: "Ambient Light Sensor",
          typeDescription: "Pengukur intensitas lux & auto-brightness",
          isAvailable: hasLightSensor,
          hardwareName: lightSensorName,
        ),
        SensorChecklistItem(
          keyName: "barometer",
          label: "Barometer / Altimeter",
          typeDescription: "Tekanan atmosfer & estimasi ketinggian (altitude)",
          isAvailable: hasBarometer,
          hardwareName: barometerName,
        ),
        SensorChecklistItem(
          keyName: "step_counter",
          label: "Step Counter (Pedometer)",
          typeDescription: "Penghitung langkah kaki real-time hardware",
          isAvailable: hasStepCounter,
          hardwareName: stepCounterName,
        ),
        SensorChecklistItem(
          keyName: "gravity",
          label: "Gravity Sensor",
          typeDescription: "Vektor percepatan gravitasi bumi terpisah",
          isAvailable: hasGravity,
          hardwareName: gravityName,
        ),
      ];

  int get availableSensorsCount =>
      checklist.where((item) => item.isAvailable).length;
}
