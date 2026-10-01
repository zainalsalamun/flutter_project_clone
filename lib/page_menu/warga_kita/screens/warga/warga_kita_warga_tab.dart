import 'package:flutter/material.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';
import '../../widgets/warga_kita_network_image.dart';

class WargaKitaWargaTab extends StatefulWidget {
  const WargaKitaWargaTab({super.key});

  @override
  State<WargaKitaWargaTab> createState() => _WargaKitaWargaTabState();
}

class _WargaKitaWargaTabState extends State<WargaKitaWargaTab> {
  String _searchQuery = '';
  String _selectedBlock = 'Semua';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _blocks = ['Semua', 'Blok C1', 'Blok C2', 'Blok C3', 'Blok C4'];

  List<ResidentContact> _filterResidents(List<ResidentContact> source) {
    return source.where((r) {
      final matchesSearch = r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.houseNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.role.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesBlock = _selectedBlock == 'Semua' || r.block == _selectedBlock;
      return matchesSearch && matchesBlock;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Direktori Warga RT 04',
          style: WargaKitaTheme.font(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: WargaKitaTheme.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WargaKitaTheme.cardBorder),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Cari nama tetangga, blok, atau jabatan...',
                      hintStyle: WargaKitaTheme.font(fontSize: 13, color: WargaKitaTheme.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded, color: WargaKitaTheme.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Block Filter Horizontal Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _blocks.map((b) {
                      final isSel = _selectedBlock == b;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(b),
                          selected: isSel,
                          selectedColor: WargaKitaTheme.primaryContainer,
                          backgroundColor: const Color(0xFFF8FAFC),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : WargaKitaTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSel ? WargaKitaTheme.primaryContainer : WargaKitaTheme.cardBorder,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedBlock = b);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Resident Directory List
          Expanded(
            child: ValueListenableBuilder<List<ResidentContact>>(
              valueListenable: WargaKitaData().residentsNotifier,
              builder: (context, residents, _) {
                final displayList = _filterResidents(residents);

                if (displayList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_search_rounded, size: 48, color: WargaKitaTheme.textTertiary),
                        const SizedBox(height: 12),
                        Text(
                          'Warga tidak ditemukan',
                          style: WargaKitaTheme.font(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: displayList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final res = displayList[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: WargaKitaTheme.cardBorder),
                        boxShadow: WargaKitaTheme.cardShadow,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: WargaKitaNetworkImage(
                              imageUrl: res.avatarUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        res.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: WargaKitaTheme.font(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: WargaKitaTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (res.isVerified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF10B981),
                                        size: 15,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${res.block} ${res.houseNumber} • ${res.phone}',
                                  style: WargaKitaTheme.font(
                                    fontSize: 11,
                                    color: WargaKitaTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: res.role.contains('Ketua') || res.role.contains('Bendahara')
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    res.role,
                                    style: WargaKitaTheme.font(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: res.role.contains('Ketua') || res.role.contains('Bendahara')
                                          ? const Color(0xFF047857)
                                          : WargaKitaTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Menghubungi ${res.name} (${res.phone})...'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD1FAE5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.phone_rounded, color: Color(0xFF047857), size: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
