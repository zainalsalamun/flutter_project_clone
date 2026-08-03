import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';

class RecentTransactionList extends StatelessWidget {
  final bool isHistoryPage;

  const RecentTransactionList({super.key, this.isHistoryPage = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isHistoryPage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaksi Terakhir',
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Lihat Semua',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _TransactionItem(
                title: 'Transfer Masuk',
                subtitle: 'Dari Andi Setiawan',
                amount: 1000000,
                isIncome: true,
                time: 'Hari ini, 09:30',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.success,
              ),
              _TransactionItem(
                title: 'Transfer Keluar',
                subtitle: 'Ke Dimas Ramadhan',
                amount: -500000,
                isIncome: false,
                time: 'Hari ini, 07:45',
                icon: Icons.send_rounded,
                iconColor: AppColors.danger,
              ),
              _TransactionItem(
                title: 'QRIS Payment',
                subtitle: 'Coffee Shop',
                amount: -35000,
                isIncome: false,
                time: 'Kemarin, 16:20',
                icon: Icons.qr_code_2_rounded,
                iconColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: isIncome ? '+ Rp ' : '- Rp ',
      decimalDigits: 0,
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            currencyFormatter.format(amount.abs()),
            style: AppTextStyles.body.copyWith(
              color: isIncome ? AppColors.success : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: AppTextStyles.caption.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
