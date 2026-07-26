import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/habit_model.dart';
import 'bloc/habit_bloc.dart';
import 'bloc/habit_event.dart';
import 'bloc/habit_state.dart';

class HabitTrackerPage extends StatelessWidget {
  const HabitTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitBloc(),
      child: const HabitTrackerView(),
    );
  }
}

class HabitTrackerView extends StatefulWidget {
  const HabitTrackerView({super.key});

  @override
  State<HabitTrackerView> createState() => _HabitTrackerViewState();
}

class _HabitTrackerViewState extends State<HabitTrackerView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentIndex == 0 ? 'Today\'s Habits' : 'Statistics',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
              onPressed: () => _showAddHabitSheet(context),
            )
        ],
      ),
      body: _currentIndex == 0 ? const _HomeView() : const _StatsView(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF1BFFFF),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }

  void _showAddHabitSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: ctx.read<HabitBloc>(),
          child: const _AddHabitForm(),
        );
      },
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(state),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  return _HabitCard(habit: state.habits[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(HabitState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1BFFFF).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Great job!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.completedTodayCount} of ${state.totalHabits} habits',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'completed today',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🔥', style: TextStyle(fontSize: 40)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state.habits.isEmpty) {
          return const Center(
            child: Text("No habits yet", style: TextStyle(color: Colors.white)),
          );
        }
        
        int bestGlobalStreak = 0;
        for (var h in state.habits) {
          if (h.bestStreak > bestGlobalStreak) {
            bestGlobalStreak = h.bestStreak;
          }
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Best Streak',
                    value: '$bestGlobalStreak days',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Total Habits',
                    value: '${state.totalHabits}',
                    icon: Icons.list_alt,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Your Habits Progress",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...state.habits.map((h) => _buildHabitProgress(h)),
          ],
        );
      },
    );
  }

  Widget _buildHabitProgress(HabitModel habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(habit.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                habit.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '${(habit.progress * 100).toInt()}%',
                style: TextStyle(
                  color: habit.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: habit.progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(habit.color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Streak: ${habit.currentStreak}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Best Streak: ${habit.bestStreak}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HabitModel habit;

  const _HabitCard({required this.habit});

  void _showDetails(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: ctx.read<HabitBloc>(),
          child: _HabitDetailsSheet(habit: habit),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: habit.isCompletedToday ? habit.color.withOpacity(0.5) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (habit.isCompletedToday)
              BoxShadow(
                color: habit.color.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: habit.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(habit.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.currentStreak} Day Streak',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                context.read<HabitBloc>().add(ToggleHabitStatus(habit.id));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: habit.isCompletedToday ? habit.color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: habit.isCompletedToday ? habit.color : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: habit.isCompletedToday
                    ? const Icon(Icons.check, color: Colors.white)
                    : const Icon(Icons.check, color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddHabitForm extends StatefulWidget {
  const _AddHabitForm();

  @override
  State<_AddHabitForm> createState() => _AddHabitFormState();
}

class _AddHabitFormState extends State<_AddHabitForm> {
  final _titleController = TextEditingController();
  String _selectedEmoji = '🏃‍♂️';
  Color _selectedColor = const Color(0xFF10B981);
  final int _targetDays = 30;

  final _emojis = ['🏃‍♂️', '📚', '💧', '🧘‍♂️', '🍎', '💪', '🎸', '🎨', '🚀', '🧠'];
  final _colors = [
    const Color(0xFF10B981), // Emerald
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF3B82F6), // Blue
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFEF4444), // Red
    const Color(0xFFEC4899), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Habit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Habit Title',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Choose Icon', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojis.length,
              itemBuilder: (context, index) {
                final emoji = _emojis[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 50,
                    decoration: BoxDecoration(
                      color: _selectedEmoji == emoji ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('Choose Color', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _colors.map((c) {
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == c ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                if (_titleController.text.trim().isEmpty) return;
                
                context.read<HabitBloc>().add(AddHabit(HabitModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text.trim(),
                  emoji: _selectedEmoji,
                  color: _selectedColor,
                  targetDays: _targetDays,
                )));
                
                Navigator.pop(context);
              },
              child: const Text('Save Habit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _HabitDetailsSheet extends StatelessWidget {
  final HabitModel habit;

  const _HabitDetailsSheet({required this.habit});

  @override
  Widget build(BuildContext context) {
    // Generate last 14 days calendar
    final now = DateTime.now();
    final List<DateTime> lastDays = [];
    for (int i = 13; i >= 0; i--) {
      lastDays.add(now.subtract(Duration(days: i)));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: habit.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: Text(habit.emoji, style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Created recently',
                      style: TextStyle(color: Colors.grey.shade400),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  context.read<HabitBloc>().add(DeleteHabit(habit.id));
                  Navigator.pop(context);
                },
              )
            ],
          ),
          const SizedBox(height: 32),
          const Text('Last 14 Days', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: lastDays.map((date) {
              final isCompleted = habit.isCompletedOn(date);
              final isToday = date.day == now.day && date.month == now.month;
              return GestureDetector(
                onTap: () {
                  context.read<HabitBloc>().add(ToggleHabitStatus(habit.id, date: date));
                  Navigator.pop(context); // Close sheet to reflect change (or could use BlocBuilder inside)
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isCompleted ? habit.color : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: isToday ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Current Streak',
                  value: '${habit.currentStreak}',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Best Streak',
                  value: '${habit.bestStreak}',
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
