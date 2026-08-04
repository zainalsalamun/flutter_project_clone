import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Transfer'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.qr_code_scanner_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari nomor rekening atau nama',
                  prefixIcon: const Icon(Icons.search_rounded),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
            ),
            
            // Favorites
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Favorit', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                      Text('Lihat Semua', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFavoriteItem('AS', 'Ayah', '1234 5678 90', Colors.green.shade100, Colors.green.shade700),
                      _buildFavoriteItem('IS', 'Ibu', '0987 6543 21', Colors.teal.shade100, Colors.teal.shade700),
                      _buildFavoriteItem('DR', 'Dimas', '1122 3344 55', Colors.red.shade100, Colors.red.shade700),
                      _buildFavoriteItem('KN', 'Kantor', '6677 8899 00', Colors.purple.shade100, Colors.purple.shade700),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Form Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle Ke Rekening / Ke Bank Lain
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Ke Rekening',
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Ke Bank Lain',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  _buildFormInput('Nomor Rekening', 'Masukkan nomor rekening'),
                  const SizedBox(height: 16),
                  _buildFormInput('Nama Penerima', 'Akan tampil otomatis', enabled: false),
                  const SizedBox(height: 16),
                  _buildFormInput('Nominal', 'Rp 0', isNumber: true),
                  const SizedBox(height: 16),
                  _buildFormInput('Catatan (Opsional)', 'Tulis catatan'),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Lanjut'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(String initial, String name, String number, Color bgColor, Color textColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: bgColor,
          child: Text(
            initial,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(
          number,
          style: AppTextStyles.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildFormInput(String label, String hint, {bool enabled = true, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          enabled: enabled,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: enabled ? Colors.white : AppColors.background,
          ),
        ),
      ],
    );
  }
}
