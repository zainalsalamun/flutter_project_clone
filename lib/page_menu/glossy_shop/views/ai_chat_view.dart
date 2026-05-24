import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class AiChatView extends StatefulWidget {
  final VoidCallback onStopListening;

  const AiChatView({
    super.key,
    required this.onStopListening,
  });

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _orbitController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _orbitRadiusAnimation;

  @override
  void initState() {
    super.initState();
    
    // Core scaling pulse for the holographic sphere
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Speed rotation for outer particle rings
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Secondary pulsing orbit spacing
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    _orbitRadiusAnimation = Tween<double>(begin: 80, end: 120).animate(
      CurvedAnimation(parent: _orbitController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          
          // Request Bubble / Intent text
          _buildRequestHeader(),
          
          const Spacer(),
          
          // Outer Orbit System + Glowing holographic sphere
          _buildHologramCenter(),
          
          const Spacer(),
          
          // Pulse Text Status
          _buildListeningIndicator(),
          
          const SizedBox(height: 40),
          
          // Action Controllers
          _buildControlActions(),
          
          const SizedBox(height: 110),
        ],
      ),
    );
  }

  Widget _buildRequestHeader() {
    return const Column(
      children: [
        Text(
          "I'm looking for a",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          "minimalistic trending\ngraphic Hoodie.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.25,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.purpleAccent,
                blurRadius: 15,
                offset: Offset(0, 2),
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHologramCenter() {
    return Center(
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer rotating orbits
            AnimatedBuilder(
              animation: Listenable.merge([_rotationController, _orbitRadiusAnimation]),
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(300, 300),
                  painter: HologramOrbitPainter(
                    angle: _rotationController.value * 2 * math.pi,
                    radius: _orbitRadiusAnimation.value,
                  ),
                );
              },
            ),
            
            // Sphere glowing background blur
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.pinkAccent.shade100,
                      Colors.purple.shade400,
                      Colors.indigo.shade900.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.45),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.3),
                      blurRadius: 70,
                      spreadRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            
            // Central Holographic core
            ScaleTransition(
              scale: _pulseAnimation,
              child: ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF4081), Color(0xFF651FFF), Color(0xFF00E5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gloss overlay shine
                      Positioned(
                        top: -15,
                        left: -15,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                      // Core micro grid pattern
                      Opacity(
                        opacity: 0.15,
                        child: Image.network(
                          "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=100",
                          fit: BoxFit.cover,
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeningIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Listening",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 4),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            int dotCount = ((_pulseController.value * 3.5).floor() % 4);
            return SizedBox(
              width: 25,
              child: Text(
                "." * dotCount,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildControlActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text/Keyboard button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.keyboard_outlined, color: Colors.white70, size: 20),
            onPressed: widget.onStopListening,
          ),
        ),
        
        const SizedBox(width: 20),
        
        // Premium Pulse control pill
        GestureDetector(
          onTap: widget.onStopListening,
          child: GlassCard(
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            opacity: 0.15,
            border: Border.all(
              color: Colors.pinkAccent.withOpacity(0.35),
              width: 1.5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF4081), Color(0xFF651FFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.blur_circular,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Ask AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 20),
        
        // Sphere Globe Button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.language_outlined, color: Colors.white70, size: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class HologramOrbitPainter extends CustomPainter {
  final double angle;
  final double radius;

  HologramOrbitPainter({required this.angle, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw outer orbital circle 1 (tilted)
    final orbit1Paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.0), Colors.purpleAccent.withOpacity(0.2), Colors.purpleAccent.withOpacity(0.05)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * 0.4);
    canvas.scale(1.0, 0.45);
    canvas.drawCircle(Offset.zero, radius, orbit1Paint);
    
    // Draw orbital glowing dot
    final dotPaint = Paint()
      ..color = Colors.cyanAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(radius * math.cos(angle), radius * math.sin(angle)), 3.5, dotPaint);
    canvas.restore();

    // Draw outer orbital circle 2 (opposite tilt)
    final orbit2Paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.0), Colors.pinkAccent.withOpacity(0.2), Colors.pinkAccent.withOpacity(0.05)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 20))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-angle * 0.3 - 1.0);
    canvas.scale(0.9, 0.3);
    canvas.drawCircle(Offset.zero, radius + 20, orbit2Paint);
    
    // Draw orbital glowing dot 2
    final dot2Paint = Paint()
      ..color = Colors.pinkAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset((radius + 20) * math.cos(-angle * 1.5), (radius + 20) * math.sin(-angle * 1.5)), 4, dot2Paint);
    canvas.restore();
    
    // Draw glowing orbit circles 3 (center halo)
    final haloPaint = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 58, haloPaint);
  }

  @override
  bool shouldRepaint(covariant HologramOrbitPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.radius != radius;
  }
}
