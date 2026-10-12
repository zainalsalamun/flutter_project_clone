import 'package:flutter/material.dart';

class InlineDateTimePickerShowcase extends StatefulWidget {
  const InlineDateTimePickerShowcase({super.key});

  @override
  State<InlineDateTimePickerShowcase> createState() =>
      _InlineDateTimePickerShowcaseState();
}

class _InlineDateTimePickerShowcaseState
    extends State<InlineDateTimePickerShowcase> {
  DateTime _currentMonth = DateTime(2026, 9, 1);
  DateTime _selectedDate = DateTime(2026, 9, 24);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 30);

  final List<String> _quickTimeSlots = const [
    '09:00',
    '11:30',
    '14:30',
    '16:00',
    '19:30',
  ];

  final List<String> _monthNames = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<String> _dayNames = const [
    'MIN',
    'SEN',
    'SEL',
    'RAB',
    'KAM',
    'JUM',
    'SAB',
  ];

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _confirmBooking() {
    final dateStr =
        '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}';
    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} WIB';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.event_available_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Jadwal Dikonfirmasi: $dateStr • $timeStr',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. INLINE CALENDAR CARD ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Calendar Month Navigation Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    visualDensity: VisualDensity.compact,
                    onPressed: _prevMonth,
                  ),
                  Text(
                    '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    visualDensity: VisualDensity.compact,
                    onPressed: _nextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Day Names Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    _dayNames.map((d) {
                      return SizedBox(
                        width: 34,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color:
                                d == 'MIN'
                                    ? const Color(0xFFEF4444)
                                    : Colors.grey.shade500,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 8),

              // Monthly Days Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 35, // 5 weeks max
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final dayNumber = index - firstWeekday + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox.shrink();
                  }

                  final dateObj = DateTime(
                    _currentMonth.year,
                    _currentMonth.month,
                    dayNumber,
                  );

                  final isSelected =
                      dateObj.year == _selectedDate.year &&
                      dateObj.month == _selectedDate.month &&
                      dateObj.day == _selectedDate.day;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = dateObj),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF6366F1)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.35),
                                    blurRadius: 6,
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. TIME PICKER & SLOTS ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Color(0xFF6366F1),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pilih Jam / Slot Waktu:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} WIB',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Quick Time Slots Chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    _quickTimeSlots.map((slot) {
                      final parts = slot.split(':');
                      final hour = int.parse(parts[0]);
                      final minute = int.parse(parts[1]);
                      final isSelected =
                          _selectedTime.hour == hour &&
                          _selectedTime.minute == minute;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTime = TimeOfDay(
                              hour: hour,
                              minute: minute,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF6366F1)
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            '$slot WIB',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 3. SUMMARY BANNER & CTA ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jadwal Terpilih:',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year} • ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: _confirmBooking,
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
