import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/diagnostics_logger_service.dart';
import '../theme/diagnostics_colors.dart';

class LiveDebugLogConsole extends StatefulWidget {
  final VoidCallback? onTriggerSync;
  final VoidCallback? onClearLogs;

  const LiveDebugLogConsole({
    super.key,
    this.onTriggerSync,
    this.onClearLogs,
  });

  @override
  State<LiveDebugLogConsole> createState() => _LiveDebugLogConsoleState();
}

class _LiveDebugLogConsoleState extends State<LiveDebugLogConsole> {
  LogLevel? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _copyAllLogs(BuildContext context) {
    final text = DiagnosticsLoggerService.instance.exportLogsAsString();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("All debug logs copied to clipboard!"),
        backgroundColor: DiagnosticsColors.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DiagnosticsLoggerService.instance,
      builder: (context, _) {
        final allLogs = DiagnosticsLoggerService.instance.logs;
        final filteredLogs = allLogs.where((log) {
          if (_selectedFilter != null && log.level != _selectedFilter) {
            return false;
          }
          if (_searchQuery.isNotEmpty) {
            final q = _searchQuery.toLowerCase();
            final matchesMsg = log.message.toLowerCase().contains(q);
            final matchesTag = log.tag.toLowerCase().contains(q);
            final matchesPayload = log.formattedPayload.toLowerCase().contains(q);
            return matchesMsg || matchesTag || matchesPayload;
          }
          return true;
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: DiagnosticsColors.darkSurface, // Terminal dark background
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terminal Top Bar (Fully Responsive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: DiagnosticsColors.darkCard,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.terminal_rounded,
                        size: 15, color: DiagnosticsColors.primaryLight),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        "DEBUG LOG CONSOLE",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: DiagnosticsColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DiagnosticsColors.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${filteredLogs.length}",
                        style: const TextStyle(
                          color: DiagnosticsColors.primaryLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded,
                          size: 15, color: Colors.white70),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      tooltip: "Copy all logs",
                      onPressed: () => _copyAllLogs(context),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded,
                          size: 17, color: DiagnosticsColors.dangerLight),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      tooltip: "Clear logs",
                      onPressed: widget.onClearLogs,
                    ),
                  ],
                ),
              ),

              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    _FilterChip(
                      label: "ALL",
                      isSelected: _selectedFilter == null,
                      onTap: () => setState(() => _selectedFilter = null),
                      color: DiagnosticsColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    _FilterChip(
                      label: "INFO",
                      isSelected: _selectedFilter == LogLevel.info,
                      onTap: () =>
                          setState(() => _selectedFilter = LogLevel.info),
                      color: DiagnosticsColors.primaryLight,
                    ),
                    const SizedBox(width: 5),
                    _FilterChip(
                      label: "DEBUG",
                      isSelected: _selectedFilter == LogLevel.debug,
                      onTap: () =>
                          setState(() => _selectedFilter = LogLevel.debug),
                      color: DiagnosticsColors.purpleLight,
                    ),
                    const SizedBox(width: 5),
                    _FilterChip(
                      label: "SUCCESS",
                      isSelected: _selectedFilter == LogLevel.success,
                      onTap: () =>
                          setState(() => _selectedFilter = LogLevel.success),
                      color: DiagnosticsColors.success,
                    ),
                    const SizedBox(width: 5),
                    _FilterChip(
                      label: "WARN",
                      isSelected: _selectedFilter == LogLevel.warn,
                      onTap: () =>
                          setState(() => _selectedFilter = LogLevel.warn),
                      color: DiagnosticsColors.warning,
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: DiagnosticsColors.white, fontSize: 11),
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search in logs...",
                    hintStyle: TextStyle(
                        color: DiagnosticsColors.white.withValues(alpha: 0.3),
                        fontSize: 11),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 15, color: Colors.white54),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                size: 14, color: Colors.white54),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: DiagnosticsColors.darkCard,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Log Entries List
              SizedBox(
                height: 280,
                child: filteredLogs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.code_off_rounded,
                                size: 32,
                                color: DiagnosticsColors.white.withValues(alpha: 0.2)),
                            const SizedBox(height: 6),
                            Text(
                              "No logs matched filter",
                              style: TextStyle(
                                color: DiagnosticsColors.white.withValues(alpha: 0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredLogs.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        itemBuilder: (context, index) {
                          final entry = filteredLogs[index];
                          return _LogEntryItem(entry: entry);
                        },
                      ),
              ),

              // Bottom Action Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: const BoxDecoration(
                  color: DiagnosticsColors.darkCard,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(19)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "💡 Tap log to view JSON",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    if (widget.onTriggerSync != null)
                      ElevatedButton.icon(
                        onPressed: widget.onTriggerSync,
                        icon: const Icon(Icons.sync_rounded, size: 13),
                        label: const Text("Rescan",
                            style: TextStyle(fontSize: 10)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DiagnosticsColors.primary,
                          foregroundColor: DiagnosticsColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.white60,
            fontSize: 9,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _LogEntryItem extends StatefulWidget {
  final DiagnosticsLogEntry entry;

  const _LogEntryItem({required this.entry});

  @override
  State<_LogEntryItem> createState() => _LogEntryItemState();
}

class _LogEntryItemState extends State<_LogEntryItem> {
  bool _isExpanded = false;

  Color get _levelColor {
    return switch (widget.entry.level) {
      LogLevel.debug => DiagnosticsColors.purpleLight,
      LogLevel.info => DiagnosticsColors.primaryLight,
      LogLevel.warn => DiagnosticsColors.warning,
      LogLevel.error => DiagnosticsColors.danger,
      LogLevel.success => DiagnosticsColors.success,
    };
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final hasPayload = entry.payload != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: DiagnosticsColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _levelColor.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: InkWell(
        onTap: hasPayload
            ? () => setState(() => _isExpanded = !_isExpanded)
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header line: Time, Level badge, Tag, Expand indicator
              Row(
                children: [
                  Text(
                    entry.formattedTime,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontFamily: 'monospace',
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: _levelColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.level.name.toUpperCase(),
                      style: TextStyle(
                        color: _levelColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: DiagnosticsColors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.tag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 8,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  if (hasPayload) ...[
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 15,
                      color: Colors.white38,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              // Message
              Text(
                entry.message,
                style: const TextStyle(
                  color: DiagnosticsColors.border,
                  fontSize: 10.5,
                  fontFamily: 'monospace',
                  height: 1.3,
                ),
              ),

              // Expanded JSON Payload
              if (_isExpanded && hasPayload) ...[
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PAYLOAD / DATA",
                            style: TextStyle(
                              color: DiagnosticsColors.primaryLight,
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: entry.formattedPayload));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Payload copied!"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.copy_rounded,
                                    size: 11, color: Colors.white70),
                                SizedBox(width: 3),
                                Text(
                                  "Copy",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        entry.formattedPayload,
                        style: const TextStyle(
                          color: DiagnosticsColors.successBorder,
                          fontFamily: 'monospace',
                          fontSize: 9.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
