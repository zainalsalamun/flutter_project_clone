import 'package:flutter/material.dart';

class SharkFitAlarmPage extends StatefulWidget {
  const SharkFitAlarmPage({super.key});

  @override
  State<SharkFitAlarmPage> createState() => _SharkFitAlarmPageState();
}

class _SharkFitAlarmPageState extends State<SharkFitAlarmPage> {
  final List<Map<String, dynamic>> _alarms = [
    {
      'time': '07:00',
      'label': 'Morning',
      'repeat': 'Mon, Tue, Wed, Thu, Fri',
      'enabled': true,
    },
    {'time': '08:30', 'label': 'Work', 'repeat': 'Everyday', 'enabled': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Alarms',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // TODO: Implement add alarm
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add alarm feature coming soon')),
              );
            },
          ),
        ],
      ),
      body:
          _alarms.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm_off,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No alarms set',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  final alarm = _alarms[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  alarm['time'],
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        alarm['enabled']
                                            ? Colors.black
                                            : Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'AM', // Assuming AM for simplicity or parse from time
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        alarm['enabled']
                                            ? Colors.grey.shade600
                                            : Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${alarm['label']} • ${alarm['repeat']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Switch(
                          value: alarm['enabled'],
                          activeColor: const Color(0xFF00C853),
                          onChanged: (value) {
                            setState(() {
                              alarm['enabled'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        onPressed: () {
          // TODO: Implement add alarm
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add alarm feature coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
