import 'package:flutter/material.dart';

class AttendanceLog extends StatelessWidget {
  const AttendanceLog({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFC62828), // Deep Red
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Attendance Log',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: [
              Tab(text: 'Logs'),
              Tab(text: 'Attendance'),
              Tab(text: 'Shift'),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: const TabBarView(
          children: [
            _LogsTab(),
            Center(child: Text('Attendance Tab')),
            Center(child: Text('Shift Tab')),
          ],
        ),
      ),
    );
  }
}

class _LogsTab extends StatelessWidget {
  const _LogsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Month Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: Color(0xFF5A5A5A),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Jan 2026',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Summary Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4F9), // Light Blue/Grey
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Decorative curve background could go here if needed, simplified for now
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: _StatItem(
                            label: 'Absent',
                            value: '0',
                            isBlue: false,
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: 'Late clock in',
                            value: '9',
                            isBlue: true,
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: 'Early clock...',
                            value: '4',
                            isBlue: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: _StatItem(
                            label: 'No clock in',
                            value: '0',
                            isBlue: false,
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: 'No clock out',
                            value: '2',
                            isBlue: true,
                          ),
                        ),
                        Expanded(child: SizedBox()), // Spacer
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // List
        const _LogItem(
          date: '21 Dec',
          status: 'Day Off',
          statusColor: Color(0xFFD32F2F), // Red
          isHoliday: false,
        ),
        const _Divider(),
        const _LogItem(
          date: '22 Dec',
          status: 'Work shift',
          clockIn: '09:25',
          clockInColor: Color(0xFFD32F2F), // Late?
          clockOut: '18:43',
        ),
        const _Divider(),
        const _LogItem(
          date: '23 Dec',
          status: 'Work shift',
          clockIn: '09:55',
          clockInColor: Color(0xFFD32F2F),
          clockOut: '22:24',
        ),
        const _Divider(),
        const _LogItem(
          date: '24 Dec',
          status: 'Work shift',
          clockIn: '08:41',
          clockInColor: Color(0xFFD32F2F),
          clockOut: '19:34',
        ),
        const _Divider(),
        const _LogItem(
          date: '25 Dec',
          status: 'Holiday',
          statusColor: Color(0xFFD32F2F),
          isHoliday: true,
        ),
        const _Divider(),
        const _LogItem(
          date: '26 Dec',
          status: 'Holiday',
          statusColor: Color(0xFFD32F2F),
          isHoliday: true,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBlue;

  const _StatItem({
    required this.label,
    required this.value,
    required this.isBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isBlue ? const Color(0xFF1565C0) : const Color(0xFF424242),
          ),
        ),
      ],
    );
  }
}

class _LogItem extends StatelessWidget {
  final String date;
  final String status;
  final Color? statusColor;
  final String? clockIn;
  final Color? clockInColor;
  final String? clockOut;
  final Color? clockOutColor;
  final bool isHoliday;

  const _LogItem({
    required this.date,
    required this.status,
    this.statusColor,
    this.clockIn,
    this.clockInColor,
    this.clockOut,
    // ignore: unused_element_parameter
    this.clockOutColor,
    this.isHoliday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Date & Status Column
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isHoliday ? const Color(0xFFD32F2F) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    color: statusColor ?? Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Clock In/Out Column - Center
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    clockIn ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: clockInColor ?? Colors.black87,
                      fontWeight:
                          clockIn != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 60,
                  child: Text(
                    clockOut ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: clockOutColor ?? Colors.black87,
                      fontWeight:
                          clockOut != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.grey.shade200);
  }
}
