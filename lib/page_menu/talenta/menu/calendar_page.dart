import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Mocking Jan 2026
  // Jan 1, 2026 is a Thursday
  final int daysInMonth = 31;
  final int firstWeekday = 4; // Thu (Sun=0, Mon=1... if using that system)
  // Actually DateTime.thursday is 4. Material Grid usually starts Sun.
  // Let's rely on standard grid logic.
  // 2026 Jan 1 is Thursday.
  // Su Mo Tu We Th Fr Sa
  //              1  2  3
  //  4  5  6  7  8  9 10...

  final List<int> eventDays = [1, 16];
  final int selectedDay = 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6), // Light Beige
      appBar: AppBar(
        leading: const BackButton(color: Color(0xFF5A5A5A)),
        elevation: 0,
        backgroundColor: const Color(0xFFFBF8F6),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Jan 2026',
              style: TextStyle(
                color: Color(0xFF1F1F1F),
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Color(0xFF1F1F1F)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Today',
              style: TextStyle(
                color: Color(0xFF4967FF),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Days Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _DayHeader('Sun'),
                    _DayHeader('Mon'),
                    _DayHeader('Tue'),
                    _DayHeader('Wed'),
                    _DayHeader('Thu'),
                    _DayHeader('Fri'),
                    _DayHeader('Sat'),
                  ],
                ),
                const SizedBox(height: 12),
                // Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 35, // 5 rows is enough for Jan 2026
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1, // Square
                  ),
                  itemBuilder: (context, index) {
                    // Offset for Thursday start (index 0 is Sun).
                    // Sun(0), Mon(1), Tue(2), Wed(3), Thu(4) -> 1st.
                    // So -4 + 1? No.
                    // 0 1 2 3 -> empty. 4 -> 1.
                    final dayNum = index - 3;
                    if (dayNum < 1 || dayNum > daysInMonth) {
                      return const SizedBox();
                    }
                    return _DayCell(
                      day: dayNum,
                      isSelected: dayNum == selectedDay,
                      hasEvent: eventDays.contains(dayNum),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'View all events this month',
                      style: TextStyle(
                        color: Color(0xFF4967FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFF4967FF),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Sheet / List Area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: const [
                        _ExpandableItem(
                          title: 'Activities',
                          count: 0,
                          showContent: false,
                        ),
                        _ExpandableItem(
                          title: 'Time off',
                          count: 39,
                          showContent: false,
                        ),
                        _ExpandableItem(
                          title: 'Holiday',
                          count: 0,
                          showContent: false,
                        ),
                        _ExpandableItem(
                          title: 'Birthday',
                          count: 1,
                          showContent: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final String text;
  const _DayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40, // rough match grid
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF757575), fontSize: 13),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool hasEvent;

  const _DayCell({
    required this.day,
    this.isSelected = false,
    this.hasEvent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4967FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF2A2A2A),
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (hasEvent && !isSelected) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF4967FF),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpandableItem extends StatelessWidget {
  final String title;
  final int count;
  final bool showContent;

  const _ExpandableItem({
    required this.title,
    required this.count,
    this.showContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          '$title ($count)',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Color(0xFF757575)),
        initiallyExpanded: showContent,
        children:
            showContent
                ? [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=12',
                          ), // Placeholder
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'John Doe', // Placeholder name
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Product Designer',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
                : [],
      ),
    );
  }
}
