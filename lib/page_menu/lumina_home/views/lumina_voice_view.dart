import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';

class LuminaVoiceView extends StatefulWidget {
  final Function(String command) onExecuteCommand;

  const LuminaVoiceView({
    super.key,
    required this.onExecuteCommand,
  });

  @override
  State<LuminaVoiceView> createState() => _LuminaVoiceViewState();
}

class _LuminaVoiceViewState extends State<LuminaVoiceView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isListening = false;
  String _assistantResponse = 'Tap the microphone or select a quick voice command below.';

  final List<String> _quickCommands = [
    'Turn on Living Room Light',
    'Set AC to 22°C Eco Mode',
    'Turn off all bedroom devices',
    'Activate Movie Night Scene',
    'Good Night, turn off everything',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerVoiceCommand(String command) {
    setState(() {
      _isListening = true;
      _assistantResponse = 'Processing: "$command"...';
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _assistantResponse = 'Done! Executed command: "$command".';
        });
        widget.onExecuteCommand(command);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LuminaThemeScope.of(context).colors;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Title
              Column(
                children: [
                  Text(
                    'Lumina Voice Assistant',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Natural voice automation for your smart home',
                    style: TextStyle(color: theme.secondaryText, fontSize: 13),
                  ),
                ],
              ),

              const Spacer(),

              // Animated Pulsating Glowing Orb
              Center(
                child: GestureDetector(
                  onTap: () {
                    _triggerVoiceCommand('Turn on Living Room lights');
                  },
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 180 * _pulseAnimation.value,
                            height: 180 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF59E0B).withOpacity(theme.isDark ? 0.12 : 0.15),
                            ),
                          ),
                          // Mid ring
                          Container(
                            width: 140 * _pulseAnimation.value,
                            height: 140 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF97316).withOpacity(theme.isDark ? 0.2 : 0.25),
                            ),
                          ),
                          // Core Orb Button
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF59E0B).withOpacity(0.5),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isListening ? Icons.graphic_eq : Icons.mic_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Assistant Response Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.cardBorder),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.black, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _assistantResponse,
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Quick Voice Command Suggestions
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Commands',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickCommands.map((cmd) {
                  return ActionChip(
                    backgroundColor: theme.cardBackground,
                    side: BorderSide(color: theme.cardBorder),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    avatar: const Icon(Icons.mic, size: 14, color: Color(0xFFF59E0B)),
                    label: Text(
                      cmd,
                      style: TextStyle(color: theme.primaryText, fontSize: 12),
                    ),
                    onPressed: () => _triggerVoiceCommand(cmd),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
