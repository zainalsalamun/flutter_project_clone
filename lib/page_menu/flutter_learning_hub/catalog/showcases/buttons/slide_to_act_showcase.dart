import 'package:flutter/material.dart';

class SlideToActShowcase extends StatefulWidget {
  const SlideToActShowcase({super.key});

  @override
  State<SlideToActShowcase> createState() => _SlideToActShowcaseState();
}

class _SlideToActShowcaseState extends State<SlideToActShowcase> {
  bool _isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _isUnlocked ? Colors.green.shade50 : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isUnlocked ? Colors.green : Colors.amber,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                  color: _isUnlocked ? Colors.green : Colors.amber.shade800,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _isUnlocked
                      ? 'Transaction Confirmed!'
                      : 'Waiting for swipe...',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:
                        _isUnlocked
                            ? Colors.green.shade800
                            : Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SlideToConfirmButton(
            text: 'Slide to Confirm Payment',
            completedText: 'Payment Completed',
            isCompleted: _isUnlocked,
            onConfirmed: () {
              setState(() => _isUnlocked = true);
            },
            onReset: () {
              setState(() => _isUnlocked = false);
            },
          ),
        ],
      ),
    );
  }
}

class SlideToConfirmButton extends StatefulWidget {
  final String text;
  final String completedText;
  final bool isCompleted;
  final VoidCallback onConfirmed;
  final VoidCallback onReset;
  final Color primaryColor;
  final double height;

  const SlideToConfirmButton({
    super.key,
    required this.text,
    required this.completedText,
    required this.isCompleted,
    required this.onConfirmed,
    required this.onReset,
    this.primaryColor = const Color(0xFF6366F1),
    this.height = 56,
  });

  @override
  State<SlideToConfirmButton> createState() => _SlideToConfirmButtonState();
}

class _SlideToConfirmButtonState extends State<SlideToConfirmButton> {
  double _dragPosition = 0;
  final GlobalKey _trackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.isCompleted) {
      return Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(widget.height / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'Confirmed Successfully',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: () {
                setState(() => _dragPosition = 0);
                widget.onReset();
              },
              tooltip: 'Reset Slider',
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final thumbSize = widget.height - 8;
        final maxDrag = trackWidth - thumbSize - 8;

        return Container(
          key: _trackKey,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(
              color: widget.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Shimmer / animated prompt text
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              // Draggable Thumb
              Positioned(
                left: 4 + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx).clamp(
                        0.0,
                        maxDrag,
                      );
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragPosition >= maxDrag * 0.85) {
                      widget.onConfirmed();
                    } else {
                      setState(() {
                        _dragPosition = 0;
                      });
                    }
                  },
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: widget.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
