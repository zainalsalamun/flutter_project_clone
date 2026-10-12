import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KanbanDragDropBoardShowcase extends StatefulWidget {
  const KanbanDragDropBoardShowcase({super.key});

  @override
  State<KanbanDragDropBoardShowcase> createState() =>
      _KanbanDragDropBoardShowcaseState();
}

enum _KanbanPriority { high, medium, low }

class _KanbanTask {
  final String id;
  final String title;
  final String description;
  final _KanbanPriority priority;
  final String tag;
  final String assignee;
  final int completedSubtasks;
  final int totalSubtasks;
  String columnId; // 'todo', 'in_progress', 'done'

  _KanbanTask({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.tag,
    required this.assignee,
    required this.completedSubtasks,
    required this.totalSubtasks,
    required this.columnId,
  });
}

class _KanbanDragDropBoardShowcaseState
    extends State<KanbanDragDropBoardShowcase> {
  final List<_KanbanTask> _tasks = [
    _KanbanTask(
      id: 'task-1',
      title: 'Desain Sistem Komponen UI',
      description: 'Buat token warna, tipografi, dan varian tombol di Figma.',
      priority: _KanbanPriority.high,
      tag: ' UI/UX',
      assignee: 'AW',
      completedSubtasks: 3,
      totalSubtasks: 4,
      columnId: 'todo',
    ),
    _KanbanTask(
      id: 'task-2',
      title: 'Integrasi AI Face Scanner',
      description: 'Implementasi custom painter laser viewfinder retina.',
      priority: _KanbanPriority.medium,
      tag: ' AI Feature',
      assignee: 'RP',
      completedSubtasks: 1,
      totalSubtasks: 3,
      columnId: 'todo',
    ),
    _KanbanTask(
      id: 'task-3',
      title: 'Optimasi Repaint Boundary',
      description: 'Pastikan animasi wave progress berjalan mulus pada 60 FPS.',
      priority: _KanbanPriority.high,
      tag: ' Performance',
      assignee: 'DA',
      completedSubtasks: 2,
      totalSubtasks: 2,
      columnId: 'in_progress',
    ),
    _KanbanTask(
      id: 'task-4',
      title: 'Setup CI/CD Pipeline',
      description:
          'Konfigurasi GitHub Actions untuk auto-build APK & iOS bundle.',
      priority: _KanbanPriority.low,
      tag: ' DevOps',
      assignee: 'CW',
      completedSubtasks: 1,
      totalSubtasks: 4,
      columnId: 'in_progress',
    ),
    _KanbanTask(
      id: 'task-5',
      title: 'Setup Database PostgreSQL',
      description: 'Migrasi schema database autentikasi dan relasi tabel.',
      priority: _KanbanPriority.medium,
      tag: ' Backend',
      assignee: 'AW',
      completedSubtasks: 5,
      totalSubtasks: 5,
      columnId: 'done',
    ),
  ];

  int _taskCounter = 6;

  void _moveTask(_KanbanTask task, String targetColumnId) {
    if (task.columnId == targetColumnId) return;

    HapticFeedback.mediumImpact();
    setState(() {
      task.columnId = targetColumnId;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          'Task "${task.title}" dipindahkan ke ${_getColumnTitle(targetColumnId)}',
          style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _getColumnTitle(String colId) {
    switch (colId) {
      case 'todo':
        return 'To Do';
      case 'in_progress':
        return 'In Progress';
      case 'done':
        return 'Done';
      default:
        return colId;
    }
  }

  void _showAddTaskDialog(String columnId) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFF1E293B),
            title: Text(
              'Tambah Task (${_getColumnTitle(columnId)})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Judul task...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Deskripsi singkat...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;

                  setState(() {
                    _tasks.add(
                      _KanbanTask(
                        id: 'task-${_taskCounter++}',
                        title: titleController.text.trim(),
                        description:
                            descController.text.trim().isEmpty
                                ? 'Tidak ada deskripsi.'
                                : descController.text.trim(),
                        priority: _KanbanPriority.medium,
                        tag: ' Task',
                        assignee: 'ME',
                        completedSubtasks: 0,
                        totalSubtasks: 2,
                        columnId: columnId,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Tambah'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instruction Pill
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Icon(
                Icons.touch_app_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Tahan & Geser (Long Press & Drag) kartu antar kolom:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),

        // KANBAN COLUMNS HORIZONTAL SCROLL TRACK
        SizedBox(
          height: 440,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildKanbanColumn(
                columnId: 'todo',
                title: 'To Do',
                color: const Color(0xFF38BDF8),
                icon: Icons.checklist_rounded,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              _buildKanbanColumn(
                columnId: 'in_progress',
                title: 'In Progress',
                color: const Color(0xFFF59E0B),
                icon: Icons.hourglass_top_rounded,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              _buildKanbanColumn(
                columnId: 'done',
                title: 'Done',
                color: const Color(0xFF10B981),
                icon: Icons.task_alt_rounded,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKanbanColumn({
    required String columnId,
    required String title,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    final columnTasks = _tasks.where((t) => t.columnId == columnId).toList();

    return DragTarget<_KanbanTask>(
      onWillAcceptWithDetails: (details) => details.data.columnId != columnId,
      onAcceptWithDetails: (details) => _moveTask(details.data, columnId),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Container(
          width: 260,
          decoration: BoxDecoration(
            color:
                isHovered
                    ? color.withValues(alpha: 0.12)
                    : (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isHovered
                      ? color
                      : (isDark ? Colors.white12 : Colors.black12),
              width: isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // COLUMN HEADER
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black12,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${columnTasks.length}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () => _showAddTaskDialog(columnId),
                      icon: Icon(
                        Icons.add_rounded,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // TASK CARDS LIST
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemCount: columnTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = columnTasks[index];
                    return LongPressDraggable<_KanbanTask>(
                      data: task,
                      delay: const Duration(milliseconds: 150),
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 250,
                          child: _buildTaskCard(
                            task,
                            isDark: isDark,
                            isFeedback: true,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.35,
                        child: _buildTaskCard(task, isDark: isDark),
                      ),
                      child: _buildTaskCard(task, isDark: isDark),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(
    _KanbanTask task, {
    required bool isDark,
    bool isFeedback = false,
  }) {
    Color priorityColor = const Color(0xFF10B981);
    String priorityLabel = 'Low';
    if (task.priority == _KanbanPriority.high) {
      priorityColor = const Color(0xFFEF4444);
      priorityLabel = 'High ';
    } else if (task.priority == _KanbanPriority.medium) {
      priorityColor = const Color(0xFFF59E0B);
      priorityLabel = 'Med ';
    }

    final progress =
        task.totalSubtasks > 0
            ? (task.completedSubtasks / task.totalSubtasks)
            : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
        boxShadow:
            isFeedback
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAG & PRIORITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.tag,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: priorityColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  priorityLabel,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // TITLE
          Text(
            task.title,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // DESCRIPTION
          Text(
            task.description,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 10.5,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // SUBTASK PROGRESS BAR
          Row(
            children: [
              Icon(
                Icons.check_box_outlined,
                color: isDark ? Colors.white38 : Colors.black38,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '${task.completedSubtasks}/${task.totalSubtasks}',
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0
                          ? const Color(0xFF10B981)
                          : const Color(0xFF38BDF8),
                    ),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // ASSIGNEE AVATAR
              CircleAvatar(
                radius: 10,
                backgroundColor:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                child: Text(
                  task.assignee,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
