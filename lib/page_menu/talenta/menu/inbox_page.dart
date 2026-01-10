import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Inbox',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          bottom: const TabBar(
            labelColor: Color(0xFF2F74FF),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2F74FF),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [Tab(text: 'Notifications'), Tab(text: 'Need My Approval')],
          ),
        ),
        body: const TabBarView(
          children: [_NotificationsTab(), _NeedMyApprovalTab()],
        ),
      ),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    // Dummy Data for Notifications
    final notifications = [
      _NotificationItem(
        initials: 'IW',
        name: 'Indra Wijaya',
        message: 'Your time off request on 12 Jan 2026 was approved.',
        status: 'Time Off Request approved',
        time: 'Today',
      ),
      _NotificationItem(
        initials: 'SYS',
        name: 'System',
        message: 'Your monthly payslip is ready to view.',
        status: 'Payslip generated',
        time: 'Yesterday',
        isSystem: true,
      ),
      _NotificationItem(
        initials: 'LP',
        name: 'Lestari Putri',
        message: 'Your shift change request for 15 Jan 2026 is submitted.',
        status: 'Shift Change submitted',
        time: 'Yesterday',
      ),
      _NotificationItem(
        initials: 'SYS',
        name: 'System',
        message: 'Your clock out is submitted successfully.',
        status: 'Attendance status updated',
        time: '2 days ago',
        isSystem: true,
      ),
      _NotificationItem(
        initials: 'BS',
        name: 'Budi Santoso',
        message: 'Your reimbursement request #R-1029 has been processed.',
        status: 'Reimbursement paid',
        time: '3 days ago',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  item.isSystem
                      ? const Color(0xFFE5F0FF) // Light Blue for System
                      : const Color(0xFFF5F5F5), // Light Grey for Users
              child:
                  item.isSystem
                      ? const Icon(
                        Icons.notifications_active,
                        color: Color(0xFF2F74FF),
                      )
                      : Text(
                        item.initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NeedMyApprovalTab extends StatelessWidget {
  const _NeedMyApprovalTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _ApprovalItem(
          icon: Icons.receipt_long_outlined,
          title: 'Reimbursement',
          color: Colors.teal,
        ),
        _ApprovalItem(
          icon: Icons.access_time_filled,
          title: 'Time Off',
          color: Colors.blue,
        ),
        _ApprovalItem(
          icon: Icons.location_on,
          title: 'Attendance',
          color: Colors.orange,
        ),
        _ApprovalItem(
          icon: Icons.history_toggle_off,
          title: 'Overtime',
          color: Colors.deepOrange,
        ),
        _ApprovalItem(
          icon: Icons.change_circle_outlined,
          title: 'Shift change',
          color: Colors.cyan,
        ),
        _ApprovalItem(
          icon: Icons.person_outline,
          title: 'Change data',
          color: Colors.deepPurple,
        ),
        _ApprovalItem(
          icon: Icons.assignment,
          title: 'Forms',
          color: Colors.purple,
        ),
        _ApprovalItem(icon: Icons.flag, title: 'Goals', color: Colors.red),
        _ApprovalItem(
          icon: Icons.calendar_month,
          title: 'Timesheet',
          color: Colors.indigo,
        ),
        _ApprovalItem(icon: Icons.task_alt, title: 'Task', color: Colors.green),
        _ApprovalItem(
          icon: Icons.person_add,
          title: 'Add employee',
          color: Colors.amber,
        ),
        _ApprovalItem(
          icon: Icons.transfer_within_a_station,
          title: 'Employee transfer',
          color: Colors.brown,
        ),
      ],
    );
  }
}

class _ApprovalItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ApprovalItem({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}

class _NotificationItem {
  final String initials;
  final String name;
  final String message;
  final String status;
  final String time;
  final bool isSystem;

  _NotificationItem({
    required this.initials,
    required this.name,
    required this.message,
    required this.status,
    required this.time,
    this.isSystem = false,
  });
}
