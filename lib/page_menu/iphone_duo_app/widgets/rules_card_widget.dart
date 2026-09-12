import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/iphone_duo_app/models/lock_plan.dart';
import 'package:project_clone/page_menu/iphone_duo_app/widgets/lock_card_graphic.dart';

class LockCardView extends StatefulWidget {
  final LockPlan plan;
  final VoidCallback? onBack;
  final VoidCallback? onDeposit;

  const LockCardView({
    super.key,
    required this.plan,
    this.onBack,
    this.onDeposit,
  });

  @override
  State<LockCardView> createState() => _LockCardViewState();
}

class _LockCardViewState extends State<LockCardView> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: widget.onBack,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  plan.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 24), // Balance spacing
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Main Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Card Banner
                Container(
                  width: double.infinity,
                  height: 142,
                  decoration: BoxDecoration(
                    color: plan.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: plan.primaryColor.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background glowing radial highlight
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                      ),

                      // Card Content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Interest Pill Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                plan.interestRate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ),

                            // Balance Area
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Total wealth',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isBalanceVisible = !_isBalanceVisible;
                                        });
                                      },
                                      child: Icon(
                                        _isBalanceVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.white.withValues(alpha: 0.85),
                                        size: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _isBalanceVisible ? plan.wealthAmount : '₦ ••••••',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 3D Graphic positioned on right
                      Positioned(
                        right: 8,
                        bottom: 6,
                        child: LockCardGraphic(
                          type: plan.type,
                          size: 110,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // "The Rules" Section Title
                const Text(
                  'The Rules',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 10),

                // Rules Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: plan.lightBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: plan.primaryColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < plan.rules.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        _buildRuleItem(plan.rules[i], plan.textColor),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Lock / Deposit CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: widget.onDeposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Lock Funds in ${plan.title}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(RuleItem item, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: accentColor.withValues(alpha: 0.8),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.description,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            letterSpacing: -0.1,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
