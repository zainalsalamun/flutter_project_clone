import 'package:flutter/material.dart';
import '../models/fundamental_module.dart';
import '../models/lesson_item.dart';
import '../data/lessons_repository.dart';
import 'lesson_detail_page.dart';
import '../../basics/pages/flutter_basics_home_page.dart';
import '../../catalog/pages/widget_catalog_home_page.dart';

class FundamentalsHomePage extends StatefulWidget {
  const FundamentalsHomePage({super.key});

  @override
  State<FundamentalsHomePage> createState() => _FundamentalsHomePageState();
}

class _FundamentalsHomePageState extends State<FundamentalsHomePage> {
  final TextEditingController _searchController = TextEditingController();
  FundamentalModule _selectedModule = FundamentalModule.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LessonItem> get _filteredLessons {
    return LessonsRepository.allLessons.where((lesson) {
      final matchesModule = _selectedModule == FundamentalModule.all ||
          lesson.module == _selectedModule;

      final q = _searchQuery.toLowerCase().trim();
      final matchesQuery = q.isEmpty ||
          lesson.title.toLowerCase().contains(q) ||
          lesson.subtitle.toLowerCase().contains(q) ||
          lesson.summary.toLowerCase().contains(q);

      return matchesModule && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLessons;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.auto_stories_rounded, color: Color(0xFF6366F1), size: 22),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Materi Dasar Flutter',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${LessonsRepository.allLessons.length} Modul',
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
          // Quick Jump Bar to Widget Labs
          Container(
            color: const Color(0xFFEEF2FF),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.hub_rounded, color: Color(0xFF4F46E5), size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Praktik langsung dengan live widget:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF3730A3)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FlutterBasicsHomePage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Basic Widgets ', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WidgetCatalogHomePage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Pro Lab ', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari materi (Lifecycle, Widget Tree, Null Safety, State)...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF6366F1)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Module Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: FundamentalModule.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final mod = FundamentalModule.values[index];
                  final isSelected = _selectedModule == mod;

                  return InkWell(
                    onTap: () => setState(() => _selectedModule = mod),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? mod.color : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? mod.color : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            mod.icon,
                            size: 15,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            mod.title,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Lessons List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 52, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          'Materi tidak ditemukan',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba kata kunci pencarian lain',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final lesson = filtered[index];
                      return _buildLessonCard(context, lesson);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, LessonItem lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonDetailPage(lesson: lesson),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: lesson.module.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#${lesson.order}',
                      style: TextStyle(
                        color: lesson.module.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.module.title,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: lesson.module.color,
                          ),
                        ),
                        Text(
                          lesson.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                lesson.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.readTimeMinutes} menit baca',
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lesson.level,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF059669),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (lesson.visualizerBuilder != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 12, color: Color(0xFF6366F1)),
                          SizedBox(width: 4),
                          Text(
                            'Diagram Interaktif',
                            style: TextStyle(fontSize: 10, color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
