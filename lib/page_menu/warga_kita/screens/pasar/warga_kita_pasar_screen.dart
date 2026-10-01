import 'package:flutter/material.dart';
import '../../core/warga_kita_currency.dart';
import '../../core/warga_kita_theme.dart';

class WargaKitaPasarScreen extends StatefulWidget {
  const WargaKitaPasarScreen({super.key});

  @override
  State<WargaKitaPasarScreen> createState() => _WargaKitaPasarScreenState();
}

class _WargaKitaPasarScreenState extends State<WargaKitaPasarScreen> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = ['Semua', 'Kuliner & Makanan', 'Sembako & Galon', 'Jasa & Servis', 'Kerajinan'];

  final List<Map<String, dynamic>> _products = [
    {
      'title': 'Nasi Uduk Komplit Bu Sri',
      'category': 'Kuliner & Makanan',
      'price': 15000,
      'seller': 'Ibu Sri (Blok C1/04)',
      'phone': '0812-3456-7890',
      'rating': '4.9',
      'tag': 'Buka Pagi',
      'desc': 'Nasi uduk gurih dengan bihun, telur balado, orek tempe, dan kerupuk renyah.',
      'icon': Icons.rice_bowl_rounded,
      'color': Color(0xFFD97706),
    },
    {
      'title': 'Isi Ulang Galon Aqua & Gas Elpiji 3kg',
      'category': 'Sembako & Galon',
      'price': 22000,
      'seller': 'Toko Berkah Pak Joko (Blok C2/01)',
      'phone': '0813-8899-1122',
      'rating': '5.0',
      'tag': 'Antar Gratis',
      'desc': 'Siap antar langsung ke depan pintu rumah untuk seluruh warga RT 04.',
      'icon': Icons.local_drink_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'Jasa Cuci AC & Servis Elektronik',
      'category': 'Jasa & Servis',
      'price': 65000,
      'seller': 'Mas Dedi Teknik (Blok C3/15)',
      'phone': '0877-2233-4455',
      'rating': '4.8',
      'tag': 'Bergaransi',
      'desc': 'Pembersihan AC 0.5 - 2 PK, tambah freon, dan perbaikan mesin cuci warga.',
      'icon': Icons.build_rounded,
      'color': Color(0xFF6D28D9),
    },
    {
      'title': 'Kue Kering Nastar & Kastengel Wisman',
      'category': 'Kuliner & Makanan',
      'price': 45000,
      'seller': 'Dapur Mama Maria (Blok C4/09)',
      'phone': '0856-1122-3344',
      'rating': '4.9',
      'tag': 'Pre-Order',
      'desc': 'Kue kering toples renyah lumer butter premium wisman homemade.',
      'icon': Icons.cake_rounded,
      'color': Color(0xFFE11D48),
    },
    {
      'title': 'Madu Murni Randu & Hutan Liar 500ml',
      'category': 'Sembako & Galon',
      'price': 85000,
      'seller': 'Bpk. Hendro (Blok C3/04)',
      'phone': '0819-5566-7788',
      'rating': '5.0',
      'tag': '100% Asli',
      'desc': 'Madu mentah asli dari peternakan lebah alami tanpa campuran pemanis buatan.',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF047857),
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'Semua') return _products;
    return _products.where((p) => p['category'] == _selectedCategory).toList();
  }

  void _contactSeller(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Hubungi Penjual UMKM RT',
                style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                item['title'],
                textAlign: TextAlign.center,
                style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF047857)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WargaKitaTheme.cardBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront_rounded, color: Color(0xFF047857), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item['seller'],
                            style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone_rounded, color: Color(0xFF0284C7), size: 20),
                        const SizedBox(width: 10),
                        Text(
                          item['phone'],
                          style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w600, color: WargaKitaTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Menghubungkan ke WhatsApp ${item['seller']}...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_rounded, color: Colors.white),
                  label: Text(
                    'Pesan via WhatsApp Warga',
                    style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: WargaKitaTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pasar Warga & UMKM RT 04',
          style: WargaKitaTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: WargaKitaTheme.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Banner gotong royong ekonomi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_rounded, color: Color(0xFF047857), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dukung Usaha Tetangga Sendiri',
                        style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF065F46)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Beli kebutuhan harian dari sesama warga RT 04 untuk memperkuat perekonomian lingkungan.',
                        style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Categories Horizontal Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((c) {
                final isSelected = c == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      c,
                      style: WargaKitaTheme.font(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : WargaKitaTheme.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF047857),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF047857) : WargaKitaTheme.cardBorder,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = c);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Product List
          ..._filteredProducts.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: WargaKitaTheme.cardBorder),
                boxShadow: WargaKitaTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (p['color'] as Color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(p['icon'] as IconData, color: p['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['title'],
                              style: WargaKitaTheme.font(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: WargaKitaTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              p['seller'],
                              style: WargaKitaTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          p['tag'],
                          style: WargaKitaTheme.font(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p['desc'],
                    style: WargaKitaTheme.font(fontSize: 11.5, color: WargaKitaTheme.textSecondary, height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatWargaRupiah(p['price']),
                        style: WargaKitaTheme.font(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: WargaKitaTheme.textPrimary,
                        ),
                      ),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton.icon(
                          onPressed: () => _contactSeller(p),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Colors.white),
                          label: Text(
                            'Pesan',
                            style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF047857),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
