package com.naltech.project_clone

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.naltech.project_clone/device_diagnostics"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceDiagnostics" -> {
                    try {
                        // 1. Battery Telemetry directly from Android System APIs
                        val (batteryPct, stateStr) = getLiveBatteryInfo(context)

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

                        // 5. Real Firmware & Hardware Properties from Build
                        val data = mapOf(
                            "level" to batteryPct,
                            "state" to stateStr,
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
                        result.success(data)
                    } catch (e: Exception) {
                        result.error("DIAGNOSTICS_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getLiveBatteryInfo(ctx: Context): Pair<Int, String> {
        var batteryPct = -1
        var stateStr = "discharging"

        // Step 1: Standard registerReceiver without flags (official Android sticky query for ACTION_BATTERY_CHANGED)
        try {
            val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            val stickyIntent = ctx.registerReceiver(null, filter)
            if (stickyIntent != null) {
                val level = stickyIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                val scale = stickyIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                if (level >= 0 && scale > 0) {
                    batteryPct = (level * 100) / scale
                }
                val status = stickyIntent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                val plugged = stickyIntent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
                val isCharging = plugged > 0 || status == BatteryManager.BATTERY_STATUS_CHARGING
                stateStr = when {
                    status == BatteryManager.BATTERY_STATUS_FULL -> "full"
                    isCharging -> "charging"
                    else -> "discharging"
                }
            }
        } catch (t: Throwable) {
            android.util.Log.w("DeviceDiagnostics", "Sticky receiver failed: ${t.message}")
        }

        // Step 2: Try applicationContext if activity context returned null
        if (batteryPct < 0) {
            try {
                val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                val stickyIntent = applicationContext.registerReceiver(null, filter)
                if (stickyIntent != null) {
                    val level = stickyIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                    val scale = stickyIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                    if (level >= 0 && scale > 0) {
                        batteryPct = (level * 100) / scale
                    }
                    val status = stickyIntent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                    val plugged = stickyIntent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
                    val isCharging = plugged > 0 || status == BatteryManager.BATTERY_STATUS_CHARGING
                    stateStr = when {
                        status == BatteryManager.BATTERY_STATUS_FULL -> "full"
                        isCharging -> "charging"
                        else -> "discharging"
                    }
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
                    val level = finalIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                    val scale = finalIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                    if (level >= 0 && scale > 0) {
                        batteryPct = (level * 100) / scale
                    }
                    val status = finalIntent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                    val plugged = finalIntent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
                    val isCharging = plugged > 0 || status == BatteryManager.BATTERY_STATUS_CHARGING
                    stateStr = when {
                        status == BatteryManager.BATTERY_STATUS_FULL -> "full"
                        isCharging -> "charging"
                        else -> "discharging"
                    }
                }
                try {
                    ctx.unregisterReceiver(tempReceiver)
                } catch (_: Throwable) {}
            } catch (t: Throwable) {
                android.util.Log.w("DeviceDiagnostics", "Dynamic receiver failed: ${t.message}")
            }
        }

        // Step 5: Android sysfs kernel paths
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

        android.util.Log.i("DeviceDiagnostics", "Live Battery resolved: level=$batteryPct, state=$stateStr")
        return Pair(batteryPct, stateStr)
    }
}
