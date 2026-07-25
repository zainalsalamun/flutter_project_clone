import 'package:flutter/material.dart';

class BrutalButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final double borderWidth;
  final double shadowOffset;

  const BrutalButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = const Color(0xFFF9A8D4), // Pastel Pink
    this.borderWidth = 3.0,
    this.shadowOffset = 6.0,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          _isPressed ? widget.shadowOffset : 0,
          _isPressed ? widget.shadowOffset : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(color: Colors.black, width: widget.borderWidth),
          boxShadow:
              _isPressed
                  ? [] // No shadow when pressed down
                  : [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(widget.shadowOffset, widget.shadowOffset),
                      blurRadius: 0,
                    ),
                  ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: widget.child,
      ),
    );
  }
}
