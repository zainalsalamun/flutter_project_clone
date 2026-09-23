import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/network_connectivity_service.dart';
import '../theme/diagnostics_colors.dart';
import '../pages/network_speed_diagnostics_page.dart';

class NetworkStatusCard extends StatefulWidget {
  final NetworkInfoData networkInfo;
  final VoidCallback onTestPing;
  final VoidCallback? onSimulateBadConnection;
  final bool isTestingPing;

  const NetworkStatusCard({
    super.key,
    required this.networkInfo,
    required this.onTestPing,
    this.onSimulateBadConnection,
    this.isTestingPing = false,
  });

  @override
  State<NetworkStatusCard> createState() => _NetworkStatusCardState();
}

class _NetworkStatusCardState extends State<NetworkStatusCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _shiverController;
  late Animation<double> _shiverAnimation;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for status dots and glows
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shiver / Tremor animation for unstable connection jitter
    _shiverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shiverAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shiverController, curve: Curves.easeInOut),
    );

    // Blinking animation for unstable signal bars
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _blinkAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _updateAnimationStates(widget.networkInfo.isBadConnection);
  }

  @override
  void didUpdateWidget(covariant NetworkStatusCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.networkInfo.isBadConnection !=
        widget.networkInfo.isBadConnection) {
      _updateAnimationStates(widget.networkInfo.isBadConnection);
    }
  }

  void _updateAnimationStates(bool isBad) {
    if (isBad) {
      if (!_shiverController.isAnimating) {
        _shiverController.repeat(reverse: true);
      }
      if (!_blinkController.isAnimating) {
        _blinkController.repeat(reverse: true);
      }
    } else {
      _shiverController.stop();
      _shiverController.reset();
      _blinkController.stop();
      _blinkController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shiverController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.networkInfo;
    final isOnline = info.isOnline;
    final isWifi = info.isWifi;
    final isCellular = info.isCellular;
    final isOffline = info.isDisconnected;
    final isBad = info.isBadConnection;

    // Determine thematic color
    final Color themeColor;
    if (isOffline) {
      themeColor = DiagnosticsColors.danger;
    } else if (isBad) {
      themeColor = DiagnosticsColors.warning;
    } else if (isOnline) {
      themeColor = DiagnosticsColors.success;
    } else {
      themeColor = DiagnosticsColors.warning;
    }

    final IconData iconData;
    if (isOffline) {
      iconData = Icons.wifi_off_rounded;
    } else if (isWifi) {
      iconData = isBad ? Icons.wifi_protected_setup_rounded : Icons.wifi_rounded;
    } else if (isCellular) {
      iconData = Icons.signal_cellular_alt_rounded;
    } else {
      iconData = Icons.device_hub_rounded;
    }

    final headerBadge = isOffline
        ? "OFFLINE"
        : (isBad
            ? "UNSTABLE / POOR"
            : (isWifi ? "WIFI ON" : (isCellular ? "DATA ON" : "ONLINE")));

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shiverAnimation, _blinkAnimation]),
      builder: (context, _) {
        final glowOpacity = isBad ? (_pulseAnimation.value * 0.25) : 0.04;
        final borderColor = isBad
            ? Color.lerp(
                DiagnosticsColors.warning,
                const Color(0xFFEA580C),
                _pulseAnimation.value,
              )!
            : (isOnline
                ? DiagnosticsColors.success.withValues(alpha: 0.3)
                : (isOffline
                    ? DiagnosticsColors.danger.withValues(alpha: 0.2)
                    : DiagnosticsColors.border));

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: DiagnosticsColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: isBad ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: themeColor.withValues(alpha: glowOpacity),
                blurRadius: isBad ? 16 : 10,
                spreadRadius: isBad ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Pulsing Status Dot
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: _pulseAnimation.value * 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "NETWORK & INTERNET CONNECTION",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: DiagnosticsColors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ON/OFF State Badge
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: isBad
                            ? Border.all(color: themeColor.withValues(alpha: 0.4), width: 0.8)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isBad) ...[
                            Icon(Icons.warning_amber_rounded,
                                size: 11, color: themeColor),
                            const SizedBox(width: 3),
                          ],
                          Flexible(
                            child: Text(
                              headerBadge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Main Connection Status Hero Tile
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isBad
                      ? DiagnosticsColors.warningBg
                      : DiagnosticsColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isBad
                        ? DiagnosticsColors.warningBorder
                        : DiagnosticsColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    // Shivering Icon Container (Jitters when bad connection)
                    Transform.translate(
                      offset: Offset(
                        isBad ? math.sin(_shiverAnimation.value * math.pi * 2) * 2.5 : 0.0,
                        0.0,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(iconData, color: themeColor, size: 22),
                          ),
                          if (isBad)
                            Positioned(
                              right: -3,
                              top: -3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: DiagnosticsColors.danger,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.priority_high_rounded,
                                  size: 10,
                                  color: DiagnosticsColors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Connection Info text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  info.networkName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: DiagnosticsColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Signal Strength Bars
                              _buildSignalBars(isOffline, isBad, isOnline),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            info.statusMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isBad
                                  ? DiagnosticsColors.warningDark
                                  : (isOnline
                                      ? DiagnosticsColors.success
                                      : DiagnosticsColors.textSubtle),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Action Buttons: Ping & Bad Connection Sim
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ping Button
                        InkWell(
                          onTap: widget.isTestingPing ? null : widget.onTestPing,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 6),
                            decoration: BoxDecoration(
                              color: DiagnosticsColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: DiagnosticsColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.isTestingPing)
                                  const SizedBox(
                                    width: 11,
                                    height: 11,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.8,
                                      color: DiagnosticsColors.primary,
                                    ),
                                  )
                                else
                                  const Icon(Icons.speed_rounded,
                                      size: 13, color: DiagnosticsColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  widget.isTestingPing ? "..." : "Ping",
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: DiagnosticsColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bad Connection Simulator Toggle Button
                        if (widget.onSimulateBadConnection != null) ...[
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: widget.onSimulateBadConnection,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 6),
                              decoration: BoxDecoration(
                                color: isBad
                                    ? DiagnosticsColors.danger.withValues(alpha: 0.12)
                                    : DiagnosticsColors.warning.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isBad
                                      ? DiagnosticsColors.danger.withValues(alpha: 0.3)
                                      : DiagnosticsColors.warning.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Tooltip(
                                message: isBad
                                    ? "Kembalikan ke koneksi normal"
                                    : "Simulasi koneksi jelek (High Ping)",
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isBad
                                          ? Icons.restart_alt_rounded
                                          : Icons.bolt_rounded,
                                      size: 13,
                                      color: isBad
                                          ? DiagnosticsColors.danger
                                          : DiagnosticsColors.warningDark,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      isBad ? "Reset" : "Test Lag",
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: isBad
                                            ? DiagnosticsColors.danger
                                            : DiagnosticsColors.warningDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Animated Bad Connection Warning Banner
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: DiagnosticsColors.warningSubtle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: DiagnosticsColors.warning.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: _shiverAnimation.value * 0.1,
                          child: const Icon(
                            Icons.signal_wifi_bad_rounded,
                            size: 18,
                            color: DiagnosticsColors.warningDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "⚠️ Jaringan Lemah / Tidak Stabil!",
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                info.latencyMs >= 150
                                    ? "Latensi tinggi (${info.latencyMs} ms). Respons aplikasi mungkin melambat."
                                    : "WiFi/Data terhubung tanpa akses paket internet global.",
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  color: Color(0xFFB45309),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                crossFadeState: isBad
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 12),

              // 4. Network Metrics Grid (State, IP, Ping, Quality)
              Row(
                children: [
                  Expanded(
                    child: _NetworkMetricTile(
                      label: "Internet State",
                      value: isOnline ? "Online" : "Offline",
                      valueColor: isOnline
                          ? DiagnosticsColors.success
                          : DiagnosticsColors.danger,
                      icon: isOnline
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NetworkMetricTile(
                      label: "IP Address",
                      value: info.ipAddress,
                      valueColor: DiagnosticsColors.textPrimary,
                      icon: Icons.language_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NetworkMetricTile(
                      label: "Ping Latency",
                      value: info.latencyMs >= 0 ? "${info.latencyMs} ms" : "N/A",
                      valueColor: info.latencyMs >= 0 && info.latencyMs < 100
                          ? DiagnosticsColors.success
                          : (info.latencyMs < 200
                              ? DiagnosticsColors.warning
                              : DiagnosticsColors.danger),
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NetworkMetricTile(
                      label: "Quality Tier",
                      value: info.qualityLabel,
                      valueColor: isBad
                          ? DiagnosticsColors.warningDark
                          : (isOnline
                              ? DiagnosticsColors.success
                              : DiagnosticsColors.danger),
                      icon: Icons.network_check_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Action button to open full Network & Speed Diagnostics Studio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: const Color(0xFF38BDF8),
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFF0284C7), width: 1.2),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.speed_rounded, size: 16, color: Color(0xFF38BDF8)),
                  label: const Text(
                    "Uji Kecepatan & Diagnostik Jaringan Lengkap",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NetworkSpeedDiagnosticsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 4-bar visual signal strength indicator
  Widget _buildSignalBars(bool isOffline, bool isBad, bool isOnline) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        final barHeight = 4.0 + (index * 2.5); // 4, 6.5, 9, 11.5
        Color barColor;

        if (isOffline) {
          barColor = DiagnosticsColors.borderDark;
        } else if (isBad) {
          if (index < 2) {
            barColor = DiagnosticsColors.warning;
          } else {
            // Flickering amber/red bars for bad connection
            barColor = DiagnosticsColors.danger
                .withValues(alpha: _blinkAnimation.value);
          }
        } else if (isOnline) {
          barColor = DiagnosticsColors.success;
        } else {
          barColor = index == 0
              ? DiagnosticsColors.warning
              : DiagnosticsColors.border;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 3,
          height: barHeight,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }),
    );
  }
}

class _NetworkMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  const _NetworkMetricTile({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: DiagnosticsColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DiagnosticsColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: DiagnosticsColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.0,
                    color: DiagnosticsColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
