import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3EF),
      appBar: _appBar(),
      body: Column(
        children: [
          _summarySection(),
          const SizedBox(height: 12),
          _statusCards(),
          const SizedBox(height: 12),
          Expanded(child: _taskList()),
        ],
      ),
      bottomNavigationBar: _createTaskButton(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF6F3EF),
      elevation: 0,
      leading: const BackButton(color: Color(0xFF1F1F1F)),
      centerTitle: true,
      title: const Text(
        'Task',
        style: TextStyle(color: Color(0xFF1F1F1F), fontWeight: FontWeight.w700),
      ),
      actions: const [
        Icon(Icons.search, color: Color(0xFF6A6A6A)),
        SizedBox(width: 16),
        Icon(Icons.filter_alt_outlined, color: Color(0xFF6A6A6A)),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _summarySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              title: "Total today's work",
              value: "00:00:00",
              action: "Go to time tracker",
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _summaryItem(
              title: "Active project",
              value: "2",
              action: "View all projects",
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String title,
    required String value,
    required String action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          action,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4967FF),
          ),
        ),
      ],
    );
  }

  Widget _statusCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Expanded(
            child: _StatusCard(
              title: 'To do',
              count: '5',
              bg: Color(0xFFEFF2F4),
              color: Color(0xFF6A6A6A),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _StatusCard(
              title: 'In progress',
              count: '0',
              bg: Color(0xFFFFF2D9),
              color: Color(0xFFD59B2D),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _StatusCard(
              title: 'In review',
              count: '0',
              bg: Color(0xFFEAF0FF),
              color: Color(0xFF4967FF),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _StatusCard(
              title: 'Done',
              count: '1',
              bg: Color(0xFFE9F6EE),
              color: Color(0xFF3A9B63),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: dummyTasks.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final task = dummyTasks[index];
        return _taskTile(task);
      },
    );
  }

  Widget _taskTile(TaskItem task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            task.done ? Icons.check_circle : Icons.check_circle_outline,
            color:
                task.done ? const Color(0xFF3A9B63) : const Color(0xFF9AA0A6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.meta,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9AA0A6)),
        ],
      ),
    );
  }

  // ================= BOTTOM BUTTON =================
  Widget _createTaskButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4E6BE4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {},
          child: const Text(
            'Create task',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final Color bg;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.bg,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.checklist, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem {
  final String title;
  final String meta;
  final bool done;

  TaskItem({required this.title, required this.meta, required this.done});
}

final dummyTasks = [
  TaskItem(
    title: 'Information Security Policy',
    meta: 'ID: 819  ·  Due date: No due date',
    done: false,
  ),
  TaskItem(
    title: 'Kerangka Pengelolaan Risiko',
    meta: 'ID: 813  ·  Due date: No due date',
    done: false,
  ),
  TaskItem(
    title: 'Pendaftaran Asuransi Karyawan',
    meta: 'ID: 807  ·  Due date: No due date',
    done: false,
  ),
  TaskItem(
    title: 'Peraturan Perusahaan',
    meta: 'ID: 801  ·  Due date: No due date',
    done: false,
  ),
  TaskItem(
    title: 'Materi Desember',
    meta: 'ID: 797  ·  Due date: No due date',
    done: false,
  ),
  TaskItem(
    title: 'Perjanjian Kerahasiaan',
    meta: 'ID: 902  ·  Completed: 9 Jan 2025 at 10:19',
    done: true,
  ),
];
