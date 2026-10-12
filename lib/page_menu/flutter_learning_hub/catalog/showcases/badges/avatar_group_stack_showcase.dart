import 'package:flutter/material.dart';

class AvatarGroupStackShowcase extends StatelessWidget {
  const AvatarGroupStackShowcase({super.key});

  final List<Map<String, dynamic>> _members = const [
    {
      'name': 'Zainal Salamun',
      'role': 'Lead Flutter Architect',
      'color': Color(0xFF6366F1),
      'online': true,
    },
    {
      'name': 'Sarah Connor',
      'role': 'UI/UX Designer',
      'color': Color(0xFFEC4899),
      'online': true,
    },
    {
      'name': 'Alex Rivera',
      'role': 'Backend Engineer',
      'color': Color(0xFF10B981),
      'online': false,
    },
    {
      'name': 'Elena Rostova',
      'role': 'Product Manager',
      'color': Color(0xFFF59E0B),
      'online': true,
    },
    {
      'name': 'David Chen',
      'role': 'QA Specialist',
      'color': Color(0xFF3B82F6),
      'online': false,
    },
    {
      'name': 'Marcus Vance',
      'role': 'DevOps Engineer',
      'color': Color(0xFF8B5CF6),
      'online': true,
    },
  ];

  void _showMemberList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Active Workspace Team (6 Members)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              ..._members.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: m['color'] as Color,
                            child: Text(
                              (m['name'] as String)[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (m['online'] as bool)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            m['role'] as String,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Project Card with Avatar Stack
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'IN PROGRESS',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Icon(Icons.more_horiz_rounded, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Mobile Banking App Redesign',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                'Sprint #14 • 8 tasks remaining',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 18),

              // Avatar Stack Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showMemberList(context),
                    child: OverlappingAvatarStack(
                      avatars:
                          _members.take(4).map((m) {
                            return AvatarItemData(
                              initials: (m['name'] as String)[0],
                              backgroundColor: m['color'] as Color,
                              isOnline: m['online'] as bool,
                            );
                          }).toList(),
                      extraCount: 2,
                    ),
                  ),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF6366F1,
                      ).withValues(alpha: 0.1),
                      foregroundColor: const Color(0xFF6366F1),
                    ),
                    icon: const Icon(Icons.person_add_alt_rounded, size: 18),
                    onPressed: () => _showMemberList(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AvatarItemData {
  final String initials;
  final Color backgroundColor;
  final bool isOnline;

  const AvatarItemData({
    required this.initials,
    required this.backgroundColor,
    this.isOnline = false,
  });
}

class OverlappingAvatarStack extends StatelessWidget {
  final List<AvatarItemData> avatars;
  final int extraCount;
  final double radius;
  final double overlap;

  const OverlappingAvatarStack({
    super.key,
    required this.avatars,
    this.extraCount = 0,
    this.radius = 18,
    this.overlap = 12,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final totalCount = avatars.length + (extraCount > 0 ? 1 : 0);
    final totalWidth = size + (totalCount - 1) * (size - overlap);

    return SizedBox(
      height: size,
      width: totalWidth,
      child: Stack(
        children: [
          ...List.generate(avatars.length, (index) {
            final avatar = avatars[index];
            return Positioned(
              left: index * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  color: avatar.backgroundColor,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      avatar.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (avatar.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          if (extraCount > 0)
            Positioned(
              left: avatars.length * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0F172A),
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Center(
                  child: Text(
                    '+$extraCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
