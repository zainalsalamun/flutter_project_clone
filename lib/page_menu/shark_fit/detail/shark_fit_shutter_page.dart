import 'package:flutter/material.dart';

class SharkFitShutterPage extends StatefulWidget {
  const SharkFitShutterPage({super.key});

  @override
  State<SharkFitShutterPage> createState() => _SharkFitShutterPageState();
}

class _SharkFitShutterPageState extends State<SharkFitShutterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Camera Shutter',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Camera Preview Placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for camera stream
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 64, color: Colors.white24),
                      SizedBox(height: 16),
                      Text(
                        'Camera Preview',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ],
                  ),

                  // Guidelines
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white10),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white10),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.white10),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.white10),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Instructions
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              'Shake your wrist or press the device button\nto take a picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circularButton(Icons.photo_library),
                _shutterButton(),
                _circularButton(Icons.timer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shutterButton() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _circularButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
}
