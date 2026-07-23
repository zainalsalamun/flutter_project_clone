import 'package:flutter/material.dart';

class CryptoAsset {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double balance;
  final Color themeColor;
  final IconData icon;

  CryptoAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.balance,
    required this.themeColor,
    required this.icon,
  });

  double get totalValue => currentPrice * balance;
}
