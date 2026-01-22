import 'package:flutter/material.dart';

class SharkFitOthersPage extends StatefulWidget {
  const SharkFitOthersPage({super.key});

  @override
  State<SharkFitOthersPage> createState() => _SharkFitOthersPageState();
}

class _SharkFitOthersPageState extends State<SharkFitOthersPage> {
  bool _findPhone = true;
  bool _dndMode = false;
  bool _liftWrist = true;
  bool _weatherSync = true;
  String _timeFormat = '24-hour';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        title: const Text(
          'Other Settings',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection([
              _buildSwitchItem(
                title: 'Find Phone',
                subtitle: 'Allow watch to ring phone',
                value: _findPhone,
                onChanged: (val) => setState(() => _findPhone = val),
              ),
              _buildDivider(),
              _buildSwitchItem(
                title: 'Do Not Disturb',
                subtitle: 'Disable notifications on watch',
                value: _dndMode,
                onChanged: (val) => setState(() => _dndMode = val),
              ),
              _buildDivider(),
              _buildSwitchItem(
                title: 'Lift Wrist to View Info',
                value: _liftWrist,
                onChanged: (val) => setState(() => _liftWrist = val),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection([
              _buildTimeFormatItem(),
              _buildDivider(),
              _buildSwitchItem(
                title: 'Weather Sync',
                subtitle: 'Sync local weather to device',
                value: _weatherSync,
                onChanged: (val) => setState(() => _weatherSync = val),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection([
              _buildActionItem(
                title: 'Device Language',
                trailingText: 'English',
                onTap: () {},
              ),
              _buildDivider(),
              _buildActionItem(
                title: 'Vibration Strength',
                trailingText: 'Medium',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection([
              _buildActionItem(
                title: 'Restart Device',
                textColor: Colors.black87,
                onTap: () {
                  // Mock restart action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restarting device...')),
                  );
                },
              ),
              _buildDivider(),
              _buildActionItem(
                title: 'Reset Device',
                textColor: Colors.red,
                onTap: () {
                  // Mock reset action
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFEEEEEE),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    String? trailingText,
    Color textColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFormatItem() {
    return InkWell(
      onTap: () {
        setState(() {
          _timeFormat = _timeFormat == '12-hour' ? '24-hour' : '12-hour';
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Time Format',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              _timeFormat,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
