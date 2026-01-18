import 'package:flutter/material.dart';

class SharkFitGoalPage extends StatefulWidget {
  const SharkFitGoalPage({super.key});

  @override
  State<SharkFitGoalPage> createState() => _SharkFitGoalPageState();
}

class _SharkFitGoalPageState extends State<SharkFitGoalPage> {
  int _selectedSteps = 10000;
  late FixedExtentScrollController _scrollController;
  final List<int> _stepOptions = List.generate(
    30,
    (index) => (index + 1) * 1000,
  ); // 1000 to 30000

  @override
  void initState() {
    super.initState();
    final initialIndex = _stepOptions.indexOf(_selectedSteps);
    _scrollController = FixedExtentScrollController(
      initialItem: initialIndex != -1 ? initialIndex : 9,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Target Setting',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Mock save
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF00C853),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C853).withOpacity(0.1),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.directions_run,
                  size: 48,
                  color: Color(0xFF00C853),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Daily Goal",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  "$_selectedSteps",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "steps",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),
          const Text(
            "Swipe to adjust your goal",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Selection Indicator
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00C853).withOpacity(0.3),
                    ),
                  ),
                ),

                ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: 60,
                  perspective: 0.005,
                  diameterRatio: 1.2,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedSteps = _stepOptions[index];
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: _stepOptions.length,
                    builder: (context, index) {
                      final isSelected = _stepOptions[index] == _selectedSteps;
                      return Center(
                        child: Text(
                          "${_stepOptions[index]}",
                          style: TextStyle(
                            fontSize: isSelected ? 24 : 18,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isSelected
                                    ? const Color(0xFF00C853)
                                    : Colors.grey.shade400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
