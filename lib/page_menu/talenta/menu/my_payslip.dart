import 'package:flutter/material.dart';

class MyPayslip extends StatelessWidget {
  const MyPayslip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Payslip'),
        backgroundColor: const Color(0xFFF6F6F6),
        foregroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: const Center(child: Text('My Payslip Content')),
    );
  }
}
