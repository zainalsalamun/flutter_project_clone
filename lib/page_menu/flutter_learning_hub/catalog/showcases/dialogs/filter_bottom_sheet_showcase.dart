import 'package:flutter/material.dart';

class FilterBottomSheetShowcase extends StatefulWidget {
  const FilterBottomSheetShowcase({super.key});

  @override
  State<FilterBottomSheetShowcase> createState() =>
      _FilterBottomSheetShowcaseState();
}

class _FilterBottomSheetShowcaseState extends State<FilterBottomSheetShowcase> {
  String _selectedSort = 'Terlaris';
  RangeValues _priceRange = const RangeValues(50000, 650000);
  final Set<String> _selectedCategories = {'Elektronik', 'Aksesoris'};
  double _minRating = 4.0;
  bool _freeShippingOnly = true;

  final List<String> _sortOptions = [
    'Paling Sesuai',
    'Terlaris',
    'Harga Terendah',
    'Ulasan Terbanyak',
  ];

  final List<String> _categoryOptions = [
    'Elektronik',
    'Aksesoris',
    'Fashion Pria',
    'Kamera',
    'Audio & TWS',
    'Gaming',
  ];

  String _formatCurrency(double val) {
    final intVal = (val ~/ 1000) * 1000;
    final str = intVal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _FilterBottomSheetContent(
          initialSort: _selectedSort,
          initialRange: _priceRange,
          initialCategories: Set.from(_selectedCategories),
          initialRating: _minRating,
          initialFreeShipping: _freeShippingOnly,
          sortOptions: _sortOptions,
          categoryOptions: _categoryOptions,
          formatCurrency: _formatCurrency,
          onApply: (sort, range, cats, rating, shipping) {
            setState(() {
              _selectedSort = sort;
              _priceRange = range;
              _selectedCategories.clear();
              _selectedCategories.addAll(cats);
              _minRating = rating;
              _freeShippingOnly = shipping;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Filter berhasil diterapkan!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Color(0xFF10B981),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. FILTER OVERVIEW CARD ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: Color(0xFF6366F1),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Status Filter Aktif',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_selectedCategories.length + (_freeShippingOnly ? 1 : 0) + 2} Kriteria',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Active Filter Tags Wrap
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSummaryBadge(
                    icon: Icons.sort_rounded,
                    label: _selectedSort,
                  ),
                  _buildSummaryBadge(
                    icon: Icons.payments_outlined,
                    label:
                        '${_formatCurrency(_priceRange.start)} - ${_formatCurrency(_priceRange.end)}',
                  ),
                  _buildSummaryBadge(
                    icon: Icons.star_rounded,
                    label: 'Rating ≥ ${_minRating.toInt()}*',
                  ),
                  if (_freeShippingOnly)
                    _buildSummaryBadge(
                      icon: Icons.local_shipping_rounded,
                      label: 'Gratis Ongkir',
                      color: const Color(0xFF10B981),
                    ),
                  ..._selectedCategories.map(
                    (c) => _buildSummaryBadge(
                      icon: Icons.category_rounded,
                      label: c,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Trigger Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _openFilterModal,
                  icon: const Icon(Icons.filter_list_rounded, size: 18),
                  label: const Text(
                    'Buka Filter Drawer (Bottom Sheet)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBadge({
    required IconData icon,
    required String label,
    Color color = const Color(0xFF6366F1),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FILTER BOTTOM SHEET CONTENT WITH STICKY HEADER & FOOTER
// ---------------------------------------------------------------------------
class _FilterBottomSheetContent extends StatefulWidget {
  final String initialSort;
  final RangeValues initialRange;
  final Set<String> initialCategories;
  final double initialRating;
  final bool initialFreeShipping;
  final List<String> sortOptions;
  final List<String> categoryOptions;
  final String Function(double) formatCurrency;
  final void Function(
    String sort,
    RangeValues range,
    Set<String> cats,
    double rating,
    bool shipping,
  )
  onApply;

  const _FilterBottomSheetContent({
    required this.initialSort,
    required this.initialRange,
    required this.initialCategories,
    required this.initialRating,
    required this.initialFreeShipping,
    required this.sortOptions,
    required this.categoryOptions,
    required this.formatCurrency,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<_FilterBottomSheetContent> {
  late String _tempSort;
  late RangeValues _tempRange;
  late Set<String> _tempCategories;
  late double _tempRating;
  late bool _tempShipping;

  @override
  void initState() {
    super.initState();
    _tempSort = widget.initialSort;
    _tempRange = widget.initialRange;
    _tempCategories = Set.from(widget.initialCategories);
    _tempRating = widget.initialRating;
    _tempShipping = widget.initialFreeShipping;
  }

  void _resetAll() {
    setState(() {
      _tempSort = 'Terlaris';
      _tempRange = const RangeValues(10000, 1000000);
      _tempCategories.clear();
      _tempRating = 3.0;
      _tempShipping = false;
    });
  }

  int get _matchingProductCount {
    int count = 42;
    count -= (_tempCategories.length * 3);
    if (_tempShipping) count -= 8;
    if (_tempRating >= 4.0) count -= 10;
    return count.clamp(4, 60);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------- STICKY TOP HEADER ----------------
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                // Top Notch Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // Title & Reset Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF6366F1),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Filter & Urutkan Produk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _resetAll,
                      child: const Text(
                        'Reset Semua',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------- SCROLLABLE FILTER BODY ----------------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Sort Options
                _buildSectionHeader('Urutkan Berdasarkan'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      widget.sortOptions.map((opt) {
                        final isSelected = _tempSort == opt;
                        return ChoiceChip(
                          label: Text(opt),
                          selected: isSelected,
                          selectedColor: const Color(0xFF6366F1),
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF334155),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _tempSort = opt);
                          },
                        );
                      }).toList(),
                ),
                const Divider(height: 28),

                // 2. Price Range Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader('Rentang Harga'),
                    Text(
                      '${widget.formatCurrency(_tempRange.start)} - ${widget.formatCurrency(_tempRange.end)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF6366F1),
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: const Color(0xFF6366F1),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    values: _tempRange,
                    min: 0,
                    max: 1000000,
                    divisions: 40,
                    onChanged: (vals) => setState(() => _tempRange = vals),
                  ),
                ),
                const Divider(height: 28),

                // 3. Category Multi-select
                _buildSectionHeader('Kategori Pilihan'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      widget.categoryOptions.map((cat) {
                        final isSelected = _tempCategories.contains(cat);
                        return FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(
                            0xFF6366F1,
                          ).withValues(alpha: 0.15),
                          checkmarkColor: const Color(0xFF6366F1),
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color:
                                isSelected
                                    ? const Color(0xFF6366F1)
                                    : const Color(0xFF334155),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _tempCategories.add(cat);
                              } else {
                                _tempCategories.remove(cat);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                const Divider(height: 28),

                // 4. Rating Selector & Shipping
                _buildSectionHeader('Rating Minimum'),
                Row(
                  children:
                      [3.0, 4.0, 4.5].map((r) {
                        final isSelected = _tempRating == r;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.amber,
                            ),
                            label: Text('$r+ Ke atas'),
                            selected: isSelected,
                            selectedColor: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.15),
                            labelStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : Colors.black87,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _tempRating = r);
                            },
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 12),

                // Free Shipping Switch
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Row(
                    children: [
                      Icon(
                        Icons.local_shipping_rounded,
                        size: 18,
                        color: Color(0xFF10B981),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Hanya Produk Bebas Ongkir',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  value: _tempShipping,
                  activeThumbColor: const Color(0xFF10B981),
                  onChanged: (val) => setState(() => _tempShipping = val),
                ),
              ],
            ),
          ),

          // ---------------- STICKY BOTTOM ACTION BAR ----------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hasil Filter:',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        Text(
                          '$_matchingProductCount Produk Cocok',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onApply(
                        _tempSort,
                        _tempRange,
                        _tempCategories,
                        _tempRating,
                        _tempShipping,
                      );
                    },
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}
