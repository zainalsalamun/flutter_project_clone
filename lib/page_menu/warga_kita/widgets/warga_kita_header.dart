import 'package:flutter/material.dart';
import '../core/warga_kita_data.dart';
import '../core/warga_kita_theme.dart';
import 'warga_kita_network_image.dart';

class WargaKitaHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const WargaKitaHeader({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = WargaKitaData.defaultUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: App Logo, Name, Badge & Subtitle
          Row(
            children: [
              // Logo Icon (Green Container with House Icon)
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: WargaKitaTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: WargaKitaTheme.primaryContainer.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Title, Badge & Subtitle Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'WargaKita',
                        style: WargaKitaTheme.font(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: WargaKitaTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // RT/RW Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6CF8BB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.rtRw,
                          style: WargaKitaTheme.font(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF005D42),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${user.village} • Home',
                    style: WargaKitaTheme.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: WargaKitaTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right: Notification Bell & Profile Avatar
          Row(
            children: [
              // Notification Bell with Red Indicator
              InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: WargaKitaTheme.textPrimary,
                        size: 24,
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: WargaKitaTheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Profile Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: WargaKitaTheme.primaryContainer.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: WargaKitaNetworkImage(
                      imageUrl: user.avatarUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
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
