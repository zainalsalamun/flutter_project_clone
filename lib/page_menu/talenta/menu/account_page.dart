import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Andi Saputra',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Senior Mobile Developer\nApp Development Team',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PT Teknologi Maju',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

              // MY INFO
              _SectionHeader(title: 'My info'),
              _MenuItem(icon: Icons.person_outline, title: 'Personal info'),
              _MenuItem(icon: Icons.badge_outlined, title: 'Employment info'),
              _MenuItem(
                icon: Icons.contact_emergency_outlined,
                title: 'Emergency contact info',
              ),
              _MenuItem(icon: Icons.people_outline, title: 'Family info'),
              _MenuItem(
                icon: Icons.school_outlined,
                title: 'Education & Experience',
              ),
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'Payroll info',
              ),
              _MenuItem(icon: Icons.info_outline, title: 'Additional info'),
              _MenuItem(icon: Icons.folder_open, title: 'My files'),
              _MenuItem(icon: Icons.warning_amber_rounded, title: 'Reprimand'),

              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

              // SETTINGS
              _SectionHeader(title: 'Settings'),
              _MenuItem(icon: Icons.lock_outline, title: 'Change password'),
              _MenuItem(
                icon: Icons.pin_drop, // Approximating icon
                title: 'PIN',
                trailingText: 'Disabled',
              ),
              _MenuItem(
                icon: Icons.access_time,
                title: 'Reminder clock in/out',
              ),
              _MenuItem(
                icon: Icons.language,
                title: 'Language',
                trailingText: 'Default device',
              ),

              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

              // HELP
              _SectionHeader(title: 'Help'),
              _MenuItem(icon: Icons.help_outline, title: 'Help center'),
              _MenuItem(
                icon: Icons.local_activity_outlined,
                title: 'FAQ',
              ), // Approximating icon

              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

              // OTHER
              _SectionHeader(title: 'Other'),
              _MenuItem(
                icon: Icons.verified_user_outlined,
                title: 'Safety & Privacy',
              ),
              _MenuItem(
                icon: Icons.campaign_outlined,
                title: 'Give us feedback',
              ),
              _MenuItem(icon: Icons.logout, title: 'Sign out'),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Version 2.105.1 (12038)',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailingText,
    // ignore: unused_element_parameter
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
