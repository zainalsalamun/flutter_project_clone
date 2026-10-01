import 'package:flutter/material.dart';
import '../models/ai_dashboard_models.dart';
import '../theme/ai_dashboard_theme.dart';

class DeployAgentModal extends StatefulWidget {
  final ValueChanged<AiAgentTask> onDeploy;

  const DeployAgentModal({super.key, required this.onDeploy});

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<AiAgentTask> onDeploy,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => DeployAgentModal(onDeploy: onDeploy),
    );
  }

  @override
  State<DeployAgentModal> createState() => _DeployAgentModalState();
}

class _DeployAgentModalState extends State<DeployAgentModal> {
  final _nameController = TextEditingController();
  String _selectedModel = 'Claude 3.5 Sonnet';
  double _concurrency = 4;
  bool _isDeploying = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon isi nama agent task!"),
          backgroundColor: AiDashboardTheme.danger,
        ),
      );
      return;
    }

    setState(() => _isDeploying = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      final newTask = AiAgentTask(
        id:
            'AGT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        name: name,
        model: _selectedModel,
        status: 'Running',
        progress: 0.1,
        tokensConsumed: 12500,
        runtimeSeconds: 5.0,
        startedAt: DateTime.now(),
      );

      widget.onDeploy(newTask);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🚀 Agent $name berhasil di-deploy ke cloud cluster!"),
          backgroundColor: AiDashboardTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AiDashboardTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AiDashboardTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AiDashboardTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deploy Autonomous AI Agent",
                          style: TextStyle(
                            color: AiDashboardTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Provision dedicated asynchronous LLM worker",
                          style: TextStyle(
                            color: AiDashboardTheme.textMuted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AiDashboardTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Task Name Field
            const Text(
              "Agent Task Name",
              style: TextStyle(
                color: AiDashboardTheme.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              style: const TextStyle(
                color: AiDashboardTheme.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: "e.g. Multi-PDF Vector Embedder",
                hintStyle: const TextStyle(
                  color: AiDashboardTheme.textMuted,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: AiDashboardTheme.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AiDashboardTheme.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AiDashboardTheme.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AiDashboardTheme.primary),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Model Selection
            const Text(
              "Model Inference Backbone",
              style: TextStyle(
                color: AiDashboardTheme.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AiDashboardTheme.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AiDashboardTheme.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedModel,
                  isExpanded: true,
                  dropdownColor: AiDashboardTheme.surfaceElevated,
                  items:
                      [
                        'Claude 3.5 Sonnet',
                        'GPT-4o',
                        'Gemini 1.5 Pro',
                        'Llama 3 70B',
                      ].map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text(
                            m,
                            style: const TextStyle(
                              color: AiDashboardTheme.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedModel = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Concurrency Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Worker Concurrency Threads",
                  style: TextStyle(
                    color: AiDashboardTheme.textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${_concurrency.toInt()} Threads",
                  style: const TextStyle(
                    color: AiDashboardTheme.primaryGlow,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AiDashboardTheme.primary,
                inactiveTrackColor: AiDashboardTheme.background,
                thumbColor: Colors.white,
                trackHeight: 3,
              ),
              child: Slider(
                value: _concurrency,
                min: 1,
                max: 16,
                divisions: 15,
                onChanged: (val) => setState(() => _concurrency = val),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _isDeploying ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AiDashboardTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:
                    _isDeploying
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          "Launch Worker Instance",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
