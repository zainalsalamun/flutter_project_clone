import 'package:flutter/material.dart';

class NeumorphicButtonShowcase extends StatefulWidget {
  const NeumorphicButtonShowcase({super.key});

  @override
  State<NeumorphicButtonShowcase> createState() =>
      _NeumorphicButtonShowcaseState();
}

class _NeumorphicButtonShowcaseState extends State<NeumorphicButtonShowcase> {
  bool _isLightOn = false;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Neumorphic Soft UI Buttons',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicIconButton(
                icon: _isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                isActive: _isLightOn,
                activeColor: Colors.amber,
                onTap: () => setState(() => _isLightOn = !_isLightOn),
              ),
              NeumorphicIconButton(
                icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                isActive: _isMuted,
                activeColor: Colors.redAccent,
                onTap: () => setState(() => _isMuted = !_isMuted),
              ),
              NeumorphicIconButton(
                icon: Icons.favorite,
                isActive: true,
                activeColor: Colors.pink,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          NeumorphicButton(text: 'Soft Press Action', onTap: () {}),
        ],
      ),
    );
  }
}

class NeumorphicIconButton extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<NeumorphicIconButton> createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDown = _isPressed || widget.isActive;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(18),
          boxShadow:
              isDown
                  ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.9),
                      offset: const Offset(3, 3),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
                      offset: const Offset(-3, -3),
                      blurRadius: 4,
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(-5, -5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFF94A3B8).withValues(alpha: 0.6),
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                    ),
                  ],
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color:
                widget.isActive ? widget.activeColor : const Color(0xFF64748B),
            size: 28,
          ),
        ),
      ),
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const NeumorphicButton({super.key, required this.text, required this.onTap});

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              _isPressed
                  ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.8),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
                      offset: const Offset(-2, -2),
                      blurRadius: 4,
                    ),
                  ]
                  : [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFF94A3B8).withValues(alpha: 0.6),
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                    ),
                  ],
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Color(0xFF334155),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
