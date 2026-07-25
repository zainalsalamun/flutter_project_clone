import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'widgets/brutal_card.dart';
import 'widgets/brutal_button.dart';
import 'models/zenith_task_model.dart';
import 'bloc/zenith_task_bloc.dart';
import 'bloc/zenith_task_event.dart';
import 'bloc/zenith_task_state.dart';

class ZenithTaskPage extends StatelessWidget {
  const ZenithTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ZenithTaskBloc(),
      child: const ZenithTaskView(),
    );
  }
}

class ZenithTaskView extends StatelessWidget {
  const ZenithTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ZENITH',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 4.0,
          ), 
        ),
      ),
      body: BlocBuilder<ZenithTaskBloc, ZenithTaskState>(
        builder: (context, state) {
          final percentageStr = (state.completionPercentage * 100).toInt().toString();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              BrutalCard(
                backgroundColor: const Color(0xFFF9A8D4), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TODAY',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You have ${state.pendingTasksCount} pending tasks.',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$percentageStr%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'YOUR TASKS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),

              ...state.tasks.map((task) => _buildTaskItem(context, task)),

              const SizedBox(height: 32),

              BrutalButton(
                backgroundColor: const Color(0xFF93C5FD), 
                onPressed: () {
                  final newId = DateTime.now().millisecondsSinceEpoch.toString();
                  final colors = [
                    const Color(0xFFFEF08A),
                    const Color(0xFFA7F3D0),
                    const Color(0xFFDDD6FE),
                    const Color(0xFF93C5FD),
                    const Color(0xFFF9A8D4),
                  ];
                  final randomColor = colors[Random().nextInt(colors.length)];
                  
                  context.read<ZenithTaskBloc>().add(
                    AddZenithTask(
                      ZenithTaskModel(
                        id: newId,
                        title: 'New Random Task',
                        tag: 'NEW',
                        color: randomColor,
                        done: false,
                      ),
                    ),
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'NEW TASK ADDED',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: const Color(0xFFFEF08A),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'CREATE TASK',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, ZenithTaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BrutalCard(
        backgroundColor: task.color,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.read<ZenithTaskBloc>().add(ToggleZenithTask(task.id));
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: task.done ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: task.done
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      task.tag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      decoration:
                          task.done ? TextDecoration.lineThrough : null,
                      decorationThickness: 3.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
