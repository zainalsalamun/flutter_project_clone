import 'package:flutter/material.dart';

class LoadingButtonShowcase extends StatefulWidget {
  const LoadingButtonShowcase({super.key});

  @override
  State<LoadingButtonShowcase> createState() => _LoadingButtonShowcaseState();
}

class _LoadingButtonShowcaseState extends State<LoadingButtonShowcase> {
  ButtonState _state1 = ButtonState.idle;
  ButtonState _state2 = ButtonState.idle;

  void _triggerAction1() async {
    setState(() => _state1 = ButtonState.loading);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _state1 = ButtonState.success);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _state1 = ButtonState.idle);
  }

  void _triggerAction2() async {
    setState(() => _state2 = ButtonState.loading);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _state2 = ButtonState.error);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _state2 = ButtonState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingMorphButton(
            text: 'Save & Submit (Success Flow)',
            state: _state1,
            color: const Color(0xFF6366F1),
            onPressed: _state1 == ButtonState.idle ? _triggerAction1 : null,
          ),
          const SizedBox(height: 20),
          LoadingMorphButton(
            text: 'Process Payment (Error Flow)',
            state: _state2,
            color: const Color(0xFF0F172A),
            onPressed: _state2 == ButtonState.idle ? _triggerAction2 : null,
          ),
        ],
      ),
    );
  }
}

enum ButtonState { idle, loading, success, error }

class LoadingMorphButton extends StatelessWidget {
  final String text;
  final ButtonState state;
  final VoidCallback? onPressed;
  final Color color;
  final double width;
  final double height;

  const LoadingMorphButton({
    super.key,
    required this.text,
    required this.state,
    this.onPressed,
    this.color = const Color(0xFF6366F1),
    this.width = 280,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final isIconState = state != ButtonState.idle;
    final buttonWidth = isIconState ? height : width;

    Color currentBgColor = color;
    if (state == ButtonState.success) currentBgColor = const Color(0xFF10B981);
    if (state == ButtonState.error) currentBgColor = const Color(0xFFEF4444);

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          color: currentBgColor,
          borderRadius: BorderRadius.circular(isIconState ? height / 2 : 14),
          boxShadow: [
            BoxShadow(
              color: currentBgColor.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(isIconState ? height / 2 : 14),
            onTap: state == ButtonState.idle ? onPressed : null,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildChild(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    switch (state) {
      case ButtonState.loading:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case ButtonState.success:
        return const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 26,
          key: ValueKey('success_icon'),
        );
      case ButtonState.error:
        return const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 26,
          key: ValueKey('error_icon'),
        );
      case ButtonState.idle:
        return Text(
          text,
          key: const ValueKey('idle_text'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        );
    }
  }
}
