import 'package:flutter/material.dart';
import '../core/warga_kita_theme.dart';

class WargaKitaServiceTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeBgColor;
  final Color? badgeTextColor;
  final VoidCallback onTap;

  const WargaKitaServiceTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeBgColor,
    this.badgeTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container with optional Badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
              ),
              if (badgeText != null)
                Positioned(
                  top: -6,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeBgColor ?? const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFA7F3D0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      badgeText!,
                      style: WargaKitaTheme.font(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: badgeTextColor ?? const Color(0xFF047857),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: WargaKitaTheme.font(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: WargaKitaTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 1),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: WargaKitaTheme.font(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
