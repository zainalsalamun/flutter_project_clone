import 'package:flutter/material.dart';

class SharkFitFindDevicePage extends StatefulWidget {
  const SharkFitFindDevicePage({super.key});

  @override
  State<SharkFitFindDevicePage> createState() => _SharkFitFindDevicePageState();
}

class _SharkFitFindDevicePageState extends State<SharkFitFindDevicePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Find Device',
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
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple Effect (visible when searching)
                  if (_isSearching) ...[
                    _buildRipple(_controller),
                    _buildRipple(
                      _controller,
                      delay: const Duration(milliseconds: 1000),
                    ),
                  ],
                  // Central Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.watch,
                      size: 60,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _isSearching
                  ? 'Searching for device...'
                  : 'Click the button to find your device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _toggleSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSearching ? Colors.red : Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isSearching ? 'Stop Searching' : 'Start Searching',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRipple(AnimationController controller, {Duration? delay}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Calculate a staggered value based on delay
        double value = controller.value;
        if (delay != null) {
          double delayPct =
              delay.inMilliseconds / controller.duration!.inMilliseconds;
          value = (value - delayPct);
          if (value < 0) value += 1.0;
        }

        return Container(
          width: 120 + (value * 200),
          height: 120 + (value * 200),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.cyan.withOpacity(1.0 - value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
