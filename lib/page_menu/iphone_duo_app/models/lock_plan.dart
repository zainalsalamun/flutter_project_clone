import 'package:flutter/material.dart';

enum LockType {
  vaultLock,
  fixedLock,
  targetSavings,
}

class RuleItem {
  final String title;
  final String description;

  const RuleItem({
    required this.title,
    required this.description,
  });
}

class LockPlan {
  final LockType type;
  final String title;
  final String interestRate;
  final String wealthAmount;
  final Color primaryColor;
  final Color secondaryColor;
  final Color lightBgColor;
  final Color textColor;
  final List<RuleItem> rules;

  const LockPlan({
    required this.type,
    required this.title,
    required this.interestRate,
    required this.wealthAmount,
    required this.primaryColor,
    required this.secondaryColor,
    required this.lightBgColor,
    required this.textColor,
    required this.rules,
  });

  static List<LockPlan> samplePlans = [
    const LockPlan(
      type: LockType.vaultLock,
      title: 'Vault Lock',
      interestRate: '12% per annum',
      wealthAmount: '₦0.00',
      primaryColor: Color(0xFF28A0F6),
      secondaryColor: Color(0xFF0077D8),
      lightBgColor: Color(0xFFEAF5FE),
      textColor: Color(0xFF1E6BA8),
      rules: [
        RuleItem(title: 'DURATION', description: '6 months'),
        RuleItem(title: 'ACCESS', description: 'Locked until maturity'),
        RuleItem(title: 'WITHDRAWAL', description: 'No withdrawals before maturity'),
        RuleItem(title: 'EARLY EXIT', description: 'Allowed with a penalty of 5%'),
        RuleItem(title: 'INTEREST', description: 'Calculated daily and paid at maturity'),
      ],
    ),
    const LockPlan(
      type: LockType.fixedLock,
      title: 'Fixed lock',
      interestRate: '12% per annum',
      wealthAmount: '₦0.00',
      primaryColor: Color(0xFF9042F6),
      secondaryColor: Color(0xFF6B22D4),
      lightBgColor: Color(0xFFF4EEFD),
      textColor: Color(0xFF6D2BBF),
      rules: [
        RuleItem(title: 'ACCESS', description: 'Locked until maturity'),
        RuleItem(title: 'WITHDRAWAL', description: 'No withdrawals before maturity'),
        RuleItem(title: 'EARLY EXIT', description: 'Allowed with a penalty of 5%'),
        RuleItem(title: 'INTEREST', description: 'Calculated daily and paid at maturity'),
        RuleItem(title: 'MATURITY', description: 'Principal and interest move to your wallet'),
      ],
    ),
    const LockPlan(
      type: LockType.targetSavings,
      title: 'Target Savings',
      interestRate: '12% per annum',
      wealthAmount: '₦0.00',
      primaryColor: Color(0xFF1ECB6B),
      secondaryColor: Color(0xFF0EA34F),
      lightBgColor: Color(0xFFEBF9F1),
      textColor: Color(0xFF167B40),
      rules: [
        RuleItem(title: 'ACCESS', description: 'Locked until maturity'),
        RuleItem(title: 'WITHDRAWAL', description: 'No withdrawals before maturity'),
        RuleItem(title: 'EARLY EXIT', description: 'Allowed with a penalty of 5%'),
        RuleItem(title: 'INTEREST', description: 'Calculated daily and paid at maturity'),
        RuleItem(title: 'FUNDING', description: 'Wallet, card or bank transfer'),
      ],
    ),
  ];
}
