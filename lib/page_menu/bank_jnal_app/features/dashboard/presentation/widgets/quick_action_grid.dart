import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionItem(icon: Icons.sync_alt_rounded, label: 'Transfer', onTap: () {}),
            _ActionItem(icon: Icons.qr_code_scanner_rounded, label: 'QRIS', onTap: () {}),
            _ActionItem(icon: Icons.account_balance_wallet_outlined, label: 'Top Up', onTap: () {}),
            _ActionItem(icon: Icons.payment_rounded, label: 'Bayar', onTap: () {}),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionItem(icon: Icons.phone_android_rounded, label: 'Pulsa', onTap: () {}),
            _ActionItem(icon: Icons.lightbulb_outline_rounded, label: 'Listrik', onTap: () {}),
            _ActionItem(icon: Icons.wifi_rounded, label: 'Internet', onTap: () {}),
            _ActionItem(icon: Icons.grid_view_rounded, label: 'Lainnya', onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
