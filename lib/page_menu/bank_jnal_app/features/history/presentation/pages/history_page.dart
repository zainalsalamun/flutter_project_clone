import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';
import '../../../dashboard/presentation/widgets/recent_transaction_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                _buildTab(0, 'Semua'),
                const SizedBox(width: 8),
                _buildTab(1, 'Masuk'),
                const SizedBox(width: 8),
                _buildTab(2, 'Keluar'),
              ],
            ),
          ),
          
          // Transaction List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Text(
                  'Mei 2024',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const RecentTransactionList(isHistoryPage: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
