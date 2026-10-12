import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lesson_item.dart';
import '../widgets/formatted_markdown_text.dart';

class LessonDetailPage extends StatefulWidget {
  final LessonItem lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  int? _selectedQuizIndex;
  bool _hasSubmittedQuiz = false;

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contoh kode berhasil disalin ke clipboard!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(lesson.icon, color: lesson.module.color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Modul #${lesson.order}: ${lesson.title}',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Lesson Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: lesson.module.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lesson.module.title,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: lesson.module.color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.readTimeMinutes} menit baca',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FormattedMarkdownText(
                    lesson.summary,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.45,
                    ),
                    codeColor: const Color(0xFF4F46E5),
                    codeBackgroundColor: const Color(0xFFEEF2FF),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Embedded Interactive Visualizer (if present)
            if (lesson.visualizerBuilder != null) ...[
              lesson.visualizerBuilder!(context),
              const SizedBox(height: 20),
            ],

            // Section Breakdown
            ...lesson.sections.map((sec) => _buildSectionCard(sec)),

            // Key Takeaways Card
            if (lesson.keyTakeaways.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Poin Kunci (Key Takeaways):',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...lesson.keyTakeaways.map((point) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FormattedMarkdownText(
                                point,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF14532D),
                                  height: 1.4,
                                ),
                                codeColor: const Color(0xFF166534),
                                codeBackgroundColor: const Color(0xFFDCFCE7),
                                boldColor: const Color(0xFF14532D),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            // Checkpoint Quiz (if present)
            if (lesson.quiz != null) ...[
              const SizedBox(height: 20),
              _buildQuizCard(lesson.quiz!),
            ],

            const SizedBox(height: 24),
            // Bottom Done button
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Selesai Membaca Modul Ini'),
              style: FilledButton.styleFrom(
                backgroundColor: lesson.module.color,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(LessonSection sec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sec.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          FormattedMarkdownText(
            sec.content,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF334155),
              height: 1.45,
            ),
            codeColor: const Color(0xFF4F46E5),
            codeBackgroundColor: const Color(0xFFEEF2FF),
            boldColor: const Color(0xFF0F172A),
          ),

          // Bullet Points
          if (sec.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...sec.bulletPoints.map((bp) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(Icons.circle, size: 6, color: Color(0xFF6366F1)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FormattedMarkdownText(
                        bp,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF334155),
                          height: 1.4,
                        ),
                        codeColor: const Color(0xFF4F46E5),
                        codeBackgroundColor: const Color(0xFFEEF2FF),
                        boldColor: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          // Code Snippet Box
          if (sec.codeSnippet != null) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Contoh Kode Dart',
                          style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.white70),
                          tooltip: 'Salin Kode',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _copyCode(sec.codeSnippet!),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      sec.codeSnippet!.trim(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFF38BDF8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Callout Banner
          if (sec.callout != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sec.isWarning ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: sec.isWarning ? const Color(0xFFFECACA) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    sec.isWarning ? Icons.warning_amber_rounded : Icons.tips_and_updates_rounded,
                    color: sec.isWarning ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormattedMarkdownText(
                      sec.callout!,
                      style: TextStyle(
                        fontSize: 12,
                        color: sec.isWarning ? const Color(0xFF991B1B) : const Color(0xFF1E40AF),
                        height: 1.4,
                      ),
                      codeColor: sec.isWarning ? const Color(0xFF991B1B) : const Color(0xFF1D4ED8),
                      codeBackgroundColor: sec.isWarning ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
                      boldColor: sec.isWarning ? const Color(0xFF7F1D1D) : const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizCard(QuizQuestion quiz) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.quiz_rounded, color: Color(0xFF6366F1), size: 20),
              SizedBox(width: 8),
              Text(
                'Uji Pemahaman Materi (Quiz Checkpoint)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF4338CA)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FormattedMarkdownText(
            quiz.question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A), height: 1.35),
            codeColor: const Color(0xFF4F46E5),
            codeBackgroundColor: const Color(0xFFEEF2FF),
          ),
          const SizedBox(height: 12),

          // Options List
          ...quiz.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final isSelected = _selectedQuizIndex == idx;
            final isCorrect = idx == quiz.correctIndex;

            Color bgColor = const Color(0xFFF8FAFC);
            Color borderColor = const Color(0xFFCBD5E1);
            Color textColor = const Color(0xFF334155);

            if (_hasSubmittedQuiz) {
              if (isCorrect) {
                bgColor = const Color(0xFFDCFCE7);
                borderColor = const Color(0xFF22C55E);
                textColor = const Color(0xFF15803D);
              } else if (isSelected && !isCorrect) {
                bgColor = const Color(0xFFFEE2E2);
                borderColor = const Color(0xFFEF4444);
                textColor = const Color(0xFFB91C1C);
              }
            } else if (isSelected) {
              bgColor = const Color(0xFFEEF2FF);
              borderColor = const Color(0xFF6366F1);
              textColor = const Color(0xFF4338CA);
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedQuizIndex = idx;
                  _hasSubmittedQuiz = true;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Text(
                      '${String.fromCharCode(65 + idx)}. ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Expanded(
                      child: FormattedMarkdownText(
                        opt,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          height: 1.3,
                        ),
                        codeColor: textColor,
                        codeBackgroundColor: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    if (_hasSubmittedQuiz && isCorrect)
                      const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18)
                    else if (_hasSubmittedQuiz && isSelected && !isCorrect)
                      const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 18),
                  ],
                ),
              ),
            );
          }),

          // Feedback Explanation
          if (_hasSubmittedQuiz) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedQuizIndex == quiz.correctIndex ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedQuizIndex == quiz.correctIndex ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedQuizIndex == quiz.correctIndex ? 'Jawaban Benar!' : 'Pembahasan Jawaban:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _selectedQuizIndex == quiz.correctIndex ? const Color(0xFF166534) : const Color(0xFF991B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FormattedMarkdownText(
                    quiz.explanation,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: _selectedQuizIndex == quiz.correctIndex ? const Color(0xFF14532D) : const Color(0xFF7F1D1D),
                      height: 1.35,
                    ),
                    codeColor: _selectedQuizIndex == quiz.correctIndex ? const Color(0xFF14532D) : const Color(0xFF7F1D1D),
                    codeBackgroundColor: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
