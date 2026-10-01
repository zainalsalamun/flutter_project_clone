import 'package:flutter/material.dart';
import '../core/warga_kita_theme.dart';
import '../models/warga_kita_models.dart';

class WargaKitaAgendaCard extends StatelessWidget {
  final AgendaItem agenda;
  final VoidCallback onActionTap;
  final VoidCallback? onCardTap;

  const WargaKitaAgendaCard({
    super.key,
    required this.agenda,
    required this.onActionTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WargaKitaTheme.cardBorder,
          width: 1,
        ),
        boxShadow: WargaKitaTheme.cardShadow,
      ),
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges & Timestamp Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: agenda.categoryBadgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          agenda.categoryBadge,
                          style: WargaKitaTheme.font(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: agenda.categoryBadgeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        agenda.organizer,
                        style: WargaKitaTheme.font(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: WargaKitaTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    agenda.timeAgo,
                    style: WargaKitaTheme.font(
                      fontSize: 11,
                      color: WargaKitaTheme.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                agenda.title,
                style: WargaKitaTheme.font(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: WargaKitaTheme.textPrimary,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                agenda.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: WargaKitaTheme.font(
                  fontSize: 12,
                  color: WargaKitaTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Details Container (Event Schedule or Ronda Shift Box)
              if (!agenda.isSiskamling)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE2E7FF),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: WargaKitaTheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            agenda.dateFormatted,
                            style: WargaKitaTheme.font(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: WargaKitaTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: WargaKitaTheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            agenda.timeFormatted,
                            style: WargaKitaTheme.font(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: WargaKitaTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              agenda.location,
                              style: WargaKitaTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: WargaKitaTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                // Siskamling Special Shift Row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE2E7FF),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD1FAE5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: Color(0xFF047857),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Malam Ini: Regu Bpk. Hendra & ...',
                              style: WargaKitaTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: WargaKitaTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pukul 22.00 – 04.30 WIB',
                              style: WargaKitaTheme.font(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: WargaKitaTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tukar Jadwal Button
                      InkWell(
                        onTap: onActionTap,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDAE2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            agenda.isConfirmed ? 'Terjadwal' : 'Tukar\nJadwal',
                            textAlign: TextAlign.center,
                            style: WargaKitaTheme.font(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Row for Non-Siskamling (Attendee Count & "Ikut Serta" Button)
              if (!agenda.isSiskamling) ...[
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Avatar Initials Stack + Confirmed Count
                    Row(
                      children: [
                        SizedBox(
                          width: 58,
                          height: 26,
                          child: Stack(
                            children: [
                              _buildInitialsBubble('H', 0, const Color(0xFF10B981)),
                              _buildInitialsBubble('R', 16, const Color(0xFF0284C7)),
                              _buildInitialsBubble('A', 32, const Color(0xFFF59E0B)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${agenda.attendeeCount} Warga Konfirmasi Hadir',
                          style: WargaKitaTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: WargaKitaTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // "Ikut Serta" Button
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: onActionTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: agenda.isConfirmed
                              ? const Color(0xFF10B981)
                              : WargaKitaTheme.primaryContainer,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (agenda.isConfirmed) ...[
                              const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              agenda.isConfirmed ? 'Terdaftar' : agenda.actionLabel,
                              style: WargaKitaTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsBubble(String initial, double left, Color bg) {
    return Positioned(
      left: left,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
