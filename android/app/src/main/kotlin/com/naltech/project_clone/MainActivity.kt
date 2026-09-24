package com.naltech.project_clone

import android.app.ActivityManager
import android.app.AppOpsManager
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.hardware.Sensor
import android.hardware.SensorManager
import android.location.Geocoder
import android.location.Location
import android.location.LocationManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.PowerManager
import android.os.Process
import android.os.StatFs
import android.provider.Settings
import android.telephony.TelephonyManager
import android.util.DisplayMetrics
import android.view.Display
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.File
import java.io.FileOutputStream
import java.io.InputStreamReader
import java.net.NetworkInterface
import java.util.Locale

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
    private var pendingPermissionResult: MethodChannel.Result? = null
    private val PERMISSION_REQUEST_CODE = 9911
    private var latestLiveLocation: Location? = null

    private val locationListener = object : android.location.LocationListener {
        override fun onLocationChanged(loc: Location) {
            if (latestLiveLocation == null || loc.accuracy <= (latestLiveLocation?.accuracy ?: Float.MAX_VALUE)) {
                latestLiveLocation = loc
            }
        }
        override fun onProviderEnabled(provider: String) {}
        override fun onProviderDisabled(provider: String) {}
        @Deprecated("Deprecated in Java")
        override fun onStatusChanged(provider: String?, status: Int, extras: android.os.Bundle?) {}
    }

    private fun startLocationListening() {
        try {
            val hasFine = ContextCompat.checkSelfPermission(
                this, android.Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
            val hasCoarse = ContextCompat.checkSelfPermission(
                this, android.Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
            if (hasFine || hasCoarse) {
                val lm = getSystemService(Context.LOCATION_SERVICE) as? LocationManager ?: return
                if (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                    lm.requestLocationUpdates(
                        LocationManager.GPS_PROVIDER,
                        1000L,
                        0.5f,
                        locationListener,
                        android.os.Looper.getMainLooper()
                    )
                }
                if (lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
                    lm.requestLocationUpdates(
                        LocationManager.NETWORK_PROVIDER,
                        2000L,
                        1.0f,
                        locationListener,
                        android.os.Looper.getMainLooper()
                    )
                }
            }
        } catch (_: Throwable) {}
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            val fineGranted = ContextCompat.checkSelfPermission(
                this, android.Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
            val coarseGranted = ContextCompat.checkSelfPermission(
                this, android.Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
            val cameraGranted = ContextCompat.checkSelfPermission(
                this, android.Manifest.permission.CAMERA
            ) == PackageManager.PERMISSION_GRANTED

            val lm = getSystemService(Context.LOCATION_SERVICE) as? LocationManager
            val isGpsEnabled = lm?.isProviderEnabled(LocationManager.GPS_PROVIDER) ?: false
            val isNetworkLocEnabled = lm?.isProviderEnabled(LocationManager.NETWORK_PROVIDER) ?: false

            if (fineGranted || coarseGranted) {
                startLocationListening()
            }

            val response = mapOf(
                "fineLocationGranted" to fineGranted,
                "coarseLocationGranted" to coarseGranted,
                "cameraGranted" to cameraGranted,
                "isLocationGranted" to (fineGranted || coarseGranted),
                "isGpsEnabled" to isGpsEnabled,
                "isNetworkLocEnabled" to isNetworkLocEnabled
            )
            pendingPermissionResult?.success(response)
            pendingPermissionResult = null
        }
    }

    override fun onResume() {
        super.onResume()
        startLocationListening()
    }

    override fun onPause() {
        super.onPause()
        try {
            val lm = getSystemService(Context.LOCATION_SERVICE) as? LocationManager
            lm?.removeUpdates(locationListener)
        } catch (_: Throwable) {}
    }

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

                        // 8. Location, Geotagging & Cellular Carrier Telemetry
                        val locationCarrierData = getLocationAndCarrierData(context)

                        // 9. Real Firmware & Hardware Properties from Build
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
                        data.putAll(locationCarrierData)
                        result.success(data)
                    } catch (e: Exception) {
                        result.error("DIAGNOSTICS_ERROR", e.message, null)
                    }
                }
                "insertGeotagPhoto" -> {
                    try {
                        val originalPath = call.argument<String>("originalPath") ?: ""
                        val compressedPath = call.argument<String>("compressedPath") ?: ""
                        val originalSize = (call.argument<Number>("originalSize") ?: 0L).toLong()
                        val compressedSize = (call.argument<Number>("compressedSize") ?: 0L).toLong()
                        val timestamp = (call.argument<Number>("timestamp") ?: System.currentTimeMillis()).toLong()
                        val latitude = (call.argument<Number>("latitude") ?: 0.0).toDouble()
                        val longitude = (call.argument<Number>("longitude") ?: 0.0).toDouble()
                        val altitude = (call.argument<Number>("altitude") ?: 0.0).toDouble()
                        val accuracy = (call.argument<Number>("accuracy") ?: 0.0).toDouble()
                        val address = call.argument<String>("address") ?: ""
                        val carrier = call.argument<String>("carrier") ?: ""

                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val id = dbHelper.insertPhoto(
                            originalPath, compressedPath, originalSize, compressedSize,
                            timestamp, latitude, longitude, altitude, accuracy, address, carrier
                        )
                        result.success(id)
                    } catch (e: Exception) {
                        result.error("SQLITE_INSERT_ERROR", e.message, null)
                    }
                }
                "getAllGeotagPhotos" -> {
                    try {
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val list = dbHelper.getAllPhotos()
                        result.success(list)
                    } catch (e: Exception) {
                        result.error("SQLITE_QUERY_ERROR", e.message, null)
                    }
                }
                "deleteGeotagPhoto" -> {
                    try {
                        val id = (call.argument<Number>("id") ?: 0L).toLong()
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val rows = dbHelper.deletePhoto(id)
                        result.success(rows > 0)
                    } catch (e: Exception) {
                        result.error("SQLITE_DELETE_ERROR", e.message, null)
                    }
                }
                "getGeotagPhotoStats" -> {
                    try {
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val stats = dbHelper.getStats()
                        result.success(stats)
                    } catch (e: Exception) {
                        result.error("SQLITE_STATS_ERROR", e.message, null)
                    }
                }
                "insertScreenTimeSession" -> {
                    try {
                        val sessionId = call.argument<String>("sessionId") ?: ""
                        val date = call.argument<String>("date") ?: ""
                        val sessionStartMs = (call.argument<Number>("sessionStartMs") ?: System.currentTimeMillis()).toLong()
                        val sessionEndMs = (call.argument<Number>("sessionEndMs") ?: System.currentTimeMillis()).toLong()
                        val durationSeconds = (call.argument<Number>("durationSeconds") ?: 0).toInt()
                        val pageBreakdownJson = call.argument<String>("pageBreakdownJson") ?: "{}"
                        val batteryConsumed = (call.argument<Number>("batteryConsumed") ?: 0).toInt()
                        val isSynced = call.argument<Boolean>("isSynced") ?: false

                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val id = dbHelper.insertScreenTimeSession(
                            sessionId, date, sessionStartMs, sessionEndMs, durationSeconds,
                            pageBreakdownJson, batteryConsumed, isSynced
                        )
                        result.success(id)
                    } catch (e: Exception) {
                        result.error("SQLITE_SCREEN_TIME_INSERT_ERROR", e.message, null)
                    }
                }
                "getAllScreenTimeSessions" -> {
                    try {
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val list = dbHelper.getAllScreenTimeSessions()
                        result.success(list)
                    } catch (e: Exception) {
                        result.error("SQLITE_SCREEN_TIME_QUERY_ERROR", e.message, null)
                    }
                }
                "markScreenTimeSessionsSynced" -> {
                    try {
                        val sessionIds = call.argument<List<String>>("sessionIds") ?: emptyList()
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val updated = dbHelper.markScreenTimeSessionsSynced(sessionIds)
                        result.success(updated)
                    } catch (e: Exception) {
                        result.error("SQLITE_SCREEN_TIME_SYNC_ERROR", e.message, null)
                    }
                }
                "getScreenTimeDailyStats" -> {
                    try {
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val stats = dbHelper.getScreenTimeDailyStats()
                        result.success(stats)
                    } catch (e: Exception) {
                        result.error("SQLITE_SCREEN_TIME_STATS_ERROR", e.message, null)
                    }
                }
                "compressImage" -> {
                    try {
                        val inputPath = call.argument<String>("inputPath") ?: ""
                        val outputPath = call.argument<String>("outputPath") ?: ""
                        val targetWidth = call.argument<Int>("targetWidth") ?: 1280
                        val quality = call.argument<Int>("quality") ?: 75

                        val inputFile = File(inputPath)
                        if (!inputFile.exists()) {
                            result.error("FILE_NOT_FOUND", "Input file does not exist", null)
                            return@setMethodCallHandler
                        }

                        val bitmap = BitmapFactory.decodeFile(inputPath)
                        if (bitmap == null) {
                            result.error("DECODE_ERROR", "Failed to decode image bitmap", null)
                            return@setMethodCallHandler
                        }

                        val scaledBitmap = if (bitmap.width > targetWidth) {
                            val targetHeight = (bitmap.height.toFloat() / bitmap.width.toFloat() * targetWidth).toInt()
                            Bitmap.createScaledBitmap(bitmap, targetWidth, targetHeight, true)
                        } else {
                            bitmap
                        }

                        val outFile = if (outputPath.isNotEmpty()) File(outputPath) else {
                            File(applicationContext.cacheDir, "geotag_compressed_${System.currentTimeMillis()}.jpg")
                        }
                        outFile.parentFile?.mkdirs()

                        val fos = FileOutputStream(outFile)
                        scaledBitmap.compress(Bitmap.CompressFormat.JPEG, quality, fos)
                        fos.flush()
                        fos.close()

                        val origSize = inputFile.length()
                        val compSize = outFile.length()

                        val resultMap = HashMap<String, Any>()
                        resultMap["path"] = outFile.absolutePath
                        resultMap["originalSize"] = origSize
                        resultMap["compressedSize"] = compSize
                        val saved = if (origSize > compSize) origSize - compSize else 0L
                        resultMap["savingsPercent"] = if (origSize > 0) (saved.toFloat() / origSize.toFloat() * 100f) else 0f

                        result.success(resultMap)
                    } catch (e: Exception) {
                        result.error("COMPRESSION_ERROR", e.message, null)
                    }
                }
                "saveImageToGallery" -> {
                    try {
                        val imagePath = call.argument<String>("imagePath") ?: ""
                        val title = call.argument<String>("title") ?: "geotag_${System.currentTimeMillis()}"
                        val description = call.argument<String>("description") ?: "Geotagged Photo"

                        val srcFile = File(imagePath)
                        if (!srcFile.exists()) {
                            result.error("FILE_NOT_FOUND", "Source image file not found", null)
                            return@setMethodCallHandler
                        }

                        val resolver = applicationContext.contentResolver
                        val contentValues = ContentValues().apply {
                            put(android.provider.MediaStore.Images.Media.DISPLAY_NAME, "${title}.jpg")
                            put(android.provider.MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                            put(android.provider.MediaStore.Images.Media.DESCRIPTION, description)
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                put(android.provider.MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Geotagging")
                                put(android.provider.MediaStore.Images.Media.IS_PENDING, 1)
                            }
                        }

                        val uri = resolver.insert(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
                        if (uri != null) {
                            resolver.openOutputStream(uri)?.use { out ->
                                srcFile.inputStream().use { input ->
                                    input.copyTo(out)
                                }
                                out.flush()
                            }

                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                contentValues.clear()
                                contentValues.put(android.provider.MediaStore.Images.Media.IS_PENDING, 0)
                                resolver.update(uri, contentValues, null, null)
                            }

                            // Trigger MediaScanner
                            android.media.MediaScannerConnection.scanFile(
                                applicationContext,
                                arrayOf(srcFile.absolutePath),
                                arrayOf("image/jpeg"),
                                null
                            )

                            result.success(mapOf(
                                "success" to true,
                                "uri" to uri.toString(),
                                "album" to "Pictures/Geotagging"
                            ))
                        } else {
                            result.error("GALLERY_ERROR", "Failed to create MediaStore entry", null)
                        }
                    } catch (e: Exception) {
                        result.error("GALLERY_SAVE_ERROR", e.message, null)
                    }
                }
                "updateGeotagCloudSync" -> {
                    try {
                        val id = (call.argument<Number>("id") ?: 0L).toLong()
                        val cloudUrl = call.argument<String>("cloudUrl") ?: ""
                        val cloudProvider = call.argument<String>("cloudProvider") ?: "cloud"
                        val dbHelper = GeotagSqliteHelper.getInstance(applicationContext)
                        val ok = dbHelper.updateCloudSync(id, cloudUrl, cloudProvider)
                        result.success(ok)
                    } catch (e: Exception) {
                        result.error("SQLITE_CLOUD_UPDATE_ERROR", e.message, null)
                    }
                }
                "checkBiometrics" -> {
                    val (hasBio, isEnrolled) = checkBiometricStatus(applicationContext)
                    result.success(mapOf(
                        "hasHardware" to hasBio,
                        "isEnrolled" to isEnrolled,
                        "hasBiometricHardware" to hasBio,
                        "isBiometricEnrolled" to isEnrolled
                    ))
                }
                "authenticateBiometric" -> {
                    val title = call.argument<String>("title") ?: "Autentikasi Biometrik"
                    val subtitle = call.argument<String>("subtitle") ?: "Verifikasi sidik jari atau wajah untuk melanjutkan"
                    val description = call.argument<String>("description") ?: ""

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        try {
                            val executor = ContextCompat.getMainExecutor(this)
                            val builder = android.hardware.biometrics.BiometricPrompt.Builder(this)
                                .setTitle(title)

                            if (subtitle.isNotEmpty()) {
                                builder.setSubtitle(subtitle)
                            }
                            if (description.isNotEmpty()) {
                                builder.setDescription(description)
                            }
                            builder.setNegativeButton("Batal", executor) { _, _ ->
                                result.success(mapOf("authenticated" to false, "error" to "USER_CANCELLED"))
                            }

                            val prompt = builder.build()
                            val cancellationSignal = android.os.CancellationSignal()

                            prompt.authenticate(
                                cancellationSignal,
                                executor,
                                object : android.hardware.biometrics.BiometricPrompt.AuthenticationCallback() {
                                    override fun onAuthenticationSucceeded(authResult: android.hardware.biometrics.BiometricPrompt.AuthenticationResult?) {
                                        super.onAuthenticationSucceeded(authResult)
                                        result.success(mapOf("authenticated" to true, "error" to null))
                                    }

                                    override fun onAuthenticationFailed() {
                                        super.onAuthenticationFailed()
                                    }

                                    override fun onAuthenticationError(errorCode: Int, errString: CharSequence?) {
                                        super.onAuthenticationError(errorCode, errString)
                                        result.success(mapOf(
                                            "authenticated" to false,
                                            "error" to (errString?.toString() ?: "AUTH_ERROR"),
                                            "errorCode" to errorCode
                                        ))
                                    }
                                }
                            )
                        } catch (e: Exception) {
                            val (hasBio, isEnrolled) = checkBiometricStatus(applicationContext)
                            result.success(mapOf(
                                "authenticated" to false,
                                "error" to (e.message ?: "BIOMETRIC_EXCEPTION"),
                                "hasHardware" to hasBio,
                                "isEnrolled" to isEnrolled
                            ))
                        }
                    } else {
                        val (hasBio, isEnrolled) = checkBiometricStatus(applicationContext)
                        result.success(mapOf(
                            "authenticated" to isEnrolled,
                            "fallback" to true,
                            "hasHardware" to hasBio,
                            "isEnrolled" to isEnrolled
                        ))
                    }
                }
                "getDetailedWifiInfo" -> {
                    val info = getDetailedWifiInfo(applicationContext)
                    result.success(info)
                }
                "getNetworkTrafficStats" -> {
                    val stats = getNetworkTrafficStats()
                    result.success(stats)
                }
                "pingHostNative" -> {
                    val host = call.argument<String>("host") ?: "1.1.1.1"
                    val count = call.argument<Int>("count") ?: 3
                    val timeout = call.argument<Int>("timeout") ?: 2
                    val pingResult = pingHostNative(host, count, timeout)
                    result.success(pingResult)
                }
                "requestLocationPermission" -> {
                    val fineGranted = ContextCompat.checkSelfPermission(
                        this, android.Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                    val coarseGranted = ContextCompat.checkSelfPermission(
                        this, android.Manifest.permission.ACCESS_COARSE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                    val cameraGranted = ContextCompat.checkSelfPermission(
                        this, android.Manifest.permission.CAMERA
                    ) == PackageManager.PERMISSION_GRANTED

                    val lm = getSystemService(Context.LOCATION_SERVICE) as? LocationManager
                    val isGpsEnabled = lm?.isProviderEnabled(LocationManager.GPS_PROVIDER) ?: false
                    val isNetworkLocEnabled = lm?.isProviderEnabled(LocationManager.NETWORK_PROVIDER) ?: false

                    if (fineGranted && cameraGranted) {
                        result.success(mapOf(
                            "fineLocationGranted" to true,
                            "coarseLocationGranted" to true,
                            "cameraGranted" to true,
                            "isLocationGranted" to true,
                            "isGpsEnabled" to isGpsEnabled,
                            "isNetworkLocEnabled" to isNetworkLocEnabled
                        ))
                    } else {
                        pendingPermissionResult = result
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(
                                android.Manifest.permission.ACCESS_FINE_LOCATION,
                                android.Manifest.permission.ACCESS_COARSE_LOCATION,
                                android.Manifest.permission.CAMERA
                            ),
                            PERMISSION_REQUEST_CODE
                        )
                    }
                }
                "checkLocationStatus" -> {
                    val fineGranted = ContextCompat.checkSelfPermission(
                        this, android.Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                    val coarseGranted = ContextCompat.checkSelfPermission(
                        this, android.Manifest.permission.ACCESS_COARSE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                    val cameraGranted = ContextCompat.checkSelfPermission(
                        this, android.Manifest.permission.CAMERA
                    ) == PackageManager.PERMISSION_GRANTED

                    val lm = getSystemService(Context.LOCATION_SERVICE) as? LocationManager
                    val isGpsEnabled = lm?.isProviderEnabled(LocationManager.GPS_PROVIDER) ?: false
                    val isNetworkLocEnabled = lm?.isProviderEnabled(LocationManager.NETWORK_PROVIDER) ?: false

                    result.success(mapOf(
                        "fineLocationGranted" to fineGranted,
                        "coarseLocationGranted" to coarseGranted,
                        "cameraGranted" to cameraGranted,
                        "isLocationGranted" to (fineGranted || coarseGranted),
                        "isGpsEnabled" to isGpsEnabled,
                        "isNetworkLocEnabled" to isNetworkLocEnabled
                    ))
                }
                "openLocationSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.message, null)
                    }
                }
                "openAppSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                            data = Uri.fromParts("package", packageName, null)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.message, null)
                    }
                }
                "reverseGeocodeNative" -> {
                    val lat = (call.argument<Number>("latitude") ?: 0.0).toDouble()
                    val lon = (call.argument<Number>("longitude") ?: 0.0).toDouble()
                    try {
                        if (Geocoder.isPresent()) {
                            val geocoder = Geocoder(this, Locale("id", "ID"))
                            @Suppress("DEPRECATION")
                            val addresses = geocoder.getFromLocation(lat, lon, 1)
                            if (!addresses.isNullOrEmpty()) {
                                val addr = addresses[0]
                                val fullAddress = addr.getAddressLine(0) ?: ""
                                val thoroughfare = addr.thoroughfare ?: ""
                                val subThoroughfare = addr.subThoroughfare ?: ""
                                val locality = addr.locality ?: ""
                                val subLocality = addr.subLocality ?: ""
                                val adminArea = addr.adminArea ?: ""
                                val postalCode = addr.postalCode ?: ""

                                result.success(mapOf(
                                    "fullAddress" to fullAddress,
                                    "thoroughfare" to thoroughfare,
                                    "subThoroughfare" to subThoroughfare,
                                    "locality" to locality,
                                    "subLocality" to subLocality,
                                    "adminArea" to adminArea,
                                    "postalCode" to postalCode
                                ))
                                return@setMethodCallHandler
                            }
                        }
                        result.success(null)
                    } catch (e: Exception) {
                        result.success(null)
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

        // Tier 1: Modern BiometricManager for Android 11+ (API 30+)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val bm = ctx.getSystemService(android.hardware.biometrics.BiometricManager::class.java)
                if (bm != null) {
                    val canAuth = bm.canAuthenticate(
                        android.hardware.biometrics.BiometricManager.Authenticators.BIOMETRIC_STRONG or
                        android.hardware.biometrics.BiometricManager.Authenticators.BIOMETRIC_WEAK
                    )
                    if (canAuth == android.hardware.biometrics.BiometricManager.BIOMETRIC_SUCCESS) {
                        hasHardware = true
                        isEnrolled = true
                    } else if (canAuth == android.hardware.biometrics.BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED) {
                        hasHardware = true
                        isEnrolled = false
                    } else if (canAuth != android.hardware.biometrics.BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE) {
                        hasHardware = true
                    }
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Tier 2: BiometricManager for Android 10 (API 29)
                val bm = ctx.getSystemService(android.hardware.biometrics.BiometricManager::class.java)
                if (bm != null) {
                    val canAuth = bm.canAuthenticate()
                    if (canAuth == android.hardware.biometrics.BiometricManager.BIOMETRIC_SUCCESS) {
                        hasHardware = true
                        isEnrolled = true
                    } else if (canAuth == android.hardware.biometrics.BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED) {
                        hasHardware = true
                        isEnrolled = false
                    } else if (canAuth != android.hardware.biometrics.BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE) {
                        hasHardware = true
                    }
                }
            }
        } catch (_: Throwable) {}

        // Tier 3: FingerprintManager for Android 6-9 (API 23-28) or secondary confirmation
        if (!isEnrolled && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                @Suppress("DEPRECATION")
                val fm = ctx.getSystemService(Context.FINGERPRINT_SERVICE) as? android.hardware.fingerprint.FingerprintManager
                if (fm != null) {
                    if (fm.isHardwareDetected) {
                        hasHardware = true
                    }
                    if (fm.hasEnrolledFingerprints()) {
                        isEnrolled = true
                    }
                }
            } catch (_: Throwable) {}
        }

        // Tier 4: PackageManager system feature fallback
        if (!hasHardware) {
            try {
                hasHardware = ctx.packageManager.hasSystemFeature(PackageManager.FEATURE_FINGERPRINT) ||
                              ctx.packageManager.hasSystemFeature(PackageManager.FEATURE_FACE)
            } catch (_: Throwable) {}
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

    // 4.1. Detailed Wi-Fi Information (dBm, Frequency, Link Speed, Gateway, DNS)
    private fun getDetailedWifiInfo(ctx: Context): Map<String, Any?> {
        val res = mutableMapOf<String, Any?>()
        try {
            val wm = ctx.applicationContext.getSystemService(Context.WIFI_SERVICE) as? android.net.wifi.WifiManager
            val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
            @Suppress("DEPRECATION")
            val winfo = wm?.connectionInfo

            val isWifiEnabled = wm?.isWifiEnabled ?: false
            res["isWifiEnabled"] = isWifiEnabled

            if (winfo != null && winfo.networkId != -1) {
                var ssid = winfo.ssid ?: "Unknown"
                if (ssid.startsWith("\"") && ssid.endsWith("\"") && ssid.length > 1) {
                    ssid = ssid.substring(1, ssid.length - 1)
                }
                if (ssid == "<unknown ssid>") ssid = "Connected Wi-Fi"

                val bssid = winfo.bssid ?: "00:00:00:00:00:00"
                val rssi = winfo.rssi
                val linkSpeed = winfo.linkSpeed // Mbps
                val frequency = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) winfo.frequency else 2412 // MHz

                var band = "2.4 GHz"
                if (frequency in 4900..5900) {
                    band = "5 GHz"
                } else if (frequency > 5900) {
                    band = "6 GHz (Wi-Fi 6E)"
                }

                @Suppress("DEPRECATION")
                val signalLevel = android.net.wifi.WifiManager.calculateSignalLevel(rssi, 100) // 0 - 100%

                res["isConnected"] = true
                res["ssid"] = ssid
                res["bssid"] = bssid
                res["rssi"] = rssi
                res["signalLevel"] = signalLevel
                res["linkSpeedMbps"] = linkSpeed
                res["frequencyMhz"] = frequency
                res["band"] = band

                val ipInt = winfo.ipAddress
                val ipStr = String.format(
                    Locale.US, "%d.%d.%d.%d",
                    ipInt and 0xff, ipInt shr 8 and 0xff, ipInt shr 16 and 0xff, ipInt shr 24 and 0xff
                )
                res["localIp"] = ipStr

                // Gateway & DNS from LinkProperties
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && cm != null) {
                    val activeNet = cm.activeNetwork
                    val lp = cm.getLinkProperties(activeNet)
                    if (lp != null) {
                        val routes = lp.routes
                        for (r in routes) {
                            if (r.isDefaultRoute && r.gateway != null) {
                                res["gateway"] = r.gateway?.hostAddress
                            }
                        }
                        val dnsList = lp.dnsServers.mapNotNull { it.hostAddress }
                        if (dnsList.isNotEmpty()) {
                            res["dns1"] = dnsList[0]
                            if (dnsList.size > 1) res["dns2"] = dnsList[1]
                        }
                    }
                }

                @Suppress("DEPRECATION")
                val dhcp = wm.dhcpInfo
                if (dhcp != null) {
                    if (res["gateway"] == null && dhcp.gateway != 0) {
                        res["gateway"] = String.format(
                            Locale.US, "%d.%d.%d.%d",
                            dhcp.gateway and 0xff, dhcp.gateway shr 8 and 0xff, dhcp.gateway shr 16 and 0xff, dhcp.gateway shr 24 and 0xff
                        )
                    }
                    if (res["dns1"] == null && dhcp.dns1 != 0) {
                        res["dns1"] = String.format(
                            Locale.US, "%d.%d.%d.%d",
                            dhcp.dns1 and 0xff, dhcp.dns1 shr 8 and 0xff, dhcp.dns1 shr 16 and 0xff, dhcp.dns1 shr 24 and 0xff
                        )
                    }
                    if (dhcp.netmask != 0) {
                        res["netmask"] = String.format(
                            Locale.US, "%d.%d.%d.%d",
                            dhcp.netmask and 0xff, dhcp.netmask shr 8 and 0xff, dhcp.netmask shr 16 and 0xff, dhcp.netmask shr 24 and 0xff
                        )
                    }
                }
            } else {
                res["isConnected"] = false
                res["ssid"] = "Not Connected"
            }
        } catch (e: Exception) {
            res["error"] = e.message
            res["isConnected"] = false
        }
        return res
    }

    // 4.2. Network Traffic Statistics (Total Data Rx/Tx in Bytes & Packets)
    private fun getNetworkTrafficStats(): Map<String, Any> {
        val rxBytes = android.net.TrafficStats.getTotalRxBytes()
        val txBytes = android.net.TrafficStats.getTotalTxBytes()
        val rxPackets = android.net.TrafficStats.getTotalRxPackets()
        val txPackets = android.net.TrafficStats.getTotalTxPackets()

        val mobileRxBytes = android.net.TrafficStats.getMobileRxBytes()
        val mobileTxBytes = android.net.TrafficStats.getMobileTxBytes()

        return mapOf(
            "totalRxBytes" to if (rxBytes >= 0) rxBytes else 0L,
            "totalTxBytes" to if (txBytes >= 0) txBytes else 0L,
            "totalRxPackets" to if (rxPackets >= 0) rxPackets else 0L,
            "totalTxPackets" to if (txPackets >= 0) txPackets else 0L,
            "mobileRxBytes" to if (mobileRxBytes >= 0) mobileRxBytes else 0L,
            "mobileTxBytes" to if (mobileTxBytes >= 0) mobileTxBytes else 0L
        )
    }

    // 4.3. Native ICMP Ping Command Runner
    private fun pingHostNative(host: String, count: Int, timeoutSec: Int): Map<String, Any?> {
        val result = mutableMapOf<String, Any?>()
        try {
            val process = Runtime.getRuntime().exec("ping -c $count -W $timeoutSec $host")
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = StringBuilder()
            var line: String?
            val latencies = mutableListOf<Double>()

            while (reader.readLine().also { line = it } != null) {
                output.append(line).append("\n")
                val timeIndex = line?.indexOf("time=") ?: -1
                if (timeIndex != -1) {
                    val sub = line!!.substring(timeIndex + 5)
                    val msIndex = sub.indexOf(" ms")
                    val spaceIndex = sub.indexOf(" ")
                    val endIdx = if (msIndex != -1) msIndex else (if (spaceIndex != -1) spaceIndex else sub.length)
                    sub.substring(0, endIdx).toDoubleOrNull()?.let { latencies.add(it) }
                }
            }
            reader.close()
            process.waitFor()

            result["host"] = host
            result["success"] = latencies.isNotEmpty()
            result["output"] = output.toString()

            if (latencies.isNotEmpty()) {
                val min = latencies.minOrNull() ?: 0.0
                val max = latencies.maxOrNull() ?: 0.0
                val avg = latencies.average()

                var jitter = 0.0
                if (latencies.size > 1) {
                    var diffSum = 0.0
                    for (i in 1 until latencies.size) {
                        diffSum += Math.abs(latencies[i] - latencies[i - 1])
                    }
                    jitter = diffSum / (latencies.size - 1)
                }

                result["minMs"] = min
                result["maxMs"] = max
                result["avgMs"] = avg
                result["jitterMs"] = jitter
                result["packetCount"] = count
                result["receivedCount"] = latencies.size
                result["packetLossPercent"] = ((count - latencies.size).toDouble() / count.toDouble() * 100.0)
            } else {
                result["packetLossPercent"] = 100.0
                result["avgMs"] = -1.0
                result["jitterMs"] = 0.0
            }
        } catch (e: Exception) {
            result["success"] = false
            result["error"] = e.message
            result["avgMs"] = -1.0
            result["packetLossPercent"] = 100.0
            result["jitterMs"] = 0.0
        }
        return result
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

    // 7. Location, Geotagging & Cellular Carrier Telemetry
    private fun getLocationAndCarrierData(ctx: Context): Map<String, Any> {
        // 1. Cellular Network & SIM Info
        var carrierName = "No SIM / WiFi Only"
        var simState = "READY"
        var countryIso = "id"

        try {
            val tm = ctx.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            if (tm != null) {
                val opName = tm.networkOperatorName
                val simOpName = tm.simOperatorName
                if (!opName.isNullOrBlank()) {
                    carrierName = opName
                } else if (!simOpName.isNullOrBlank()) {
                    carrierName = simOpName
                }

                simState = when (tm.simState) {
                    TelephonyManager.SIM_STATE_READY -> "READY"
                    TelephonyManager.SIM_STATE_ABSENT -> "ABSENT"
                    TelephonyManager.SIM_STATE_PIN_REQUIRED,
                    TelephonyManager.SIM_STATE_PUK_REQUIRED,
                    TelephonyManager.SIM_STATE_NETWORK_LOCKED -> "LOCKED"
                    else -> "READY"
                }

                val iso = tm.networkCountryIso.ifEmpty { tm.simCountryIso }
                if (!iso.isNullOrBlank()) {
                    countryIso = iso.lowercase()
                }
            }
        } catch (_: Throwable) {}

        // 2. Location & GPS Telemetry
        var isGpsEnabled = false
        var isNetworkLocEnabled = false
        var isPermissionGranted = false
        var hasGpsHardware = false
        var latitude = 0.0
        var longitude = 0.0
        var altitude = 0.0
        var accuracy = 0.0
        var speed = 0.0
        var bearing = 0.0
        var isLocationMock = false
        var providerName = "none"

        try {
            hasGpsHardware = ctx.packageManager.hasSystemFeature(PackageManager.FEATURE_LOCATION_GPS)
            val lm = ctx.getSystemService(Context.LOCATION_SERVICE) as? LocationManager
            if (lm != null) {
                isGpsEnabled = lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
                isNetworkLocEnabled = lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)

                val hasFine = ContextCompat.checkSelfPermission(
                    ctx, android.Manifest.permission.ACCESS_FINE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
                val hasCoarse = ContextCompat.checkSelfPermission(
                    ctx, android.Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED

                isPermissionGranted = hasFine || hasCoarse

                if (isPermissionGranted) {
                    var bestLocation: Location? = latestLiveLocation
                    val providers = lm.getProviders(true)
                    for (p in providers) {
                        val l = lm.getLastKnownLocation(p) ?: continue
                        if (bestLocation == null || l.accuracy < bestLocation.accuracy) {
                            bestLocation = l
                        }
                    }

                    if (bestLocation != null) {
                        latitude = bestLocation.latitude
                        longitude = bestLocation.longitude
                        altitude = bestLocation.altitude
                        accuracy = bestLocation.accuracy.toDouble()
                        speed = (bestLocation.speed * 3.6) // m/s to km/h
                        bearing = bestLocation.bearing.toDouble()
                        providerName = bestLocation.provider ?: "gps"
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            isLocationMock = bestLocation.isMock
                        } else {
                            @Suppress("DEPRECATION")
                            isLocationMock = bestLocation.isFromMockProvider
                        }
                    }
                }
            }
        } catch (_: Throwable) {}

        return mapOf(
            "carrierName" to carrierName,
            "simState" to simState,
            "countryIso" to countryIso,
            "isGpsEnabled" to isGpsEnabled,
            "isNetworkLocEnabled" to isNetworkLocEnabled,
            "isLocationPermissionGranted" to isPermissionGranted,
            "hasGpsHardware" to hasGpsHardware,
            "latitude" to latitude,
            "longitude" to longitude,
            "altitudeMeters" to altitude,
            "accuracyMeters" to accuracy,
            "speedKmh" to speed,
            "bearingDegrees" to bearing,
            "isLocationMock" to isLocationMock,
            "locationProvider" to providerName
        )
    }
}

