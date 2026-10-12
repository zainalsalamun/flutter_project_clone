import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/basic_widget_model.dart';
import '../../fundamentals/widgets/formatted_markdown_text.dart';

class BasicWidgetDetailPage extends StatefulWidget {
  final BasicWidgetModel item;

  const BasicWidgetDetailPage({super.key, required this.item});

  @override
  State<BasicWidgetDetailPage> createState() => _BasicWidgetDetailPageState();
}

class _BasicWidgetDetailPageState extends State<BasicWidgetDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.item.codeSnippet));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kode ${widget.item.name} berhasil disalin ke clipboard!',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

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
        title: Row(
          children: [
            Icon(item.icon, color: item.category.color, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
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
          IconButton(
            icon: const Icon(
              Icons.copy_rounded,
              color: Color(0xFF6366F1),
              size: 20,
            ),
            tooltip: 'Salin Kode',
            onPressed: _copyCode,
          ),
          const SizedBox(width: 6),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: item.category.color,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: item.category.color,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.touch_app_rounded, size: 18),
              text: 'Playground',
            ),
            Tab(icon: Icon(Icons.code_rounded, size: 18), text: 'Source Code'),
            Tab(
              icon: Icon(Icons.menu_book_rounded, size: 18),
              text: 'Properties',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Interactive Playground
          _buildPlaygroundTab(item),

          // Tab 2: Source Code
          _buildSourceCodeTab(item),

          // Tab 3: Properties & Guide
          _buildPropertiesTab(item),
        ],
      ),
    );
  }

  Widget _buildPlaygroundTab(BasicWidgetModel item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info summary card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.category.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.category.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FormattedMarkdownText(
                        item.summary,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive live showcase
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: item.previewBuilder(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCodeTab(BasicWidgetModel item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Canonical Dart Code',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _copyCode,
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Salin Kode', style: TextStyle(fontSize: 12)),
                style: FilledButton.styleFrom(
                  backgroundColor: item.category.color,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: SelectableText(
              item.codeSnippet.trim(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.5,
                color: Color(0xFF38BDF8),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesTab(BasicWidgetModel item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Detailed Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF6366F1),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Deskripsi & Konsep Utama',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FormattedMarkdownText(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF334155),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Key Properties Table
          const Text(
            'Parameter & Properti Kunci:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          ...item.keyProperties.map((prop) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        prop.name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          prop.type,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4338CA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  FormattedMarkdownText(
                    prop.description,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                  if (prop.defaultValue != '-') ...[
                    const SizedBox(height: 4),
                    Text(
                      'Default: ${prop.defaultValue}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // Best Practice Tips
          if (item.usageTips.isNotEmpty) ...[
            const Text(
              'Tips & Pitfalls (Praktik Terbaik):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    item.usageTips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.circle,
                                size: 6,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FormattedMarkdownText(
                                tip,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF78350F),
                                  height: 1.35,
                                ),
                                codeColor: const Color(0xFF92400E),
                                codeBackgroundColor: const Color(0xFFFDE68A),
                                boldColor: const Color(0xFF78350F),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
