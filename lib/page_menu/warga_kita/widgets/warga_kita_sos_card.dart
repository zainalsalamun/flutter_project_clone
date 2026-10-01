import 'package:flutter/material.dart';
import '../core/warga_kita_theme.dart';

class WargaKitaSosCard extends StatelessWidget {
  final VoidCallback onTriggerSos;
  final VoidCallback? onPosRondaTap;

  const WargaKitaSosCard({
    super.key,
    required this.onTriggerSos,
    this.onPosRondaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WargaKitaTheme.sosCardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: WargaKitaTheme.sosCardBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Pulsing Siren Icon + Title & Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular SOS Beacon Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF991B1B),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF991B1B).withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.sensors_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tombol Darurat (SOS)',
                      style: WargaKitaTheme.font(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF991B1B),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Siaga 24 Jam: Panggil Pos Satpam, Koordinator Ronda, atau Medis.',
                      style: WargaKitaTheme.font(
                        fontSize: 12,
                        color: WargaKitaTheme.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Row: [ SIAGA DARURAT BUTTON ] + [ POS RONDA STATUS BOX ]
          Row(
            children: [
              // Main SOS Trigger Button
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onTriggerSos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF991B1B),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: const Color(0xFF991B1B).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SIAGA DARURAT',
                          style: WargaKitaTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Pos Ronda Status Box
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: onPosRondaTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: WargaKitaTheme.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pos Ronda',
                          style: WargaKitaTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: WargaKitaTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Siaga',
                              style: WargaKitaTheme.font(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
