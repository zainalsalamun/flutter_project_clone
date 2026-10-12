import 'package:flutter/material.dart';
import 'fundamental_module.dart';

class LessonSection {
  final String title;
  final String content;
  final List<String> bulletPoints;
  final String? codeSnippet;
  final String? callout;
  final bool isWarning;

  const LessonSection({
    required this.title,
    required this.content,
    this.bulletPoints = const [],
    this.codeSnippet,
    this.callout,
    this.isWarning = false,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class LessonItem {
  final String id;
  final String title;
  final String subtitle;
  final FundamentalModule module;
  final int order;
  final int readTimeMinutes;
  final String level;
  final IconData icon;
  final String summary;
  final List<LessonSection> sections;
  final List<String> keyTakeaways;
  final Widget Function(BuildContext context)? visualizerBuilder;
  final QuizQuestion? quiz;
  final int? _xpReward;
  final List<String>? _codeSnippets;

  const LessonItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.module,
    required this.order,
    required this.readTimeMinutes,
    this.level = 'Fundamental',
    required this.icon,
    required this.summary,
    required this.sections,
    required this.keyTakeaways,
    this.visualizerBuilder,
    this.quiz,
    int? xpReward,
    List<String>? codeSnippets,
  })  : _xpReward = xpReward,
        _codeSnippets = codeSnippets;

  /// Calculated or explicitly defined XP Reward for completing the lesson
  int get xpReward => _xpReward ?? (readTimeMinutes * 15 + 50);

  /// List of code snippets extracted from sections or custom list
  List<String> get codeSnippets =>
      _codeSnippets ??
      sections
          .where((s) => s.codeSnippet != null && s.codeSnippet!.trim().isNotEmpty)
          .map((s) => s.codeSnippet!)
          .toList();
}
