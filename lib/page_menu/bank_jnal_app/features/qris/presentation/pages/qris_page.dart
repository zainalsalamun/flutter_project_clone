import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';

class QrisPage extends StatelessWidget {
  const QrisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('QRIS'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.flash_off_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Scan',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'Saya',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Mock Camera View
          Container(
            color: Colors.black87,
            width: double.infinity,
            height: double.infinity,
          ),
          
          // Overlay UI
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 48),
                Text(
                  'Arahkan kamera ke QR Code',
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
                const Spacer(),
                
                // Scan Frame
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white54,
                        size: 100,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Actions
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomAction(Icons.photo_library_outlined, 'Galeri'),
                      _buildBottomAction(Icons.qr_code_rounded, 'Scan QRIS', isCenter: true),
                      _buildBottomAction(Icons.flashlight_on_outlined, 'Lampu'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, {bool isCenter = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isCenter ? 16 : 12),
          decoration: BoxDecoration(
            color: isCenter ? AppColors.primary : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isCenter ? 32 : 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
