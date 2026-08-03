import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';

class HeroCard extends StatelessWidget {
  final double balance;
  final String accountNumber;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  const HeroCard({
    super.key,
    required this.balance,
    required this.accountNumber,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3B82F6), // Lighter blue
            AppColors.primary, // Primary #0057FF
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'BANK\nJ-NAL',
                    style: AppTextStyles.heading.copyWith(
                      color: Colors.white,
                      height: 1.1,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.sync_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Saldo Utama',
            style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          Text(
            isBalanceVisible ? currencyFormatter.format(balance) : 'Rp •••••••',
            style: AppTextStyles.display.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    accountNumber,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Salin',
                      style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
