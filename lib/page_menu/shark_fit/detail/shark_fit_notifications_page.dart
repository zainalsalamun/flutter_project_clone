import 'package:flutter/material.dart';

class SharkFitNotificationsPage extends StatefulWidget {
  const SharkFitNotificationsPage({super.key});

  @override
  State<SharkFitNotificationsPage> createState() =>
      _SharkFitNotificationsPageState();
}

class _SharkFitNotificationsPageState extends State<SharkFitNotificationsPage> {
  bool _masterToggle = true;
  final Map<String, bool> _appToggles = {
    'Call': true,
    'SMS': true,
    'Mail': false,
    'Facebook': false,
    'WhatsApp': true,
    'Instagram': true,
    'X (Twitter)': false,
    'Skype': false,
    'Line': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master Switch
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Push Notifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: _masterToggle,
                        activeColor: const Color(0xFF00C853),
                        onChanged: (val) {
                          setState(() => _masterToggle = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Turn on to allow notifications to be pushed to your device. When disabled, the watch will not receive any notifications.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Apps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Apps List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildAppTile('Call', Icons.call, Colors.green),
                  _buildDivider(),
                  _buildAppTile('SMS', Icons.message, Colors.blue),
                  _buildDivider(),
                  _buildAppTile('Mail', Icons.mail, Colors.redAccent),
                  _buildDivider(),
                  _buildAppTile('Facebook', Icons.facebook, Colors.indigo),
                  _buildDivider(),
                  _buildAppTile('WhatsApp', Icons.chat_bubble, Colors.green),
                  _buildDivider(),
                  _buildAppTile(
                    'Instagram',
                    Icons.camera_alt,
                    Colors.purpleAccent,
                  ),
                  _buildDivider(),
                  _buildAppTile('X (Twitter)', Icons.close, Colors.black),
                  _buildDivider(),
                  _buildAppTile('Skype', Icons.video_call, Colors.lightBlue),
                  _buildDivider(),
                  _buildAppTile(
                    'Line',
                    Icons.chat,
                    Colors.greenAccent,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 56),
      child: Divider(height: 1, color: Color(0xFFF5F5F5)),
    );
  }

  Widget _buildAppTile(
    String title,
    IconData icon,
    Color iconColor, {
    bool isLast = false,
  }) {
    final isEnabled = _appToggles[title] ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: isEnabled && _masterToggle, // Disable if master is off
            activeColor: const Color(0xFF00C853),
            onChanged:
                _masterToggle
                    ? (val) {
                      setState(() {
                        _appToggles[title] = val;
                      });
                    }
                    : null,
          ),
        ],
      ),
    );
  }
}
