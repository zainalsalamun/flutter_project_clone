import 'package:flutter/material.dart';

class Reimbursement extends StatelessWidget {
  const Reimbursement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1F1F1F)),
        centerTitle: true,
        title: const Text(
          'Reimbursement ',
          style: TextStyle(
            color: Color(0xFF1F1F1F),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: const Center(child: Text('Reimbursement ')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
