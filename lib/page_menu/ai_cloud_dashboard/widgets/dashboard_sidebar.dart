import 'package:flutter/material.dart';
import '../theme/ai_dashboard_theme.dart';

class DashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const DashboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isCollapsed ? 80 : 250,
      decoration: BoxDecoration(
        color: AiDashboardTheme.surface,
        border: Border(
          right: BorderSide(
            color: AiDashboardTheme.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo & Workspace Brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AiDashboardTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AiDashboardTheme.primary.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NEXUS AI",
                          style: TextStyle(
                            color: AiDashboardTheme.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "Cloud Intelligence Hub",
                          style: TextStyle(
                            color: AiDashboardTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(color: AiDashboardTheme.borderLight, height: 1),
          const SizedBox(height: 12),

          // Navigation Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  label: "Overview Hub",
                  badge: null,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.insights_rounded,
                  label: "LLM Usage & Tokens",
                  badge: "LIVE",
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.smart_toy_rounded,
                  label: "Autonomous Agents",
                  badge: "4 Active",
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.public_rounded,
                  label: "Global Cloud Edge",
                  badge: null,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.vpn_key_rounded,
                  label: "API Keys & Secrets",
                  badge: null,
                ),
                _buildNavItem(
                  index: 5,
                  icon: Icons.credit_card_rounded,
                  label: "Billing & Quotas",
                  badge: null,
                ),
              ],
            ),
          ),

          // Workspace status pill & collapse button
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (!isCollapsed)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AiDashboardTheme.surfaceElevated.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AiDashboardTheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AiDashboardTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Cluster 99.98% Healthy",
                            style: TextStyle(
                              color: AiDashboardTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Toggle Collapse Action
                IconButton(
                  onPressed: onToggleCollapse,
                  icon: Icon(
                    isCollapsed
                        ? Icons.chevron_right_rounded
                        : Icons.chevron_left_rounded,
                    color: AiDashboardTheme.textSecondary,
                  ),
                  tooltip: isCollapsed ? "Expand Sidebar" : "Collapse Sidebar",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    String? badge,
  }) {
    final isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () => onItemSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 14 : 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AiDashboardTheme.primary.withOpacity(0.18)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? AiDashboardTheme.primary.withOpacity(0.5)
                      : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color:
                    isSelected
                        ? AiDashboardTheme.primaryGlow
                        : AiDashboardTheme.textSecondary,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.white
                              : AiDashboardTheme.textSecondary,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          badge == "LIVE"
                              ? AiDashboardTheme.danger.withOpacity(0.2)
                              : AiDashboardTheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color:
                            badge == "LIVE"
                                ? AiDashboardTheme.danger
                                : AiDashboardTheme.primary,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color:
                            badge == "LIVE"
                                ? AiDashboardTheme.danger
                                : AiDashboardTheme.primaryGlow,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
