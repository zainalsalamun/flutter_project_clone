import 'package:flutter/material.dart';

class MyPayslip extends StatefulWidget {
  const MyPayslip({super.key});

  @override
  State<MyPayslip> createState() => _MyPayslipState();
}

class _MyPayslipState extends State<MyPayslip> {
  String _selectedYear = '2025';
  final List<String> _years = ['2026', '2025', '2024', '2023'];

  // Data per year
  // Data per year
  final Map<String, List<Map<String, String>>> _yearData = {
    '2026': [
      {
        'month': 'January',
        'period': '01 Jan - 31 Jan',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
    ],
    '2025': [
      {
        'month': 'December',
        'period': '01 Dec - 31 Dec',
        'status': 'Paid',
        'amount': 'Rp 150.000.000',
      },
      {
        'month': 'November',
        'period': '01 Nov - 30 Nov',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'October',
        'period': '01 Oct - 31 Oct',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'September',
        'period': '01 Sep - 30 Sep',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'August',
        'period': '01 Aug - 31 Aug',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'July',
        'period': '01 Jul - 31 Jul',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'June',
        'period': '01 Jun - 30 Jun',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'May',
        'period': '01 May - 31 May',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'April',
        'period': '01 Apr - 30 Apr',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'March',
        'period': '01 Mar - 31 Mar',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'February',
        'period': '01 Feb - 28 Feb',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'January',
        'period': '01 Jan - 31 Jan',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
    ],
    '2024': [
      {
        'month': 'December',
        'period': '01 Dec - 31 Dec',
        'status': 'Paid',
        'amount': 'Rp 150.000.000',
      },
      {
        'month': 'November',
        'period': '01 Nov - 30 Nov',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'October',
        'period': '01 Oct - 31 Oct',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'September',
        'period': '01 Sep - 30 Sep',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'August',
        'period': '01 Aug - 31 Aug',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'July',
        'period': '01 Jul - 31 Jul',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'June',
        'period': '01 Jun - 30 Jun',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'May',
        'period': '01 May - 31 May',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'April',
        'period': '01 Apr - 30 Apr',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'March',
        'period': '01 Mar - 31 Mar',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'February',
        'period': '01 Feb - 29 Feb',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'January',
        'period': '01 Jan - 31 Jan',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
    ],
    '2023': [
      {
        'month': 'December',
        'period': '01 Dec - 31 Dec',
        'status': 'Paid',
        'amount': 'Rp 150.000.000',
      },
      {
        'month': 'November',
        'period': '01 Nov - 30 Nov',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'October',
        'period': '01 Oct - 31 Oct',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
      {
        'month': 'September',
        'period': '01 Sep - 30 Sep',
        'status': 'Paid',
        'amount': 'Rp 25.000.000',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentData = _yearData[_selectedYear] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text(
          'My Payslip',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD32F2F), // Red theme
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Year Filter Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Year',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedYear,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFD32F2F),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedYear = newValue!;
                        });
                      },
                      items:
                          _years.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Payslip List
          Expanded(
            child:
                currentData.isEmpty
                    ? Center(child: Text('No payslips for $_selectedYear'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: currentData.length,
                      itemBuilder: (context, index) {
                        final data = currentData[index];
                        return _buildPayslipCard(
                          data['month']!,
                          data['period']!,
                          data['amount']!,
                          data['status']!,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipCard(
    String month,
    String period,
    String amount,
    String status,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  period,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Take Home Pay',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          amount,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD32F2F),
                        side: const BorderSide(color: Color(0xFFD32F2F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _showPayslipDetail(context, month, amount);
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPayslipDetail(BuildContext context, String month, String amount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle Bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Payslip $month $_selectedYear',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'PT Naltech Indonesia',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Details List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text(
                      'EARNINGS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Basic Salary', 'Rp 28.000.000'),
                    _buildDetailRow('Fixed Allowance', 'Rp 2.000.000'),
                    _buildDetailRow('Overtime', 'Rp 1.500.000'),
                    const SizedBox(height: 24),
                    const Text(
                      'DEDUCTIONS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Potongan Pajak (PPh 21)',
                      'Rp 3.500.000',
                      isDeduction: true,
                    ),
                    _buildDetailRow(
                      'BPJS Kesehatan',
                      'Rp 1.000.000',
                      isDeduction: true,
                    ),
                    _buildDetailRow(
                      'BPJS Ketenagakerjaan',
                      'Rp 2.000.000',
                      isDeduction: true,
                    ),
                    const SizedBox(height: 32),
                    const Divider(height: 1),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TAKE HOME PAY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          amount,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Download PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String amount, {
    bool isDeduction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            isDeduction ? '-$amount' : amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDeduction ? Colors.red[700] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
