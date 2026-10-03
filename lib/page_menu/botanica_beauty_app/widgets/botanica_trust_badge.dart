import 'package:flutter/material.dart';
import '../core/botanica_theme.dart';

class BotanicaTrustBadgeRow extends StatelessWidget {
  const BotanicaTrustBadgeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BotanicaTheme.primaryTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BotanicaTheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(Icons.verified_user_rounded, '100% Asli', 'BPOM Resmi'),
          Container(width: 1, height: 28, color: BotanicaTheme.primary.withValues(alpha: 0.2)),
          _buildItem(Icons.local_shipping_rounded, 'Bebas Ongkir', 'Min. Rp 250rb'),
          Container(width: 1, height: 28, color: BotanicaTheme.primary.withValues(alpha: 0.2)),
          _buildItem(Icons.replay_rounded, 'Garansi 14 Hari', 'Retur Mudah'),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: BotanicaTheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          title,
          style: BotanicaTheme.font(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: BotanicaTheme.primary,
          ),
        ),
        Text(
          subtitle,
          style: BotanicaTheme.font(
            fontSize: 10,
            color: BotanicaTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
