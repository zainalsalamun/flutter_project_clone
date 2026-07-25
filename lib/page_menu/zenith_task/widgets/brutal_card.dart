import 'package:flutter/material.dart';

class BrutalCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;

  const BrutalCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderWidth = 3.0,
    this.shadowOffset = 6.0,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: 0, // Hard shadow is key for Neo-Brutalism
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
