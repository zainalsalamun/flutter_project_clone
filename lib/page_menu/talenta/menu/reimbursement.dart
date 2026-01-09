import 'package:flutter/material.dart';

class Reimbursement extends StatelessWidget {
  const Reimbursement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6), // Light Beige
      appBar: AppBar(
        title: const Text(
          'Benefit Reimbursement',
          style: TextStyle(
            color: Color(0xFF1F1F1F),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFBF8F6),
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1F1F1F)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Balance Section
              const Text(
                'My balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Color(0xFF1F4BD8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No policy assigned',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Reimbursement policy will appear if\nyou have assigned one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Filter Section
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Color(0xFF5A5A5A),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Jan 2026',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2A2A2A),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48, // Match height roughly
                    width: 48,
                    decoration: const BoxDecoration(
                      // color: Colors.white,
                      // borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF757575),
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Empty State Request
              Center(
                child: Column(
                  children: [
                    // Illustration placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.folder_open,
                        size: 64,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No reimbursement request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'You can request reimbursement by clicking this button below.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4967FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Request reimbursement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
