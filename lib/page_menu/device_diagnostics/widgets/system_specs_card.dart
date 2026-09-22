import 'package:flutter/material.dart';
import '../models/device_diagnostics_event.dart';

class SystemSpecsCard extends StatelessWidget {
  final DeviceDiagnosticsEvent event;
  final String osVersion;
  final String osBuild;
  final bool isRooted;
  final bool isDeveloperMode;

  const SystemSpecsCard({
    super.key,
    required this.event,
    required this.osVersion,
    required this.osBuild,
    required this.isRooted,
    required this.isDeveloperMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.devices_other_rounded,
                        size: 18, color: Color(0xFF0284C7)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Device & OS Specs",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "App v${event.appVersion}",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Grid of specs
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "Device Model",
                  value: event.model,
                  icon: Icons.smartphone_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "Codename",
                  value: event.device,
                  icon: Icons.code_rounded,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "Brand / Maker",
                  value: "${event.brand} (${event.manufacturer})",
                  icon: Icons.business_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "OS Version",
                  value: osVersion,
                  icon: Icons.android_rounded,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "Sisa Storage / Total",
                  value: event.totalStorageBytes > 0
                      ? "${event.formattedAvailableStorage} / ${event.formattedTotalStorage}"
                      : event.formattedAvailableStorage,
                  icon: Icons.sd_storage_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "Sisa RAM / Total",
                  value: event.totalRamBytes > 0
                      ? "${event.formattedAvailableRam} / ${event.formattedTotalRam}"
                      : event.formattedAvailableRam,
                  icon: Icons.memory_rounded,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              Expanded(
                child: _SpecItem(
                  label: "OS Build ID",
                  value: osBuild,
                  icon: Icons.build_circle_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpecItem(
                  label: "Captured Time",
                  value:
                      "${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}:${event.timestamp.second.toString().padLeft(2, '0')} UTC",
                  icon: Icons.access_time_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          // Security Auditing Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SECURITY & INTEGRITY FLAGS",
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Root Status
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isRooted
                              ? const Color(0xFFFEF2F2)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isRooted
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFF86EFAC),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isRooted
                                  ? Icons.warning_amber_rounded
                                  : Icons.security_rounded,
                              size: 14,
                              color: isRooted
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                isRooted ? "Rooted" : "Not Rooted",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isRooted
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Developer Mode
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDeveloperMode
                              ? const Color(0xFFFFFBEB)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDeveloperMode
                                ? const Color(0xFFFDE68A)
                                : const Color(0xFF86EFAC),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDeveloperMode
                                  ? Icons.developer_mode_rounded
                                  : Icons.lock_outline_rounded,
                              size: 14,
                              color: isDeveloperMode
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                isDeveloperMode ? "Dev Mode ON" : "Dev Mode OFF",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDeveloperMode
                                      ? const Color(0xFFD97706)
                                      : const Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SpecItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
