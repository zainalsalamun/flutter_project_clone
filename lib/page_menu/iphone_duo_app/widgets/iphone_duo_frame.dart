import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/iphone_duo_app/models/lock_plan.dart';
import 'package:project_clone/page_menu/iphone_duo_app/widgets/rules_card_widget.dart';
import 'package:project_clone/page_menu/iphone_duo_app/widgets/side_action_dock.dart';

class IPhoneDuoDeviceFrame extends StatelessWidget {
  final LockPlan plan;
  final int selectedNavIndex;
  final ValueChanged<int> onNavItemSelected;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onDeposit;
  final double width;
  final double height;

  const IPhoneDuoDeviceFrame({
    super.key,
    required this.plan,
    required this.selectedNavIndex,
    required this.onNavItemSelected,
    this.onBackTap,
    this.onNotificationTap,
    this.onShareTap,
    this.onDeposit,
    this.width = 330,
    this.height = 660,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // Titanium / Chrome metallic chassis finish
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B7280),
              Color(0xFF374151),
              Color(0xFF1F2937),
              Color(0xFF111827),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            bottomLeft: Radius.circular(36),
            topRight: Radius.circular(44),
            bottomRight: Radius.circular(44),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: plan.primaryColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 10, // left bezel with hinge
          top: 6,
          right: 6,
          bottom: 6,
        ),
        child: Stack(
          children: [
            // Left Hinge Metal Spine Simulation
            Positioned(
              left: -8,
              top: 40,
              bottom: 40,
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF9CA3AF),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Inner Display Screen
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(38),
                bottomRight: Radius.circular(38),
              ),
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    // Main Screen Body with Right Dock
                    Row(
                      children: [
                        // Left Main Content Area
                        Expanded(
                          child: LockCardView(
                            plan: plan,
                            onBack: onBackTap,
                            onDeposit: onDeposit,
                          ),
                        ),

                        // Vertical Divider Line (Subtle)
                        Container(
                          width: 1,
                          height: double.infinity,
                          color: Colors.grey.withValues(alpha: 0.12),
                        ),

                        // Right Vertical Action Dock
                        SideActionDock(
                          selectedNavIndex: selectedNavIndex,
                          onNavItemSelected: onNavItemSelected,
                          onBackTap: onBackTap,
                          onNotificationTap: onNotificationTap,
                          onShareTap: onShareTap,
                        ),
                      ],
                    ),

                    // Top-Right Camera Punch Hole (Simulating the iPhone Duo Front Camera cutout)
                    Positioned(
                      top: 14,
                      right: 50,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: const Color(0xFF090D16),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1E293B),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 4.5,
                            height: 4.5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E40AF),
                              shape: BoxShape.circle,
                            ),
                          ),
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
    );
  }
}
