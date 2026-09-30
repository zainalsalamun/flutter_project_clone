import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpPinInputShowcase extends StatefulWidget {
  const OtpPinInputShowcase({super.key});

  @override
  State<OtpPinInputShowcase> createState() => _OtpPinInputShowcaseState();
}

class _OtpPinInputShowcaseState extends State<OtpPinInputShowcase> {
  String _enteredCode = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter Verification Code',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'We sent a 6-digit code to your phone',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 24),
          OtpPinInputWidget(
            length: 6,
            onCompleted: (pin) {
              setState(() => _enteredCode = pin);
            },
          ),
          const SizedBox(height: 20),
          if (_enteredCode.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Code Submitted: $_enteredCode',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class OtpPinInputWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const OtpPinInputWidget({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  State<OtpPinInputWidget> createState() => _OtpPinInputWidgetState();
}

class _OtpPinInputWidgetState extends State<OtpPinInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        final fullCode = _controllers.map((c) => c.text).join();
        widget.onCompleted(fullCode);
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.length,
          (index) => Container(
            width: 44,
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[index].text.isEmpty &&
                    index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor:
                      _focusNodes[index].hasFocus
                          ? const Color(0xFF6366F1).withValues(alpha: 0.08)
                          : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (val) => _onChanged(val, index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