class GeotagSqliteHelper private constructor(context: Context) :
    SQLiteOpenHelper(context.applicationContext, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        const val DATABASE_NAME = "geotag_diagnostics.db"
        const val DATABASE_VERSION = 1
        const val TABLE_PHOTOS = "geotagged_photos"

        const val COL_ID = "id"
        const val COL_ORIGINAL_PATH = "original_path"
        const val COL_COMPRESSED_PATH = "compressed_path"
        const val COL_ORIGINAL_SIZE = "original_size_bytes"
        const val COL_COMPRESSED_SIZE = "compressed_size_bytes"
        const val COL_TIMESTAMP = "timestamp"
        const val COL_LATITUDE = "latitude"
        const val COL_LONGITUDE = "longitude"
        const val COL_ALTITUDE = "altitude"
        const val COL_ACCURACY = "accuracy"
        const val COL_ADDRESS = "address"
        const val COL_CARRIER = "carrier"
        const val COL_IS_CLOUD_SYNCED = "is_cloud_synced"
        const val COL_CLOUD_URL = "cloud_url"
        const val COL_CLOUD_PROVIDER = "cloud_provider"
        const val COL_CLOUD_SYNCED_AT = "cloud_synced_at"
        const val COL_CREATED_AT = "created_at"

        const val TABLE_SCREEN_TIME = "screen_time_sessions"

        const val COL_ST_ID = "id"
        const val COL_ST_SESSION_ID = "session_id"
        const val COL_ST_DATE = "date"
        const val COL_ST_START_MS = "session_start_ms"
        const val COL_ST_END_MS = "session_end_ms"
        const val COL_ST_DURATION_SEC = "duration_seconds"
        const val COL_ST_PAGE_BREAKDOWN = "page_breakdown_json"
        const val COL_ST_BATTERY_CONSUMED = "battery_consumed"
        const val COL_ST_IS_SYNCED = "is_synced"
        const val COL_ST_SYNCED_AT = "synced_at_ms"
        const val COL_ST_CREATED_AT = "created_at_ms"

        @Volatile
        private var instance: GeotagSqliteHelper? = null

        fun getInstance(context: Context): GeotagSqliteHelper {
            return instance ?: synchronized(this) {
                instance ?: GeotagSqliteHelper(context.applicationContext).also { instance = it }
            }
        }
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createSql = """
            CREATE TABLE IF NOT EXISTS $TABLE_PHOTOS (
                $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COL_ORIGINAL_PATH TEXT NOT NULL,
                $COL_COMPRESSED_PATH TEXT NOT NULL,
                $COL_ORIGINAL_SIZE INTEGER NOT NULL,
                $COL_COMPRESSED_SIZE INTEGER NOT NULL,
                $COL_TIMESTAMP INTEGER NOT NULL,
                $COL_LATITUDE REAL NOT NULL,
                $COL_LONGITUDE REAL NOT NULL,
                $COL_ALTITUDE REAL NOT NULL,
                $COL_ACCURACY REAL NOT NULL,
                $COL_ADDRESS TEXT NOT NULL,
                $COL_CARRIER TEXT,
                $COL_IS_CLOUD_SYNCED INTEGER DEFAULT 0,
                $COL_CLOUD_URL TEXT,
                $COL_CLOUD_PROVIDER TEXT,
                $COL_CLOUD_SYNCED_AT INTEGER DEFAULT 0,
                $COL_CREATED_AT INTEGER NOT NULL
            )
        """.trimIndent()
        db.execSQL(createSql)

        val createScreenTimeSql = """
            CREATE TABLE IF NOT EXISTS $TABLE_SCREEN_TIME (
                $COL_ST_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COL_ST_SESSION_ID TEXT NOT NULL,
                $COL_ST_DATE TEXT NOT NULL,
                $COL_ST_START_MS INTEGER NOT NULL,
                $COL_ST_END_MS INTEGER NOT NULL,
                $COL_ST_DURATION_SEC INTEGER NOT NULL,
                $COL_ST_PAGE_BREAKDOWN TEXT,
                $COL_ST_BATTERY_CONSUMED INTEGER DEFAULT 0,
                $COL_ST_IS_SYNCED INTEGER DEFAULT 0,
                $COL_ST_SYNCED_AT INTEGER DEFAULT 0,
                $COL_ST_CREATED_AT INTEGER NOT NULL
            )
        """.trimIndent()
        db.execSQL(createScreenTimeSql)
    }

    override fun onOpen(db: SQLiteDatabase) {
        super.onOpen(db)
        try {
            db.execSQL("ALTER TABLE $TABLE_PHOTOS ADD COLUMN $COL_IS_CLOUD_SYNCED INTEGER DEFAULT 0")
        } catch (_: Throwable) {}
        try {
            db.execSQL("ALTER TABLE $TABLE_PHOTOS ADD COLUMN $COL_CLOUD_URL TEXT")
        } catch (_: Throwable) {}
        try {
            db.execSQL("ALTER TABLE $TABLE_PHOTOS ADD COLUMN $COL_CLOUD_PROVIDER TEXT")
        } catch (_: Throwable) {}
        try {
            db.execSQL("ALTER TABLE $TABLE_PHOTOS ADD COLUMN $COL_CLOUD_SYNCED_AT INTEGER DEFAULT 0")
        } catch (_: Throwable) {}
        try {
            val createScreenTimeSql = """
                CREATE TABLE IF NOT EXISTS $TABLE_SCREEN_TIME (
                    $COL_ST_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    $COL_ST_SESSION_ID TEXT NOT NULL,
                    $COL_ST_DATE TEXT NOT NULL,
                    $COL_ST_START_MS INTEGER NOT NULL,
                    $COL_ST_END_MS INTEGER NOT NULL,
                    $COL_ST_DURATION_SEC INTEGER NOT NULL,
                    $COL_ST_PAGE_BREAKDOWN TEXT,
                    $COL_ST_BATTERY_CONSUMED INTEGER DEFAULT 0,
                    $COL_ST_IS_SYNCED INTEGER DEFAULT 0,
                    $COL_ST_SYNCED_AT INTEGER DEFAULT 0,
                    $COL_ST_CREATED_AT INTEGER NOT NULL
                )
            """.trimIndent()
            db.execSQL(createScreenTimeSql)
        } catch (_: Throwable) {}
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_PHOTOS")
        db.execSQL("DROP TABLE IF EXISTS $TABLE_SCREEN_TIME")
        onCreate(db)
    }

    fun insertScreenTimeSession(
        sessionId: String,
        date: String,
        sessionStartMs: Long,
        sessionEndMs: Long,
        durationSeconds: Int,
        pageBreakdownJson: String,
        batteryConsumed: Int,
        isSynced: Boolean
    ): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_ST_SESSION_ID, sessionId)
            put(COL_ST_DATE, date)
            put(COL_ST_START_MS, sessionStartMs)
            put(COL_ST_END_MS, sessionEndMs)
            put(COL_ST_DURATION_SEC, durationSeconds)
            put(COL_ST_PAGE_BREAKDOWN, pageBreakdownJson)
            put(COL_ST_BATTERY_CONSUMED, batteryConsumed)
            put(COL_ST_IS_SYNCED, if (isSynced) 1 else 0)
            put(COL_ST_SYNCED_AT, if (isSynced) System.currentTimeMillis() else 0L)
            put(COL_ST_CREATED_AT, System.currentTimeMillis())
        }
        return db.insertWithOnConflict(TABLE_SCREEN_TIME, null, values, SQLiteDatabase.CONFLICT_REPLACE)
    }

    fun getAllScreenTimeSessions(): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        val db = readableDatabase
        val cursor = db.rawQuery("SELECT * FROM $TABLE_SCREEN_TIME ORDER BY $COL_ST_ID DESC", null)
        cursor.use {
            while (it.moveToNext()) {
                val map = mutableMapOf<String, Any>()
                map["id"] = it.getLong(it.getColumnIndexOrThrow(COL_ST_ID))
                map["sessionId"] = it.getString(it.getColumnIndexOrThrow(COL_ST_SESSION_ID))
                map["date"] = it.getString(it.getColumnIndexOrThrow(COL_ST_DATE))
                map["sessionStartMs"] = it.getLong(it.getColumnIndexOrThrow(COL_ST_START_MS))
                map["sessionEndMs"] = it.getLong(it.getColumnIndexOrThrow(COL_ST_END_MS))
                map["durationSeconds"] = it.getInt(it.getColumnIndexOrThrow(COL_ST_DURATION_SEC))
                map["pageBreakdownJson"] = it.getString(it.getColumnIndexOrThrow(COL_ST_PAGE_BREAKDOWN)) ?: "{}"
                map["batteryConsumed"] = it.getInt(it.getColumnIndexOrThrow(COL_ST_BATTERY_CONSUMED))
                map["isSynced"] = it.getInt(it.getColumnIndexOrThrow(COL_ST_IS_SYNCED)) == 1
                map["syncedAtMs"] = it.getLong(it.getColumnIndexOrThrow(COL_ST_SYNCED_AT))
                map["createdAtMs"] = it.getLong(it.getColumnIndexOrThrow(COL_ST_CREATED_AT))
                list.add(map)
            }
        }
        return list
    }

    fun markScreenTimeSessionsSynced(sessionIds: List<String>): Boolean {
        if (sessionIds.isEmpty()) return true
        val db = writableDatabase
        val now = System.currentTimeMillis()
        val values = ContentValues().apply {
            put(COL_ST_IS_SYNCED, 1)
            put(COL_ST_SYNCED_AT, now)
        }
        for (id in sessionIds) {
            db.update(TABLE_SCREEN_TIME, values, "$COL_ST_SESSION_ID = ?", arrayOf(id))
        }
        return true
    }

    fun getScreenTimeDailyStats(): Map<String, Any> {
        val db = readableDatabase
        val dailyMap = mutableMapOf<String, Long>()
        var totalLifetimeSeconds = 0L
        var totalSessions = 0L
        var pendingSyncCount = 0L

        val cursor = db.rawQuery(
            "SELECT $COL_ST_DATE, $COL_ST_DURATION_SEC, $COL_ST_IS_SYNCED FROM $TABLE_SCREEN_TIME",
            null
        )
        cursor.use {
            while (it.moveToNext()) {
                totalSessions++
                val d = it.getString(0) ?: ""
                val sec = it.getLong(1)
                val synced = it.getInt(2) == 1
                if (!synced) pendingSyncCount++
                totalLifetimeSeconds += sec
                dailyMap[d] = (dailyMap[d] ?: 0L) + sec
            }
        }

        return mapOf(
            "totalLifetimeSeconds" to totalLifetimeSeconds,
            "totalSessions" to totalSessions,
            "pendingSyncCount" to pendingSyncCount,
            "dailyBreakdown" to dailyMap
        )
    }

    fun insertPhoto(
        originalPath: String,
        compressedPath: String,
        originalSize: Long,
        compressedSize: Long,
        timestamp: Long,
        latitude: Double,
        longitude: Double,
        altitude: Double,
        accuracy: Double,
        address: String,
        carrier: String,
        cloudUrl: String = "",
        isCloudSynced: Boolean = false,
        cloudProvider: String = ""
    ): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_ORIGINAL_PATH, originalPath)
            put(COL_COMPRESSED_PATH, compressedPath)
            put(COL_ORIGINAL_SIZE, originalSize)
            put(COL_COMPRESSED_SIZE, compressedSize)
            put(COL_TIMESTAMP, timestamp)
            put(COL_LATITUDE, latitude)
            put(COL_LONGITUDE, longitude)
            put(COL_ALTITUDE, altitude)
            put(COL_ACCURACY, accuracy)
            put(COL_ADDRESS, address)
            put(COL_CARRIER, carrier)
            put(COL_IS_CLOUD_SYNCED, if (isCloudSynced) 1 else 0)
            put(COL_CLOUD_URL, cloudUrl)
            put(COL_CLOUD_PROVIDER, cloudProvider)
            put(COL_CLOUD_SYNCED_AT, if (isCloudSynced) System.currentTimeMillis() else 0L)
            put(COL_CREATED_AT, System.currentTimeMillis())
        }
        return db.insert(TABLE_PHOTOS, null, values)
    }

    fun updateCloudSync(id: Long, cloudUrl: String, cloudProvider: String): Boolean {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_IS_CLOUD_SYNCED, 1)
            put(COL_CLOUD_URL, cloudUrl)
            put(COL_CLOUD_PROVIDER, cloudProvider)
            put(COL_CLOUD_SYNCED_AT, System.currentTimeMillis())
        }
        val rows = db.update(TABLE_PHOTOS, values, "$COL_ID = ?", arrayOf(id.toString()))
        return rows > 0
    }

    fun getAllPhotos(): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        val db = readableDatabase
        val cursor = db.rawQuery("SELECT * FROM $TABLE_PHOTOS ORDER BY $COL_ID DESC", null)
        cursor.use {
            while (it.moveToNext()) {
                val map = mutableMapOf<String, Any>()
                map["id"] = it.getLong(it.getColumnIndexOrThrow(COL_ID))
                map["original_path"] = it.getString(it.getColumnIndexOrThrow(COL_ORIGINAL_PATH))
                map["compressed_path"] = it.getString(it.getColumnIndexOrThrow(COL_COMPRESSED_PATH))
                map["original_size_bytes"] = it.getLong(it.getColumnIndexOrThrow(COL_ORIGINAL_SIZE))
                map["compressed_size_bytes"] = it.getLong(it.getColumnIndexOrThrow(COL_COMPRESSED_SIZE))
                map["timestamp"] = it.getLong(it.getColumnIndexOrThrow(COL_TIMESTAMP))
                map["latitude"] = it.getDouble(it.getColumnIndexOrThrow(COL_LATITUDE))
                map["longitude"] = it.getDouble(it.getColumnIndexOrThrow(COL_LONGITUDE))
                map["altitude"] = it.getDouble(it.getColumnIndexOrThrow(COL_ALTITUDE))
                map["accuracy"] = it.getDouble(it.getColumnIndexOrThrow(COL_ACCURACY))
                map["address"] = it.getString(it.getColumnIndexOrThrow(COL_ADDRESS))
                map["carrier"] = it.getString(it.getColumnIndexOrThrow(COL_CARRIER)) ?: ""
                
                val cloudSyncIdx = it.getColumnIndex(COL_IS_CLOUD_SYNCED)
                val cloudUrlIdx = it.getColumnIndex(COL_CLOUD_URL)
                val cloudProvIdx = it.getColumnIndex(COL_CLOUD_PROVIDER)
                val cloudTimeIdx = it.getColumnIndex(COL_CLOUD_SYNCED_AT)

                map["is_cloud_synced"] = if (cloudSyncIdx != -1) it.getInt(cloudSyncIdx) == 1 else false
                map["cloud_url"] = if (cloudUrlIdx != -1) (it.getString(cloudUrlIdx) ?: "") else ""
                map["cloud_provider"] = if (cloudProvIdx != -1) (it.getString(cloudProvIdx) ?: "") else ""
                map["cloud_synced_at"] = if (cloudTimeIdx != -1) it.getLong(cloudTimeIdx) else 0L

                map["created_at"] = it.getLong(it.getColumnIndexOrThrow(COL_CREATED_AT))
                list.add(map)
            }
        }
        return list
    }

    fun deletePhoto(id: Long): Int {
        val db = writableDatabase
        return db.delete(TABLE_PHOTOS, "$COL_ID = ?", arrayOf(id.toString()))
    }

    fun getStats(): Map<String, Any> {
        val db = readableDatabase
        var count = 0L
        var origBytes = 0L
        var compBytes = 0L
        val cursor = db.rawQuery(
            "SELECT $COL_ORIGINAL_SIZE, $COL_COMPRESSED_SIZE FROM $TABLE_PHOTOS",
            null
        )
        cursor.use {
            while (it.moveToNext()) {
                count++
                var o = it.getLong(0)
                var c = it.getLong(1)
                if (o > 0 && c > 0 && o < c) {
                    val temp = o
                    o = c
                    c = temp
                }
                origBytes += o
                compBytes += c
            }
        }
        val savedBytes = if (origBytes > compBytes) origBytes - compBytes else 0L
        val ratio = if (origBytes > 0) (savedBytes.toDouble() / origBytes.toDouble() * 100) else 0.0
        return mapOf(
            "totalPhotos" to count,
            "totalOriginalBytes" to origBytes,
            "totalCompressedBytes" to compBytes,
            "totalSavedBytes" to savedBytes,
            "savingsPercent" to ratio
        )
    }
}
