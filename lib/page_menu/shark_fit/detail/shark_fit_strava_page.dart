import 'package:flutter/material.dart';

class SharkFitStravaPage extends StatefulWidget {
  const SharkFitStravaPage({super.key});

  @override
  State<SharkFitStravaPage> createState() => _SharkFitStravaPageState();
}

class _SharkFitStravaPageState extends State<SharkFitStravaPage> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Strava',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Strava Logo Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFC4C02), // Strava Orange
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.directions_run,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Connect to Strava",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Upload your activities to Strava automatically. Share your running and cycling routes with friends.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            const Spacer(),

            // Connect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isConnected = !_isConnected;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isConnected
                            ? 'Connected to Strava'
                            : 'Disconnected from Strava',
                      ),
                      backgroundColor:
                          _isConnected
                              ? const Color(0xFF00C853)
                              : Colors.black87,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isConnected ? Colors.white : const Color(0xFFFC4C02),
                  foregroundColor:
                      _isConnected ? const Color(0xFFFC4C02) : Colors.white,
                  side:
                      _isConnected
                          ? const BorderSide(color: Color(0xFFFC4C02), width: 2)
                          : null,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isConnected ? 'Disconnect' : 'Connect',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!_isConnected)
              TextButton(
                onPressed: () {
                  // TODO: Open help/info
                },
                child: const Text(
                  "Learn more about Strava integration",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
