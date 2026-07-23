import 'package:flutter/material.dart';
import '../models/crypto_asset.dart';

class CryptoAssetTile extends StatelessWidget {
  final CryptoAsset asset;

  const CryptoAssetTile({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final isPositive = asset.priceChangePercentage24h >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: asset.themeColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(asset.icon, color: asset.themeColor, size: 24),
          ),
          const SizedBox(width: 16),

          // Name & Symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  asset.symbol,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Mini Chart Placeholder (A glowing line)
          Expanded(
            child: Center(
              child: Container(
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                      width: 2,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isPositive
                              ? const Color(0xFF10B981).withOpacity(0.3)
                              : const Color(0xFFEF4444).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Price & Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${asset.currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color:
                        isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                    size: 12,
                  ),
                  Text(
                    '${asset.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
                    style: TextStyle(
                      color:
                          isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
