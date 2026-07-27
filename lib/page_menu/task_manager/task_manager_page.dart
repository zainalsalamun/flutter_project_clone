import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_manager_bloc.dart';
import 'bloc/task_manager_event.dart';
import 'bloc/task_manager_state.dart';
import 'repositories/task_repository.dart';

class TaskManagerPage extends StatelessWidget {
  const TaskManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskManagerBloc(repository: TaskRepository())..add(LoadTasks()),
      child: const TaskManagerView(),
    );
  }
}

class TaskManagerView extends StatefulWidget {
  const TaskManagerView({super.key});

  @override
  State<TaskManagerView> createState() => _TaskManagerViewState();
}

class _TaskManagerViewState extends State<TaskManagerView> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask(BuildContext context) {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    context.read<TaskManagerBloc>().add(AddTask(text));
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildInputArea(context),
              _buildStats(),
              _buildFilters(),
              Expanded(
                child: BlocBuilder<TaskManagerBloc, TaskManagerState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.filteredTasks.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildTaskList(state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const Expanded(
            child: Text(
              "Task Manager Pro",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _taskController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (_) => _addTask(context),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _addTask(context),
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return BlocBuilder<TaskManagerBloc, TaskManagerState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: "Total Tasks",
                  value: state.totalTasks.toString(),
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: "Completed",
                  value: state.completedTasks.toString(),
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return BlocBuilder<TaskManagerBloc, TaskManagerState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            children: [
              _buildFilterChip(context, 'All', 'all', state.currentFilter),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Pending', 'pending', state.currentFilter),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Completed', 'completed', state.currentFilter),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String filter, String currentFilter) {
    final isActive = currentFilter == filter;
    return GestureDetector(
      onTap: () {
        context.read<TaskManagerBloc>().add(ChangeFilter(filter));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskManagerState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: state.filteredTasks.length,
      itemBuilder: (context, index) {
        final task = state.filteredTasks[index];
        final isCompleted = task.completed;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: GestureDetector(
              onTap: () => context.read<TaskManagerBloc>().add(ToggleTaskStatus(task.id)),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF10B981) : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? const Color(0xFF10B981) : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            title: Text(
              task.text,
              style: TextStyle(
                color: isCompleted ? Colors.white.withOpacity(0.3) : Colors.white,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white.withOpacity(0.3),
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => context.read<TaskManagerBloc>().add(DeleteTask(task.id)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            "No tasks yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add a task above to get started",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
