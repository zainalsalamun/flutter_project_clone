import 'package:flutter/material.dart';

class SharkFitUpgradePage extends StatefulWidget {
  const SharkFitUpgradePage({super.key});

  @override
  State<SharkFitUpgradePage> createState() => _SharkFitUpgradePageState();
}

class _SharkFitUpgradePageState extends State<SharkFitUpgradePage> {
  bool _isChecking = false;
  String _statusMessage = 'Current Version: V1.0.0';
  bool _upToDate = true;

  void _checkForUpdates() async {
    setState(() {
      _isChecking = true;
      _statusMessage = 'Checking for updates...';
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isChecking = false;
        _upToDate = true; // Simulating no updates found for now
        _statusMessage =
            'Your software is up to date.\nCurrent Version: V1.0.0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Firmware Upgrade',
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
      body: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(
            child: Column(
              children: [
                // Device/Upgrade Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.system_update_alt,
                    size: 60,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Black Shark GTN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (_isChecking)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  )
                else
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                if (!_isChecking)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _checkForUpdates,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Check for Updates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Auto-update over Wi-Fi is enabled',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
