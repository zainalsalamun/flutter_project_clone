import 'package:flutter/material.dart';
import '../../core/aura_colors.dart';
import '../../core/aura_typography.dart';
import '../../widgets/aura_companion_orb.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AuraHabitAssistantScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AuraHabitAssistantScreen({
    super.key,
    this.onBack,
  });

  @override
  State<AuraHabitAssistantScreen> createState() => _AuraHabitAssistantScreenState();
}

class _AuraHabitAssistantScreenState extends State<AuraHabitAssistantScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];

  final List<Map<String, dynamic>> _quickChips = const [
    {
      'label': 'Tips Kebiasaan',
      'icon': Icons.lightbulb_outline_rounded,
      'color': Color(0xFFD97706),
      'bg': Color(0xFFFEF3C7),
      'prompt': 'Beri saya tips terbaik untuk konsisten bangun pagi dan minum air.',
      'response': 'Kunci konsistensi adalah habit stacking: tautkan kebiasaan baru tepat setelah rutinitas yang sudah ada. Misalnya, minum segelas air segera setelah alarm berbunyi.',
    },
    {
      'label': 'Target Baru',
      'icon': Icons.track_changes_rounded,
      'color': Color(0xFF4F46E5),
      'bg': Color(0xFFEEF2FF),
      'prompt': 'Bagaimana cara menentukan target kebiasaan harian yang realistis?',
      'response': 'Mulai dari dosis mikro. Jangan langsung 1 jam olahraga, mulai dari 10-15 menit per hari selama 14 hari pertama untuk membangun momentum mental.',
    },
    {
      'label': 'Jadwal Rutin',
      'icon': Icons.calendar_today_rounded,
      'color': Color(0xFF059669),
      'bg': Color(0xFFD1FAE5),
      'prompt': 'Bantu saya menyusun jadwal kebiasaan pagi yang optimal.',
      'response': 'Jadwal pagi ideal: 06.00 Hidrasi 1 gelas air, 06.15 Peregangan 15 menit, 06.35 Sarapan bernutrisi, 07.00 Review 3 prioritas utama harian.',
    },
  ];

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text, {String? customResponse}) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text.trim(),
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _promptController.clear();
    });

    _scrollToBottom();

    // Simulated Smart Response
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            text: customResponse ??
                "Rencana kebiasaan '$text' telah dicatat. Mulai dari langkah kecil hari ini dan pantau progresmu di tab Pelacak.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.canvas,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AuraColors.gradientStart,
              AuraColors.gradientMid,
              AuraColors.canvas,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.35, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              _buildTopBar(),

              // Scrollable Main Content
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    // Center Hero Graphic
                    const SizedBox(height: 10),
                    const Center(
                      child: AuraCompanionOrb(
                        size: 130,
                        showOrbitingIcons: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Greeting Texts
                    Center(
                      child: Text(
                        "Halo, Ada yang bisa\nsaya bantu?",
                        textAlign: TextAlign.center,
                        style: AuraTypography.displayLarge.copyWith(
                          fontSize: 24,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Partner cerdas untuk membangun kebiasaan positif dan konsisten.",
                        textAlign: TextAlign.center,
                        style: AuraTypography.bodyMedium.copyWith(
                          color: AuraColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Suggestion Chips Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _quickChips.map((chip) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              onPressed: () {
                                _sendMessage(
                                  chip['prompt'] as String,
                                  customResponse: chip['response'] as String,
                                );
                              },
                              backgroundColor: AuraColors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: AuraColors.borderLight,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              avatar: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: chip['bg'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  chip['icon'] as IconData,
                                  size: 13,
                                  color: chip['color'] as Color,
                                ),
                              ),
                              label: Text(
                                chip['label'] as String,
                                style: AuraTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AuraColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Messages Stream
                    if (_messages.isNotEmpty) ...[
                      const Divider(color: AuraColors.borderLight),
                      const SizedBox(height: 12),
                      ..._messages.map(_buildMessageBubble),
                    ],
                  ],
                ),
              ),

              // Bottom Input Container
              _buildInputContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AuraColors.textPrimary,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AuraColors.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AuraColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AuraColors.exerciseAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "Asisten Aktif",
                  style: AuraTypography.labelSmall.copyWith(
                    color: AuraColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 22),
            color: AuraColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser ? AuraColors.primary : AuraColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          border: message.isUser
              ? null
              : Border.all(color: AuraColors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: AuraTypography.bodyMedium.copyWith(
            color: message.isUser ? Colors.white : AuraColors.textPrimary,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: AuraColors.borderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AuraColors.surfaceMuted,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AuraColors.borderLight),
        ),
        child: Row(
          children: [
            // Attachment Icon
            IconButton(
              icon: const Icon(Icons.attach_file_rounded, size: 20),
              color: AuraColors.textMuted,
              onPressed: () {},
              visualDensity: VisualDensity.compact,
            ),
            // Camera Icon
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, size: 20),
              color: AuraColors.textMuted,
              onPressed: () {},
              visualDensity: VisualDensity.compact,
            ),
            // Input TextField
            Expanded(
              child: TextField(
                controller: _promptController,
                textInputAction: TextInputAction.send,
                onSubmitted: (val) => _sendMessage(val),
                style: AuraTypography.bodyMedium.copyWith(
                  color: AuraColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Ketik pertanyaan atau target...",
                  hintStyle: AuraTypography.bodyMedium.copyWith(
                    color: AuraColors.textMuted,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            // Send Button
            GestureDetector(
              onTap: () => _sendMessage(_promptController.text),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AuraColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
