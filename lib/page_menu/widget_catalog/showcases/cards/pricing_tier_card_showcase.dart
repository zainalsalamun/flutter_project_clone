import 'package:flutter/material.dart';

class PricingTierCardShowcase extends StatefulWidget {
  const PricingTierCardShowcase({super.key});

  @override
  State<PricingTierCardShowcase> createState() =>
      _PricingTierCardShowcaseState();
}

class _PricingTierCardShowcaseState extends State<PricingTierCardShowcase> {
  bool _isAnnual = true;
  int _selectedTierIndex = 1; // Pro is default

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Billing Period Switcher
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => _isAnnual = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        !_isAnnual
                            ? const Color(0xFF0F172A)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Monthly',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: !_isAnnual ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isAnnual = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isAnnual
                            ? const Color(0xFF0F172A)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Annual',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              _isAnnual ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '-20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Pricing Cards
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Starter Card
            Expanded(
              child: _buildPricingCard(
                index: 0,
                name: 'Starter',
                price: _isAnnual ? '\$9' : '\$12',
                period: '/month',
                isPopular: false,
                features: ['5 Projects', '10GB Storage', 'Community Support'],
              ),
            ),
            const SizedBox(width: 12),

            // Pro Card
            Expanded(
              child: _buildPricingCard(
                index: 1,
                name: 'Pro Cloud',
                price: _isAnnual ? '\$29' : '\$39',
                period: '/month',
                isPopular: true,
                features: [
                  'Unlimited Projects',
                  '500GB Fast Storage',
                  '24/7 Priority Support',
                  'AI Widget Generator',
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required int index,
    required String name,
    required String price,
    required String period,
    required bool isPopular,
    required List<String> features,
  }) {
    final isSelected = _selectedTierIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTierIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPopular ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF6366F1)
                    : (isPopular ? Colors.white12 : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isPopular
                      ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isPopular ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 11,
                    color: isPopular ? Colors.white60 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...features.map((f) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color:
                          isPopular
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isPopular ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color:
                    isPopular ? const Color(0xFF6366F1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  isSelected ? 'Selected' : 'Choose Plan',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
