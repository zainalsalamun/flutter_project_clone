import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StickyHeaderDataTableShowcase extends StatefulWidget {
  const StickyHeaderDataTableShowcase({super.key});

  @override
  State<StickyHeaderDataTableShowcase> createState() =>
      _StickyHeaderDataTableShowcaseState();
}

class _ProductRow {
  final String id;
  final String name;
  final String category;
  final int price;
  final int stock;
  final String status; // 'Tersedia', 'Menipis', 'Habis'

  const _ProductRow({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
  });
}

class _StickyHeaderDataTableShowcaseState
    extends State<StickyHeaderDataTableShowcase> {
  final List<_ProductRow> _allProducts = const [
    _ProductRow(
      id: 'P-101',
      name: 'MacBook Pro M3 14"',
      category: 'Laptop',
      price: 28999000,
      stock: 14,
      status: 'Tersedia',
    ),
    _ProductRow(
      id: 'P-102',
      name: 'iPhone 16 Pro Max 256GB',
      category: 'Smartphone',
      price: 24499000,
      stock: 8,
      status: 'Tersedia',
    ),
    _ProductRow(
      id: 'P-103',
      name: 'Sony WH-1000XM5 ANC',
      category: 'Audio',
      price: 5499000,
      stock: 3,
      status: 'Menipis',
    ),
    _ProductRow(
      id: 'P-104',
      name: 'Keychron K2 Pro Mechanical',
      category: 'Accessories',
      price: 1850000,
      stock: 0,
      status: 'Habis',
    ),
    _ProductRow(
      id: 'P-105',
      name: 'Dell UltraSharp 27" 4K',
      category: 'Monitor',
      price: 8900000,
      stock: 12,
      status: 'Tersedia',
    ),
    _ProductRow(
      id: 'P-106',
      name: 'Logitech MX Master 3S',
      category: 'Accessories',
      price: 1599000,
      stock: 22,
      status: 'Tersedia',
    ),
    _ProductRow(
      id: 'P-107',
      name: 'iPad Pro M4 11" OLED',
      category: 'Tablet',
      price: 16999000,
      stock: 5,
      status: 'Menipis',
    ),
    _ProductRow(
      id: 'P-108',
      name: 'AirPods Pro Gen 2 USB-C',
      category: 'Audio',
      price: 3899000,
      stock: 18,
      status: 'Tersedia',
    ),
  ];

  String _searchQuery = '';
  int _sortColumnIndex = 0; // 0: Name, 1: Category, 2: Price, 3: Stock
  bool _sortAscending = true;
  final Set<String> _selectedIds = {};

  // Pagination
  final int _rowsPerPage = 5;
  int _currentPage = 0;

  void _onSort(int columnIndex) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
    });
  }

  void _toggleSelectRow(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAllPage(bool select, List<_ProductRow> pageData) {
    HapticFeedback.selectionClick();
    setState(() {
      if (select) {
        for (var p in pageData) {
          _selectedIds.add(p.id);
        }
      } else {
        for (var p in pageData) {
          _selectedIds.remove(p.id);
        }
      }
    });
  }

  List<_ProductRow> _getProcessedData() {
    var list =
        _allProducts.where((p) {
          final q = _searchQuery.toLowerCase();
          return p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q) ||
              p.id.toLowerCase().contains(q);
        }).toList();

    list.sort((a, b) {
      int cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = a.name.compareTo(b.name);
          break;
        case 1:
          cmp = a.category.compareTo(b.category);
          break;
        case 2:
          cmp = a.price.compareTo(b.price);
          break;
        case 3:
          cmp = a.stock.compareTo(b.stock);
          break;
      }
      return _sortAscending ? cmp : -cmp;
    });

    return list;
  }

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final processedData = _getProcessedData();
    final totalPages = (processedData.length / _rowsPerPage).ceil();
    final safeCurrentPage = _currentPage.clamp(
      0,
      totalPages > 0 ? totalPages - 1 : 0,
    );
    final startIndex = safeCurrentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, processedData.length);
    final pageData = processedData.sublist(startIndex, endIndex);

    final isAllSelected =
        pageData.isNotEmpty &&
        pageData.every((p) => _selectedIds.contains(p.id));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SEARCH BAR & FILTER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: isDark ? Colors.white60 : Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        _currentPage = 0;
                      });
                    },
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari produk, kategori, atau SKU...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontSize: 12,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _searchQuery = ''),
                    child: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white60 : Colors.black54,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // BATCH ACTIONS BANNER
          if (_selectedIds.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF38BDF8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedIds.length} Baris Terpilih',
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ekspor data ke CSV berhasil!'),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.download_rounded,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                        label: const Text(
                          'Ekspor',
                          style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 11,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _selectedIds.clear());
                        },
                        icon: Icon(
                          Icons.clear_all_rounded,
                          size: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        label: Text(
                          'Batal',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // MAIN STICKY HEADER DATA TABLE FRAME
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 580,
                  child: Column(
                    children: [
                      // 1. STICKY HEADER ROW
                      Container(
                        color:
                            isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF1F5F9),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            // Select All Checkbox
                            SizedBox(
                              width: 28,
                              child: Checkbox(
                                value: isAllSelected,
                                onChanged:
                                    (val) =>
                                        _selectAllPage(val ?? false, pageData),
                                activeColor: const Color(0xFF38BDF8),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ID
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('No', 0, isDark),
                            ),
                            // Product Name
                            Expanded(
                              flex: 3,
                              child: _buildHeaderCell('Produk', 1, isDark),
                            ),
                            // Category
                            Expanded(
                              flex: 2,
                              child: _buildHeaderCell('Kategori', 2, isDark),
                            ),
                            // Price
                            Expanded(
                              flex: 2,
                              child: _buildHeaderCell('Harga', 3, isDark),
                            ),
                            // Stock
                            Expanded(
                              flex: 1,
                              child: _buildHeaderCell('Stok', 4, isDark),
                            ),
                            // Status
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: Colors.white12),

                      // 2. DATA ROWS
                      if (pageData.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 36,
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tidak ada produk ditemukan',
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white38 : Colors.black38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...List.generate(pageData.length, (index) {
                          final product = pageData[index];
                          final isSelected = _selectedIds.contains(product.id);

                          return Container(
                            color:
                                isSelected
                                    ? const Color(
                                      0xFF38BDF8,
                                    ).withValues(alpha: 0.1)
                                    : (index.isEven
                                        ? (isDark
                                            ? const Color(0xFF1E293B)
                                            : Colors.white)
                                        : (isDark
                                            ? const Color(0xFF161F2E)
                                            : const Color(0xFFF8FAFC))),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                // Checkbox
                                SizedBox(
                                  width: 28,
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged:
                                        (val) => _toggleSelectRow(product.id),
                                    activeColor: const Color(0xFF38BDF8),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // ID
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${startIndex + index + 1}',
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                // Name
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          color:
                                              isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        product.id,
                                        style: TextStyle(
                                          color:
                                              isDark
                                                  ? Colors.white38
                                                  : Colors.black38,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Category
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    product.category,
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black87,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                // Price
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _formatRupiah(product.price),
                                    style: const TextStyle(
                                      color: Color(0xFF38BDF8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Stock
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${product.stock}',
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black87,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                // Status Pill Badge
                                Expanded(
                                  flex: 2,
                                  child: _buildStatusBadge(product.status),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // PAGINATION CONTROLS FOOTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menampilkan ${processedData.isEmpty ? 0 : startIndex + 1}-$endIndex dari ${processedData.length} data',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 11,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed:
                        safeCurrentPage > 0
                            ? () => setState(
                              () => _currentPage = safeCurrentPage - 1,
                            )
                            : null,
                    icon: const Icon(Icons.chevron_left_rounded, size: 20),
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  Text(
                    '${safeCurrentPage + 1} / ${totalPages == 0 ? 1 : totalPages}',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        safeCurrentPage < totalPages - 1
                            ? () => setState(
                              () => _currentPage = safeCurrentPage + 1,
                            )
                            : null,
                    icon: const Icon(Icons.chevron_right_rounded, size: 20),
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, int columnIndex, bool isDark) {
    final isSorted = _sortColumnIndex == columnIndex;

    return InkWell(
      onTap: () => _onSort(columnIndex),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color:
                  isSorted
                      ? const Color(0xFF38BDF8)
                      : (isDark ? Colors.white70 : Colors.black87),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isSorted
                ? (_sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded)
                : Icons.unfold_more_rounded,
            color:
                isSorted
                    ? const Color(0xFF38BDF8)
                    : (isDark ? Colors.white24 : Colors.black26),
            size: 13,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFF10B981);
    if (status == 'Menipis') bg = const Color(0xFFF59E0B);
    if (status == 'Habis') bg = const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: bg.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(color: bg, fontSize: 9.5, fontWeight: FontWeight.bold),
      ),
    );
  }
}
