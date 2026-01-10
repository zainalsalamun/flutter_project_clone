import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/talenta/menu/reimbursement.dart';
import 'package:project_clone/page_menu/talenta/menu/time_off.dart';
import 'package:project_clone/page_menu/talenta/menu/live_attendance.dart';
import 'package:project_clone/page_menu/talenta/menu/forms_page.dart';
import 'package:project_clone/page_menu/talenta/menu/overtime.dart';

class RequestMenu extends StatelessWidget {
  const RequestMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Request for',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Menu Items
          _RequestItem(
            icon: Icons.receipt_long_outlined,
            title: 'Reimbursement',
            onTap: () {
              Navigator.pop(context); // Close modal
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Reimbursement()),
              );
            },
          ),
          _RequestItem(
            icon: Icons.access_time,
            title: 'Time Off',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimeOff()),
              );
            },
          ),
          _RequestItem(
            icon: Icons.location_on_outlined,
            title: 'Attendance',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveAttendance()),
              );
            },
          ),
          _RequestItem(
            icon: Icons.work_outline,
            title: 'Change shift',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormsPage()),
              );
            },
          ),
          _RequestItem(
            icon: Icons.history_toggle_off,
            title: 'Overtime',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Overtime()),
              );
            },
          ),
          _RequestItem(
            icon: Icons.person_outline,
            title: 'Change data',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RequestItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _RequestItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
