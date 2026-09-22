package com.naltech.project_clone

import android.app.ActivityManager
import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.PowerManager
import android.os.Process
import android.os.StatFs
import android.provider.Settings
import android.util.DisplayMetrics
import android.view.Display
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.net.NetworkInterface

data class BatteryDiagnosticsData(
    val level: Int,
    val state: String,
    val temperatureCelsius: Double,
    val health: String,
    val technology: String,
    val voltageMv: Int,
    val isPowerSaveMode: Boolean
)

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.naltech.project_clone/device_diagnostics"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceDiagnostics" -> {
                    try {
                        // 1. Comprehensive Battery & Thermal Telemetry directly from Android System APIs
                        val batteryData = getLiveBatteryInfo(context)

                        // 2. Real Package Info directly from PackageManager
                        var appVersionStr = "1.0.0"
                        try {
                            val pInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                context.packageManager.getPackageInfo(
                                    context.packageName,
                                    PackageManager.PackageInfoFlags.of(0)
                                )
                            } else {
                                @Suppress("DEPRECATION")
                                context.packageManager.getPackageInfo(context.packageName, 0)
                            }
                            val vName = pInfo.versionName ?: "1.0.0"
                            val vCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                                pInfo.longVersionCode
                            } else {
                                @Suppress("DEPRECATION")
                                pInfo.versionCode.toLong()
                            }
                            appVersionStr = "$vName+$vCode"
                        } catch (e: Exception) {
                            // ignore
                        }

                        // 3. Real Available & Total Internal Storage of Phone
                        var availableStorageBytes: Long = 0L
                        var totalStorageBytes: Long = 0L
                        try {
                            val dataDir = Environment.getDataDirectory()
                            val statFs = StatFs(dataDir.path)
                            availableStorageBytes = statFs.availableBlocksLong * statFs.blockSizeLong
                            totalStorageBytes = statFs.blockCountLong * statFs.blockSizeLong
                        } catch (e: Exception) {
                            // ignore
                        }

                        // 4. Real Available & Total RAM of Phone
                        var availableRamBytes: Long = 0L
                        var totalRamBytes: Long = 0L
                        try {
                            val actManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                            val memInfo = ActivityManager.MemoryInfo()
                            actManager.getMemoryInfo(memInfo)
                            availableRamBytes = memInfo.availMem
                            totalRamBytes = memInfo.totalMem
                        } catch (e: Exception) {
                            // ignore
                        }

                        // 5. Security & Anti-Fraud Telemetry
                        val isMockLocation = checkIsMockLocation(context)
                        val isEmulator = checkIsEmulator()
                        val (hasBiometric, isBiometricEnrolled) = checkBiometricStatus(context)
                        val isVpnActive = checkIsVpnActive(context)

                        // 6. Display & Screen Specifications
                        val displayData = getDisplaySpecs(context)

                        // 7. Hardware Sensors Catalog Telemetry
                        val sensorsData = getSensorsCatalog(context)

                        // 8. Real Firmware & Hardware Properties from Build
                        val data = mutableMapOf<String, Any>(
                            "level" to batteryData.level,
                            "state" to batteryData.state,
                            "temperatureCelsius" to batteryData.temperatureCelsius,
                            "batteryHealth" to batteryData.health,
                            "batteryTechnology" to batteryData.technology,
                            "batteryVoltageMv" to batteryData.voltageMv,
                            "isPowerSaveMode" to batteryData.isPowerSaveMode,
                            "isMockLocation" to isMockLocation,
                            "isEmulator" to isEmulator,
                            "hasBiometricHardware" to hasBiometric,
                            "isBiometricEnrolled" to isBiometricEnrolled,
                            "isVpnActive" to isVpnActive,
                            "model" to Build.MODEL,
                            "brand" to Build.BRAND,
                            "manufacturer" to Build.MANUFACTURER,
                            "device" to Build.DEVICE,
                            "product" to Build.PRODUCT,
                            "hardware" to Build.HARDWARE,
                            "board" to Build.BOARD,
                            "osVersion" to ("Android " + Build.VERSION.RELEASE + " (API " + Build.VERSION.SDK_INT + ")"),
                            "osBuild" to Build.DISPLAY,
                            "fingerprint" to Build.FINGERPRINT,
                            "appVersion" to appVersionStr,
                            "availableStorageBytes" to availableStorageBytes,
                            "totalStorageBytes" to totalStorageBytes,
                            "availableRamBytes" to availableRamBytes,
                            "totalRamBytes" to totalRamBytes
                        )
                        data.putAll(displayData)
                        data.putAll(sensorsData)
                        result.success(data)
                    } catch (e: Exception) {
                        result.error("DIAGNOSTICS_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getLiveBatteryInfo(ctx: Context): BatteryDiagnosticsData {
        var batteryPct = -1
        var stateStr = "discharging"
        var tempCelsius = 32.0
        var healthStr = "good"
        var techStr = "Li-ion"
        var voltageMv = 4000

        // Parse battery data from an Intent
        fun parseIntentData(intent: Intent) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            if (level >= 0 && scale > 0) {
                batteryPct = (level * 100) / scale
            }
            val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            val plugged = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
            val isCharging = plugged > 0 || status == BatteryManager.BATTERY_STATUS_CHARGING
            stateStr = when {
                status == BatteryManager.BATTERY_STATUS_FULL -> "full"
                isCharging -> "charging"
                else -> "discharging"
            }

            // Temperature in tenths of degree Celsius (e.g. 342 -> 34.2 °C)
            val rawTemp = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
            if (rawTemp > 0) {
                tempCelsius = rawTemp / 10.0
            }

            // Battery Health
            val rawHealth = intent.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_UNKNOWN)
            healthStr = when (rawHealth) {
                BatteryManager.BATTERY_HEALTH_GOOD -> "good"
                BatteryManager.BATTERY_HEALTH_OVERHEAT -> "overheat"
                BatteryManager.BATTERY_HEALTH_DEAD -> "dead"
                BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "over_voltage"
                BatteryManager.BATTERY_HEALTH_COLD -> "cold"
                BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "failure"
                else -> "good"
            }

            // Technology
            val rawTech = intent.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY)
            if (!rawTech.isNullOrBlank()) {
                techStr = rawTech
            }

            // Voltage in mV
            val rawVolt = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0)
            if (rawVolt > 0) {
                voltageMv = rawVolt
            }
        }

        // Step 1: Standard sticky receiver
        try {
            val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            val stickyIntent = ctx.registerReceiver(null, filter)
            if (stickyIntent != null) {
                parseIntentData(stickyIntent)
            }
        } catch (t: Throwable) {
            android.util.Log.w("DeviceDiagnostics", "Sticky receiver failed: ${t.message}")
        }

        // Step 2: Application Context sticky query
        if (batteryPct < 0) {
            try {
                val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                val stickyIntent = applicationContext.registerReceiver(null, filter)
                if (stickyIntent != null) {
                    parseIntentData(stickyIntent)
                }
            } catch (t: Throwable) {
                android.util.Log.w("DeviceDiagnostics", "AppContext sticky receiver failed: ${t.message}")
            }
        }

        // Step 3: Direct BatteryManager system service
        try {
            val bm = getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
            if (bm != null) {
                if (batteryPct < 0) {
                    val cap = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                    if (cap in 0..100) {
                        batteryPct = cap
                    }
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (bm.isCharging && stateStr != "full") {
                        stateStr = "charging"
                    }
                }
            }
        } catch (t: Throwable) {
            android.util.Log.w("DeviceDiagnostics", "BatteryManager failed: ${t.message}")
        }

        // Step 4: Register short-lived dynamic receiver with RECEIVER_EXPORTED on API 33+
        if (batteryPct < 0) {
            try {
                val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                var receivedIntent: Intent? = null
                val tempReceiver = object : android.content.BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        receivedIntent = intent
                    }
                }
                val registeredIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    ctx.registerReceiver(tempReceiver, filter, Context.RECEIVER_EXPORTED)
                } else {
                    ctx.registerReceiver(tempReceiver, filter)
                }
                val finalIntent = receivedIntent ?: registeredIntent
                if (finalIntent != null) {
                    parseIntentData(finalIntent)
                }
                try {
                    ctx.unregisterReceiver(tempReceiver)
                } catch (_: Throwable) {}
            } catch (t: Throwable) {
                android.util.Log.w("DeviceDiagnostics", "Dynamic receiver failed: ${t.message}")
            }
        }

        // Step 5: Android sysfs kernel paths fallback
        if (batteryPct < 0) {
            val paths = listOf(
                "/sys/class/power_supply/battery/capacity",
                "/sys/class/power_supply/battery/batt_soc",
                "/sys/class/power_supply/bms/capacity",
                "/sys/devices/platform/battery/power_supply/battery/capacity"
            )
            for (p in paths) {
                try {
                    val f = java.io.File(p)
                    if (f.exists() && f.canRead()) {
                        val txt = f.readText().trim()
                        val parsed = txt.toIntOrNull()
                        if (parsed != null && parsed in 0..100) {
                            batteryPct = parsed
                            break
                        }
                    }
                } catch (_: Throwable) {}
            }
        }

        // Sysfs temperature fallback if needed
        if (tempCelsius == 32.0) {
            val tempPaths = listOf(
                "/sys/class/power_supply/battery/temp",
                "/sys/class/power_supply/battery/batt_temp",
                "/sys/class/thermal/thermal_zone0/temp"
            )
            for (tp in tempPaths) {
                try {
                    val f = java.io.File(tp)
                    if (f.exists() && f.canRead()) {
                        val txt = f.readText().trim()
                        val parsed = txt.toDoubleOrNull()
                        if (parsed != null && parsed > 0) {
                            tempCelsius = if (parsed > 1000) parsed / 1000.0 else parsed / 10.0
                            break
                        }
                    }
                } catch (_: Throwable) {}
            }
        }

        // 6. Power Manager: Check Battery Saver Mode (Power Save Mode)
        var isPowerSaveMode = false
        try {
            val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
            if (powerManager != null) {
                isPowerSaveMode = powerManager.isPowerSaveMode
            }
        } catch (t: Throwable) {
            android.util.Log.w("DeviceDiagnostics", "PowerManager check failed: ${t.message}")
        }

        android.util.Log.i(
            "DeviceDiagnostics",
            "Live Battery resolved: level=$batteryPct, state=$stateStr, temp=${tempCelsius}C, health=$healthStr, tech=$techStr, powerSave=$isPowerSaveMode"
        )

        return BatteryDiagnosticsData(
            level = batteryPct,
            state = stateStr,
            temperatureCelsius = tempCelsius,
            health = healthStr,
            technology = techStr,
            voltageMv = voltageMv,
            isPowerSaveMode = isPowerSaveMode
        )
    }

    // 1. Detect Fake GPS / Mock Location Providers
    private fun checkIsMockLocation(ctx: Context): Boolean {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val appOps = ctx.getSystemService(Context.APP_OPS_SERVICE) as? AppOpsManager
                if (appOps != null) {
                    val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        appOps.unsafeCheckOpNoThrow(
                            AppOpsManager.OPSTR_MOCK_LOCATION,
                            Process.myUid(),
                            ctx.packageName
                        )
                    } else {
                        @Suppress("DEPRECATION")
                        appOps.checkOpNoThrow(
                            AppOpsManager.OPSTR_MOCK_LOCATION,
                            Process.myUid(),
                            ctx.packageName
                        )
                    }
                    if (mode == AppOpsManager.MODE_ALLOWED) return true
                }
            } else {
                @Suppress("DEPRECATION")
                val allowMock = Settings.Secure.getInt(
                    ctx.contentResolver,
                    Settings.Secure.ALLOW_MOCK_LOCATION,
                    0
                )
                if (allowMock != 0) return true
            }
        } catch (_: Throwable) {}
        return false
    }

    // 2. Multi-Vector Emulator / Virtual Device Detection
    private fun checkIsEmulator(): Boolean {
        try {
            val buildProps = listOf(
                Build.FINGERPRINT.startsWith("generic"),
                Build.FINGERPRINT.startsWith("unknown"),
                Build.FINGERPRINT.contains("vbox"),
                Build.FINGERPRINT.contains("generic_x86"),
                Build.MODEL.contains("google_sdk"),
                Build.MODEL.contains("Emulator"),
                Build.MODEL.contains("Android SDK built for x86"),
                Build.MANUFACTURER.contains("Genymotion"),
                Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"),
                Build.PRODUCT == "google_sdk",
                Build.PRODUCT.contains("vbox86p"),
                Build.PRODUCT.contains("emulator"),
                Build.PRODUCT.contains("simulator"),
                Build.HARDWARE.contains("goldfish"),
                Build.HARDWARE.contains("ranchu"),
                Build.HARDWARE.contains("vbox86"),
                Build.BOARD.contains("goldfish")
            )
            if (buildProps.any { it }) return true

            // Common Emulator Files
            val qemuFiles = listOf(
                "/dev/socket/qemud",
                "/dev/qemu_pipe",
                "/system/lib/libc_malloc_debug_qemu.so",
                "/sys/qemu_trace",
                "/system/bin/nox-prop",
                "/system/bin/ttVM-prop",
                "/data/data/com.bluestacks.home"
            )
            for (p in qemuFiles) {
                if (File(p).exists()) return true
            }
        } catch (_: Throwable) {}
        return false
    }

    // 3. Biometric Hardware & Enrollment Status (Fingerprint / Face Unlock)
    private fun checkBiometricStatus(ctx: Context): Pair<Boolean, Boolean> {
        var hasHardware = false
        var isEnrolled = false
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val bm = ctx.getSystemService(android.hardware.biometrics.BiometricManager::class.java)
                if (bm != null) {
                    val canAuth = bm.canAuthenticate(
                        android.hardware.biometrics.BiometricManager.Authenticators.BIOMETRIC_STRONG or
                        android.hardware.biometrics.BiometricManager.Authenticators.BIOMETRIC_WEAK
                    )
                    when (canAuth) {
                        android.hardware.biometrics.BiometricManager.BIOMETRIC_SUCCESS -> {
                            hasHardware = true
                            isEnrolled = true
                        }
                        android.hardware.biometrics.BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> {
                            hasHardware = true
                            isEnrolled = false
                        }
                        android.hardware.biometrics.BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> {
                            hasHardware = false
                            isEnrolled = false
                        }
                        else -> {
                            hasHardware = ctx.packageManager.hasSystemFeature(PackageManager.FEATURE_FINGERPRINT) ||
                                          ctx.packageManager.hasSystemFeature(PackageManager.FEATURE_FACE)
                        }
                    }
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                @Suppress("DEPRECATION")
                val fm = ctx.getSystemService(Context.FINGERPRINT_SERVICE) as? android.hardware.fingerprint.FingerprintManager
                if (fm != null) {
                    hasHardware = fm.isHardwareDetected
                    isEnrolled = fm.hasEnrolledFingerprints()
                }
            }
        } catch (_: Throwable) {
            hasHardware = ctx.packageManager.hasSystemFeature(PackageManager.FEATURE_FINGERPRINT)
        }
        return Pair(hasHardware, isEnrolled)
    }

    // 4. Detect Active VPN or Tunnel Connections
    private fun checkIsVpnActive(ctx: Context): Boolean {
        try {
            val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
            if (cm != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val activeNetwork = cm.activeNetwork
                    if (activeNetwork != null) {
                        val caps = cm.getNetworkCapabilities(activeNetwork)
                        if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
                            return true
                        }
                    }
                } else {
                    @Suppress("DEPRECATION")
                    val networks = cm.allNetworks
                    for (net in networks) {
                        val caps = cm.getNetworkCapabilities(net)
                        if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
                            return true
                        }
                    }
                }
            }

            // Interface name verification fallback
            val interfaces = NetworkInterface.getNetworkInterfaces()
            while (interfaces.hasMoreElements()) {
                val iface = interfaces.nextElement()
                if (iface.isUp) {
                    val name = iface.name.lowercase()
                    if (name.startsWith("tun") || name.startsWith("ppp") || name.startsWith("p2p") || name.startsWith("tap")) {
                        return true
                    }
                }
            }
        } catch (_: Throwable) {}
        return false
    }

    // 5. Display & Screen Specifications
    private fun getDisplaySpecs(ctx: Context): Map<String, Any> {
        var refreshRate = 60.0f
        var supportedRefreshRates = listOf(60)
        var widthPx = 1080
        var heightPx = 2400
        var densityDpi = 405
        var xdpi = 405.0f
        var ydpi = 405.0f
        var densityScale = 2.625f
        var isHdr = false

        try {
            val wm = ctx.getSystemService(Context.WINDOW_SERVICE) as? WindowManager
            val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                ctx.display
            } else {
                @Suppress("DEPRECATION")
                wm?.defaultDisplay
            }

            if (display != null) {
                refreshRate = display.refreshRate
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    val modes = display.supportedModes
                    if (modes != null && modes.isNotEmpty()) {
                        supportedRefreshRates = modes.map { it.refreshRate.toInt() }.distinct().sorted()
                    }
                } else {
                    supportedRefreshRates = listOf(refreshRate.toInt())
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val hdrCaps = display.hdrCapabilities
                    if (hdrCaps != null && hdrCaps.supportedHdrTypes.isNotEmpty()) {
                        isHdr = true
                    }
                }
            }

            val dm = DisplayMetrics()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                @Suppress("DEPRECATION")
                display?.getRealMetrics(dm)
            } else {
                @Suppress("DEPRECATION")
                display?.getMetrics(dm)
            }

            if (dm.widthPixels > 0 && dm.heightPixels > 0) {
                widthPx = dm.widthPixels
                heightPx = dm.heightPixels
                densityDpi = dm.densityDpi
                xdpi = dm.xdpi
                ydpi = dm.ydpi
                densityScale = dm.density
            } else {
                val resDm = ctx.resources.displayMetrics
                widthPx = resDm.widthPixels
                heightPx = resDm.heightPixels
                densityDpi = resDm.densityDpi
                xdpi = resDm.xdpi
                ydpi = resDm.ydpi
                densityScale = resDm.density
            }
        } catch (_: Throwable) {}

        return mapOf(
            "refreshRate" to refreshRate.toDouble(),
            "supportedRefreshRates" to supportedRefreshRates,
            "screenWidthPx" to widthPx,
            "screenHeightPx" to heightPx,
            "densityDpi" to densityDpi,
            "xdpi" to xdpi.toDouble(),
            "ydpi" to ydpi.toDouble(),
            "densityScale" to densityScale.toDouble(),
            "isHdr" to isHdr
        )
    }

    // 6. Hardware Sensors Catalog Telemetry
    private fun getSensorsCatalog(ctx: Context): Map<String, Any> {
        var totalCount = 0
        var hasGyro = false
        var gyroName = ""
        var hasAccel = false
        var accelName = ""
        var hasMag = false
        var magName = ""
        var hasProx = false
        var proxName = ""
        var hasLight = false
        var lightName = ""
        var hasBaro = false
        var baroName = ""
        var hasGravity = false
        var gravName = ""
        var hasStepCounter = false
        var stepName = ""

        try {
            val sm = ctx.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
            if (sm != null) {
                val allList = sm.getSensorList(Sensor.TYPE_ALL)
                totalCount = allList.size

                val sGyro = sm.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
                if (sGyro != null) {
                    hasGyro = true
                    gyroName = sGyro.name ?: ""
                }

                val sAccel = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
                if (sAccel != null) {
                    hasAccel = true
                    accelName = sAccel.name ?: ""
                }

                val sMag = sm.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
                if (sMag != null) {
                    hasMag = true
                    magName = sMag.name ?: ""
                }

                val sProx = sm.getDefaultSensor(Sensor.TYPE_PROXIMITY)
                if (sProx != null) {
                    hasProx = true
                    proxName = sProx.name ?: ""
                }

                val sLight = sm.getDefaultSensor(Sensor.TYPE_LIGHT)
                if (sLight != null) {
                    hasLight = true
                    lightName = sLight.name ?: ""
                }

                val sBaro = sm.getDefaultSensor(Sensor.TYPE_PRESSURE)
                if (sBaro != null) {
                    hasBaro = true
                    baroName = sBaro.name ?: ""
                }

                val sGrav = sm.getDefaultSensor(Sensor.TYPE_GRAVITY)
                if (sGrav != null) {
                    hasGravity = true
                    gravName = sGrav.name ?: ""
                }

                val sStep = sm.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
                if (sStep != null) {
                    hasStepCounter = true
                    stepName = sStep.name ?: ""
                }
            }
        } catch (_: Throwable) {}

        return mapOf(
            "totalSensorsCount" to totalCount,
            "hasGyroscope" to hasGyro,
            "gyroscopeName" to gyroName,
            "hasAccelerometer" to hasAccel,
            "accelerometerName" to accelName,
            "hasMagnetometer" to hasMag,
            "magnetometerName" to magName,
            "hasProximity" to hasProx,
            "proximityName" to proxName,
            "hasLightSensor" to hasLight,
            "lightSensorName" to lightName,
            "hasBarometer" to hasBaro,
            "barometerName" to baroName,
            "hasGravity" to hasGravity,
            "gravityName" to gravName,
            "hasStepCounter" to hasStepCounter,
            "stepCounterName" to stepName
        )
    }
}
