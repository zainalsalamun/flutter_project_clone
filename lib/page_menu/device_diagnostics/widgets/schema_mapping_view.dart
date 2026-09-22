import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/device_diagnostics_event.dart';
import '../models/user_device_diagnostics_entity.dart';

class SchemaMappingView extends StatefulWidget {
  final DeviceDiagnosticsEvent event;
  final UserDeviceDiagnosticsEntity entity;

  const SchemaMappingView({
    super.key,
    required this.event,
    required this.entity,
  });

  @override
  State<SchemaMappingView> createState() => _SchemaMappingViewState();
}

class _SchemaMappingViewState extends State<SchemaMappingView>
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

  void _copy(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label copied to clipboard!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0284C7),
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: const Color(0xFF0284C7),
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              tabs: const [
                Tab(text: "1. Event JSON"),
                Tab(text: "2. DB Entity"),
                Tab(text: "3. SQL Query"),
              ],
            ),
          ),

          // Tab views
          SizedBox(
            height: 280,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Event JSON
                _CodeViewer(
                  code: widget.event.toPrettyJson(),
                  language: "json",
                  title: "device_diagnostics (Event Payload)",
                  onCopy: () => _copy(
                      context, widget.event.toPrettyJson(), "Event JSON"),
                ),

                // Tab 2: Database Table Schema & Entity
                _CodeViewer(
                  code: widget.entity.toPrettyJson(),
                  language: "json",
                  title: "user_device_diagnostics (Table Row Map)",
                  onCopy: () => _copy(
                      context, widget.entity.toPrettyJson(), "DB Entity JSON"),
                ),

                // Tab 3: SQL Statement
                _CodeViewer(
                  code: widget.entity.toSqlInsertStatement(),
                  language: "sql",
                  title: "INSERT INTO user_device_diagnostics",
                  onCopy: () => _copy(
                      context, widget.entity.toSqlInsertStatement(), "SQL Insert"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeViewer extends StatelessWidget {
  final String code;
  final String language;
  final String title;
  final VoidCallback onCopy;

  const _CodeViewer({
    required this.code,
    required this.language,
    required this.title,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded,
                    size: 16, color: Colors.white70),
                onPressed: onCopy,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: "Copy code",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                code,
                style: const TextStyle(
                  color: Color(0xFFF1F5F9),
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
