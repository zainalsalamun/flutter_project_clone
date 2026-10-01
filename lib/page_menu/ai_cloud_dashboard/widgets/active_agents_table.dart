import 'package:flutter/material.dart';
import '../models/ai_dashboard_models.dart';
import '../theme/ai_dashboard_theme.dart';

class ActiveAgentsTable extends StatefulWidget {
  final List<AiAgentTask> tasks;
  final ValueChanged<List<AiAgentTask>> onTasksUpdated;

  const ActiveAgentsTable({
    super.key,
    required this.tasks,
    required this.onTasksUpdated,
  });

  @override
  State<ActiveAgentsTable> createState() => _ActiveAgentsTableState();
}

class _ActiveAgentsTableState extends State<ActiveAgentsTable> {
  String _filterStatus = 'All'; // 'All', 'Running', 'Completed', 'Paused'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTasks =
        widget.tasks.where((t) {
          final matchesStatus =
              _filterStatus == 'All' || t.status == _filterStatus;
          final matchesSearch =
              t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.model.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchesStatus && matchesSearch;
        }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AiDashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Search + Status Filter (Responsive Wrap)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Autonomous AI Agent Tasks",
                        style: TextStyle(
                          color: AiDashboardTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AiDashboardTheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AiDashboardTheme.primary.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          "${widget.tasks.where((t) => t.status == 'Running').length} Running",
                          style: const TextStyle(
                            color: AiDashboardTheme.primaryGlow,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Background worker fleet executing batch workflows",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),

              // Filter Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search mini box
                  Container(
                    width: 160,
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AiDashboardTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AiDashboardTheme.borderLight),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: AiDashboardTheme.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            onChanged:
                                (val) => setState(() => _searchQuery = val),
                            style: const TextStyle(
                              color: AiDashboardTheme.textPrimary,
                              fontSize: 12,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Filter task...",
                              hintStyle: TextStyle(
                                color: AiDashboardTheme.textMuted,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status dropdown
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AiDashboardTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AiDashboardTheme.borderLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterStatus,
                        dropdownColor: AiDashboardTheme.surfaceElevated,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AiDashboardTheme.textSecondary,
                          size: 16,
                        ),
                        items:
                            ['All', 'Running', 'Completed', 'Paused']
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                      s,
                                      style: const TextStyle(
                                        color: AiDashboardTheme.textPrimary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _filterStatus = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Scrollable Responsive Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AiDashboardTheme.surfaceElevated.withOpacity(0.5),
              ),
              dataRowColor: WidgetStateProperty.all(Colors.transparent),
              horizontalMargin: 12,
              columnSpacing: 24,
              columns: const [
                DataColumn(
                  label: Text(
                    "AGENT ID / TASK",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "MODEL ENGINE",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "PROGRESS",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "TOKENS BURNED",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "STATUS",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "ACTIONS",
                    style: TextStyle(
                      color: AiDashboardTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows:
                  filteredTasks.map((t) {
                    final statusColor =
                        t.status == 'Running'
                            ? AiDashboardTheme.success
                            : t.status == 'Completed'
                            ? AiDashboardTheme.secondary
                            : AiDashboardTheme.warning;

                    return DataRow(
                      cells: [
                        // Task Name + ID
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AiDashboardTheme.primary.withOpacity(
                                    0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.smart_toy_outlined,
                                  size: 16,
                                  color: AiDashboardTheme.primaryGlow,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    t.name,
                                    style: const TextStyle(
                                      color: AiDashboardTheme.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    t.id,
                                    style: const TextStyle(
                                      color: AiDashboardTheme.textMuted,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Model Engine
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AiDashboardTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AiDashboardTheme.borderLight,
                              ),
                            ),
                            child: Text(
                              t.model,
                              style: const TextStyle(
                                color: AiDashboardTheme.textSecondary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Progress Bar
                        DataCell(
                          SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${(t.progress * 100).toInt()}%",
                                      style: const TextStyle(
                                        color: AiDashboardTheme.textSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${t.runtimeSeconds.toInt()}s",
                                      style: const TextStyle(
                                        color: AiDashboardTheme.textMuted,
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: t.progress,
                                    backgroundColor:
                                        AiDashboardTheme.surfaceElevated,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      t.progress == 1.0
                                          ? AiDashboardTheme.success
                                          : AiDashboardTheme.primaryGlow,
                                    ),
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Tokens Burned
                        DataCell(
                          Text(
                            "${(t.tokensConsumed / 1000).toStringAsFixed(1)}k tokens",
                            style: const TextStyle(
                              color: AiDashboardTheme.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Status Badge
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  t.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Actions (Pause / Resume / Restart)
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  t.status == 'Running'
                                      ? Icons.pause_circle_outline_rounded
                                      : Icons.play_circle_outline_rounded,
                                  size: 18,
                                  color: AiDashboardTheme.textSecondary,
                                ),
                                tooltip:
                                    t.status == 'Running' ? "Pause" : "Resume",
                                onPressed: () {
                                  final newStatus =
                                      t.status == 'Running'
                                          ? 'Paused'
                                          : 'Running';
                                  final updatedList =
                                      widget.tasks.map((task) {
                                        if (task.id == t.id) {
                                          return task.copyWith(
                                            status: newStatus,
                                          );
                                        }
                                        return task;
                                      }).toList();
                                  widget.onTasksUpdated(updatedList);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Task ${t.id} set to $newStatus",
                                      ),
                                      backgroundColor:
                                          AiDashboardTheme.surfaceElevated,
                                      duration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.replay_rounded,
                                  size: 18,
                                  color: AiDashboardTheme.textSecondary,
                                ),
                                tooltip: "Restart Task",
                                onPressed: () {
                                  final updatedList =
                                      widget.tasks.map((task) {
                                        if (task.id == t.id) {
                                          return task.copyWith(
                                            status: 'Running',
                                            progress: 0.05,
                                          );
                                        }
                                        return task;
                                      }).toList();
                                  widget.onTasksUpdated(updatedList);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Task ${t.id} restarted!"),
                                      backgroundColor: AiDashboardTheme.primary,
                                      duration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
