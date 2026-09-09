import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../theme/lumina_theme.dart';

class RoomTabBar extends StatelessWidget {
  final List<RoomModel> rooms;
  final int selectedIndex;
  final ValueChanged<int> onRoomSelected;

  const RoomTabBar({
    super.key,
    required this.rooms,
    required this.selectedIndex,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LuminaThemeScope.of(context).colors;

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onRoomSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF59E0B) : theme.pillBackground,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Icon(
                      room.icon,
                      size: 18,
                      color: isSelected ? Colors.black87 : theme.secondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      room.name,
                      style: TextStyle(
                        color: isSelected ? Colors.black87 : theme.secondaryText,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
