import 'package:flutter/material.dart';
import '../widgets/glowing_card.dart';

class NovaDashboardView extends StatelessWidget {
  final Function(int)? onNavigate;

  const NovaDashboardView({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      children: [
        const Text(
          'Good morning,\nAlex',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What would you like to create today?',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () => onNavigate?.call(1), // Go to Chat
          child: GlowingCard(
            glowColor: const Color(0xFF10B981), // Emerald
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFF10B981), size: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nova Ultra-Fast',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Access our most capable model for complex reasoning and tasks.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onNavigate?.call(1), // Go to Chat
                child: GlowingCard(
                  glowColor: const Color(0xFFF43F5E), // Rose
                  padding: 16,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_fix_high,
                        color: Color(0xFFF43F5E),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Enhance Text',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => onNavigate?.call(2), // Go to Vision Gallery
                child: GlowingCard(
                  glowColor: const Color(0xFF8B5CF6), // Violet
                  padding: 16,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.palette_rounded,
                        color: Color(0xFF8B5CF6),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Design Ideas',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Recent Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Quantum Physics Summary',
          time: '2 hours ago',
          color: const Color(0xFF6366F1),
          onTap: () => onNavigate?.call(1),
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          icon: Icons.image_outlined,
          title: 'Generated Cyberpunk City',
          time: 'Yesterday',
          color: const Color(0xFF06B6D4), // Cyan
          onTap: () => onNavigate?.call(2),
        ),
        const SizedBox(height: 100), // padding for bottom nav
      ],
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
