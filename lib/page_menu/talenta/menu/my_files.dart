import 'package:flutter/material.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC62828), // Deep Red
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'My File',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C), // Slightly Darker Red
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white54, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              children: const [
                _FileItem(
                  title: 'SK Pengangkatan Pegawai Tetap',
                  subtitle: 'SK Pengangkatan Pegawai Tetap',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Form Rawat Jalan - Mandiri Inhealth',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Form Rawat Inap - Mandiri Inhealth',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Form Indemnity Claim - Mandiri Inhealth',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Memorandum Prosedur - Cuti Izin dan Istira...',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Surat Pernyataan Kesediaan Pemotongan Up...',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Format Pendaftaran Peserta PPIP',
                  isPdf: false, // Excel/Sheet
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Benefit Mandiri Inhealth 2025 - 2026 Pegaw...',
                  isPdf: true,
                ),
                _Divider(),
                _FileItem(
                  title: 'Company File',
                  subtitle: 'Kebijakan Sistem Manajemen Mutu & Keama...',
                  isPdf: true,
                ),
              ],
            ),
          ),
          // Bottom Button Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1), // Blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Upload file',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isPdf;

  const _FileItem({
    required this.title,
    required this.subtitle,
    required this.isPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPdf ? Icons.picture_as_pdf : Icons.table_chart,
            color: isPdf ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2A2A2A),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF616161),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (title.contains('Pegawai Tetap')) // Only show menu for first item
            Icon(Icons.more_vert, color: Colors.grey.shade600, size: 20),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, indent: 60);
  }
}
