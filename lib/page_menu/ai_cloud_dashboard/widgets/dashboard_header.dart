import 'package:flutter/material.dart';
import '../theme/ai_dashboard_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String currentEnv;
  final ValueChanged<String> onEnvChanged;
  final VoidCallback onNewAgent;
  final VoidCallback onRefresh;
  final bool isRefreshing;

  const DashboardHeader({
    super.key,
    required this.currentEnv,
    required this.onEnvChanged,
    required this.onNewAgent,
    required this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isVeryCompact = availableWidth < 520;
        final isCompact = availableWidth < 740;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AiDashboardTheme.surface,
            border: Border(
              bottom: BorderSide(
                color: AiDashboardTheme.border.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Global Search Bar (with ⌘K Badge)
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AiDashboardTheme.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AiDashboardTheme.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AiDashboardTheme.textMuted,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            color: AiDashboardTheme.textPrimary,
                            fontSize: 12.5,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                isVeryCompact
                                    ? "Search..."
                                    : "Search models, agents, latency, logs...",
                            hintStyle: const TextStyle(
                              color: AiDashboardTheme.textMuted,
                              fontSize: 12.5,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (!isCompact)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AiDashboardTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AiDashboardTheme.borderLight,
                              width: 0.8,
                            ),
                          ),
                          child: const Text(
                            "⌘K",
                            style: TextStyle(
                              color: AiDashboardTheme.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Environment Switcher (shown only on wider widths)
              if (!isCompact) ...[
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AiDashboardTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AiDashboardTheme.borderLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentEnv,
                      dropdownColor: AiDashboardTheme.surfaceElevated,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AiDashboardTheme.textSecondary,
                        size: 16,
                      ),
                      items: [
                        _buildEnvItem(
                          "Production AWS-US",
                          const Color(0xFF10B981),
                        ),
                        _buildEnvItem(
                          "Staging VPC-SG",
                          const Color(0xFF3B82F6),
                        ),
                        _buildEnvItem("Sandbox Dev", const Color(0xFFF59E0B)),
                      ],
                      onChanged: (val) {
                        if (val != null) onEnvChanged(val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Live Refresh Button
              IconButton(
                onPressed: isRefreshing ? null : onRefresh,
                icon:
                    isRefreshing
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AiDashboardTheme.primaryGlow,
                          ),
                        )
                        : const Icon(
                          Icons.refresh_rounded,
                          color: AiDashboardTheme.textSecondary,
                          size: 19,
                        ),
                tooltip: "Live Refresh Cluster Data",
              ),

              // Notifications
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "🔔 No critical cloud alerts. All 4 LLM providers operational.",
                          ),
                          backgroundColor: AiDashboardTheme.surfaceElevated,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AiDashboardTheme.textSecondary,
                      size: 19,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AiDashboardTheme.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 4),

              // Deploy New Agent Action Button
              ElevatedButton(
                onPressed: onNewAgent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AiDashboardTheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryCompact ? 10 : 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, size: 16),
                    if (!isVeryCompact) ...[
                      const SizedBox(width: 4),
                      Text(
                        isCompact ? "Deploy" : "Deploy Agent",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // User Profile Avatar
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  gradient: AiDashboardTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: AiDashboardTheme.surfaceElevated,
                  child: Text(
                    "AD",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DropdownMenuItem<String> _buildEnvItem(String label, Color dotColor) {
    return DropdownMenuItem<String>(
      value: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AiDashboardTheme.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
