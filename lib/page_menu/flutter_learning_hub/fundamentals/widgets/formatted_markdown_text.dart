import 'package:flutter/material.dart';

class FormattedMarkdownText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? codeColor;
  final Color? codeBackgroundColor;
  final Color? boldColor;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const FormattedMarkdownText(
    this.text, {
    super.key,
    this.style,
    this.codeColor,
    this.codeBackgroundColor,
    this.boldColor,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final effectiveStyle = defaultStyle.merge(style);

    final spans = _parseMarkdown(
      text,
      effectiveStyle,
      codeColor: codeColor ?? const Color(0xFF4F46E5),
      codeBgColor: codeBackgroundColor ?? const Color(0xFFEEF2FF),
      boldColor: boldColor,
    );

    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: effectiveStyle,
        children: spans,
      ),
    );
  }

  static List<InlineSpan> _parseMarkdown(
    String rawText,
    TextStyle baseStyle, {
    required Color codeColor,
    required Color codeBgColor,
    Color? boldColor,
  }) {
    if (rawText.isEmpty) return const [];

    final List<InlineSpan> spans = [];

    // Regex to match **`code`**, `**code**`, **bold**, `code`, and *italic*
    final regex = RegExp(
      r'(\*\*\`[^\`]+\`\*\*|\`\*\*[^\*]+\*\*\`|\*\*[^*]+\*\*|\`[^\`]+\`|\*[^*]+\*)',
    );

    int lastIndex = 0;

    for (final match in regex.allMatches(rawText)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: rawText.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      final matchText = match.group(0)!;

      if (matchText.startsWith('**`') && matchText.endsWith('`**')) {
        final codeContent = matchText.substring(3, matchText.length - 3);
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: codeBgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: codeColor.withValues(alpha: 0.25), width: 0.8),
            ),
            child: Text(
              codeContent,
              style: baseStyle.copyWith(
                fontFamily: 'monospace',
                fontSize: (baseStyle.fontSize ?? 13) * 0.9,
                fontWeight: FontWeight.bold,
                color: codeColor,
                height: 1.1,
              ),
            ),
          ),
        ));
      } else if (matchText.startsWith('`**') && matchText.endsWith('**`')) {
        final codeContent = matchText.substring(3, matchText.length - 3);
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: codeBgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: codeColor.withValues(alpha: 0.25), width: 0.8),
            ),
            child: Text(
              codeContent,
              style: baseStyle.copyWith(
                fontFamily: 'monospace',
                fontSize: (baseStyle.fontSize ?? 13) * 0.9,
                fontWeight: FontWeight.bold,
                color: codeColor,
                height: 1.1,
              ),
            ),
          ),
        ));
      } else if (matchText.startsWith('**') && matchText.endsWith('**')) {
        final boldContent = matchText.substring(2, matchText.length - 2);
        spans.add(TextSpan(
          text: boldContent,
          style: baseStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: boldColor ?? baseStyle.color,
          ),
        ));
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        final codeContent = matchText.substring(1, matchText.length - 1);
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: codeBgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: codeColor.withValues(alpha: 0.2), width: 0.8),
            ),
            child: Text(
              codeContent,
              style: baseStyle.copyWith(
                fontFamily: 'monospace',
                fontSize: (baseStyle.fontSize ?? 13) * 0.9,
                fontWeight: FontWeight.w600,
                color: codeColor,
                height: 1.1,
              ),
            ),
          ),
        ));
      } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
        final italicContent = matchText.substring(1, matchText.length - 1);
        spans.add(TextSpan(
          text: italicContent,
          style: baseStyle.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < rawText.length) {
      spans.add(TextSpan(
        text: rawText.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }
}
