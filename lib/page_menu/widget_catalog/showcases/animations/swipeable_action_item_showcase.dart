import 'package:flutter/material.dart';

class SwipeableActionItemShowcase extends StatefulWidget {
  const SwipeableActionItemShowcase({super.key});

  @override
  State<SwipeableActionItemShowcase> createState() =>
      _SwipeableActionItemShowcaseState();
}

class _SwipeableActionItemShowcaseState
    extends State<SwipeableActionItemShowcase> {
  final List<Map<String, String>> _messages = [
    {
      'id': '1',
      'title': 'Design Team Meeting',
      'sender': 'Sarah Connor',
      'time': '10:45 AM',
      'body': 'Don’t forget to review the final widget catalog mockups.',
    },
    {
      'id': '2',
      'title': 'Server Deployment Completed',
      'sender': 'DevOps Bot',
      'time': '09:12 AM',
      'body': 'Production cluster has been updated to v2.4.0 successfully.',
    },
    {
      'id': '3',
      'title': 'New Feedback from Client',
      'sender': 'Alex Morgan',
      'time': 'Yesterday',
      'body': 'The client approved the initial prototype with positive marks!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text('Inbox is empty'),
            TextButton(
              onPressed: () {
                setState(() {
                  _messages.addAll([
                    {
                      'id': '1',
                      'title': 'Design Team Meeting',
                      'sender': 'Sarah Connor',
                      'time': '10:45 AM',
                      'body':
                          'Don’t forget to review the final widget catalog mockups.',
                    },
                    {
                      'id': '2',
                      'title': 'Server Deployment Completed',
                      'sender': 'DevOps Bot',
                      'time': '09:12 AM',
                      'body':
                          'Production cluster has been updated to v2.4.0 successfully.',
                    },
                  ]);
                });
              },
              child: const Text('Reset Items'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Swipe right to Archive (Green) or left to Delete (Red)',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
        ..._messages.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: Key(item['id']!),
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                child: const Row(
                  children: [
                    Icon(Icons.archive_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Archive',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                final removed = item;
                setState(() {
                  _messages.removeWhere((m) => m['id'] == item['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      direction == DismissDirection.startToEnd
                          ? 'Archived "${removed['title']}"'
                          : 'Deleted "${removed['title']}"',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(
                        0xFF6366F1,
                      ).withValues(alpha: 0.1),
                      child: Text(
                        item['sender']![0],
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['sender']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                              Text(
                                item['time']!,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['body']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
