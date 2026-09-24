import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import '../models/geotagged_photo_model.dart';
import '../services/geotag_sqlite_service.dart';
import '../services/geotag_cloud_service.dart';
import '../services/biometric_auth_service.dart';
import '../services/app_screen_time_service.dart';
import 'interactive_geotag_map_page.dart';

class SavedGeotagPhotosPage extends StatefulWidget {
  const SavedGeotagPhotosPage({super.key});

  @override
  State<SavedGeotagPhotosPage> createState() => _SavedGeotagPhotosPageState();
}

class _SavedGeotagPhotosPageState extends State<SavedGeotagPhotosPage> {
  final GeotagSqliteService _sqliteService = GeotagSqliteService.instance;
  final GeotagCloudService _cloudService = GeotagCloudService.instance;
  final BiometricAuthService _biometricService = BiometricAuthService.instance;

  List<GeotaggedPhotoModel> _photos = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  bool _isVaultLocked = false;
  bool _isVaultProtectionEnabled = false;
  bool _hasBiometrics = false;
  final Set<int> _uploadingPhotoIds = {};
  final Map<int, double> _photoUploadProgress = {};
  bool _isBatchSyncing = false;
  double _batchSyncOverallProgress = 0.0;
  String _batchSyncStatusText = '';

  @override
  void initState() {
    super.initState();
    AppScreenTimeService.instance.setCurrentPage("SavedGeotagPhotosPage");
    _checkBiometricsAndLoad();
  }

  @override
  void dispose() {
    AppScreenTimeService.instance.setCurrentPage("DeviceDiagnosticsPage");
    super.dispose();
  }

