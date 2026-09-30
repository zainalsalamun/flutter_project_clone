import 'package:flutter/material.dart';
import '../models/widget_category.dart';
import '../models/widget_item.dart';
import '../data/widget_catalog_registry.dart';
import '../widgets/catalog_search_bar.dart';
import '../widgets/category_filter_list.dart';
import '../widgets/widget_card_item.dart';
import '../widgets/code_viewer_dialog.dart';
import 'widget_detail_playground_page.dart';
import '../../flutter_basics/pages/flutter_basics_home_page.dart';
import '../../flutter_fundamentals/pages/fundamentals_home_page.dart';

class WidgetCatalogHomePage extends StatefulWidget {
  const WidgetCatalogHomePage({super.key});

  @override
  State<WidgetCatalogHomePage> createState() => _WidgetCatalogHomePageState();
}

class _WidgetCatalogHomePageState extends State<WidgetCatalogHomePage> {
  final TextEditingController _searchController = TextEditingController();
  WidgetCategory _selectedCategory = WidgetCategory.all;
  String _searchQuery = '';
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<WidgetCategory, int> get _categoryCounts {
    final Map<WidgetCategory, int> counts = {
      WidgetCategory.all: WidgetCatalogRegistry.allWidgets.length,
    };
    for (var cat in WidgetCategory.values) {
      if (cat == WidgetCategory.all) continue;
      counts[cat] =
          WidgetCatalogRegistry.allWidgets
              .where((w) => w.category == cat)
              .length;
    }
    return counts;
  }

  List<WidgetItem> get _filteredWidgets {
    return WidgetCatalogRegistry.allWidgets.where((widget) {
      final matchesCategory =
          _selectedCategory == WidgetCategory.all ||
          widget.category == _selectedCategory;

      final query = _searchQuery.toLowerCase().trim();
      final matchesQuery =
          query.isEmpty ||
          widget.title.toLowerCase().contains(query) ||
          widget.description.toLowerCase().contains(query) ||
          widget.tags.any((tag) => tag.toLowerCase().contains(query));

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredWidgets;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.widgets_rounded, color: Color(0xFF6366F1), size: 22),
            SizedBox(width: 8),
            Text(
              'Widget Catalog & Lab',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: const Color(0xFF6366F1),
              size: 22,
            ),
            tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${WidgetCatalogRegistry.allWidgets.length}',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Flutter Learning Pillars Navigation Banner
          Container(
            color: const Color(0xFFF0FDF4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.hub_rounded,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Pilar Belajar Flutter:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF065F46),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FundamentalsHomePage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Materi Dasar ',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FlutterBasicsHomePage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Basic Widgets ',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: CatalogSearchBar(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),

          // Horizontal Category Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: CategoryFilterList(
              selectedCategory: _selectedCategory,
              onCategorySelected:
                  (cat) => setState(() => _selectedCategory = cat),
              categoryCounts: _categoryCounts,
            ),
          ),

          // List / Grid of Widgets
          Expanded(
            child:
                filtered.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tidak ada contoh widget ditemukan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Coba kata kunci pencarian atau kategori lain',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : _isGridView
                    ? LayoutBuilder(
                      builder: (context, constraints) {
                        final isWideScreen = constraints.maxWidth > 650;
                        final crossAxisCount = isWideScreen ? 3 : 2;

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.95,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return WidgetCardItem(
                              item: item,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => WidgetDetailPlaygroundPage(
                                          item: item,
                                        ),
                                  ),
                                );
                              },
                              onCodeTap: () {
                                CodeViewerDialog.show(context, item);
                              },
                            );
                          },
                        );
                      },
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return WidgetListTileItem(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        WidgetDetailPlaygroundPage(item: item),
                              ),
                            );
                          },
                          onCodeTap: () {
                            CodeViewerDialog.show(context, item);
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
