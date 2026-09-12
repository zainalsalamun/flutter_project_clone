import 'package:flutter/material.dart';

class SideActionDock extends StatelessWidget {
  final int selectedNavIndex;
  final ValueChanged<int> onNavItemSelected;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onShareTap;

  const SideActionDock({
    super.key,
    required this.selectedNavIndex,
    required this.onNavItemSelected,
    this.onBackTap,
    this.onNotificationTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Status & Actions Area
          Column(
            children: [
              const SizedBox(height: 2),
              // Time
              const Text(
                '9:41',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              // Wifi icon
              _DockIconButton(
                icon: Icons.wifi,
                size: 15,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              // Back/Collapse Chevron
              _DockIconButton(
                icon: Icons.chevron_left_rounded,
                size: 20,
                onTap: onBackTap,
              ),
              const SizedBox(height: 6),
              // Bell Notification
              _DockIconButton(
                icon: Icons.notifications_none_rounded,
                size: 18,
                hasBadge: true,
                onTap: onNotificationTap,
              ),
              const SizedBox(height: 6),
              // Share / Node Connect Icon
              _DockIconButton(
                icon: Icons.share_outlined,
                size: 17,
                onTap: onShareTap,
              ),
            ],
          ),

          // Bottom Floating Vertical Navigation Pill
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEBECEE),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavPillItem(
                  icon: Icons.home_rounded,
                  isSelected: selectedNavIndex == 0,
                  onTap: () => onNavItemSelected(0),
                  tooltip: 'Home',
                ),
                const SizedBox(height: 8),
                _NavPillItem(
                  icon: Icons.savings_outlined,
                  isSelected: selectedNavIndex == 1,
                  onTap: () => onNavItemSelected(1),
                  tooltip: 'Savings',
                ),
                const SizedBox(height: 8),
                _NavPillItem(
                  icon: Icons.show_chart_rounded,
                  isSelected: selectedNavIndex == 2,
                  onTap: () => onNavItemSelected(2),
                  tooltip: 'Investments',
                ),
                const SizedBox(height: 8),
                _NavPillItem(
                  icon: Icons.account_balance_wallet_outlined,
                  isSelected: selectedNavIndex == 3,
                  onTap: () => onNavItemSelected(3),
                  tooltip: 'Wallet',
                ),
                const SizedBox(height: 8),
                _NavPillItem(
                  icon: Icons.more_horiz_rounded,
                  isSelected: selectedNavIndex == 4,
                  onTap: () => onNavItemSelected(4),
                  tooltip: 'More',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DockIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool hasBadge;
  final VoidCallback? onTap;

  const _DockIconButton({
    required this.icon,
    required this.size,
    this.hasBadge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              size: size,
              color: Colors.black87,
            ),
          ),
          if (hasBadge)
            Container(
              margin: const EdgeInsets.only(top: 2, right: 2),
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _NavPillItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;

  const _NavPillItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
