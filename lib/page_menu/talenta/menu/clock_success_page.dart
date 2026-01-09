import 'package:flutter/material.dart';

class ClockSuccessPage extends StatelessWidget {
  final String clockType; // 'Clock in' or 'Clock out'
  final DateTime submissionTime;
  final String? notes;

  const ClockSuccessPage({
    super.key,
    required this.clockType,
    required this.submissionTime,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    // Helper for formatting
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = submissionTime.day;
    final month = months[submissionTime.month - 1];
    final year = submissionTime.year;
    final hour = submissionTime.hour.toString().padLeft(2, '0');
    final minute = submissionTime.minute.toString().padLeft(2, '0');

    final dateStr = '$day $month $year';
    final timeStr = '$hour:$minute';

    // Extract just the action verb if needed, but the design shows "Clock out successful"
    // So we can assume clockType is "Clock in" or "Clock out"

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            // Pop until we hit the home page (root) to reset flow
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF00C853), // Green color
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                '$clockType successful',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Details
              Text(
                'Schedule: $dateStr',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                'R',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '08:00-17:00',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),

              const SizedBox(height: 24),

              // Time
              Text(
                timeStr,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Face Recognition Status
              Text(
                'Face recognition: success',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),

              if (notes != null && notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notes, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          notes!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(flex: 3),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Back to home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // View Log Button
              TextButton(
                onPressed: () {
                  // Navigate to Attendance Log (Placeholder)
                },
                child: Text(
                  'View attendance log',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
