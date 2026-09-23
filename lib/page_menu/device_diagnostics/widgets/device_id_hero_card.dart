import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/device_diagnostics_event.dart';
import '../theme/diagnostics_colors.dart';

class DeviceIdHeroCard extends StatelessWidget {
  final DeviceDiagnosticsEvent event;
  final bool isMasked;
  final bool isLiveDevice;
  final VoidCallback onToggleMask;
  final VoidCallback? onRegenerateId;

  const DeviceIdHeroCard({
    super.key,
    required this.event,
    required this.isMasked,
    this.isLiveDevice = true,
    required this.onToggleMask,
    this.onRegenerateId,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text("$label copied to clipboard!")),
          ],
        ),
        backgroundColor: DiagnosticsColors.darkCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: DiagnosticsColors.darkSurface,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.qr_code_2_rounded,
                            color: DiagnosticsColors.primaryLight, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Device ID QR Code",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: DiagnosticsColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DiagnosticsColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: DiagnosticsColors.primaryLight.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: event.deviceIdHash,
                  version: QrVersions.auto,
                  size: 180,
                  backgroundColor: DiagnosticsColors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                event.model,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DiagnosticsColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "ID: ${event.maskedDeviceId}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DiagnosticsColors.white.withValues(alpha: 0.6),
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _copyToClipboard(context, event.deviceIdHash, "Full Device ID");
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text("Copy Full Device ID"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DiagnosticsColors.primary,
                    foregroundColor: DiagnosticsColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            DiagnosticsColors.deepNavy,
            DiagnosticsColors.darkCard,
            DiagnosticsColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: DiagnosticsColors.primaryLight.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: DiagnosticsColors.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background watermark
          Positioned(
            right: -25,
            bottom: -25,
            child: Icon(
              Icons.fingerprint_rounded,
              size: 180,
              color: DiagnosticsColors.white.withValues(alpha: 0.04),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header badge row (Overflow fixed with Flexible)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: DiagnosticsColors.primary.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: DiagnosticsColors.primaryLight.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 13,
                              color: DiagnosticsColors.primaryLight,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                "DEVICE IDENTIFIER",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: DiagnosticsColors.primaryLight,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLiveDevice
                            ? DiagnosticsColors.success.withValues(alpha: 0.2)
                            : DiagnosticsColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLiveDevice
                                ? Icons.sensors_rounded
                                : Icons.devices_other_rounded,
                            color: isLiveDevice
                                ? DiagnosticsColors.success
                                : DiagnosticsColors.warning,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isLiveDevice ? "REAL DEVICE" : "PRESET",
                            style: TextStyle(
                              color: isLiveDevice
                                  ? DiagnosticsColors.success
                                  : DiagnosticsColors.warning,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2. Device ID Display Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: DiagnosticsColors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              "HARDWARE SHA-256 HASH",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: DiagnosticsColors.textMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${event.deviceIdHash.length} chars",
                            style: const TextStyle(
                              color: DiagnosticsColors.textSubtle,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        isMasked ? event.maskedDeviceId : event.deviceIdHash,
                        style: const TextStyle(
                          color: DiagnosticsColors.pageBg,
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Actions Row (Responsive Wrap to prevent RenderFlex overflow on small screens)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Reveal / Mask Button
                    OutlinedButton.icon(
                      onPressed: onToggleMask,
                      icon: Icon(
                        isMasked
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 15,
                        color: Colors.white70,
                      ),
                      label: Text(
                        isMasked ? "Reveal" : "Mask",
                        style: const TextStyle(
                          color: DiagnosticsColors.white,
                          fontSize: 11,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: DiagnosticsColors.white.withValues(alpha: 0.25),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),

                    // Copy Button
                    ElevatedButton.icon(
                      onPressed: () => _copyToClipboard(
                          context, event.deviceIdHash, "Device ID"),
                      icon: const Icon(Icons.copy_rounded, size: 15),
                      label: const Text(
                        "Copy ID",
                        style: TextStyle(fontSize: 11),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DiagnosticsColors.primary,
                        foregroundColor: DiagnosticsColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),

                    // QR Code Button
                    IconButton.filled(
                      onPressed: () => _showQrDialog(context),
                      icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: DiagnosticsColors.white.withValues(alpha: 0.12),
                        foregroundColor: DiagnosticsColors.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      tooltip: "Show QR Code",
                    ),

                    if (onRegenerateId != null)
                      IconButton.filled(
                        onPressed: onRegenerateId,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: DiagnosticsColors.white.withValues(alpha: 0.12),
                          foregroundColor: DiagnosticsColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        tooltip: "Re-hash Device Hardware",
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. Meta Info: Installation ID & User ID
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: DiagnosticsColors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.person_outline_rounded,
                                size: 13,
                                color: DiagnosticsColors.white.withValues(alpha: 0.6)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "User: ${event.userId}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: DiagnosticsColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.app_registration_rounded,
                                size: 13,
                                color: DiagnosticsColors.white.withValues(alpha: 0.6)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "Install: ${event.maskedInstallationId}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: DiagnosticsColors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
