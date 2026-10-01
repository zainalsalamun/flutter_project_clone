import 'package:flutter/material.dart';
import '../theme/ai_dashboard_theme.dart';

class BudgetLimitCard extends StatefulWidget {
  const BudgetLimitCard({super.key});

  @override
  State<BudgetLimitCard> createState() => _BudgetLimitCardState();
}

class _BudgetLimitCardState extends State<BudgetLimitCard> {
  double _budgetCap = 250.0;
  final double _currentSpend = 148.93;
  bool _autoStopOnLimit = true;

  @override
  Widget build(BuildContext context) {
    final spendRatio = (_currentSpend / _budgetCap).clamp(0.0, 1.0);
    final isNearLimit = spendRatio > 0.8;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AiDashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Monthly Quota & Cost Alert",
                style: TextStyle(
                  color: AiDashboardTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.credit_card_rounded,
                color: AiDashboardTheme.textSecondary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Hard cap limit to prevent runaway inference billing",
            style: TextStyle(color: AiDashboardTheme.textMuted, fontSize: 11.5),
          ),
          const SizedBox(height: 18),

          // Current spend vs Cap
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Spend",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "\$${_currentSpend.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: AiDashboardTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Allocated Budget Cap",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "\$${_budgetCap.toStringAsFixed(0)} / mo",
                    style: const TextStyle(
                      color: AiDashboardTheme.primaryGlow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Custom Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: spendRatio,
              backgroundColor: AiDashboardTheme.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                isNearLimit
                    ? AiDashboardTheme.warning
                    : AiDashboardTheme.primary,
              ),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(spendRatio * 100).toStringAsFixed(1)}% consumed",
                style: TextStyle(
                  color:
                      isNearLimit
                          ? AiDashboardTheme.warning
                          : AiDashboardTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${(_budgetCap - _currentSpend).toStringAsFixed(2)} remaining",
                style: const TextStyle(
                  color: AiDashboardTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AiDashboardTheme.borderLight, height: 1),
          const SizedBox(height: 12),

          // Interactive Budget Cap Slider
          Row(
            children: [
              const Text(
                "Adjust Cap:",
                style: TextStyle(
                  color: AiDashboardTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AiDashboardTheme.primary,
                    inactiveTrackColor: AiDashboardTheme.surfaceElevated,
                    thumbColor: Colors.white,
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(
                    value: _budgetCap,
                    min: 150.0,
                    max: 1000.0,
                    divisions: 17,
                    onChanged: (val) {
                      setState(() => _budgetCap = val);
                    },
                  ),
                ),
              ),
            ],
          ),

          // Auto-kill switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Auto-throttle inference upon reaching limit",
                  style: TextStyle(
                    color: AiDashboardTheme.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ),
              Switch(
                value: _autoStopOnLimit,
                activeColor: AiDashboardTheme.primaryGlow,
                onChanged: (val) => setState(() => _autoStopOnLimit = val),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