  Future<void> _checkBiometricsAndLoad() async {
    final bioStatus = await _biometricService.checkBiometricStatus();
    final isProtected = await _biometricService.isVaultProtectionEnabled();
    final hasBio =
        bioStatus['hasHardware'] == true && bioStatus['isEnrolled'] == true;

    if (mounted) {
      setState(() {
        _hasBiometrics = hasBio;
        _isVaultProtectionEnabled = isProtected;
        // If biometric protection is enabled and not unlocked this session, lock the screen!
        _isVaultLocked = isProtected && !_biometricService.isSessionUnlocked;
      });
    }
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() => _isLoading = true);
    final photos = await _sqliteService.getAllPhotos();
    final stats = await _sqliteService.getStats();
    if (mounted) {
      setState(() {
        _photos = photos;
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBiometricVault() async {
    final bioStatus = await _biometricService.checkBiometricStatus();
    final hasBio =
        bioStatus['hasHardware'] == true && bioStatus['isEnrolled'] == true;
    if (mounted) {
      setState(() => _hasBiometrics = hasBio);
    }

    if (!hasBio) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Hardware biometrik (sidik jari/wajah) belum terdaftar di HP ini.",
            ),
            backgroundColor: Color(0xFF64748B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (_isVaultLocked) {
      final authOk = await _biometricService.authenticate(
        title: "Buka Vault Geotagging",
        subtitle: "Verifikasi sidik jari untuk membuka proteksi galeri",
      );
      if (authOk && mounted) {
        setState(() => _isVaultLocked = false);
        _loadPhotos();
      }
    } else {
      final newProtectedState = !_isVaultProtectionEnabled;
      final authOk = await _biometricService.authenticate(
        title:
            newProtectedState
                ? "Aktifkan Proteksi Biometrik"
                : "Nonaktifkan Proteksi Biometrik",
        subtitle:
            "Verifikasi sidik jari untuk menyimpan pengaturan keamanan ke aplikasi",
      );
      if (authOk && mounted) {
        await _biometricService.setVaultProtectionEnabled(newProtectedState);
        setState(() {
          _isVaultProtectionEnabled = newProtectedState;
          _isVaultLocked = newProtectedState;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newProtectedState
                  ? "Proteksi Biometrik Aktif! Preferensi tersimpan permanen di aplikasi."
                  : "Proteksi Biometrik Dinonaktifkan.",
            ),
            backgroundColor:
                newProtectedState
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF64748B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _savePhotoToGallery(GeotaggedPhotoModel photo) async {
    final file = photo.displayFile;
    if (!await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File foto tidak ditemukan di penyimpanan lokal"),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final res = await _cloudService.saveToDeviceGallery(
      file,
      title: "geotag_${photo.id ?? DateTime.now().millisecondsSinceEpoch}",
      description:
          "Foto Geotagging [${photo.formattedCoordinates}] - ${photo.fullAddress}",
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                res.success
                    ? Icons.photo_library_rounded
                    : Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  res.success
                      ? "Foto tersimpan di Galeri HP (${res.album ?? 'Pictures/Geotagging'})"
                      : (res.errorMessage ?? "Gagal menyimpan ke galeri"),
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor:
              res.success ? const Color(0xFF0284C7) : const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _uploadPhotoToCloud(GeotaggedPhotoModel photo) async {
    if (photo.id == null) return;

    if (_hasBiometrics) {
      final authOk = await _biometricService.authenticate(
        title: "Konfirmasi Cloud Backup",
        subtitle: "Verifikasi sidik jari untuk mencadangkan foto #${photo.id}",
      );
      if (!authOk) return;
    }

    final existingCloud = await _cloudService.getCloudName();
    if (existingCloud.isEmpty) {
      if (mounted) {
        await _cloudService.showCloudinaryConfigDialog(context);
      }
    }

    setState(() {
      _uploadingPhotoIds.add(photo.id!);
      _photoUploadProgress[photo.id!] = 0.05;
    });

    final res = await _cloudService.uploadPhotoToCloud(
      photo,
      onProgress: (p) {
        if (mounted) {
          setState(() {
            _photoUploadProgress[photo.id!] = p;
          });
        }
      },
    );

    if (mounted) {
      setState(() {
        _uploadingPhotoIds.remove(photo.id!);
        _photoUploadProgress.remove(photo.id!);
      });
      _loadPhotos();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                res.success
                    ? Icons.cloud_done_rounded
                    : Icons.cloud_off_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      res.success
                          ? "Foto #${photo.id} berhasil dicadangkan ke Cloud!"
                          : "Gagal mencadangkan foto ke cloud",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (res.cloudUrl != null)
                      Text(
                        "${res.provider ?? 'Cloud'}: ${res.cloudUrl}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFD1FAE5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (res.cloudUrl != null)
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: res.cloudUrl!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("URL Cloud disalin!"),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text(
                    "SALIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          backgroundColor:
              res.success ? const Color(0xFF059669) : const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _syncAllOfflinePhotos() async {
    final unsynced = _photos.where((p) => !p.isCloudSynced).toList();
    if (unsynced.isEmpty) return;

    if (_hasBiometrics) {
      final authOk = await _biometricService.authenticate(
        title: "Konfirmasi Batch Sync",
        subtitle:
            "Verifikasi sidik jari untuk menyinkronkan ${unsynced.length} foto offline ke cloud",
      );
      if (!authOk) return;
    }

    final existingCloud = await _cloudService.getCloudName();
    if (existingCloud.isEmpty) {
      if (mounted) {
        await _cloudService.showCloudinaryConfigDialog(context);
      }
    }

    setState(() {
      _isBatchSyncing = true;
      _batchSyncOverallProgress = 0.0;
      _batchSyncStatusText = "Menyiapkan sinkronisasi...";
    });

    // Show Batch Sync Progress Modal Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Syncing Offline ➔ Cloud (${(_batchSyncOverallProgress * 100).toInt()}%)",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _batchSyncStatusText,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _batchSyncOverallProgress,
                        backgroundColor: const Color(0xFF1E293B),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF38BDF8),
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total ${unsynced.length} foto diproses ke Cloudinary...",
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );

    final result = await _cloudService.syncAllUnsyncedPhotos(
      onProgress: (current, total, itemProg, overallProg) {
        if (mounted) {
          setState(() {
            _batchSyncOverallProgress = overallProg;
            _batchSyncStatusText =
                "Mengunggah foto $current dari $total (${(itemProg * 100).toInt()}%)...";
          });
        }
      },
    );

    if (mounted) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop(); // Dismiss progress modal
      setState(() {
        _isBatchSyncing = false;
        _batchSyncOverallProgress = 0.0;
      });
      _loadPhotos();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.cloud_done_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Batch Sync Selesai! ${result.successCount} foto berhasil dicadangkan ke Cloudinary.",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deletePhoto(GeotaggedPhotoModel photo) async {
    if (_hasBiometrics) {
      final authOk = await _biometricService.authenticate(
        title: "Konfirmasi Hapus SQLite",
        subtitle: "Verifikasi sidik jari untuk menghapus foto #${photo.id}",
      );
      if (!authOk) return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                SizedBox(width: 8),
                Text(
                  "Hapus Foto SQLite?",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            content: Text(
              "Foto dengan koordinat [${photo.formattedCoordinates}] akan dihapus permanen dari database SQLite lokal.",
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Hapus"),
              ),
            ],
          ),
    );

    if (confirmed == true && photo.id != null) {
      await _sqliteService.deletePhoto(photo.id!);
      _loadPhotos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Foto berhasil dihapus dari database SQLite"),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _sharePhoto(GeotaggedPhotoModel photo) async {
    final file = photo.displayFile;
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'geotag_${photo.id ?? DateTime.now().millisecondsSinceEpoch}.png',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Galeri Database SQLite Geotag",
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              "Tabel: geotagged_photos • Penyimpanan Offline",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Pengaturan Cloudinary",
            icon: const Icon(
              Icons.cloud_queue_rounded,
              color: Color(0xFF0284C7),
            ),
            onPressed: () => _cloudService.showCloudinaryConfigDialog(context),
          ),
          IconButton(
            tooltip:
                _isVaultLocked
                    ? "Buka Vault Biometrik"
                    : "Kunci Vault Biometrik",
            icon: Icon(
              _isVaultLocked ? Icons.lock_rounded : Icons.fingerprint_rounded,
              color:
                  _isVaultLocked
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF6366F1),
            ),
            onPressed: _toggleBiometricVault,
          ),
          IconButton(
            tooltip: "Refresh Database",
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
            onPressed: _loadPhotos,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body:
          _isVaultLocked
              ? _buildVaultLockScreen()
              : _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0284C7)),
              )
              : RefreshIndicator(
                color: const Color(0xFF0284C7),
                onRefresh: _loadPhotos,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 1. Compression & Storage Analytics Card
                    _buildAnalyticsHeader(),
                    const SizedBox(height: 14),

                    // 2. SQL Schema Inspector Banner
                    _buildSqlInspectorBanner(),
                    const SizedBox(height: 12),

                    // 3. Offline-to-Online Batch Sync Banner
                    _buildOfflineSyncBanner(),
                    const SizedBox(height: 16),

                    // 4. List of Geotagged Photos
                    if (_photos.isEmpty)
                      _buildEmptyState()
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "FOTO TERSIMPAN (${_photos.length})",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const Text(
                              "Newest First (ID DESC)",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._photos.map((photo) => _buildPhotoCard(photo)),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _buildVaultLockScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fingerprint_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Database SQLite Terkunci",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Proteksi Biometrik aktif. Verifikasi sidik jari atau wajah Anda untuk membuka akses ke daftar foto geotagging lokal dan riwayat GPS.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.lock_open_rounded, size: 18),
                label: const Text(
                  "Buka dengan Biometrik",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: _toggleBiometricVault,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsHeader() {
    final totalCount = _stats['totalPhotos'] ?? _photos.length;
    final totalSaved = _stats['totalSavedBytes'] ?? 0;
    final savingsPct = (_stats['savingsPercent'] as num?)?.toDouble() ?? 0.0;
    final cloudCount = _photos.where((p) => p.isCloudSynced).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.storage_rounded,
                    color: Color(0xFF38BDF8),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "DATABASE & CLOUD ANALYTICS",
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      _hasBiometrics
                          ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                          : const Color(0xFF64748B).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color:
                        _hasBiometrics
                            ? const Color(0xFF818CF8).withValues(alpha: 0.4)
                            : const Color(0xFF64748B).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _hasBiometrics
                          ? Icons.fingerprint_rounded
                          : Icons.shield_outlined,
                      size: 11,
                      color:
                          _hasBiometrics
                              ? const Color(0xFF818CF8)
                              : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _hasBiometrics ? "Biometrik Ready" : "No Biometric",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color:
                            _hasBiometrics
                                ? const Color(0xFFC7D2FE)
                                : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricCell(
                  label: "Total Foto",
                  value: "$totalCount Item",
                  sub: "SQLite Offline",
                  icon: Icons.photo_library_rounded,
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCell(
                  label: "Ruang Dihemat",
                  value: _formatBytes(
                    totalSaved is num ? totalSaved.toInt() : 0,
                  ),
                  sub: "Hemat ${savingsPct.toStringAsFixed(0)}% Kapasitas",
                  icon: Icons.compress_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricCell(
                  label: "Cloud Backup",
                  value: "$cloudCount / $totalCount Synced",
                  sub:
                      cloudCount == totalCount && totalCount > 0
                          ? "Semua Foto Tersinkron"
                          : "${totalCount - cloudCount} Belum Dicadangkan",
                  icon: Icons.cloud_done_rounded,
                  color: const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCell(
                  label: "Keamanan Vault",
                  value: _isVaultLocked ? "Terkunci" : "Terbuka",
                  sub:
                      _hasBiometrics
                          ? "Proteksi Sidik Jari"
                          : "Hardware Tidak Ada",
                  icon: Icons.lock_outline_rounded,
                  color: const Color(0xFFA855F7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell({
    required String label,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B132B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(
              color: color,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSqlInspectorBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.code_rounded, color: Color(0xFF0284C7), size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "SELECT id, address, latitude, longitude FROM geotagged_photos",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Color(0xFF334155),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineSyncBanner() {
    final unsynced = _photos.where((p) => !p.isCloudSynced).toList();
    if (unsynced.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_sync_rounded,
              color: Color(0xFFB45309),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${unsynced.length} Foto Offline Belum Dicadangkan",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Sinkronkan semua foto lokal SQLite ke Cloudinary sekarang.",
                  style: TextStyle(fontSize: 10, color: Color(0xFFB45309)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            icon:
                _isBatchSyncing
                    ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.cloud_upload_rounded, size: 14),
            label: Text(
              _isBatchSyncing ? "Syncing..." : "Sync Semua",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            onPressed: _isBatchSyncing ? null : _syncAllOfflinePhotos,
          ),
        ],
      ),
    );
  }

  void _showFullPhotoDialog(GeotaggedPhotoModel photo) {
    showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dialog Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 10, 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.compress_rounded,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Hasil Kompresi Foto #${photo.id ?? '?'}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  // Full Photo Preview
                  Flexible(
                    child: ClipRRect(
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        child: Image.file(
                          photo.displayFile,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (_, __, ___) => Container(
                                height: 220,
                                color: const Color(0xFF1E293B),
                                child: const Center(
                                  child: Text(
                                    "Gagal memuat gambar",
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),

                  // Telemetry & Compression Breakdown Footer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Before & After Stats
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: Color(0xFF94A3B8),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Asli: ${photo.formattedOriginalSize}",
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(0xFF10B981),
                                size: 14,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF10B981),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Kompresi: ${photo.formattedCompressedSize} (-${photo.formattedSavings})",
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Address & Coordinates
                        Text(
                          photo.fullAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          photo.formattedCoordinates,
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 10.5,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Cloud Sync Status Pill inside Dialog
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                photo.isCloudSynced
                                    ? const Color(
                                      0xFF064E3B,
                                    ).withValues(alpha: 0.6)
                                    : const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  photo.isCloudSynced
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF334155),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                photo.isCloudSynced
                                    ? Icons.cloud_done_rounded
                                    : Icons.cloud_off_rounded,
                                size: 14,
                                color:
                                    photo.isCloudSynced
                                        ? const Color(0xFF34D399)
                                        : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  photo.isCloudSynced
                                      ? "Tersinkron ke ${photo.cloudProvider}: ${photo.cloudUrl}"
                                      : "Belum dicadangkan ke Cloud Storage",
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color:
                                        photo.isCloudSynced
                                            ? const Color(0xFFD1FAE5)
                                            : const Color(0xFF94A3B8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (photo.isCloudSynced && photo.cloudUrl.isNotEmpty)
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: photo.cloudUrl),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("URL Cloud disalin!"),
                                        duration: Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      "SALIN",
                                      style: TextStyle(
                                        color: Color(0xFF34D399),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Quick Actions Row in Dialog
                        Row(
                          children: [
                            // Save to Gallery
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.photo_library_rounded,
                                  size: 14,
                                ),
                                label: const Text(
                                  "Galeri HP",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () => _savePhotoToGallery(photo),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Backup Cloud
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      photo.isCloudSynced
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: Icon(
                                  photo.isCloudSynced
                                      ? Icons.cloud_done_rounded
                                      : Icons.cloud_upload_rounded,
                                  size: 14,
                                ),
                                label: Text(
                                  photo.isCloudSynced ? "Synced" : "Cloud",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () => _uploadPhotoToCloud(photo),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Open Map
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF475569),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => InteractiveGeotagMapPage(
                                          latitude: photo.latitude,
                                          longitude: photo.longitude,
                                          altitude: photo.altitude,
                                          accuracy: photo.accuracy,
                                          address: photo.address,
                                          carrier: photo.carrier,
                                        ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.map_rounded,
                                size: 15,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Share
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF475569),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _sharePhoto(photo),
                              child: const Icon(
                                Icons.share_rounded,
                                size: 15,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildPhotoCard(GeotaggedPhotoModel photo) {
    final double savingsRatio =
        (photo.originalSizeBytes > 0 && photo.compressedSizeBytes > 0)
            ? (photo.compressedSizeBytes / photo.originalSizeBytes).clamp(
              0.05,
              1.0,
            )
            : 0.15;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Bar: ID, Date, and SQLite Storage Pill
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0284C7,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "ID #${photo.id ?? '?'}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.storage_rounded,
                              size: 10,
                              color: Color(0xFF10B981),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "SQLite",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                photo.isCloudSynced
                                    ? const Color(
                                      0xFF06B6D4,
                                    ).withValues(alpha: 0.12)
                                    : const Color(
                                      0xFF64748B,
                                    ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                photo.isCloudSynced
                                    ? Icons.cloud_done_rounded
                                    : Icons.cloud_off_rounded,
                                size: 10,
                                color:
                                    photo.isCloudSynced
                                        ? const Color(0xFF0891B2)
                                        : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  photo.isCloudSynced ? "Cloud" : "No Cloud",
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        photo.isCloudSynced
                                            ? const Color(0xFF0891B2)
                                            : const Color(0xFF94A3B8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  photo.formattedDateTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 2. Photo Thumbnail + Geotag Stamp Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail with Tap to Zoom
                GestureDetector(
                  onTap: () => _showFullPhotoDialog(photo),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.file(
                              photo.displayFile,
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    width: 88,
                                    height: 88,
                                    color: const Color(0xFFE2E8F0),
                                    child: const Icon(
                                      Icons.broken_image_rounded,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                            ),
                            // Orange accent bar watermark
                            Container(
                              width: 4,
                              height: 40,
                              color: const Color(0xFFF59E0B),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.zoom_in_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Address & Telemetry Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address
                      Text(
                        photo.fullAddress,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Coordinates Monospace Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          photo.formattedCoordinates,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontFamily: 'monospace',
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Altitude & Accuracy & Carrier
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "±${photo.accuracy.toStringAsFixed(1)}m • ${photo.formattedAltitude}",
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (photo.carrierName.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                photo.carrierName,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF1D4ED8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. 🗜️ PROMINENT COMPRESSION RESULTS BOX
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4), // Soft emerald tint
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF86EFAC), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Savings Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.compress_rounded,
                          color: Color(0xFF059669),
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "HASIL KOMPRESI FOTO",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Hemat ${photo.formattedSavings}",
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Size Transition: Original ➔ Compressed
                Row(
                  children: [
                    // Original Size
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ukuran Asli",
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              photo.formattedOriginalSize,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Color(0xFF059669),
                      ),
                    ),
                    // Compressed Size
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hasil Kompresi",
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF059669),
                              ),
                            ),
                            Text(
                              photo.formattedCompressedSize,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),

                // Visual Compression Ratio Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      // Compressed portion
                      Expanded(
                        flex: (savingsRatio * 100).round().clamp(5, 95),
                        child: Container(
                          height: 5,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      // Saved portion
                      Expanded(
                        flex: ((1.0 - savingsRatio) * 100).round().clamp(5, 95),
                        child: Container(
                          height: 5,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Progress Bar during individual upload
          if (_uploadingPhotoIds.contains(photo.id)) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mengunggah ke Cloudinary...",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${((_photoUploadProgress[photo.id] ?? 0.0) * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _photoUploadProgress[photo.id] ?? 0.0,
                      backgroundColor: const Color(0xFFEEF2FF),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1),
                      ),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // 4. Action Buttons Toolbar (Dual Row layout)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Column(
              children: [
                // Row 1: Primary actions (Galeri MediaStore & Cloud Backup)
                Row(
                  children: [
                    // Save to Gallery
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.photo_library_rounded, size: 13),
                        label: const Text(
                          "Galeri HP",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _savePhotoToGallery(photo),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Backup to Cloud
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              photo.isCloudSynced
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        icon:
                            _uploadingPhotoIds.contains(photo.id)
                                ? const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Icon(
                                  photo.isCloudSynced
                                      ? Icons.cloud_done_rounded
                                      : Icons.cloud_upload_rounded,
                                  size: 13,
                                ),
                        label: Text(
                          _uploadingPhotoIds.contains(photo.id)
                              ? "${((_photoUploadProgress[photo.id] ?? 0.0) * 100).toInt()}%"
                              : (photo.isCloudSynced ? "Synced" : "Cloud"),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed:
                            _uploadingPhotoIds.contains(photo.id)
                                ? null
                                : () => _uploadPhotoToCloud(photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Row 2: Secondary actions (Lihat, Peta, Share, Delete)
                Row(
                  children: [
                    // Preview Full Photo Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF334155),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 13,
                        ),
                        label: const Text(
                          "Lihat",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => _showFullPhotoDialog(photo),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Open Map Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0284C7),
                        side: const BorderSide(color: Color(0xFFBAE6FD)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.map_rounded, size: 13),
                      label: const Text(
                        "Peta",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => InteractiveGeotagMapPage(
                                  latitude: photo.latitude,
                                  longitude: photo.longitude,
                                  altitude: photo.altitude,
                                  accuracy: photo.accuracy,
                                  address: photo.address,
                                  carrier: photo.carrier,
                                ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),

                    // Share Button
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F172A),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _sharePhoto(photo),
                      child: const Icon(Icons.share_rounded, size: 14),
                    ),
                    const SizedBox(width: 6),

                    // Delete Button
                    IconButton(
                      tooltip: "Hapus dari SQLite",
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                      onPressed: () => _deletePhoto(photo),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Color(0xFF0284C7),
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Belum Ada Foto Tersimpan di SQLite",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Ambil foto ber-geotagging melalui menu kamera untuk otomatis mengompresi dan menyimpannya ke database SQLite.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 KB";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }
}
